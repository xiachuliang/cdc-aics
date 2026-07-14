package com.ruoyi.portal.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.business.domain.PortalOrder;
import com.ruoyi.business.domain.PortalOrderItem;
import com.ruoyi.business.service.IPortalOrderService;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.portal.service.ICartService;

/**
 * C端订单接口（免登录）
 *
 * @author cdc-aics
 */
@Anonymous
@RestController
@RequestMapping("/portal/order")
public class OrderController extends BaseController
{
    @Autowired
    private IPortalOrderService portalOrderService;

    @Autowired
    private ICartService cartService;

    /**
     * 创建订单
     */
    @PostMapping("/create")
    public AjaxResult create(@RequestBody OrderCreateRequest request)
    {
        if (StringUtils.isEmpty(request.getSessionId()))
        {
            return error("会话ID不能为空");
        }
        if (StringUtils.isEmpty(request.getPhone()))
        {
            return error("手机号不能为空");
        }
        if (request.getItems() == null || request.getItems().isEmpty())
        {
            return error("订单商品不能为空");
        }

        // 构建订单
        PortalOrder order = new PortalOrder();
        order.setSessionId(request.getSessionId());
        order.setCustomerPhone(request.getPhone());
        order.setCustomerName(request.getCustomerName());
        order.setRemark(request.getRemark());

        List<PortalOrderItem> orderItems = new ArrayList<>();
        for (OrderItemRequest itemReq : request.getItems())
        {
            PortalOrderItem item = new PortalOrderItem();
            item.setProductId(itemReq.getProductId());
            item.setQuantity(itemReq.getQuantity());
            orderItems.add(item);
        }

        try
        {
            PortalOrder createdOrder = portalOrderService.createOrder(order, orderItems);

            // 清空购物车
            cartService.clearCart(request.getSessionId());

            Map<String, Object> result = new HashMap<>();
            result.put("orderNo", createdOrder.getOrderNo());
            result.put("order", createdOrder);
            // 脱敏手机号
            String phone = createdOrder.getCustomerPhone();
            String phoneMasked = phone;
            if (phone != null && phone.length() >= 7)
            {
                phoneMasked = phone.substring(0, 3) + "****" + phone.substring(phone.length() - 4);
            }
            result.put("phoneMasked", phoneMasked);
            result.put("totalAmount", createdOrder.getTotalAmount());
            return success(result);
        }
        catch (Exception e)
        {
            return error(e.getMessage());
        }
    }

    /**
     * 查询订单（按手机号或订单号）
     */
    @GetMapping("/query")
    public AjaxResult query(String phone, String orderNo)
    {
        if (StringUtils.isNotEmpty(orderNo))
        {
            PortalOrder order = portalOrderService.selectPortalOrderByOrderNo(orderNo);
            if (order == null)
            {
                return error("订单不存在");
            }
            Map<String, Object> result = new HashMap<>();
            result.put("order", order);
            result.put("items", portalOrderService.selectItemsByOrderId(order.getId()));
            return success(result);
        }

        if (StringUtils.isNotEmpty(phone))
        {
            List<PortalOrder> orders = portalOrderService.selectPortalOrderByPhone(phone);
            return success(orders);
        }

        return error("请提供手机号或订单号");
    }

    /**
     * 订单详情（按订单编号）
     */
    @GetMapping("/{orderNo}")
    public AjaxResult detail(@PathVariable String orderNo)
    {
        PortalOrder order = portalOrderService.selectPortalOrderByOrderNo(orderNo);
        if (order == null)
        {
            return error("订单不存在");
        }
        List<PortalOrderItem> items = portalOrderService.selectItemsByOrderId(order.getId());
        Map<String, Object> result = new HashMap<>();
        result.put("order", order);
        result.put("items", items);
        return success(result);
    }

    // ========== 请求体 ==========

    public static class OrderCreateRequest
    {
        private String sessionId;
        private String phone;
        private String customerName;
        private List<OrderItemRequest> items;
        private String remark;

        public String getSessionId() { return sessionId; }
        public void setSessionId(String sessionId) { this.sessionId = sessionId; }
        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
        public String getCustomerName() { return customerName; }
        public void setCustomerName(String customerName) { this.customerName = customerName; }
        public List<OrderItemRequest> getItems() { return items; }
        public void setItems(List<OrderItemRequest> items) { this.items = items; }
        public String getRemark() { return remark; }
        public void setRemark(String remark) { this.remark = remark; }
    }

    public static class OrderItemRequest
    {
        private Long productId;
        private Integer quantity;

        public Long getProductId() { return productId; }
        public void setProductId(Long productId) { this.productId = productId; }
        public Integer getQuantity() { return quantity; }
        public void setQuantity(Integer quantity) { this.quantity = quantity; }
    }
}
