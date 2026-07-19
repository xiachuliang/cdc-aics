package com.ruoyi.ai.chitchat;

import java.nio.charset.StandardCharsets;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.PromptChatMemoryAdvisor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;

import com.ruoyi.ai.config.RedisChatMemory;

import reactor.core.publisher.Flux;

/**
 * 闲聊 Agent：打招呼 + 商品推荐 + 排行榜带货
 * <p>
 * <b>定位</b>：主动引导型销售，不等用户问，顺势推荐热销商品
 * <p>
 * <b>与其他 Agent 的区别</b>：
 * <ul>
 *   <li>不走 RAG（无向量检索）</li>
 *   <li>不走 Tool Calling（无 @Tool）</li>
 *   <li>排行榜通过 Prompt 注入（RankingCacheService 每小时刷新）</li>
 *   <li>共享 ChatMemory（和其他 Agent 同一个 sessionId）</li>
 * </ul>
 */
@Service
public class ChitchatAgentService {

    private static final Logger log = LoggerFactory.getLogger(ChitchatAgentService.class);

    private final ChatClient chitchatClient;
    private final RedisChatMemory redisMemory;
    private final RankingCacheService rankingCache;

    /** Prompt 模板（prompts/chitchat.st） */
    private final String promptTemplate;

    /** 模板读取失败时的兜底 System Prompt */
    private static final String FALLBACK_PROMPT = """
            你是超市导购助手「小智」。
            你的职责：陪用户聊天，在合适的时机顺势推荐热销商品。

            请先回应用户的情绪或话题，然后自然引导推荐。回答简洁亲切，控制在 100 字以内。
            """;

    public ChitchatAgentService(ChatClient.Builder builder, ChatMemory chatMemory,
                                RankingCacheService rankingCache,
                                @Qualifier("chitchatPrompt") Resource chitchatPrompt) {
        this.rankingCache = rankingCache;
        this.redisMemory = (RedisChatMemory) chatMemory;
        this.chitchatClient = builder
                .defaultAdvisors(PromptChatMemoryAdvisor.builder(chatMemory).build())
                .build();

        // 读取 Prompt 模板，失败则用兜底
        String template;
        try {
            template = chitchatPrompt.getContentAsString(StandardCharsets.UTF_8);
            log.info("闲聊 Agent Prompt 模板加载成功");
        } catch (Exception e) {
            log.warn("闲聊 Agent Prompt 模板加载失败，使用兜底硬编码");
            template = FALLBACK_PROMPT;
        }
        this.promptTemplate = template;
        log.info("闲聊 Agent 初始化完成（排行榜带货模式）");
    }

    /**
     * 组装 System Prompt：模板变量替换 + 排行榜数据 + 历史摘要
     */
    private String buildSystemPrompt(String sessionId) {
        String summary = redisMemory.getSummary(sessionId);
        String ranking = rankingCache.getFormattedTop10();

        // 排行榜数据不在模板里，避免把商品列表硬编码到模板文件
        String rankingSection = "【今日热销推荐】（每小时更新）\n" + ranking;

        String summarySection = "";
        if (!summary.isEmpty()) {
            summarySection = "---历史摘要---\n" + summary;
        }

        return promptTemplate
                .replace("{role}", "超市导购助手")
                .replace("{name}", "小智")
                .replace("{duty}", "陪用户聊天、理解情绪、顺势推荐排行榜热销商品")
                .replace("{rankingSection}", rankingSection)
                .replace("{summarySection}", summarySection)
                .replace("{maxWords}", "100");
    }

    /** 同步聊天 */
    public String chat(String sessionId, String userMessage) {
        return chitchatClient.prompt()
                .system(buildSystemPrompt(sessionId))
                .user(userMessage)
                .advisors(a -> a.param("chatMemoryConversationId", sessionId))
                .call()
                .content();
    }

    /** 流式聊天 */
    public Flux<String> chatStream(String sessionId, String userMessage) {
        return chitchatClient.prompt()
                .system(buildSystemPrompt(sessionId))
                .user(userMessage)
                .advisors(a -> a.param("chatMemoryConversationId", sessionId))
                .stream()
                .content();
    }
}
