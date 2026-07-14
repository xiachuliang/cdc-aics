package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.PurchaseOrderItem;

/**
 * 采购订单明细 数据层
 *
 * @author cdc-aics
 */
public interface PurchaseOrderItemMapper
{
    /**
     * 根据订单ID查询明细列表
     */
    public List<PurchaseOrderItem> selectItemsByOrderId(Long orderId);

    /**
     * 新增采购订单明细
     */
    public int insertPurchaseOrderItem(PurchaseOrderItem item);

    /**
     * 根据订单ID删除明细
     */
    public int deleteItemsByOrderId(Long orderId);

    /**
     * 批量新增采购订单明细
     */
    public int batchInsert(List<PurchaseOrderItem> items);
}
