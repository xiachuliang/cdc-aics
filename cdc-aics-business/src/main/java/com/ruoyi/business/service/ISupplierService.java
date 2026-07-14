package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.Supplier;

/**
 * 供应商管理 服务层
 *
 * @author cdc-aics
 */
public interface ISupplierService
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
     * 批量删除供应商
     */
    public void deleteSupplierByIds(Long[] ids);
}
