package com.ruoyi.ai.knowledge;

/**
 * 文档上传请求
 */
public class DocumentUploadRequest {

    /** 文档标题 */
    private String title;

    /** 文档内容 */
    private String content;

    /** 分类（可选，如：产品手册/规章制度/培训资料） */
    private String category;

    /** 切片大小（可选，默认 300 字符） */
    private Integer chunkSize;

    /** 滑动窗口重叠大小（可选，默认 50 字符） */
    private Integer overlap;

    // ── getter/setter ──

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public Integer getChunkSize() { return chunkSize; }
    public void setChunkSize(Integer chunkSize) { this.chunkSize = chunkSize; }

    public Integer getOverlap() { return overlap; }
    public void setOverlap(Integer overlap) { this.overlap = overlap; }
}
