package com.ruoyi.business.ranking.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 融合展示榜对象 cdc_display_ranking
 * 由热销榜 + 推荐榜加权融合生成，不手动编辑
 * 排名 = ORDER BY final_score DESC
 *
 * @author cdc-aics
 */
public class DisplayRanking extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** ID */
    private Long id;

    /** 商品ID */
    @Excel(name = "商品ID")
    private Long productId;

    /** 最终得分（排序依据） */
    @Excel(name = "最终得分")
    private BigDecimal finalScore;

    /** 热销贡献分 */
    @Excel(name = "热销分")
    private BigDecimal hotScore;

    /** 推荐贡献分 */
    @Excel(name = "推荐分")
    private BigDecimal recScore;

    /** 来源（BOTH/HOT_ONLY/REC_ONLY） */
    @Excel(name = "来源", readConverterExp = "BOTH=热销+推荐,HOT_ONLY=仅热销,REC_ONLY=仅推荐")
    private String source;

    /** 状态 */
    @Excel(name = "状态", readConverterExp = "0=启用,1=停用")
    private String status;

    /** 生成时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date generateTime;

    /** 商品名称（联表查询） */
    private String productName;

    /** 商品价格（联表查询） */
    private BigDecimal productPrice;

    /** 商品图片（联表查询） */
    private String productImage;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public BigDecimal getFinalScore() { return finalScore; }
    public void setFinalScore(BigDecimal finalScore) { this.finalScore = finalScore; }

    public BigDecimal getHotScore() { return hotScore; }
    public void setHotScore(BigDecimal hotScore) { this.hotScore = hotScore; }

    public BigDecimal getRecScore() { return recScore; }
    public void setRecScore(BigDecimal recScore) { this.recScore = recScore; }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getGenerateTime() { return generateTime; }
    public void setGenerateTime(Date generateTime) { this.generateTime = generateTime; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public BigDecimal getProductPrice() { return productPrice; }
    public void setProductPrice(BigDecimal productPrice) { this.productPrice = productPrice; }

    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }

    @Override
    public String toString() {
        return new org.apache.commons.lang3.builder.ToStringBuilder(this, org.apache.commons.lang3.builder.ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("productId", getProductId())
            .append("finalScore", getFinalScore())
            .append("hotScore", getHotScore())
            .append("recScore", getRecScore())
            .append("source", getSource())
            .append("status", getStatus())
            .append("generateTime", getGenerateTime())
            .toString();
    }
}
