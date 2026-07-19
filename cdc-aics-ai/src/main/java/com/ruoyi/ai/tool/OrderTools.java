package com.ruoyi.ai.tool;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.ruoyi.business.domain.PortalOrder;
import com.ruoyi.business.domain.PortalOrderItem;
import com.ruoyi.business.domain.Product;
import com.ruoyi.business.service.IPortalOrderService;
import com.ruoyi.business.service.IProductService;
import com.ruoyi.portal.domain.CartItem;
import com.ruoyi.portal.service.ICartService;

/**
 * 购物车 + 下单工具。
 * <p>
 * 所有需要区分用户的方法都接收 sessionId 参数（由 LLM 从系统提示中获取并传入），
 * 不依赖 ThreadLocal，避免流式调用时跨线程丢失。
 */
@Component
public class OrderTools {

    private static final Logger log = LoggerFactory.getLogger(OrderTools.class);

    @Autowired
    private ICartService cartService;

    @Autowired
    private IProductService productService;

    @Autowired
    private IPortalOrderService orderService;

    /** ThreadLocal：暂存最近一次工具调用结果，供 ChatServiceImpl 取出（同步端点用） */
    private static final ThreadLocal<ToolResult> LAST_RESULT = new ThreadLocal<>();

    public static ToolResult drainResult() {
        ToolResult r = LAST_RESULT.get();
        LAST_RESULT.remove();
        return r;
    }

    /** 工具调用结果 */
    public static class ToolResult {
        public String toolName;
        public List<CartItem> cartItems;
        public PortalOrder order;
        public List<PortalOrderItem> orderItems;

        public ToolResult(String toolName) {
            this.toolName = toolName;
        }
    }

    // ==================== 购物车工具 ====================

    @Tool(description = "将指定商品加入购物车。需要会话ID（从系统提示中获取）、商品ID和购买数量，会自动检查库存")
    public String addToCart(
            @ToolParam(description = "会话ID，从系统提示中的【会话ID: xxx】获取") String sessionId,
            @ToolParam(description = "商品ID") Long productId,
            @ToolParam(description = "购买数量，默认1") Integer quantity
    ) {
        try {
            int qty = (quantity != null && quantity > 0) ? quantity : 1;
            Product product = productService.selectProductById(productId);
            if (product == null) return "商品不存在（ID: " + productId + "）";

            int stock = product.getStock() != null ? product.getStock() : 0;
            if (stock <= 0) return "【" + product.getProductName() + "】已售罄，暂时缺货";

            // 检查购物车已有数量
            List<CartItem> existing = cartService.getCartItems(sessionId);
            int already = 0;
            for (CartItem ci : existing) {
                if (ci.getProductId().equals(productId)) { already = ci.getQuantity(); break; }
            }
            if (already + qty > stock) {
                return "库存不足！【" + product.getProductName() + "】库存" + stock + "件，购物车已有" + already + "件";
            }

            List<CartItem> items = cartService.addItem(
                    sessionId, productId, product.getProductName(),
                    product.getPrice(), qty, product.getImageUrl(), product.getShelfArea());

            ToolResult tr = new ToolResult("addToCart");
            tr.cartItems = items;
            LAST_RESULT.set(tr);

            log.info("addToCart: {} ×{}, sessionId={}", product.getProductName(), qty, sessionId);
            return "已加入购物车：" + product.getProductName() + " ×" + qty + "，" + cartSummary(items);

        } catch (Exception e) {
            log.error("addToCart 失败", e);
            return "加入购物车失败，请稍后再试";
        }
    }

    @Tool(description = "查看当前购物车中的所有商品、数量和总金额。需要会话ID（从系统提示中获取）")
    public String getCart(
            @ToolParam(description = "会话ID，从系统提示中的【会话ID: xxx】获取") String sessionId
    ) {
        try {
            List<CartItem> items = cartService.getCartItems(sessionId);
            ToolResult tr = new ToolResult("getCart");
            tr.cartItems = items;
            LAST_RESULT.set(tr);

            if (items.isEmpty()) {
                log.info("getCart: 空, sessionId={}", sessionId);
                return "购物车是空的，还没有添加任何商品";
            }
            log.info("getCart: {} 种商品, sessionId={}", items.size(), sessionId);
            return cartSummary(items);

        } catch (Exception e) {
            log.error("getCart 失败", e);
            return "查看购物车失败，请稍后再试";
        }
    }

    @Tool(description = "从购物车中移除指定商品。需要会话ID和商品ID")
    public String removeFromCart(
            @ToolParam(description = "会话ID，从系统提示中的【会话ID: xxx】获取") String sessionId,
            @ToolParam(description = "商品ID") Long productId
    ) {
        try {
            List<CartItem> items = cartService.removeItem(sessionId, productId);
            ToolResult tr = new ToolResult("removeFromCart");
            tr.cartItems = items;
            LAST_RESULT.set(tr);
            return items.isEmpty() ? "已移除，购物车现在是空的" : "已移除。购物车剩余：" + cartSummary(items);
        } catch (Exception e) {
            log.error("removeFromCart 失败", e);
            return "移除商品失败，请稍后再试";
        }
    }

