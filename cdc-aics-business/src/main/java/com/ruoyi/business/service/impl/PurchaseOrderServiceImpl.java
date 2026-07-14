package com.ruoyi.business.service.impl;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.business.domain.InventoryLog;
import com.ruoyi.business.domain.Product;
import com.ruoyi.business.domain.PurchaseOrder;
import com.ruoyi.business.domain.PurchaseOrderItem;
import com.ruoyi.business.mapper.InventoryLogMapper;
import com.ruoyi.business.mapper.ProductMapper;
import com.ruoyi.business.mapper.PurchaseOrderItemMapper;
import com.ruoyi.business.mapper.PurchaseOrderMapper;
import com.ruoyi.business.service.IPurchaseOrderService;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;

/**
 * 采购订单 服务层实现
 *
 * @author cdc-aics
 */
@Service
public class PurchaseOrderServiceImpl implements IPurchaseOrderService
{
    private static final Logger log = LoggerFactory.getLogger(PurchaseOrderServiceImpl.class);

    @Autowired
    private PurchaseOrderMapper purchaseOrderMapper;

    @Autowired
    private PurchaseOrderItemMapper purchaseOrderItemMapper;

    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private InventoryLogMapper inventoryLogMapper;

    @Override
    public PurchaseOrder selectPurchaseOrderById(Long id)
    {
        return purchaseOrderMapper.selectPurchaseOrderById(id);
    }

    @Override
    public List<PurchaseOrder> selectPurchaseOrderList(PurchaseOrder purchaseOrder)
    {
        return purchaseOrderMapper.selectPurchaseOrderList(purchaseOrder);
    }

    @Override
    public List<PurchaseOrderItem> selectItemsByOrderId(Long orderId)
    {
        return purchaseOrderItemMapper.selectItemsByOrderId(orderId);
    }

    @Override
    @Transactional
    public int insertPurchaseOrder(PurchaseOrder purchaseOrder, List<PurchaseOrderItem> items)
    {
        if (items == null || items.isEmpty())
        {
            throw new ServiceException("采购商品明细不能为空");
        }
        // 生成订单号
        purchaseOrder.setOrderNo(generateOrderNo());
        // 设置状态为草稿
        purchaseOrder.setStatus("draft");
        // 计算总金额和插入明细
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (PurchaseOrderItem item : items)
        {
            if (item.getPrice() != null && item.getQuantity() != null)
            {
                item.setSubtotal(item.getPrice().multiply(new BigDecimal(item.getQuantity())));
                totalAmount = totalAmount.add(item.getSubtotal());
            }
        }
        purchaseOrder.setTotalAmount(totalAmount);
        purchaseOrder.setCreateBy(SecurityUtils.getUsername());
        purchaseOrder.setOrderDate(new Date());

        int rows = purchaseOrderMapper.insertPurchaseOrder(purchaseOrder);

        // 设置订单ID并批量插入明细
        Long orderId = purchaseOrder.getId();
        for (PurchaseOrderItem item : items)
        {
            item.setOrderId(orderId);
        }
        if (!items.isEmpty())
        {
            purchaseOrderItemMapper.batchInsert(items);
        }

        return rows;
    }

    @Override
    public int updatePurchaseOrder(PurchaseOrder purchaseOrder)
    {
        purchaseOrder.setUpdateBy(SecurityUtils.getUsername());
        return purchaseOrderMapper.updatePurchaseOrder(purchaseOrder);
    }

    @Override
    public void deletePurchaseOrderByIds(Long[] ids)
    {
        for (Long id : ids)
        {
            PurchaseOrder order = selectPurchaseOrderById(id);
            if (StringUtils.isNull(order))
            {
                throw new ServiceException("采购订单不存在");
            }
        }
        for (Long id : ids)
        {
            purchaseOrderItemMapper.deleteItemsByOrderId(id);
            purchaseOrderMapper.deletePurchaseOrderById(id);
        }
    }

    @Override
    public void confirmOrder(Long id)
    {
        PurchaseOrder order = selectPurchaseOrderById(id);
        if (StringUtils.isNull(order))
        {
            throw new ServiceException("采购订单不存在");
        }
        if (!"draft".equals(order.getStatus()))
        {
            throw new ServiceException("仅草稿状态的订单可以确认");
        }
        order.setStatus("confirmed");
        order.setUpdateBy(SecurityUtils.getUsername());
        purchaseOrderMapper.updatePurchaseOrder(order);
    }

    @Override
    @Transactional
    public void receiveOrder(Long id, String operator)
    {
        PurchaseOrder order = selectPurchaseOrderById(id);
        if (StringUtils.isNull(order))
        {
            throw new ServiceException("采购订单不存在");
        }
        if (!"confirmed".equals(order.getStatus()))
        {
            throw new ServiceException("仅已确认状态的订单可以收货");
        }

        List<PurchaseOrderItem> items = purchaseOrderItemMapper.selectItemsByOrderId(id);

        for (PurchaseOrderItem item : items)
        {
            Product product = productMapper.selectProductById(item.getProductId());
            if (StringUtils.isNull(product))
            {
                throw new ServiceException("商品不存在，ID：" + item.getProductId());
            }

            int stockBefore = product.getStock() != null ? product.getStock() : 0;
            int stockAfter = stockBefore + item.getQuantity();

            // 更新库存
            product.setStock(stockAfter);
            productMapper.updateProduct(product);

            // 写入库存流水
            InventoryLog log = new InventoryLog();
            log.setProductId(item.getProductId());
            log.setChangeType("PURCHASE_IN");
            log.setChangeQuantity(item.getQuantity());
            log.setStockBefore(stockBefore);
            log.setStockAfter(stockAfter);
            log.setRelatedOrderNo(order.getOrderNo());
            log.setCreateBy(operator);
            log.setRemark("采购入库 - " + order.getOrderNo());
            log.setCreateTime(new Date());
            inventoryLogMapper.insertInventoryLog(log);
        }

        order.setStatus("received");
        order.setReceiveDate(new Date());
        order.setUpdateBy(operator);
        purchaseOrderMapper.updatePurchaseOrder(order);

        log.info("采购订单 {} 收货入库完成，操作人：{}", order.getOrderNo(), operator);
    }

    @Override
    public void cancelOrder(Long id)
    {
        PurchaseOrder order = selectPurchaseOrderById(id);
        if (StringUtils.isNull(order))
        {
            throw new ServiceException("采购订单不存在");
        }
        if ("received".equals(order.getStatus()))
        {
            throw new ServiceException("已收货的订单不可取消");
        }
        if ("cancelled".equals(order.getStatus()))
        {
            throw new ServiceException("订单已取消");
        }
        order.setStatus("cancelled");
        order.setUpdateBy(SecurityUtils.getUsername());
        purchaseOrderMapper.updatePurchaseOrder(order);
    }

    /**
     * 生成订单号：PO + yyyyMMdd + 3位流水号
     */
    private String generateOrderNo()
    {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String datePrefix = sdf.format(new Date());
        int count = purchaseOrderMapper.getTodayOrderCount(datePrefix);
        return "PO" + datePrefix + String.format("%03d", count + 1);
    }
}
