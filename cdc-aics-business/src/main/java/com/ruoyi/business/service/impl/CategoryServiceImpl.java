package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.domain.Category;
import com.ruoyi.business.mapper.CategoryMapper;
import com.ruoyi.business.service.ICategoryService;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;

/**
 * 商品分类管理 服务层实现
 *
 * @author cdc-aics
 */
@Service
public class CategoryServiceImpl implements ICategoryService
{
    @Autowired
    private CategoryMapper categoryMapper;

    @Override
    public Category selectCategoryById(Long id)
    {
        return categoryMapper.selectCategoryById(id);
    }

    @Override
    public List<Category> selectCategoryList(Category category)
    {
        return categoryMapper.selectCategoryList(category);
    }

    @Override
    public List<Category> selectCategoryAll()
    {
        return categoryMapper.selectCategoryAll();
    }

    @Override
    public int insertCategory(Category category)
    {
        return categoryMapper.insertCategory(category);
    }

    @Override
    public int updateCategory(Category category)
    {
        return categoryMapper.updateCategory(category);
    }

    @Override
    public void deleteCategoryByIds(Long[] ids)
    {
        for (Long id : ids)
        {
            Category category = selectCategoryById(id);
            if (StringUtils.isNull(category))
            {
                throw new ServiceException("分类不存在");
            }
        }
        categoryMapper.deleteCategoryByIds(ids);
    }
}
