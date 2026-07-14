package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.Category;

/**
 * 商品分类管理 数据层
 *
 * @author cdc-aics
 */
public interface CategoryMapper
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
     * 删除分类
     */
    public int deleteCategoryById(Long id);

    /**
     * 批量删除分类
     */
    public int deleteCategoryByIds(Long[] ids);
}
