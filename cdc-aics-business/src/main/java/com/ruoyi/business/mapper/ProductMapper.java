package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.Product;

/**
 * 商品管理 数据层
 *
 * @author cdc-aics
 */
public interface ProductMapper
{
    /**
     * 根据ID查询商品
     */
    public Product selectProductById(Long id);

    /**
     * 根据ID查询商品（行锁，用于并发库存扣减）
     */
    public Product selectProductByIdForUpdate(Long id);

    /**
     * 查询商品列表
     */
    public List<Product> selectProductList(Product product);

    /**
     * 根据条码查询商品
     */
    public Product selectProductByBarcode(String barcode);

    /**
     * 校验条码唯一性
     */
    public Product checkBarcodeUnique(String barcode);

    /**
     * 新增商品
     */
    public int insertProduct(Product product);

    /**
     * 修改商品
     */
    public int updateProduct(Product product);

    /**
     * 删除商品
     */
    public int deleteProductById(Long id);

    /**
     * 批量删除商品
     */
    public int deleteProductByIds(Long[] ids);
}
