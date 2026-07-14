package com.ruoyi.web.controller.business;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.business.domain.InventoryLog;
import com.ruoyi.business.service.IInventoryLogService;

/**
 * 库存流水查询
 *
 * @author cdc-aics
 */
@RestController
@RequestMapping("/business/inventory")
public class InventoryController extends BaseController
{
    @Autowired
    private IInventoryLogService inventoryLogService;

    @PreAuthorize("@ss.hasPermi('business:inventory:list')")
    @GetMapping("/list")
    public TableDataInfo list(InventoryLog inventoryLog)
    {
        startPage();
        List<InventoryLog> list = inventoryLogService.selectInventoryLogList(inventoryLog);
        return getDataTable(list);
    }
}
