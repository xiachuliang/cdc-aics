package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.PurchaseOrder;

/**
 * 采购订单 数据层
 *
 * @author cdc-aics
 */
public interface PurchaseOrderMapper
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
     * 新增采购订单
     */
    public int insertPurchaseOrder(PurchaseOrder purchaseOrder);

    /**
     * 修改采购订单
     */
    public int updatePurchaseOrder(PurchaseOrder purchaseOrder);

    /**
     * 删除采购订单
     */
    public int deletePurchaseOrderById(Long id);

    /**
     * 批量删除采购订单
     */
    public int deletePurchaseOrderByIds(Long[] ids);

    /**
     * 获取当天订单数量
     */
    public int getTodayOrderCount(String datePrefix);
}
