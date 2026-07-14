package com.ruoyi.ai.agent;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.document.Document;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.stereotype.Component;

import com.ruoyi.ai.rag.TextSplitter;
import com.ruoyi.business.domain.KnowledgeDoc;
import com.ruoyi.business.domain.KnowledgeFaq;
import com.ruoyi.business.service.IKnowledgeDocService;
import com.ruoyi.business.service.IKnowledgeFaqService;

import io.milvus.client.MilvusServiceClient;
import io.milvus.grpc.DataType;
import io.milvus.param.collection.CreateCollectionParam;
import io.milvus.param.collection.DescribeCollectionParam;
import io.milvus.param.collection.DropCollectionParam;
import io.milvus.param.collection.FlushParam;
import io.milvus.param.MetricType;
import io.milvus.param.collection.FieldType;
import io.milvus.param.collection.HasCollectionParam;
import io.milvus.param.collection.LoadCollectionParam;
import io.milvus.param.IndexType;
import io.milvus.param.dml.QueryParam;
import io.milvus.param.index.CreateIndexParam;
import jakarta.annotation.PostConstruct;

/**
 * 知识库初始化：首次启动建 collection + 全量加载 FAQ
 *
 * <p><b>策略：</b>
 * <ul>
 *   <li>collection 不存在 → 创建 + 建索引 + 全量加载 FAQ</li>
 *   <li>collection 已存在 → 跳过（运行时由 @FaqSync 增量维护，重启不丢数据）</li>
 * </ul>
 *
 * <p><b>和 @FaqSync 的分工：</b>
 * <pre>
 * Initializer  → 首次启动/灾后恢复（Milvus 数据丢了，从 MySQL 全量重建）
 * @FaqSync    → 运行时增量（增/改/删 FAQ 实时同步，不重启也生效）
 * </pre>
 */
@Component
public class KnowledgeBaseInitializer {

    private static final Logger log = LoggerFactory.getLogger(KnowledgeBaseInitializer.class);
    private static final String COLLECTION = "cdc_products";

    private final VectorStore vectorStore;
    private final IKnowledgeFaqService faqService;
    private final IKnowledgeDocService docService;
    private final MilvusServiceClient milvusClient;

    public KnowledgeBaseInitializer(VectorStore vectorStore,
                                     IKnowledgeFaqService faqService,
                                     IKnowledgeDocService docService,
                                     MilvusServiceClient milvusClient) {
        this.vectorStore = vectorStore;
        this.faqService = faqService;
        this.docService = docService;
        this.milvusClient = milvusClient;
    }