    @Tool(description = "修改购物车中某商品的数量。设为0即移除。需要会话ID、商品ID和新数量")
    public String updateCartQuantity(
            @ToolParam(description = "会话ID，从系统提示中的【会话ID: xxx】获取") String sessionId,
            @ToolParam(description = "商品ID") Long productId,
            @ToolParam(description = "新的数量") Integer quantity
    ) {
        try {
            int qty = (quantity != null) ? quantity : 0;
            if (qty > 0) {
                Product product = productService.selectProductById(productId);
                if (product != null && product.getStock() < qty) {
                    return "库存不足！【" + product.getProductName() + "】库存" + product.getStock() + "件";
                }
            }
            List<CartItem> items = cartService.updateQuantity(sessionId, productId, qty);
            ToolResult tr = new ToolResult("updateCartQuantity");
            tr.cartItems = items;
            LAST_RESULT.set(tr);
            return items.isEmpty() ? "数量已更新，购物车现在是空的" : "数量已更新。" + cartSummary(items);
        } catch (Exception e) {
            log.error("updateCartQuantity 失败", e);
            return "修改数量失败，请稍后再试";
        }
    }

    // ==================== 下单工具 ====================

    @Tool(description = "确认下单，将购物车中的所有商品创建为订单。需要会话ID和客户手机号。下单成功后购物车自动清空")
    public String createOrder(
            @ToolParam(description = "会话ID，从系统提示中的【会话ID: xxx】获取") String sessionId,
            @ToolParam(description = "客户手机号，11位数字") String phone,
            @ToolParam(description = "客户姓名，可选") String customerName
    ) {
        try {
            List<CartItem> cartItems = cartService.getCartItems(sessionId);
            if (cartItems.isEmpty()) return "下单失败：购物车是空的，请先添加商品";

            List<PortalOrderItem> orderItems = new ArrayList<>();
            for (CartItem ci : cartItems) {
                PortalOrderItem oi = new PortalOrderItem();
                oi.setProductId(ci.getProductId());
                oi.setQuantity(ci.getQuantity());
                orderItems.add(oi);
            }

            PortalOrder order = new PortalOrder();
            order.setSessionId(sessionId);
            order.setCustomerPhone(phone);
            if (customerName != null && !customerName.trim().isEmpty()) {
                order.setCustomerName(customerName.trim());
            }

            PortalOrder created = orderService.createOrder(order, orderItems);
            cartService.clearCart(sessionId);

            String phoneMasked = phone.length() >= 7
                    ? phone.substring(0, 3) + "****" + phone.substring(phone.length() - 4) : phone;

            List<PortalOrderItem> items = orderService.selectItemsByOrderId(created.getId());
            ToolResult tr = new ToolResult("createOrder");
            tr.order = created;
            tr.orderItems = items;
            LAST_RESULT.set(tr);

            log.info("createOrder: {}, sessionId={}, amount={}", created.getOrderNo(), sessionId, created.getTotalAmount());

            StringBuilder sb = new StringBuilder();
            sb.append("下单成功！\n");
            sb.append("订单号：").append(created.getOrderNo()).append("\n");
            sb.append("金额：¥").append(created.getTotalAmount()).append("\n");
            sb.append("手机号：").append(phoneMasked).append("\n");
            sb.append("商品明细：");
            for (PortalOrderItem item : items) {
                sb.append("\n  - ").append(item.getProductName())
                        .append(" ×").append(item.getQuantity())
                        .append(" ¥").append(item.getSubtotal());
            }
            return sb.toString();

        } catch (Exception e) {
            log.error("createOrder 失败", e);
            String msg = e.getMessage() != null ? e.getMessage() : "";
            return "下单失败" + (msg.isEmpty() ? "" : "：" + msg);
        }
    }

    // ==================== 查订单工具 ====================

    @Tool(description = "按手机号查询最近的订单，或按订单号精确查询。用于'我的订单''查物流'等问题")
    public String queryOrder(
            @ToolParam(description = "手机号或订单号") String keyword
    ) {
        try {
            PortalOrder order = orderService.selectPortalOrderByOrderNo(keyword);
            if (order == null) {
                List<PortalOrder> orders = orderService.selectPortalOrderByPhone(keyword);
                if (orders == null || orders.isEmpty()) return "未找到相关订单";
                order = orders.get(0);
            }

            List<PortalOrderItem> items = orderService.selectItemsByOrderId(order.getId());
            ToolResult tr = new ToolResult("queryOrder");
            tr.order = order;
            tr.orderItems = items;
            LAST_RESULT.set(tr);

            return "订单号：" + order.getOrderNo()
                    + " | 状态：" + statusText(order.getStatus())
                    + " | 金额：¥" + order.getTotalAmount()
                    + " | 共" + order.getItemCount() + "件商品";

        } catch (Exception e) {
            log.error("queryOrder 失败", e);
            return "查询订单失败，请稍后再试";
        }
    }

    // ==================== 辅助方法 ====================

    private String cartSummary(List<CartItem> items) {
        if (items.isEmpty()) return "购物车是空的";
        BigDecimal total = items.stream()
                .map(i -> i.getPrice().multiply(BigDecimal.valueOf(i.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        StringBuilder sb = new StringBuilder();
        sb.append("共").append(items.size()).append("种商品，合计¥").append(total);
        for (CartItem ci : items) {
            sb.append("\n  - ").append(ci.getProductName())
                    .append(" ×").append(ci.getQuantity())
                    .append(" ¥").append(ci.getPrice());
        }
        return sb.toString();
    }

    private String statusText(String status) {
        if (status == null) return "未知";
        return switch (status) {
            case "pending"   -> "待处理";
            case "confirmed" -> "已确认";
            case "completed" -> "已完成";
            case "cancelled" -> "已取消";
            default          -> status;
        };
    }
}
