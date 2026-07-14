package com.ruoyi.portal.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.TypeReference;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.portal.domain.CartItem;
import com.ruoyi.portal.service.ICartService;

/**
 * 购物车服务实现 - 基于Redis JSON存储
 *
 * @author cdc-aics
 */
@Service
public class CartServiceImpl implements ICartService
{
    private static final Logger log = LoggerFactory.getLogger(CartServiceImpl.class);

    /** 购物车Redis Key前缀 */
    private static final String CART_KEY_PREFIX = "cart:";

    /** 购物车过期时间（秒） */
    private static final int CART_TTL_SECONDS = 7200;

    @Autowired
    private RedisCache redisCache;

    /**
     * 构建Redis key
     */
    private String buildKey(String sessionId)
    {
        return CART_KEY_PREFIX + sessionId;
    }

    /**
     * 从Redis获取当前购物车Map（productId -> CartItem）
     */
    private Map<Long, CartItem> getCartMap(String sessionId)
    {
        String json = redisCache.getCacheObject(buildKey(sessionId));
        if (json == null || json.isEmpty())
        {
            return new LinkedHashMap<>();
        }
        try
        {
            Map<Long, CartItem> map = JSON.parseObject(json, new TypeReference<Map<Long, CartItem>>() {});
            return map != null ? new LinkedHashMap<>(map) : new LinkedHashMap<>();
        }
        catch (Exception e)
        {
            log.error("解析购物车JSON失败, sessionId={}", sessionId, e);
            return new LinkedHashMap<>();
        }
    }

    /**
     * 保存购物车Map到Redis
     */
    private void saveCartMap(String sessionId, Map<Long, CartItem> cartMap)
    {
        String json = JSON.toJSONString(cartMap);
        redisCache.setCacheObject(buildKey(sessionId), json, CART_TTL_SECONDS, TimeUnit.SECONDS);
    }

    @Override
    public List<CartItem> addItem(String sessionId, Long productId, String productName,
            BigDecimal price, Integer quantity, String imageUrl, String shelfArea)
    {
        Map<Long, CartItem> cartMap = getCartMap(sessionId);

        CartItem existItem = cartMap.get(productId);
        if (existItem != null)
        {
            // 已存在：累加数量
            existItem.setQuantity(existItem.getQuantity() + (quantity != null ? quantity : 1));
        }
        else
        {
            // 新增
            CartItem item = new CartItem();
            item.setProductId(productId);
            item.setProductName(productName);
            item.setPrice(price);
            item.setQuantity(quantity != null ? quantity : 1);
            item.setImageUrl(imageUrl);
            item.setShelfArea(shelfArea);
            cartMap.put(productId, item);
        }

        saveCartMap(sessionId, cartMap);
        return toList(cartMap);
    }

    @Override
    public List<CartItem> getCartItems(String sessionId)
    {
        return toList(getCartMap(sessionId));
    }

    @Override
    public List<CartItem> updateQuantity(String sessionId, Long productId, Integer quantity)
    {
        Map<Long, CartItem> cartMap = getCartMap(sessionId);

        CartItem item = cartMap.get(productId);
        if (item != null)
        {
            if (quantity != null && quantity > 0)
            {
                item.setQuantity(quantity);
            }
            else
            {
                cartMap.remove(productId);
            }
        }

        saveCartMap(sessionId, cartMap);
        return toList(cartMap);
    }

    @Override
    public List<CartItem> removeItem(String sessionId, Long productId)
    {
        Map<Long, CartItem> cartMap = getCartMap(sessionId);
        cartMap.remove(productId);
        saveCartMap(sessionId, cartMap);
        return toList(cartMap);
    }

    @Override
    public void clearCart(String sessionId)
    {
        redisCache.deleteObject(buildKey(sessionId));
    }

    @Override
    public int getCartCount(String sessionId)
    {
        Map<Long, CartItem> cartMap = getCartMap(sessionId);
        int total = 0;
        for (CartItem item : cartMap.values())
        {
            total += item.getQuantity() != null ? item.getQuantity() : 0;
        }
        return total;
    }

    /**
     * 将购物车Map转为List
     */
    private List<CartItem> toList(Map<Long, CartItem> cartMap)
    {
        return new ArrayList<>(cartMap.values());
    }
}
