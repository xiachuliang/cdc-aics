package com.ruoyi.business.domain;

import jakarta.validation.constraints.NotBlank;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * FAQ 问答对象 cdc_knowledge_faq
 *
 * @author cdc-aics
 */
public class KnowledgeFaq extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private Long id;

    /** 问题（导入时对应 Excel 第一列） */
    @Excel(name = "问题")
    @NotBlank(message = "问题不能为空")
    private String question;

    /** 回答（导入时对应 Excel 第二列） */
    @Excel(name = "回答")
    @NotBlank(message = "回答不能为空")
    private String answer;

    /** 分类 */
    @Excel(name = "分类")
    private String category;

    /** 状态（0=禁用 1=启用） */
    @Excel(name = "状态", readConverterExp = "0=禁用,1=启用")
    private String enabled;

    /** 排序 */
    private Integer orderNum;

    // ── getter/setter ──

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getQuestion() { return question; }
    public void setQuestion(String question) { this.question = question; }

    public String getAnswer() { return answer; }
    public void setAnswer(String answer) { this.answer = answer; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getEnabled() { return enabled; }
    public void setEnabled(String enabled) { this.enabled = enabled; }

    public Integer getOrderNum() { return orderNum; }
    public void setOrderNum(Integer orderNum) { this.orderNum = orderNum; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("id", getId())
                .append("question", getQuestion())
                .append("category", getCategory())
                .append("enabled", getEnabled())
                .toString();
    }
}
