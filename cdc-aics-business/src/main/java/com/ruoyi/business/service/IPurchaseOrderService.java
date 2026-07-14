package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.PurchaseOrder;
import com.ruoyi.business.domain.PurchaseOrderItem;

/**
 * 采购订单 服务层
 *
 * @author cdc-aics
 */
public interface IPurchaseOrderService
{
    /**
     * 根据ID查询采购订单
     */
    public PurchaseOrder selectPurchaseOrderById(Long id);

    /**
     * 查询采购订单列表
     */
    public List<PurchaseOrder> selectPurchaseOrderList(PurchaseOrder purchaseOrder);

    /**
     * 根据订单ID查询明细列表
     */
    public List<PurchaseOrderItem> selectItemsByOrderId(Long orderId);

    /**
     * 新增采购订单
     */
    public int insertPurchaseOrder(PurchaseOrder purchaseOrder, List<PurchaseOrderItem> items);

    /**
     * 修改采购订单
     */
    public int updatePurchaseOrder(PurchaseOrder purchaseOrder);

    /**
     * 批量删除采购订单
     */
    public void deletePurchaseOrderByIds(Long[] ids);

    /**
     * 确认订单
     */
    public void confirmOrder(Long id);

    /**
     * 收货入库
     */
    public void receiveOrder(Long id, String operator);

    /**
     * 取消订单
     */
    public void cancelOrder(Long id);
}
