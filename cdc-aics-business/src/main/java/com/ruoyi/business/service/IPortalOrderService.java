package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.PortalOrder;
import com.ruoyi.business.domain.PortalOrderItem;

/**
 * C端订单 服务层（供后台管理和门户共用）
 *
 * @author cdc-aics
 */
public interface IPortalOrderService
{
    /**
     * 根据ID查询订单
     */
    public PortalOrder selectPortalOrderById(Long id);

    /**
     * 根据订单编号查询订单
     */
    public PortalOrder selectPortalOrderByOrderNo(String orderNo);

    /**
     * 查询订单明细
     */
    public List<PortalOrderItem> selectItemsByOrderId(Long orderId);

    /**
     * 查询订单列表
     */
    public List<PortalOrder> selectPortalOrderList(PortalOrder portalOrder);

    /**
     * 创建订单（门户下单：校验库存、扣减库存、记录流水）
     */
    public PortalOrder createOrder(PortalOrder order, List<PortalOrderItem> items);

    /**
     * 完成订单
     */
    public int completeOrder(Long id, String operator);

    /**
     * 取消订单（恢复库存）
     */
    public int cancelOrder(Long id, String operator);

    /**
     * 根据手机号查询订单
     */
    public List<PortalOrder> selectPortalOrderByPhone(String phone);
}
