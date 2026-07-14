package com.ruoyi.ai.agent;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.PromptChatMemoryAdvisor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.document.Document;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.stereotype.Service;

import com.ruoyi.ai.config.RedisChatMemory;

import reactor.core.publisher.Flux;

/**
 * RAG Agent：知识咨询 + 闲聊兜底，纯向量语义检索
 *
 * <p>检索范围：FAQ + 文档切片（Milvus 向量库）
 * <p>商品查询 → Tools Agent（ProductTools SQL LIKE）
 * <p>闲聊 → 检索为空时 Prompt 引导 LLM 当闲聊处理
 */
@Service
public class RagAgentService {

    private static final Logger log = LoggerFactory.getLogger(RagAgentService.class);

    private final ChatClient ragClient;
    private final VectorStore vectorStore;
    private final RedisChatMemory redisMemory;

    public RagAgentService(ChatClient.Builder builder, VectorStore vectorStore,
                           ChatMemory chatMemory) {
        this.vectorStore = vectorStore;
        this.redisMemory = (RedisChatMemory) chatMemory;
        this.ragClient = builder
                .defaultAdvisors(PromptChatMemoryAdvisor.builder(chatMemory).build())
                .build();
        log.info("RAG Agent 初始化完成（纯向量检索模式）");
    }

    /**
     * 组装 System Prompt：历史摘要 + 检索结果
     */
    private String buildSystemPrompt(String sessionId, List<Document> docs) {
        String summary = redisMemory.getSummary(sessionId);

        StringBuilder sb = new StringBuilder();
        sb.append("你是超市智能导购「小智」。请基于以下知识库信息回答用户问题。回答简洁亲切，控制在 150 字以内。\n\n");

        if (!summary.isEmpty()) {
            sb.append("---历史摘要---\n").append(summary).append("\n");
        }

        sb.append("---知识库检索结果（常见问题 + 规章制度文档）---\n");
        if (docs.isEmpty()) {
            sb.append("（未找到相关知识）\n");
            sb.append("重要：用户的问题在知识库中没有匹配。这说明用户大概率在闲聊或打招呼。");
            sb.append("请直接友好地回应闲聊，闲聊时不要推荐某种商品，因为我们可能没有这件商品，反正就说一下聊天的话，说我可以给你推荐商品啊，也不要建议用户换个问法。\n");
        } else {
            for (int i = 0; i < docs.size(); i++) {
                Document doc = docs.get(i);
                String source = (String) doc.getMetadata().getOrDefault("source", "");
                if ("faq".equals(source)) {
                    String answer = (String) doc.getMetadata().get("answer");
                    sb.append("【").append(i + 1).append("】[FAQ] 问：").append(doc.getText()).append("\n");
                    sb.append("    答：").append(answer != null ? answer : "（无答案）").append("\n");
                } else {
                    sb.append("【").append(i + 1).append("】[文档] ").append(doc.getText()).append("\n");
                }
            }
        }

        return sb.toString();
    }

    /**
     * 纯向量语义检索
     */
    private List<Document> vectorSearch(String query) {
        return vectorStore.similaritySearch(
                SearchRequest.builder()
                        .query(query)
                        .topK(5)
                        .similarityThreshold(0.7)
                        .build()
        );
    }

    public String chat(String sessionId, String userMessage, String ragQuery) {
        List<Document> docs = vectorSearch(ragQuery);
        log.info("RAG 向量检索: ragQuery={} → {} 条结果", ragQuery, docs.size());

        return ragClient.prompt()
                .system(buildSystemPrompt(sessionId, docs))
                .user(userMessage)
                .advisors(a -> a.param("chatMemoryConversationId", sessionId))
                .call()
                .content();
    }

    public Flux<String> chatStream(String sessionId, String userMessage, String ragQuery) {
        List<Document> docs = vectorSearch(ragQuery);
        log.info("RAG 流式向量检索: ragQuery={} → {} 条结果", ragQuery, docs.size());

        return ragClient.prompt()
                .system(buildSystemPrompt(sessionId, docs))
                .user(userMessage)
                .advisors(a -> a.param("chatMemoryConversationId", sessionId))
                .stream()
                .content();
    }
}
