package com.ruoyi.portal.domain;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 购物车商品项
 *
 * @author cdc-aics
 */
public class CartItem implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 商品ID */
    private Long productId;

    /** 商品名称 */
    private String productName;

    /** 单价 */
    private BigDecimal price;

    /** 数量 */
    private Integer quantity;

    /** 商品图片URL */
    private String imageUrl;

    /** 货架位置 */
    private String shelfArea;

    public Long getProductId()
    {
        return productId;
    }

    public void setProductId(Long productId)
    {
        this.productId = productId;
    }

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

    public Integer getQuantity()
    {
        return quantity;
    }

    public void setQuantity(Integer quantity)
    {
        this.quantity = quantity;
    }

    public String getImageUrl()
    {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl)
    {
        this.imageUrl = imageUrl;
    }

    public String getShelfArea()
    {
        return shelfArea;
    }

    public void setShelfArea(String shelfArea)
    {
        this.shelfArea = shelfArea;
    }
}
