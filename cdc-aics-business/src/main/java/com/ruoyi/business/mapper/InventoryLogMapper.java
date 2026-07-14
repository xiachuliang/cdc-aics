package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.InventoryLog;

/**
 * 库存流水 数据层
 *
 * @author cdc-aics
 */
public interface InventoryLogMapper
{
    /**
     * 根据ID查询库存流水
     */
    public InventoryLog selectInventoryLogById(Long id);

    /**
     * 查询库存流水列表
     */
    public List<InventoryLog> selectInventoryLogList(InventoryLog inventoryLog);

    /**
     * 新增库存流水
     */
    public int insertInventoryLog(InventoryLog inventoryLog);
}
