package com.ruoyi.ai.tool;

import java.util.Collections;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.ruoyi.business.domain.Category;
import com.ruoyi.business.domain.Product;
import com.ruoyi.business.service.ICategoryService;
import com.ruoyi.business.service.IProductService;

@Component
public class ProductTools {

    private static final Logger log = LoggerFactory.getLogger(ProductTools.class);

    @Autowired
    private IProductService productService;

    @Autowired
    private ICategoryService categoryService;

    /**
     * ThreadLocal：暂存最近一次工具调用的结果，供 ChatServiceImpl 取出
     */
    private static final ThreadLocal<ToolResult> LAST_RESULT = new ThreadLocal<>();

    /**
     * 取出工具调用结果并清理（防止内存泄漏）
     */
    public static ToolResult drainResult() {
        ToolResult r = LAST_RESULT.get();
        LAST_RESULT.remove();
        return r;
    }

    /**
     * 工具调用结果
     */
    public static class ToolResult {
        public String toolName;
        public List<Product> products;
        public List<Category> categories;

        public ToolResult(String toolName) {
            this.toolName = toolName;
        }
    }

    // ==================== 商品查询工具 ====================

    /**
     * 工具1：按名称搜索商品
     */
    @Tool(description = "按商品名称关键词搜索已上架的商品。传入搜索词，返回匹配的商品列表，包含商品名、价格、库存数量、货架位置")
    public List<Product> searchProducts(
            @ToolParam(description = "搜索关键词，比如'零食'、'可乐'、'牛奶'") String keyword
    ) {
        try {
            Product query = new Product();
            query.setProductName(keyword);
            query.setStatus("0");
            List<Product> result = productService.selectProductList(query);

            ToolResult tr = new ToolResult("searchProducts");
            tr.products = result;
            LAST_RESULT.set(tr);

            return result;
        } catch (Exception e) {
            log.error("searchProducts 工具执行失败, keyword={}", keyword, e);
            return Collections.emptyList();
        }
    }

    /**
     * 工具2：查有库存的商品
     */
    @Tool(description = "查询所有有库存且已上架的商品列表。不需要参数，返回库存数量大于0的商品，包含商品名、价格、库存数量")
    public List<Product> getStockProducts() {
        try {
            Product query = new Product();
            query.setStatus("0");
            List<Product> allProducts = productService.selectProductList(query);
            allProducts.removeIf(p -> p.getStock() == null || p.getStock() <= 0);

            ToolResult tr = new ToolResult("getStockProducts");
            tr.products = allProducts;
            LAST_RESULT.set(tr);

            return allProducts;
        } catch (Exception e) {
            log.error("getStockProducts 工具执行失败", e);
            return Collections.emptyList();
        }
    }

    /**
     * 工具3：查商品详情
     */
    @Tool(description = "根据商品ID查看单个商品的完整信息，包含商品名、价格、库存、描述、图片URL、货架位置")
    public Product getProductDetail(
            @ToolParam(description = "商品ID，数字类型") Long productId
    ) {
        try {
            Product product = productService.selectProductById(productId);

            ToolResult tr = new ToolResult("getProductDetail");
            if (product != null) {
                tr.products = Collections.singletonList(product);
            }
            LAST_RESULT.set(tr);

            return product;
        } catch (Exception e) {
            log.error("getProductDetail 工具执行失败, productId={}", productId, e);
            return null;
        }
    }

    // ==================== 分类查询工具 ====================

    /**
     * 工具4：查所有分类
     */
    @Tool(description = "获取超市所有商品分类列表，包含分类ID和分类名称")
    public List<Category> listCategories() {
        try {
            List<Category> result = categoryService.selectCategoryAll();

            ToolResult tr = new ToolResult("listCategories");
            tr.categories = result;
            LAST_RESULT.set(tr);

            return result;
        } catch (Exception e) {
            log.error("listCategories 工具执行失败", e);
            return Collections.emptyList();
        }
    }

    /**
     * 工具5：按分类查商品
     */
    @Tool(description = "根据分类ID查询该分类下所有已上架的商品列表")
    public List<Product> getProductsByCategory(
            @ToolParam(description = "商品分类ID，数字类型") Long categoryId
    ) {
        try {
            Product query = new Product();
            query.setCategoryId(categoryId);
            query.setStatus("0");
            List<Product> result = productService.selectProductList(query);

            ToolResult tr = new ToolResult("getProductsByCategory");
            tr.products = result;
            LAST_RESULT.set(tr);

            return result;
        } catch (Exception e) {
            log.error("getProductsByCategory 工具执行失败, categoryId={}", categoryId, e);
            return Collections.emptyList();
        }
    }
}
