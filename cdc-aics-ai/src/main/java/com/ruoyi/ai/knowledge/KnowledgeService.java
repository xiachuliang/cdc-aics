package com.ruoyi.ai.knowledge;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.document.Document;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.stereotype.Service;

import com.ruoyi.ai.rag.TextSplitter;

import io.milvus.client.MilvusServiceClient;
import io.milvus.param.collection.LoadCollectionParam;
import io.milvus.param.dml.DeleteParam;

/**
 * 知识库文档服务 — 上传→切片→入库 / 删除文档→删向量
 *
 * <p><b>两个核心操作：</b>
 * <pre>
 * 上传: TextSplitter.split() → VectorStore.add() → Milvus
 * 删除: Milvus delete by docId → load collection
 * </pre>
 */
@Service
public class KnowledgeService {

    private static final Logger log = LoggerFactory.getLogger(KnowledgeService.class);
    private static final String COLLECTION = "cdc_products";

    private final VectorStore vectorStore;
    private final MilvusServiceClient milvusClient;

    public KnowledgeService(VectorStore vectorStore, MilvusServiceClient milvusClient) {
        this.vectorStore = vectorStore;
        this.milvusClient = milvusClient;
    }

    /**
     * 上传文档：切片 + 写入向量库
     *
     * @param request 文档内容 + 切片参数
     * @param docId   文档标识（存入 metadata，用于后续删除）
     * @return 切片数量
     */
    public int upload(DocumentUploadRequest request, String docId) {
        int chunkSize = request.getChunkSize() != null ? request.getChunkSize() : 300;
        int overlap = request.getOverlap() != null ? request.getOverlap() : 50;

        // 1. 结构感知切片
        List<Document> chunks = TextSplitter.split(
                request.getContent(),
                chunkSize,
                overlap,
                Map.of(
                        "docId", docId,
                        "title", request.getTitle(),
                        "category", request.getCategory() != null ? request.getCategory() : "未分类",
                        "source", "manual_upload"
                )
        );

        log.info("文档「{}」切片完成: {} 字 → {} 个 chunk（chunkSize={}, overlap={}）",
                request.getTitle(), request.getContent().length(), chunks.size(), chunkSize, overlap);

        // 2. 分批写入 Milvus
        int batchSize = 10;
        for (int i = 0; i < chunks.size(); i += batchSize) {
            int end = Math.min(i + batchSize, chunks.size());
            vectorStore.add(chunks.subList(i, end));
        }

        log.info("文档「{}」(docId={}) 入库完成: {} 个 chunk", request.getTitle(), docId, chunks.size());
        return chunks.size();
    }

    /**
     * 删除文档的所有向量切片
     *
     * <p>Milvus 1.1.2 的 VectorStore 没有 deleteByMetadata，
     * 所以用 SDK 直接发 delete 请求，按 docId 过滤删除。
     *
     * <p>删除后需要 load collection 刷新内存状态。
     *
     * @param docId 文档标识
     * @return 是否成功
     */
    public boolean deleteChunks(String docId) {
        try {
            milvusClient.delete(DeleteParam.newBuilder()
                    .withCollectionName(COLLECTION)
                    .withExpr("docId == \"" + docId + "\"")
                    .build());

            // 删除后重新加载，让 Milvus 刷新
            milvusClient.loadCollection(LoadCollectionParam.newBuilder()
                    .withCollectionName(COLLECTION).build());

            log.info("文档切片已删除: docId={}", docId);
            return true;
        } catch (Exception e) {
            log.error("删除文档切片失败: docId={}", docId, e);
            return false;
        }
    }
}
