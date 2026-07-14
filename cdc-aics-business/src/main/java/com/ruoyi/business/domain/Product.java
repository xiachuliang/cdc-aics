package com.ruoyi.business.domain;

import java.math.BigDecimal;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.annotation.Excel.ColumnType;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 商品对象 cdc_product
 *
 * @author cdc-aics
 */
public class Product extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 商品ID */
    @Excel(name = "商品ID", cellType = ColumnType.NUMERIC)
    private Long id;

    /** 商品分类ID */
    private Long categoryId;

    /** 商品条码 */
    @Excel(name = "商品条码")
    private String barcode;

    /** 商品名称 */
    @Excel(name = "商品名称")
    private String productName;

    /** 价格 */
    @Excel(name = "价格")
    private BigDecimal price;

    /** 库存数量 */
    @Excel(name = "库存数量")
    private Integer stock;

    /** 单位 */
    private String unit;

    /** 货架位置 */
    @Excel(name = "货架位置")
    private String shelfArea;

    /** 商品图片URL */
    private String imageUrl;

    /** 商品详细说明 */
    @Excel(name = "商品说明")
    private String description;

    /** 状态（0上架 1下架） */
    @Excel(name = "状态", readConverterExp = "0=上架,1=下架")
    private String status;

    /** 删除标志 */
    private String delFlag;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getCategoryId()
    {
        return categoryId;
    }

    public void setCategoryId(Long categoryId)
    {
        this.categoryId = categoryId;
    }

    public String getBarcode()
    {
        return barcode;
    }

    public void setBarcode(String barcode)
    {
        this.barcode = barcode;
    }

    @NotBlank(message = "商品名称不能为空")
    @Size(min = 0, max = 128, message = "商品名称不能超过128个字符")
    public String getProductName()
    {
        return productName;
    }

    public void setProductName(String productName)
    {
        this.productName = productName;
    }

    public BigDecimal getPrice()
    {
        return price;
    }

    public void setPrice(BigDecimal price)
    {
        this.price = price;
    }

    public Integer getStock()
    {
        return stock;
    }

    public void setStock(Integer stock)
    {
        this.stock = stock;
    }

    public String getUnit()
    {
        return unit;
    }

    public void setUnit(String unit)
    {
        this.unit = unit;
    }

    public String getShelfArea()
    {
        return shelfArea;
    }

    public void setShelfArea(String shelfArea)
    {
        this.shelfArea = shelfArea;
    }

    public String getImageUrl()
    {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl)
    {
        this.imageUrl = imageUrl;
    }

    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("categoryId", getCategoryId())
            .append("barcode", getBarcode())
            .append("productName", getProductName())
            .append("price", getPrice())
            .append("stock", getStock())
            .append("unit", getUnit())
            .append("shelfArea", getShelfArea())
            .append("imageUrl", getImageUrl())
            .append("status", getStatus())
            .append("delFlag", getDelFlag())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
