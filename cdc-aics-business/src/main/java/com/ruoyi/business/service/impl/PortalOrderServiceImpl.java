package com.ruoyi.business.service.impl;

import java.math.BigDecimal;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.business.domain.InventoryLog;
import com.ruoyi.business.domain.PortalOrder;
import com.ruoyi.business.domain.PortalOrderItem;
import com.ruoyi.business.domain.Product;
import com.ruoyi.business.mapper.InventoryLogMapper;
import com.ruoyi.business.mapper.PortalOrderItemMapper;
import com.ruoyi.business.mapper.PortalOrderMapper;
import com.ruoyi.business.mapper.ProductMapper;
import com.ruoyi.business.ranking.service.IHotRankingService;
import com.ruoyi.business.service.IPortalOrderService;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;

/**
 * C端订单 服务层实现
 *
 * @author cdc-aics
 */
@Service
public class PortalOrderServiceImpl implements IPortalOrderService
{
    private static final Logger log = LoggerFactory.getLogger(PortalOrderServiceImpl.class);

    @Autowired
    private PortalOrderMapper portalOrderMapper;

    @Autowired
    private PortalOrderItemMapper portalOrderItemMapper;

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private InventoryLogMapper inventoryLogMapper;

    @Autowired
    private IHotRankingService hotRankingService;

    @Override
    public PortalOrder selectPortalOrderById(Long id)
    {
        return portalOrderMapper.selectPortalOrderById(id);
    }

    @Override
    public PortalOrder selectPortalOrderByOrderNo(String orderNo)
    {
        return portalOrderMapper.selectPortalOrderByOrderNo(orderNo);
    }

    @Override
    public List<PortalOrderItem> selectItemsByOrderId(Long orderId)
    {
        return portalOrderItemMapper.selectItemsByOrderId(orderId);
    }

    @Override
    public List<PortalOrder> selectPortalOrderList(PortalOrder portalOrder)
    {
        return portalOrderMapper.selectPortalOrderList(portalOrder);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PortalOrder createOrder(PortalOrder order, List<PortalOrderItem> items)
    {
        // 生成订单编号: XS + yyyyMMdd + 4位序号
        String datePrefix = new java.text.SimpleDateFormat("yyyyMMdd").format(new Date());
        int count = portalOrderMapper.getTodayOrderCount(datePrefix);
        String orderNo = "XS" + datePrefix + String.format("%04d", count + 1);
        order.setOrderNo(orderNo);
        order.setStatus("pending");
        order.setCreateTime(new Date());

        // 第一轮：FOR UPDATE 锁定库存行，校验库存并计算总金额
        BigDecimal totalAmount = BigDecimal.ZERO;
        int itemCount = 0;
        Map<Long, Product> lockedProducts = new LinkedHashMap<>();

        for (PortalOrderItem item : items)
        {
            Product product = productMapper.selectProductByIdForUpdate(item.getProductId());
            if (product == null)
            {
                throw new ServiceException("商品[id=" + item.getProductId() + "]不存在");
            }
            if (product.getStock() == null || product.getStock() < item.getQuantity())
            {
                throw new ServiceException("商品[" + product.getProductName() + "]库存不足，当前库存："
                    + (product.getStock() != null ? product.getStock() : 0));
            }

            // 设置商品信息（使用数据库最新数据）
            item.setProductName(product.getProductName());
            item.setPrice(product.getPrice());
            item.setShelfArea(product.getShelfArea());
            BigDecimal subtotal = product.getPrice().multiply(new BigDecimal(item.getQuantity()));
            item.setSubtotal(subtotal);
            totalAmount = totalAmount.add(subtotal);
            itemCount += item.getQuantity();

            lockedProducts.put(item.getProductId(), product);
        }
        order.setTotalAmount(totalAmount);
        order.setItemCount(itemCount);

        // 保存订单
        portalOrderMapper.insertPortalOrder(order);

        // 第二轮：扣减库存 + 记录流水（复用已锁定的商品对象，无需再查DB）
        for (PortalOrderItem item : items)
        {
            item.setOrderId(order.getId());

            Product product = lockedProducts.get(item.getProductId());
            int stockBefore = product.getStock() != null ? product.getStock() : 0;
            int stockAfter = stockBefore - item.getQuantity();

            product.setStock(stockAfter);
            productMapper.updateProduct(product);

            InventoryLog log = new InventoryLog();
            log.setProductId(item.getProductId());
            log.setChangeType("SALE_OUT");
            log.setChangeQuantity(-item.getQuantity());
            log.setStockBefore(stockBefore);
            log.setStockAfter(stockAfter);
            log.setRelatedOrderNo(orderNo);
            log.setCreateBy("顾客下单");
            log.setCreateTime(new Date());
            log.setRemark("C端销售出库 - " + orderNo);
            inventoryLogMapper.insertInventoryLog(log);
        }
        portalOrderItemMapper.batchInsert(items);

        // 同步热销排行榜：下单后自动累加商品销量
        for (PortalOrderItem item : items) {
            try {
                hotRankingService.incrementSales(item.getProductId(), item.getQuantity());
            } catch (Exception e) {
                // 排行榜同步失败不影响下单
                log.error("同步热销排行榜失败: productId={}", item.getProductId(), e);
            }
        }

        return order;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int completeOrder(Long id, String operator)
    {
        PortalOrder order = portalOrderMapper.selectPortalOrderById(id);
        if (order == null)
        {
            throw new ServiceException("订单不存在");
        }
        if (!"pending".equals(order.getStatus()) && !"confirmed".equals(order.getStatus()))
        {
            throw new ServiceException("仅待处理/已确认的订单可完成");
        }
        // 库存已在下单时扣减，此处仅标记取货完成
        order.setStatus("completed");
        order.setCompleteTime(new Date());
        return portalOrderMapper.updatePortalOrder(order);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int cancelOrder(Long id, String operator)
    {
        PortalOrder order = portalOrderMapper.selectPortalOrderById(id);
        if (order == null)
        {
            throw new ServiceException("订单不存在");
        }
        if ("completed".equals(order.getStatus()))
        {
            throw new ServiceException("已完成的订单不可取消");
        }
        if ("cancelled".equals(order.getStatus()))
        {
            throw new ServiceException("订单已取消");
        }

        // 恢复库存
        List<PortalOrderItem> items = portalOrderItemMapper.selectItemsByOrderId(id);
        for (PortalOrderItem item : items)
        {
            Product product = productMapper.selectProductById(item.getProductId());
            if (product != null)
            {
                int stockBefore = product.getStock() != null ? product.getStock() : 0;
                int stockAfter = stockBefore + item.getQuantity();
                product.setStock(stockAfter);
                product.setUpdateBy(operator);
                productMapper.updateProduct(product);

                // 记录库存流水（取消恢复）
                InventoryLog log = new InventoryLog();
                log.setProductId(item.getProductId());
                log.setChangeType("CANCEL_RESTORE");
                log.setChangeQuantity(item.getQuantity());
                log.setStockBefore(stockBefore);
                log.setStockAfter(stockAfter);
                log.setRelatedOrderNo(order.getOrderNo());
                log.setCreateBy(operator);
                log.setCreateTime(new Date());
                inventoryLogMapper.insertInventoryLog(log);
            }
        }

        order.setStatus("cancelled");
        return portalOrderMapper.updatePortalOrder(order);
    }

    @Override
    public List<PortalOrder> selectPortalOrderByPhone(String phone)
    {
        PortalOrder query = new PortalOrder();
        query.setCustomerPhone(phone);
        return portalOrderMapper.selectPortalOrderList(query);
    }
}
