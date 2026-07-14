package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.Supplier;

/**
 * 供应商管理 数据层
 *
 * @author cdc-aics
 */
public interface SupplierMapper
{
    /**
     * 根据ID查询供应商
     */
    public Supplier selectSupplierById(Long id);

    /**
     * 查询供应商列表
     */
    public List<Supplier> selectSupplierList(Supplier supplier);

    /**
     * 新增供应商
     */
    public int insertSupplier(Supplier supplier);

    /**
     * 修改供应商
     */
    public int updateSupplier(Supplier supplier);

    /**
     * 删除供应商
     */
    public int deleteSupplierById(Long id);

    /**
     * 批量删除供应商
     */
    public int deleteSupplierByIds(Long[] ids);
}
