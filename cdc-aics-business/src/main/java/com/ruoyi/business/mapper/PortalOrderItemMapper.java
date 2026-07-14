package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.PortalOrderItem;

/**
 * C端订单明细 数据层
 *
 * @author cdc-aics
 */
public interface PortalOrderItemMapper
{
    /**
     * 根据订单ID查询明细列表
     */
    public List<PortalOrderItem> selectItemsByOrderId(Long orderId);

    /**
     * 新增订单明细
     */
    public int insertPortalOrderItem(PortalOrderItem item);

    /**
     * 批量新增订单明细
     */
    public int batchInsert(List<PortalOrderItem> items);
}
