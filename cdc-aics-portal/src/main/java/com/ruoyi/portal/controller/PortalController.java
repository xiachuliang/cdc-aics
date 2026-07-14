package com.ruoyi.portal.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.business.domain.Category;
import com.ruoyi.business.domain.Product;
import com.ruoyi.business.service.ICategoryService;
import com.ruoyi.business.service.IProductService;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * C端门户 - 分类/商品接口（免登录）
 *
 * @author cdc-aics
 */
@Anonymous
@RestController
@RequestMapping("/portal")
public class PortalController extends BaseController
{
    @Autowired
    private ICategoryService categoryService;

    @Autowired
    private IProductService productService;

    /** ========== 分类接口 ========== */

    /**
     * 获取所有启用的分类列表
     */
    @GetMapping("/category/list")
    public AjaxResult categoryList()
    {
        List<Category> list = categoryService.selectCategoryAll();
        return success(list);
    }

    /** ========== 商品接口 ========== */

    /**
     * 商品分页查询（支持分类、关键词筛选）
     */
    @GetMapping("/product/page")
    public TableDataInfo productPage(Product product)
    {
        startPage();
        // C端只展示上架商品
        product.setStatus("0");
        List<Product> list = productService.selectProductList(product);
        return getDataTable(list);
    }

    /**
     * 商品详情
     */
    @GetMapping("/product/{id}")
    public AjaxResult productDetail(@PathVariable Long id)
    {
        Product product = productService.selectProductById(id);
        return success(product);
    }

    /**
     * 商品搜索（按名称模糊匹配）
     */
    @GetMapping("/product/search")
    public TableDataInfo productSearch(Product product)
    {
        startPage();
        // 强制按名称搜索
        product.setBarcode(null);
        List<Product> list = productService.selectProductList(product);
        return getDataTable(list);
    }
}