    @PostConstruct
    public void init() {
        try {
            boolean exists = milvusClient.hasCollection(
                    HasCollectionParam.newBuilder().withCollectionName(COLLECTION).build()).getData();

            boolean needRebuild = false;
            if (exists) {
                // 检查 schema 是否兼容（必须有 doc_id 字段，Spring AI 依赖这个字段）
                boolean hasDocId = false;
                var desc = milvusClient.describeCollection(
                        DescribeCollectionParam.newBuilder().withCollectionName(COLLECTION).build());
                for (var field : desc.getData().getSchema().getFieldsList()) {
                    if ("doc_id".equals(field.getName())) {
                        hasDocId = true;
                        break;
                    }
                }

                if (!hasDocId) {
                    log.info("旧版 schema（缺少 doc_id 字段），需要重建 collection");
                    needRebuild = true;
                } else {
                    // schema 兼容，用 query 查实际存活实体数（getCollectionStatistics 含软删除，不准）
                    try {
                        milvusClient.loadCollection(LoadCollectionParam.newBuilder()
                                .withCollectionName(COLLECTION).build());
                        var queryResult = milvusClient.query(QueryParam.newBuilder()
                                .withCollectionName(COLLECTION)
                                .withExpr("doc_id != \"\"")
                                .withLimit(1L)
                                .withOutFields(List.of("doc_id"))
                                .build());
                        int fieldCount = queryResult.getData().getFieldsDataCount();
                        if (queryResult.getStatus() == 0
                                && fieldCount > 0
                                && queryResult.getData().getFieldsData(0).getScalars().getStringData().getDataCount() > 0) {
                            log.info("Milvus collection 有实际数据，跳过初始化");
                            return;
                        }
                    } catch (Exception e) {
                        log.warn("查询 Milvus 实际数据失败，将重建: {}", e.getMessage());
                    }
                    log.info("Milvus collection 无实际数据，重新加载");
                    needRebuild = true;
                }
            } else {
                log.info("Milvus collection 不存在，开始首次初始化...");
                needRebuild = true;
            }

            if (needRebuild) {
                // 删旧建新
                if (exists) {
                    milvusClient.dropCollection(DropCollectionParam.newBuilder()
                            .withCollectionName(COLLECTION).build());
                    log.info("已删除旧 collection");
                }
            } else {
                return;
            }

            // 1. 建 collection
            milvusClient.createCollection(CreateCollectionParam.newBuilder()
                    .withCollectionName(COLLECTION)
                    .withDescription("CDC 知识库（FAQ + 文档切片）")
                    .withFieldTypes(List.of(
                            FieldType.newBuilder().withName("doc_id")
                                    .withDataType(DataType.VarChar).withMaxLength(128).withPrimaryKey(true).build(),
                            FieldType.newBuilder().withName("metadata")
                                    .withDataType(DataType.JSON).build(),
                            FieldType.newBuilder().withName("content")
                                    .withDataType(DataType.VarChar).withMaxLength(2048).build(),
                            FieldType.newBuilder().withName("embedding")
                                    .withDataType(DataType.FloatVector).withDimension(1024).build()
                    ))
                    .build());
            log.info("创建 collection: {}", COLLECTION);

            // 2. 加载启用状态的 FAQ
            List<KnowledgeFaq> faqs = faqService.selectList(new KnowledgeFaq());
            List<Document> docs = new ArrayList<>();
            int faqCount = 0;
            for (KnowledgeFaq f : faqs) {
                if (!"1".equals(f.getEnabled())) continue;
                if (f.getQuestion() == null || f.getAnswer() == null) continue;
                docs.add(new Document(f.getQuestion(), Map.of(
                        "faqId", String.valueOf(f.getId()),
                        "question", f.getQuestion(),
                        "answer", f.getAnswer(),
                        "category", f.getCategory() != null ? f.getCategory() : "通用",
                        "source", "faq"
                )));
                faqCount++;
            }

            // 2b. 加载已切片的文档（规章制度等 Word 上传的）
            List<KnowledgeDoc> docList = docService.selectList(new KnowledgeDoc());
            int docCount = 0;
            for (KnowledgeDoc d : docList) {
                if (!"1".equals(d.getChunked())) continue;
                if (d.getContent() == null || d.getDocId() == null) continue;
                int cs = d.getChunkSize() != null ? d.getChunkSize() : 300;
                int ov = d.getOverlap() != null ? d.getOverlap() : 50;
                List<Document> chunks = TextSplitter.split(d.getContent(), cs, ov,
                        Map.of("docId", d.getDocId(), "title",
                                d.getTitle() != null ? d.getTitle() : "",
                                "category", d.getCategory() != null ? d.getCategory() : "未分类",
                                "source", "manual_upload"));
                docs.addAll(chunks);
                docCount++;
            }
            log.info("文档待加载: {} 篇 → {} 个切片", docCount, docCount > 0 ? docs.size() - faqCount : 0);

            // 3. 分批写入
            if (!docs.isEmpty()) {
                int batchSize = 10;
                for (int i = 0; i < docs.size(); i += batchSize) {
                    int end = Math.min(i + batchSize, docs.size());
                    vectorStore.add(docs.subList(i, end));
                    log.info("批次 {}/{}: {} 条", (i / batchSize) + 1,
                            (docs.size() + batchSize - 1) / batchSize, end - i);
                }
            }

            // 3b. 刷盘（flush 才真正落盘，否则重启数据丢失）
            milvusClient.flush(FlushParam.newBuilder()
                    .withCollectionNames(List.of(COLLECTION)).build());
            log.info("数据已刷盘");

            // 4. 建索引
            milvusClient.createIndex(CreateIndexParam.newBuilder()
                    .withCollectionName(COLLECTION)
                    .withFieldName("embedding")
                    .withIndexType(IndexType.IVF_FLAT)
                    .withMetricType(MetricType.COSINE)
                    .withExtraParam("{\"nlist\":128}")
                    .build());
            log.info("索引创建成功");

            // 5. 加载到内存
            milvusClient.loadCollection(LoadCollectionParam.newBuilder()
                    .withCollectionName(COLLECTION).build());
            log.info("知识库初始化完成: {} 条 FAQ + {} 篇文档（{} 个切片）",
                    faqCount, docCount, docs.size() - faqCount);
        } catch (Exception e) {
            log.error("知识库初始化失败", e);
        }
    }
}
