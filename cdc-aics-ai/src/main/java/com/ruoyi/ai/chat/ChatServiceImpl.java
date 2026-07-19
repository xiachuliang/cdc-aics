package com.ruoyi.ai.chat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.PromptChatMemoryAdvisor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;

import com.ruoyi.ai.config.RedisChatMemory;
import com.ruoyi.ai.tool.OrderTools;
import com.ruoyi.ai.tool.ProductTools;
import com.ruoyi.ai.tool.ToolResultStore;

import reactor.core.publisher.Flux;

import java.nio.charset.StandardCharsets;
import java.util.UUID;

@Service
public class ChatServiceImpl implements IChatService {

    private static final Logger log = LoggerFactory.getLogger(ChatServiceImpl.class);

    private final ChatClient chatClient;
    private final PromptChatMemoryAdvisor memoryAdvisor;
    private final RedisChatMemory redisMemory;

    public ChatServiceImpl(ChatClient chatClient, ChatMemory chatMemory,
                           @Qualifier("guidePrompt") Resource guidePrompt) {
        this.redisMemory = (RedisChatMemory) chatMemory;
        // 从模板文件读取并替换变量，读取失败则用兜底硬编码
        String systemPrompt;
        try {
            systemPrompt = guidePrompt.getContentAsString(StandardCharsets.UTF_8)
                    .replace("{role}", "超市导购助手")
                    .replace("{name}", "小智")
                    .replace("{duty}", "帮助顾客查找商品、加入购物车、下单购买、解答购物疑问")
                    .replace("{style}", "热情简洁，先给出核心答案再补充细节")
                    .replace("{maxWords}", "200")
                    .replace("{extraRules}", "- 商品信息必须来自工具查询结果，不得编造\n- 如果查不到直接告诉用户，不要瞎编\n- 用户说'买X'时先搜商品再问数量，加购前确认库存\n- 下单前必须先展示购物车内容让用户确认，再收集手机号");
        } catch (Exception e) {
            log.warn("Prompt模板加载失败，使用兜底提示词", e);
            systemPrompt = "你是智能导购助手「小智」。热情、简洁，回答控制在200字以内。";
        }

        this.chatClient = chatClient.mutate()
                .defaultSystem(systemPrompt)
                .build();
        this.memoryAdvisor = PromptChatMemoryAdvisor.builder(chatMemory)
                .build();
        log.info("ChatClient 初始化完成，已启用对话记忆 + 5个Tool工具 + Prompt模板");
    }

    @Override
    public ChatResult chat(String sessionId, String message) {
        log.info("收到对话请求, sessionId={}, message={}", sessionId, message);
        long start = System.currentTimeMillis();
        try {
            // 注入历史摘要 + 会话ID（让 LLM 传给工具，避免 ThreadLocal 跨线程丢失）
            String summary = redisMemory.getSummary(sessionId);
            String fullMessage = "【会话ID: " + sessionId + "】"
                    + (summary.isEmpty() ? "" : "\n【历史摘要】" + summary)
                    + "\n【用户当前问题】" + message;

            String answer = chatClient.prompt()
                    .user(fullMessage)
                    .advisors(a -> a.param("chatMemoryConversationId", sessionId))
                    .advisors(memoryAdvisor)
                    .call()
                    .content();

            long cost = System.currentTimeMillis() - start;

            ProductTools.ToolResult productResult = ProductTools.drainResult();
            OrderTools.ToolResult orderResult = OrderTools.drainResult();

            // ★ 同步端点：存到 ToolResultStore，让流式端点也能通过 /ai/chat/tool-data 取到卡片数据
            ToolResultStore.put(sessionId,
                    orderResult != null ? orderResult.toolName
                            : (productResult != null ? productResult.toolName : null),
                    productResult != null ? productResult.products : null,
                    productResult != null ? productResult.categories : null,
                    orderResult != null ? orderResult.cartItems : null,
                    orderResult != null ? orderResult.order : null,
                    orderResult != null ? orderResult.orderItems : null);

            ChatResult cr = new ChatResult();
            cr.setAnswer(answer);

            // 合并 ProductTools 结果
            if (productResult != null) {
                cr.setToolCalled(productResult.toolName);
                cr.setProducts(productResult.products);
                cr.setCategories(productResult.categories);
            }
            // 合并 OrderTools 结果（购物车/订单卡片优先覆盖 toolCalled）
            if (orderResult != null) {
                cr.setToolCalled(orderResult.toolName);
                cr.setCartItems(orderResult.cartItems);
                cr.setOrder(orderResult.order);
                cr.setOrderItems(orderResult.orderItems);
            }

            if (productResult != null || orderResult != null) {
                log.info("AI 回复成功, 耗时={}ms, 工具={}, 商品={}, 分类={}, 购物车={}, 订单={}",
                        cost, cr.getToolCalled(),
                        cr.getProducts() != null ? cr.getProducts().size() : 0,
                        cr.getCategories() != null ? cr.getCategories().size() : 0,
                        cr.getCartItems() != null ? cr.getCartItems().size() : 0,
                        cr.getOrder() != null ? cr.getOrder().getOrderNo() : "无");
            } else {
                log.info("AI 回复成功（纯聊天）, 耗时={}ms", cost);
            }
            return cr;

        } catch (Exception e) {
            long cost = System.currentTimeMillis() - start;
            ProductTools.drainResult();
            OrderTools.drainResult();
            log.error("AI 调用失败, 耗时={}ms, 错误: {}", cost, e.getMessage(), e);
            ChatResult cr = new ChatResult();
            cr.setAnswer("抱歉，AI服务暂时不可用，请稍后再试。【" + e.getMessage() + "】");
            return cr;
        }
    }

    @Override
    public Flux<String> chatStream(String sessionId, String message) {
        log.info("收到流式对话请求, sessionId={}, message={}", sessionId, message);
        long start = System.currentTimeMillis();
        String summary = redisMemory.getSummary(sessionId);
        // ★ 注入 sessionId，让 LLM 传给工具（避免 ThreadLocal 跨线程丢失）
        String fullMessage = "【会话ID: " + sessionId + "】"
                + (summary.isEmpty() ? "" : "\n【历史摘要】" + summary)
                + "\n【用户当前问题】" + message;

        return chatClient.prompt()
                .user(fullMessage)
                .advisors(a -> a.param("chatMemoryConversationId", sessionId))
                .advisors(memoryAdvisor)
                .stream()
                .content()
                .doOnNext(token -> log.debug("流式输出 token: {}", token))
                .doOnComplete(() -> log.info("流式输出完成, 耗时={}ms", System.currentTimeMillis() - start))
                .doOnError(e -> log.error("流式输出异常, 耗时={}ms", System.currentTimeMillis() - start, e))
                .doFinally(signal -> {
                    ProductTools.ToolResult pr = ProductTools.drainResult();
                    OrderTools.ToolResult or = OrderTools.drainResult();
                    ToolResultStore.put(sessionId,
                            or != null ? or.toolName : (pr != null ? pr.toolName : null),
                            pr != null ? pr.products : null,
                            pr != null ? pr.categories : null,
                            or != null ? or.cartItems : null,
                            or != null ? or.order : null,
                            or != null ? or.orderItems : null);
                });
    }

    @Override
    public String newSessionId() {
        return UUID.randomUUID().toString().replace("-", "");
    }
}
