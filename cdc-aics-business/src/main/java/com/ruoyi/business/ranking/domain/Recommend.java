package com.ruoyi.business.ranking.domain;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 运营推荐榜对象 cdc_recommend
 * 优先级 = ORDER BY score DESC，实时计算，不存死序号
 *
 * @author cdc-aics
 */
public class Recommend extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** ID */
    private Long id;

    /** 商品ID */
    @Excel(name = "商品ID")
    private Long productId;

    /** 推荐指数（0-100，排序依据，越高越优先） */
    @Excel(name = "推荐指数")
    private Integer score;

    /** 推荐理由 */
    @Excel(name = "推荐理由")
    private String reason;

    /** 状态 */
    @Excel(name = "状态", readConverterExp = "0=启用,1=停用")
    private String status;

    /** 商品名称（联表查询） */
    private String productName;

    /** 商品价格（联表查询） */
    private java.math.BigDecimal productPrice;

    /** 商品图片（联表查询） */
    private String productImage;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    @NotNull(message = "商品ID不能为空")
    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    @NotNull(message = "推荐指数不能为空")
    public Integer getScore() { return score; }
    public void setScore(Integer score) { this.score = score; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public java.math.BigDecimal getProductPrice() { return productPrice; }
    public void setProductPrice(java.math.BigDecimal productPrice) { this.productPrice = productPrice; }

    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("productId", getProductId())
            .append("score", getScore())
            .append("reason", getReason())
            .append("status", getStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
