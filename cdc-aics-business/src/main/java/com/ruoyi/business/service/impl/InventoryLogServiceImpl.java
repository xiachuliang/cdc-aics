package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.domain.InventoryLog;
import com.ruoyi.business.mapper.InventoryLogMapper;
import com.ruoyi.business.service.IInventoryLogService;

/**
 * 库存流水 服务层实现
 *
 * @author cdc-aics
 */
@Service
public class InventoryLogServiceImpl implements IInventoryLogService
{
    @Autowired
    private InventoryLogMapper inventoryLogMapper;

    @Override
    public InventoryLog selectInventoryLogById(Long id)
    {
        return inventoryLogMapper.selectInventoryLogById(id);
    }

    @Override
    public List<InventoryLog> selectInventoryLogList(InventoryLog inventoryLog)
    {
        return inventoryLogMapper.selectInventoryLogList(inventoryLog);
    }

    @Override
    public int insertInventoryLog(InventoryLog inventoryLog)
    {
        return inventoryLogMapper.insertInventoryLog(inventoryLog);
    }
}
