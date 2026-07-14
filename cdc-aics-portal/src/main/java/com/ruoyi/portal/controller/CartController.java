package com.ruoyi.portal.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.business.domain.Product;
import com.ruoyi.business.mapper.ProductMapper;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.portal.domain.CartItem;
import com.ruoyi.portal.service.ICartService;

/**
 * C端购物车接口（免登录）
 *
 * @author cdc-aics
 */
@Anonymous
@RestController
@RequestMapping("/portal/cart")
public class CartController extends BaseController
{
    @Autowired
    private ICartService cartService;

    @Autowired
    private ProductMapper productMapper;

    /**
     * 添加商品到购物车
     */
    @PostMapping("/add")
    public AjaxResult add(@RequestBody CartAddRequest request)
    {
        Product product = productMapper.selectProductById(request.getProductId());
        if (product == null)
        {
            return error("商品不存在");
        }
        int qty = request.getQuantity() != null ? request.getQuantity() : 1;

        // 检查库存：购物车已有 + 本次添加 > 库存？
        List<CartItem> existingItems = cartService.getCartItems(request.getSessionId());
        int alreadyInCart = 0;
        for (CartItem ci : existingItems)
        {
            if (ci.getProductId().equals(request.getProductId()))
            {
                alreadyInCart = ci.getQuantity();
                break;
            }
        }
        int totalNeeded = alreadyInCart + qty;
        int stock = product.getStock() != null ? product.getStock() : 0;
        if (totalNeeded > stock)
        {
            return error("库存不足！当前库存" + stock + "件，购物车已有" + alreadyInCart + "件，无法再添加" + qty + "件");
        }

        List<CartItem> items = cartService.addItem(
                request.getSessionId(),
                request.getProductId(),
                product.getProductName(),
                product.getPrice(),
                qty,
                product.getImageUrl(),
                product.getShelfArea());

        Map<String, Object> result = new HashMap<>();
        result.put("cartCount", cartService.getCartCount(request.getSessionId()));
        result.put("cartItems", items);
        return success(result);
    }

    /**
     * 获取购物车列表
     */
    @GetMapping("/list")
    public AjaxResult list(String sessionId)
    {
        List<CartItem> items = cartService.getCartItems(sessionId);
        Map<String, Object> result = new HashMap<>();
        result.put("cartCount", cartService.getCartCount(sessionId));
        result.put("cartItems", items);
        return success(result);
    }

    /**
     * 更新商品数量
     */
    @PutMapping("/update")
    public AjaxResult update(@RequestBody CartUpdateRequest request)
    {
        // 检查库存
        Product product = productMapper.selectProductById(request.getProductId());
        if (product != null)
        {
            int stock = product.getStock() != null ? product.getStock() : 0;
            if (request.getQuantity() != null && request.getQuantity() > stock)
            {
                return error("库存不足！当前库存" + stock + "件");
            }
        }

        List<CartItem> items = cartService.updateQuantity(
                request.getSessionId(),
                request.getProductId(),
                request.getQuantity());
        Map<String, Object> result = new HashMap<>();
        result.put("cartCount", cartService.getCartCount(request.getSessionId()));
        result.put("cartItems", items);
        return success(result);
    }

    /**
     * 从购物车移除商品
     */
    @DeleteMapping("/remove")
    public AjaxResult remove(@RequestBody CartRemoveRequest request)
    {
        List<CartItem> items = cartService.removeItem(request.getSessionId(), request.getProductId());
        Map<String, Object> result = new HashMap<>();
        result.put("cartCount", cartService.getCartCount(request.getSessionId()));
        result.put("cartItems", items);
        return success(result);
    }

    /**
     * 清空购物车
     */
    @DeleteMapping("/clear")
    public AjaxResult clear(@RequestBody CartClearRequest request)
    {
        cartService.clearCart(request.getSessionId());
        return success();
    }

    // ========== 请求体 ==========

    public static class CartAddRequest
    {
        private String sessionId;
        private Long productId;
        private Integer quantity;

        public String getSessionId() { return sessionId; }
        public void setSessionId(String sessionId) { this.sessionId = sessionId; }
        public Long getProductId() { return productId; }
        public void setProductId(Long productId) { this.productId = productId; }
        public Integer getQuantity() { return quantity; }
        public void setQuantity(Integer quantity) { this.quantity = quantity; }
    }

    public static class CartUpdateRequest
    {
        private String sessionId;
        private Long productId;
        private Integer quantity;

        public String getSessionId() { return sessionId; }
        public void setSessionId(String sessionId) { this.sessionId = sessionId; }
        public Long getProductId() { return productId; }
        public void setProductId(Long productId) { this.productId = productId; }
        public Integer getQuantity() { return quantity; }
        public void setQuantity(Integer quantity) { this.quantity = quantity; }
    }

    public static class CartRemoveRequest
    {
        private String sessionId;
        private Long productId;

        public String getSessionId() { return sessionId; }
        public void setSessionId(String sessionId) { this.sessionId = sessionId; }
        public Long getProductId() { return productId; }
        public void setProductId(Long productId) { this.productId = productId; }
    }

    public static class CartClearRequest
    {
        private String sessionId;

        public String getSessionId() { return sessionId; }
        public void setSessionId(String sessionId) { this.sessionId = sessionId; }
    }
}
