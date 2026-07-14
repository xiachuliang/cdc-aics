package com.ruoyi.web.controller.business;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.business.domain.PortalOrder;
import com.ruoyi.business.service.IPortalOrderService;

/**
 * 订单管理（后台）
 *
 * @author cdc-aics
 */
@RestController
@RequestMapping("/business/order")
public class BusinessOrderController extends BaseController
{
    @Autowired
    private IPortalOrderService portalOrderService;

    @PreAuthorize("@ss.hasPermi('business:order:list')")
    @GetMapping("/list")
    public TableDataInfo list(PortalOrder portalOrder)
    {
        startPage();
        List<PortalOrder> list = portalOrderService.selectPortalOrderList(portalOrder);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('business:order:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        AjaxResult ajax = success(portalOrderService.selectPortalOrderById(id));
        ajax.put("items", portalOrderService.selectItemsByOrderId(id));
        return ajax;
    }

    @PreAuthorize("@ss.hasPermi('business:order:list')")
    @Log(title = "订单管理", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/complete")
    public AjaxResult complete(@PathVariable Long id)
    {
        return toAjax(portalOrderService.completeOrder(id, getUsername()));
    }

    @PreAuthorize("@ss.hasPermi('business:order:list')")
    @Log(title = "订单管理", businessType = BusinessType.UPDATE)
    @PutMapping("/{id}/cancel")
    public AjaxResult cancel(@PathVariable Long id)
    {
        return toAjax(portalOrderService.cancelOrder(id, getUsername()));
    }
}
