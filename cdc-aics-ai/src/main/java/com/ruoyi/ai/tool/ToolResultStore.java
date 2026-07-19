package com.ruoyi.ai.tool;

import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import com.ruoyi.business.domain.Category;
import com.ruoyi.business.domain.PortalOrder;
import com.ruoyi.business.domain.PortalOrderItem;
import com.ruoyi.business.domain.Product;
import com.ruoyi.portal.domain.CartItem;

/**
 * 工具调用结果暂存（跨线程共享，解决流式端点无法返回卡片数据的问题）。
 * <p>
 * 使用方式：
 * 1. 工具方法执行后 → ToolResultStore.put(sessionId, result)
 * 2. 前端流式结束后 → GET /ai/chat/tool-data?sessionId=xxx → drain 取走结果
 * <p>
 * 使用 ConcurrentHashMap，drain 即取即删，不会内存泄漏。
 */
public final class ToolResultStore {

    private static final ConcurrentHashMap<String, StoredResult> store = new ConcurrentHashMap<>();

    private ToolResultStore() {}

    /** 写入工具结果（每次工具调用都会覆盖同一 sessionId 的上次结果） */
    public static void put(String sessionId, String toolName,
                           List<Product> products, List<Category> categories,
                           List<CartItem> cartItems,
                           PortalOrder order, List<PortalOrderItem> orderItems) {
        StoredResult r = store.computeIfAbsent(sessionId, k -> new StoredResult());
        if (toolName != null) r.toolName = toolName;
        if (products != null) r.products = products;
        if (categories != null) r.categories = categories;
        if (cartItems != null) r.cartItems = cartItems;
        if (order != null) r.order = order;
        if (orderItems != null) r.orderItems = orderItems;
    }

    /** 取出并删除（前端调用一次后即清空） */
    public static StoredResult drain(String sessionId) {
        return store.remove(sessionId);
    }

    /** 暂存的数据结构 */
    public static class StoredResult {
        public String toolName;
        public List<Product> products;
        public List<Category> categories;
        public List<CartItem> cartItems;
        public PortalOrder order;
        public List<PortalOrderItem> orderItems;
    }
}
