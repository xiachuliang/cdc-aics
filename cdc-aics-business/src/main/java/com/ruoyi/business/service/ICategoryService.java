package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.Category;

/**
 * 商品分类管理 服务层
 *
 * @author cdc-aics
 */
public interface ICategoryService
{
    /**
     * 根据ID查询分类
     */
    public Category selectCategoryById(Long id);

    /**
     * 查询分类列表
     */
    public List<Category> selectCategoryList(Category category);

    /**
     * 查询所有启用的分类列表
     */
    public List<Category> selectCategoryAll();

    /**
     * 新增分类
     */
    public int insertCategory(Category category);

    /**
     * 修改分类
     */
    public int updateCategory(Category category);

    /**
     * 批量删除分类
     */
    public void deleteCategoryByIds(Long[] ids);
}
