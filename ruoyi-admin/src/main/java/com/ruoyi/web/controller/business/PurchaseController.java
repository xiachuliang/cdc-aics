package com.ruoyi.web.controller.business;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.business.domain.PurchaseOrder;
import com.ruoyi.business.service.IPurchaseOrderService;

/**
 * 采购订单管理
 *
 * @author cdc-aics
 */
@RestController
@RequestMapping("/business/purchase")
public class PurchaseController extends BaseController
{
    @Autowired
    private IPurchaseOrderService purchaseOrderService;

    @PreAuthorize("@ss.hasPermi('business:purchase:list')")
    @GetMapping("/list")
    public TableDataInfo list(PurchaseOrder purchaseOrder)
    {
        startPage();
        List<PurchaseOrder> list = purchaseOrderService.selectPurchaseOrderList(purchaseOrder);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('business:purchase:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        AjaxResult ajax = success(purchaseOrderService.selectPurchaseOrderById(id));
        ajax.put("items", purchaseOrderService.selectItemsByOrderId(id));
        return ajax;
    }

    @PreAuthorize("@ss.hasPermi('business:purchase:add')")
    @Log(title = "采购管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody PurchaseOrder purchaseOrder)
    {
        purchaseOrder.setCreateBy(getUsername());
        return toAjax(purchaseOrderService.insertPurchaseOrder(purchaseOrder, purchaseOrder.getItems()));
    }

    @PreAuthorize("@ss.hasPermi('business:purchase:edit')")
    @Log(title = "采购管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody PurchaseOrder purchaseOrder)
    {
        purchaseOrder.setUpdateBy(getUsername());
        return toAjax(purchaseOrderService.updatePurchaseOrder(purchaseOrder));
    }

    @PreAuthorize("@ss.hasPermi('business:purchase:remove')")
    @Log(title = "采购管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        purchaseOrderService.deletePurchaseOrderByIds(ids);
        return success();
    }

    @PreAuthorize("@ss.hasPermi('business:purchase:list')")
    @Log(title = "采购管理", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/confirm")
    public AjaxResult confirm(@PathVariable Long id)
    {
        purchaseOrderService.confirmOrder(id);
        return success();
    }

    @PreAuthorize("@ss.hasPermi('business:purchase:list')")
    @Log(title = "采购管理", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/receive")
    public AjaxResult receive(@PathVariable Long id)
    {
        purchaseOrderService.receiveOrder(id, getUsername());
        return success();
    }

    @PreAuthorize("@ss.hasPermi('business:purchase:list')")
    @Log(title = "采购管理", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/cancel")
    public AjaxResult cancel(@PathVariable Long id)
    {
        purchaseOrderService.cancelOrder(id);
        return success();
    }
}
