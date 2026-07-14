package com.ruoyi.ai.agent;

import java.util.List;
import java.util.Map;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.document.Document;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.stereotype.Component;

import com.ruoyi.business.annotation.FaqSync;
import com.ruoyi.business.annotation.FaqSync.Action;
import com.ruoyi.business.domain.KnowledgeFaq;
import com.ruoyi.business.service.IKnowledgeFaqService;

import io.milvus.client.MilvusServiceClient;
import io.milvus.param.collection.FlushParam;
import io.milvus.param.collection.LoadCollectionParam;
import io.milvus.param.dml.DeleteParam;

/**
 * FAQ 同步切面：拦截 @FaqSync 注解，自动同步 Milvus
 *
 * <p><b>设计要点：</b>
 * <ul>
 *   <li>向量化内容：只取 question，方便语义匹配</li>
 *   <li>metadata：存 question + answer，检索后连带返回回答</li>
 *   <li>disabled=0 的 FAQ 不写入向量库</li>
 * </ul>
 */
@Aspect
@Component
public class FaqSyncAspect {

    private static final Logger log = LoggerFactory.getLogger(FaqSyncAspect.class);
    private static final String COLLECTION = "cdc_products";

    private final VectorStore vectorStore;
    private final IKnowledgeFaqService faqService;
    private final MilvusServiceClient milvusClient;

    public FaqSyncAspect(VectorStore vectorStore, IKnowledgeFaqService faqService,
                          MilvusServiceClient milvusClient) {
        this.vectorStore = vectorStore;
        this.faqService = faqService;
        this.milvusClient = milvusClient;
    }

    /** INSERT / UPDATE */
    @Around("@annotation(sync) && args(faq,..)")
    public Object handleInsertUpdate(ProceedingJoinPoint jp, FaqSync sync, KnowledgeFaq faq) throws Throwable {
        Object result = jp.proceed();  // 先执行业务

        if (sync.value() == Action.INSERT || sync.value() == Action.UPDATE) {
            // disabled 的不入向量库
            if ("0".equals(faq.getEnabled())) {
                deleteFromVector(faq.getId());
                log.info("FAQ 已禁用，从向量库移除: id={}", faq.getId());
            } else {
                syncToVector(faq, sync.value());
            }
        }
        return result;
    }

    /** DELETE：删前查出 FAQ，执行业务删除，再删向量 */
    @Around("@annotation(sync) && args(id)")
    public Object handleDelete(ProceedingJoinPoint jp, FaqSync sync, Long id) throws Throwable {
        KnowledgeFaq faq = faqService.selectById(id);
        Object result = jp.proceed();
        if (faq != null) {
            deleteFromVector(id);
        }
        return result;
    }

    private void syncToVector(KnowledgeFaq faq, Action action) {
        try {
            // UPDATE 时先删旧的；INSERT 时 id 是新的，不需要删
            if (action == Action.UPDATE) {
                deleteFromVector(faq.getId());
            }

            // 向量化内容只用 question，方便语义匹配
            Document doc = new Document(faq.getQuestion(), Map.of(
                    "faqId", String.valueOf(faq.getId()),
                    "question", faq.getQuestion(),
                    "answer", faq.getAnswer() != null ? faq.getAnswer() : "",
                    "category", faq.getCategory() != null ? faq.getCategory() : "通用",
                    "source", "faq"
            ));
            vectorStore.add(List.of(doc));

            // Milvus 需要 load 才能被查
            milvusClient.loadCollection(LoadCollectionParam.newBuilder()
                    .withCollectionName(COLLECTION).build());

            // flush 落盘，否则重启数据丢失
            milvusClient.flush(FlushParam.newBuilder()
                    .withCollectionNames(List.of(COLLECTION)).build());

            log.info("FAQ 向量{}: id={}, question={}",
                    action == Action.INSERT ? "新增" : "更新",
                    faq.getId(), faq.getQuestion());
        } catch (Exception e) {
            log.error("FAQ 向量同步失败 {} id={}", action, faq.getId(), e);
        }
    }

    private void deleteFromVector(Long faqId) {
        try {
            // metadata 是 JSON 字段，Milvus 用 metadata["key"] 语法访问其内部字段
            milvusClient.delete(DeleteParam.newBuilder()
                    .withCollectionName(COLLECTION)
                    .withExpr("metadata[\"faqId\"] == \"" + faqId + "\"")
                    .build());
            milvusClient.loadCollection(LoadCollectionParam.newBuilder()
                    .withCollectionName(COLLECTION).build());
        } catch (Exception e) {
            log.error("FAQ 向量删除失败 id={}", faqId, e);
        }
    }
}
