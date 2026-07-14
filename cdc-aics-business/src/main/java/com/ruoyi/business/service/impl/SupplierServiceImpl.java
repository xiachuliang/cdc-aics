package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.domain.Supplier;
import com.ruoyi.business.mapper.SupplierMapper;
import com.ruoyi.business.service.ISupplierService;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;

/**
 * 供应商管理 服务层实现
 *
 * @author cdc-aics
 */
@Service
public class SupplierServiceImpl implements ISupplierService
{
    @Autowired
    private SupplierMapper supplierMapper;

    @Override
    public Supplier selectSupplierById(Long id)
    {
        return supplierMapper.selectSupplierById(id);
    }

    @Override
    public List<Supplier> selectSupplierList(Supplier supplier)
    {
        return supplierMapper.selectSupplierList(supplier);
    }

    @Override
    public int insertSupplier(Supplier supplier)
    {
        return supplierMapper.insertSupplier(supplier);
    }

    @Override
    public int updateSupplier(Supplier supplier)
    {
        return supplierMapper.updateSupplier(supplier);
    }

    @Override
    public void deleteSupplierByIds(Long[] ids)
    {
        for (Long id : ids)
        {
            Supplier supplier = selectSupplierById(id);
            if (StringUtils.isNull(supplier))
            {
                throw new ServiceException("供应商不存在");
            }
        }
        supplierMapper.deleteSupplierByIds(ids);
    }
}
