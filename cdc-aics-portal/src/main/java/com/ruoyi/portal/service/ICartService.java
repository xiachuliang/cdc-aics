package com.ruoyi.portal.service;

import java.util.List;
import com.ruoyi.portal.domain.CartItem;

/**
 * 购物车服务接口
 *
 * @author cdc-aics
 */
public interface ICartService
{
    /**
     * 添加商品到购物车
     *
     * @param sessionId 会话ID
     * @param productId 商品ID
     * @param productName 商品名称
     * @param price 单价
     * @param quantity 数量
     * @param imageUrl 商品图片URL
     * @param shelfArea 货架位置
     * @return 当前购物车商品列表
     */
    public List<CartItem> addItem(String sessionId, Long productId, String productName,
            java.math.BigDecimal price, Integer quantity, String imageUrl, String shelfArea);

    /**
     * 获取购物车所有商品
     *
     * @param sessionId 会话ID
     * @return 购物车商品列表
     */
    public List<CartItem> getCartItems(String sessionId);

    /**
     * 更新商品数量
     *
     * @param sessionId 会话ID
     * @param productId 商品ID
     * @param quantity 新数量
     */
    public List<CartItem> updateQuantity(String sessionId, Long productId, Integer quantity);

    /**
     * 从购物车移除商品
     *
     * @param sessionId 会话ID
     * @param productId 商品ID
     */
    public List<CartItem> removeItem(String sessionId, Long productId);

    /**
     * 清空购物车
     *
     * @param sessionId 会话ID
     */
    public void clearCart(String sessionId);

    /**
     * 获取购物车商品总件数
     *
     * @param sessionId 会话ID
     * @return 总件数
     */
    public int getCartCount(String sessionId);
}
