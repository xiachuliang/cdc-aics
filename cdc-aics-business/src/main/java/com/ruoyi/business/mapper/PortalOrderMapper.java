package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.PortalOrder;

/**
 * C端订单 数据层
 *
 * @author cdc-aics
 */
public interface PortalOrderMapper
{
    /**
     * 根据ID查询订单
     */
    public PortalOrder selectPortalOrderById(Long id);

    /**
     * 查询订单列表
     */
    public List<PortalOrder> selectPortalOrderList(PortalOrder portalOrder);

    /**
     * 根据订单编号查询订单
     */
    public PortalOrder selectPortalOrderByOrderNo(String orderNo);

    /**
     * 新增订单
     */
    public int insertPortalOrder(PortalOrder portalOrder);

    /**
     * 修改订单
     */
    public int updatePortalOrder(PortalOrder portalOrder);

    /**
     * 获取当天订单数量
     */
    public int getTodayOrderCount(String datePrefix);
}
