package com.ruoyi.business.service.impl;

import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.domain.Product;
import com.ruoyi.business.mapper.ProductMapper;
import com.ruoyi.business.service.IProductService;
import com.ruoyi.common.constant.UserConstants;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;

/**
 * 商品管理 服务层实现
 *
 * @author cdc-aics
 */
@Service
public class ProductServiceImpl implements IProductService
{
    private static final Logger log = LoggerFactory.getLogger(ProductServiceImpl.class);

    @Autowired
    private ProductMapper productMapper;

    @Override
    public Product selectProductById(Long id)
    {
        return productMapper.selectProductById(id);
    }

    @Override
    public List<Product> selectProductList(Product product)
    {
        return productMapper.selectProductList(product);
    }

    @Override
    public int insertProduct(Product product)
    {
        return productMapper.insertProduct(product);
    }

    @Override
    public int updateProduct(Product product)
    {
        return productMapper.updateProduct(product);
    }

    @Override
    public void deleteProductByIds(Long[] ids)
    {
        for (Long id : ids)
        {
            Product product = selectProductById(id);
            if (StringUtils.isNull(product))
            {
                throw new ServiceException("商品不存在");
            }
        }
        productMapper.deleteProductByIds(ids);
    }

    @Override
    public boolean checkBarcodeUnique(Product product)
    {
        Long id = StringUtils.isNull(product.getId()) ? -1L : product.getId();
        Product info = productMapper.checkBarcodeUnique(product.getBarcode());
        if (StringUtils.isNotNull(info) && info.getId().longValue() != id.longValue())
        {
            return UserConstants.NOT_UNIQUE;
        }
        return UserConstants.UNIQUE;
    }

    @Override
    public String importProduct(List<Product> productList, String operatorName)
    {
        if (StringUtils.isNull(productList) || productList.size() == 0)
        {
            throw new ServiceException("导入商品数据不能为空！");
        }
        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();

        for (Product product : productList)
        {
            try
            {
                product.setCreateBy(operatorName);
                this.insertProduct(product);
                successNum++;
                successMsg.append("<br/>").append(successNum).append("、商品 ").append(product.getProductName()).append(" 导入成功");
            }
            catch (Exception e)
            {
                failureNum++;
                String msg = "<br/>" + failureNum + "、商品 " + product.getProductName() + " 导入失败：";
                failureMsg.append(msg).append(e.getMessage());
                log.error(msg, e);
            }
        }
        if (failureNum > 0)
        {
            failureMsg.insert(0, "很抱歉，导入失败！共 " + failureNum + " 条数据格式不正确，错误如下：");
            throw new ServiceException(failureMsg.toString());
        }
        else
        {
            successMsg.insert(0, "恭喜您，数据已全部导入成功！共 " + successNum + " 条，数据如下：");
        }
        return successMsg.toString();
    }

    @Override
    public int updateStock(Long productId, int delta)
    {
        Product product = selectProductById(productId);
        if (StringUtils.isNull(product))
        {
            throw new ServiceException("商品不存在");
        }
        int currentStock = product.getStock() != null ? product.getStock() : 0;
        int newStock = currentStock + delta;
        if (newStock < 0)
        {
            throw new ServiceException("库存不足，当前库存：" + currentStock + "，需要：" + Math.abs(delta));
        }
        product.setStock(newStock);
        return updateProduct(product);
    }

    @Override
    public int deductStock(Long productId, int quantity)
    {
        Product product = selectProductById(productId);
        if (StringUtils.isNull(product))
        {
            throw new ServiceException("商品不存在");
        }
        int currentStock = product.getStock() != null ? product.getStock() : 0;
        if (currentStock < quantity)
        {
            throw new ServiceException("库存不足，当前库存：" + currentStock + "，需要：" + quantity);
        }
        return updateStock(productId, -quantity);
    }
}
