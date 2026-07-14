package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.Product;

/**
 * 商品管理 服务层
 *
 * @author cdc-aics
 */
public interface IProductService
{
    /**
     * 根据ID查询商品
     */
    public Product selectProductById(Long id);

    /**
     * 查询商品列表
     */
    public List<Product> selectProductList(Product product);

    /**
     * 新增商品
     */
    public int insertProduct(Product product);

    /**
     * 修改商品
     */
    public int updateProduct(Product product);

    /**
     * 批量删除商品
     */
    public void deleteProductByIds(Long[] ids);

    /**
     * 校验条码唯一性
     */
    public boolean checkBarcodeUnique(Product product);

    /**
     * 批量导入商品
     */
    public String importProduct(List<Product> productList, String operatorName);

    /**
     * 更新库存（delta为正数时增加库存，为负数时减少库存）
     */
    public int updateStock(Long productId, int delta);

    /**
     * 扣减库存（先校验库存是否充足）
     */
    public int deductStock(Long productId, int quantity);
}
