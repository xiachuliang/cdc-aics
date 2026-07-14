package com.ruoyi.ai.knowledge;

import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.ruoyi.business.domain.KnowledgeDoc;
import com.ruoyi.business.service.IKnowledgeDocService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 知识库文档管理 — 上传 Word / 切片入库 / 列表 / 删除
 *
 * <p><b>API 一览：</b>
 * <pre>
 * POST   /ai/knowledge/upload    上传 Word → 切片 → 入库
 * GET    /ai/knowledge/list      文档列表（支持按 title/category/chunked 筛选）
 * GET    /ai/knowledge/{id}      文档详情（含全文）
 * DELETE /ai/knowledge/{id}      删除文档 + 删除 Milvus 向量
 * </pre>
 */
@RestController
@RequestMapping("/ai/knowledge")
public class KnowledgeController extends BaseController {

    @Autowired
    private KnowledgeService knowledgeService;

    @Autowired
    private IKnowledgeDocService docService;

    /**
     * 上传 Word 文档
     *
     * @param file      .docx 文件
     * @param category  分类
     * @param doChunk   是否切片（默认 true）
     * @param chunkSize 切片大小（默认 300）
     * @param overlap   重叠大小（默认 50）
     */
    @PostMapping("/upload")
    public AjaxResult upload(@RequestParam("file") MultipartFile file,
                             @RequestParam(required = false) String category,
                             @RequestParam(required = false, defaultValue = "true") boolean doChunk,
                             @RequestParam(required = false, defaultValue = "300") int chunkSize,
                             @RequestParam(required = false, defaultValue = "50") int overlap) {
        try {
            // 1. 解析 Word
            WordParser.ParseResult parsed = WordParser.parse(
                    file.getInputStream(), file.getOriginalFilename());

            // 2. 存 MySQL
            String docId = UUID.randomUUID().toString().substring(0, 8);

            KnowledgeDoc doc = new KnowledgeDoc();
            doc.setTitle(parsed.title());
            doc.setContent(parsed.content());
            doc.setCategory(category);
            doc.setFileSize(file.getSize() / 1024);  // KB
            doc.setChunkSize(chunkSize);
            doc.setOverlap(overlap);

            // 3. 切片（可选）
            if (doChunk) {
                DocumentUploadRequest req = new DocumentUploadRequest();
                req.setTitle(parsed.title());
                req.setContent(parsed.content());
                req.setCategory(category);
                req.setChunkSize(chunkSize);
                req.setOverlap(overlap);

                int chunkCount = knowledgeService.upload(req, docId);
                doc.setChunked("1");
                doc.setChunkCount(chunkCount);
                doc.setDocId(docId);
            } else {
                doc.setChunked("0");
                doc.setChunkCount(0);
                doc.setDocId(docId);
            }

            docService.insert(doc);

            return AjaxResult.success(Map.of(
                    "id", doc.getId(),
                    "title", parsed.title(),
                    "chars", parsed.content().length(),
                    "chunked", doChunk,
                    "chunks", doChunk ? doc.getChunkCount() : 0
            ));
        } catch (Exception e) {
            return AjaxResult.error("文档上传失败: " + e.getMessage());
        }
    }

    /**
     * 文档列表（分页）
     */
    @GetMapping("/list")
    public TableDataInfo list(KnowledgeDoc doc) {
        startPage();
        return getDataTable(docService.selectList(doc));
    }

    /**
     * 文档详情
     */
    @GetMapping("/{id}")
    public AjaxResult detail(@PathVariable Long id) {
        KnowledgeDoc doc = docService.selectById(id);
        if (doc == null) {
            return AjaxResult.error("文档不存在");
        }
        return AjaxResult.success(doc);
    }

    /**
     * 删除文档 — 同时删除 MySQL 记录 + Milvus 向量切片
     */
    @DeleteMapping("/{id}")
    public AjaxResult delete(@PathVariable Long id) {
        KnowledgeDoc doc = docService.selectById(id);
        if (doc == null) {
            return AjaxResult.error("文档不存在");
        }

        // 1. 如果已切片，先删 Milvus 里的向量
        if ("1".equals(doc.getChunked()) && doc.getDocId() != null) {
            knowledgeService.deleteChunks(doc.getDocId());
        }

        // 2. 删 MySQL 记录
        docService.deleteById(id);

        return AjaxResult.success(Map.of(
                "deleted", true,
                "title", doc.getTitle(),
                "chunksDeleted", "1".equals(doc.getChunked())
        ));
    }
}
