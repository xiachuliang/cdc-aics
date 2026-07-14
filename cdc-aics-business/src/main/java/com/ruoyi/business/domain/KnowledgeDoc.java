package com.ruoyi.business.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 知识库文档对象 cdc_knowledge_doc
 *
 * @author cdc-aics
 */
public class KnowledgeDoc extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /** 文档ID */
    private Long id;

    /** 文档标题 */
    @Excel(name = "文档标题")
    private String title;

    /** 分类标签 */
    @Excel(name = "分类")
    private String category;

    /** 文档全文 */
    private String content;

    /** 原始文件大小 */
    @Excel(name = "文件大小(KB)")
    private Long fileSize;

    /** 是否已切片（0=未切片 1=已切片） */
    @Excel(name = "切片状态", readConverterExp = "0=未切片,1=已切片")
    private String chunked;

    /** 切片数量 */
    @Excel(name = "切片数")
    private Integer chunkCount;

    /** 切片大小 */
    private Integer chunkSize;

    /** 重叠大小 */
    private Integer overlap;

    /** Milvus文档标识 */
    private String docId;

    // ── getter/setter ──

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Long getFileSize() { return fileSize; }
    public void setFileSize(Long fileSize) { this.fileSize = fileSize; }

    public String getChunked() { return chunked; }
    public void setChunked(String chunked) { this.chunked = chunked; }

    public Integer getChunkCount() { return chunkCount; }
    public void setChunkCount(Integer chunkCount) { this.chunkCount = chunkCount; }

    public Integer getChunkSize() { return chunkSize; }
    public void setChunkSize(Integer chunkSize) { this.chunkSize = chunkSize; }

    public Integer getOverlap() { return overlap; }
    public void setOverlap(Integer overlap) { this.overlap = overlap; }

    public String getDocId() { return docId; }
    public void setDocId(String docId) { this.docId = docId; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("id", getId())
                .append("title", getTitle())
                .append("category", getCategory())
                .append("fileSize", getFileSize())
                .append("chunked", getChunked())
                .append("chunkCount", getChunkCount())
                .append("docId", getDocId())
                .toString();
    }
}
