package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.InventoryLog;

/**
 * 库存流水 服务层
 *
 * @author cdc-aics
 */
public interface IInventoryLogService
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
