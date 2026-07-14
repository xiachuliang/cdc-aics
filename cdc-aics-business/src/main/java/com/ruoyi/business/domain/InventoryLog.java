package com.ruoyi.business.domain;

import java.util.Date;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.annotation.Excel.ColumnType;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 库存流水对象 cdc_inventory_log
 *
 * @author cdc-aics
 */
public class InventoryLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 日志ID */
    @Excel(name = "日志ID", cellType = ColumnType.NUMERIC)
    private Long id;

    /** 商品ID */
    @Excel(name = "商品ID")
    private Long productId;

    /** 变更类型（PURCHASE_IN 采购入库 / SALE_OUT 销售出库 / MANUAL_ADJUST 手动调整 / CANCEL_RESTORE 取消恢复） */
    @Excel(name = "变更类型", readConverterExp = "PURCHASE_IN=采购入库,SALE_OUT=销售出库,MANUAL_ADJUST=手动调整,CANCEL_RESTORE=取消恢复")
    private String changeType;

    /** 变更数量（正数为入库，负数为出库） */
    @Excel(name = "变更数量")
    private Integer changeQuantity;

    /** 变更前库存 */
    @Excel(name = "变更前库存")
    private Integer stockBefore;

    /** 变更后库存 */
    @Excel(name = "变更后库存")
    private Integer stockAfter;

    /** 关联订单号 */
    @Excel(name = "关联订单号")
    private String relatedOrderNo;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "创建时间", dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getProductId()
    {
        return productId;
    }

    public void setProductId(Long productId)
    {
        this.productId = productId;
    }

    public String getChangeType()
    {
        return changeType;
    }

    public void setChangeType(String changeType)
    {
        this.changeType = changeType;
    }

    public Integer getChangeQuantity()
    {
        return changeQuantity;
    }

    public void setChangeQuantity(Integer changeQuantity)
    {
        this.changeQuantity = changeQuantity;
    }

    public Integer getStockBefore()
    {
        return stockBefore;
    }

    public void setStockBefore(Integer stockBefore)
    {
        this.stockBefore = stockBefore;
    }

    public Integer getStockAfter()
    {
        return stockAfter;
    }

    public void setStockAfter(Integer stockAfter)
    {
        this.stockAfter = stockAfter;
    }

    public String getRelatedOrderNo()
    {
        return relatedOrderNo;
    }

    public void setRelatedOrderNo(String relatedOrderNo)
    {
        this.relatedOrderNo = relatedOrderNo;
    }

    @Override
    public Date getCreateTime()
    {
        return createTime;
    }

    @Override
    public void setCreateTime(Date createTime)
    {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("productId", getProductId())
            .append("changeType", getChangeType())
            .append("changeQuantity", getChangeQuantity())
            .append("stockBefore", getStockBefore())
            .append("stockAfter", getStockAfter())
            .append("relatedOrderNo", getRelatedOrderNo())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("remark", getRemark())
            .toString();
    }
}
