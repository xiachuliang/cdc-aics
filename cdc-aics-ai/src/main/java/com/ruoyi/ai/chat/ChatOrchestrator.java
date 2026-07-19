package com.ruoyi.ai.chat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.ruoyi.ai.agent.IntentResult;
import com.ruoyi.ai.agent.RagAgentService;
import com.ruoyi.ai.agent.RouterService;
import com.ruoyi.ai.chitchat.ChitchatAgentService;
import com.ruoyi.ai.config.RateLimitService;
import com.ruoyi.ai.eval.EvalJudgeService;
import com.ruoyi.ai.sql.TextToSqlService;
import com.ruoyi.business.eval.domain.ChatLog;
import com.ruoyi.business.eval.mapper.ChatLogMapper;

import reactor.core.publisher.Flux;

/**
 * 对话调度器：限流 → 意图路由 → Agent → 对话日志 + 评测抽检
 */
@Service
public class ChatOrchestrator implements IChatService {

    private static final Logger log = LoggerFactory.getLogger(ChatOrchestrator.class);

    private final RouterService routerService;
    private final RagAgentService ragAgentService;
    private final IChatService toolsAgent;
    private final TextToSqlService textToSqlService;
    private final ChitchatAgentService chitchatAgentService;
    private final EvalJudgeService evalJudgeService;
    private final RateLimitService rateLimitService;
    private final ChatLogMapper chatLogMapper;

    public ChatOrchestrator(RouterService routerService,
                            RagAgentService ragAgentService,
                            IChatService toolsAgent,
                            TextToSqlService textToSqlService,
                            ChitchatAgentService chitchatAgentService,
                            EvalJudgeService evalJudgeService,
                            RateLimitService rateLimitService,
                            ChatLogMapper chatLogMapper) {
        this.routerService = routerService;
        this.ragAgentService = ragAgentService;
        this.toolsAgent = toolsAgent;
        this.textToSqlService = textToSqlService;
        this.chitchatAgentService = chitchatAgentService;
        this.evalJudgeService = evalJudgeService;
        this.rateLimitService = rateLimitService;
        this.chatLogMapper = chatLogMapper;
        log.info("ChatOrchestrator 初始化完成（四Agent：闲聊+RAG+SQL+Tools + 限流 + 日志）");
    }

    @Override
    public ChatResult chat(String sessionId, String message) {
        // === 限流检查 ===
        if (!rateLimitService.tryAcquire(sessionId)) {
            ChatResult cr = new ChatResult();
            cr.setAnswer("您的请求太频繁了，请稍后再试。");
            return cr;
        }

        long start = System.currentTimeMillis();
        IntentResult result = routerService.classify(message);
        String intent = result.getIntent().name();
        String agent = intent;

        ChatResult cr;
        try {
            if (intent.equals("CHITCHAT")) {
                log.info("路由 → 闲聊 Agent: {}", message);
                cr = new ChatResult();
                cr.setAnswer(chitchatAgentService.chat(sessionId, message));
            } else if (intent.equals("ANALYTICS")) {
                log.info("路由 → Text-to-SQL Agent: {}", message);
                cr = new ChatResult();
                cr.setAnswer(textToSqlService.chat(sessionId, message));
            } else if (intent.equals("CONSULTATION")) {
                log.info("路由 → RAG Agent: ragQuery={}", result.getRagQuery());
                cr = new ChatResult();
                cr.setAnswer(ragAgentService.chat(sessionId, message, result.getRagQuery()));
            } else {
                log.info("路由 → Tools Agent: {}", message);
                cr = toolsAgent.chat(sessionId, message);
            }
        } catch (Exception e) {
            log.error("AI 调用异常: intent={}", intent, e);
            cr = new ChatResult();
            cr.setAnswer(degradeMessage(e));
        }

        long latency = System.currentTimeMillis() - start;

        // === 对话日志（100%记录） ===
        try {
            recordChatLog(sessionId, message, cr.getAnswer(), intent, agent, latency);
        } catch (Exception e) {
            log.warn("写对话日志失败: {}", e.getMessage());
        }

        // === 评测抽检（10%） ===
        if (evalJudgeService.shouldEvaluate() && cr.getAnswer() != null) {
            evalJudgeService.evaluateAsync(sessionId, message, cr.getAnswer(), intent, latency);
        }

        return cr;
    }

    @Override
    public Flux<String> chatStream(String sessionId, String message) {
        if (!rateLimitService.tryAcquire(sessionId)) {
            return Flux.just("您的请求太频繁了，请稍后再试。");
        }

        long start = System.currentTimeMillis();
        IntentResult result = routerService.classify(message);
        String intent = result.getIntent().name();

        Flux<String> stream;
        try {
            if (intent.equals("CHITCHAT")) {
                log.info("流式路由 → 闲聊 Agent: {}", message);
                stream = chitchatAgentService.chatStream(sessionId, message);
            } else if (intent.equals("ANALYTICS")) {
                log.info("流式路由 → Text-to-SQL Agent: {}", message);
                stream = textToSqlService.chatStream(sessionId, message);
            } else if (intent.equals("CONSULTATION")) {
                log.info("流式路由 → RAG Agent: ragQuery={}", result.getRagQuery());
                stream = ragAgentService.chatStream(sessionId, message, result.getRagQuery());
            } else {
                log.info("流式路由 → Tools Agent: {}", message);
                stream = toolsAgent.chatStream(sessionId, message);
            }
        } catch (Exception e) {
            log.error("流式 AI 调用异常: intent={}", intent, e);
            stream = Flux.just(degradeMessage(e));
        }

        // === 对话日志 + 评测抽检（流结束后） ===
        StringBuilder fullAnswer = new StringBuilder();
        return stream
                .doOnNext(fullAnswer::append)
                .doFinally(signal -> {
                    long latency = System.currentTimeMillis() - start;
                    try {
                        recordChatLog(sessionId, message, fullAnswer.toString(), intent, intent, latency);
                    } catch (Exception ex) {
                        log.warn("写对话日志失败: {}", ex.getMessage());
                    }
                    if (evalJudgeService.shouldEvaluate() && fullAnswer.length() > 0) {
                        evalJudgeService.evaluateAsync(sessionId, message, fullAnswer.toString(), intent, latency);
                    }
                });
    }

    @Override
    public String newSessionId() {
        return toolsAgent.newSessionId();
    }

    // ======================== 辅助方法 ========================

    /** 写对话日志到 MySQL（100% 记录，静默失败不影响主流程） */
    private void recordChatLog(String sessionId, String question, String answer, String intent, String agent, long latency) {
        try {
            ChatLog logEntry = new ChatLog();
            logEntry.setSessionId(sessionId);
            logEntry.setQuestion(question);
            logEntry.setAnswer(answer != null && answer.length() > 500 ? answer.substring(0, 500) : answer);
            logEntry.setIntent(intent);
            logEntry.setAgent(agent);
            logEntry.setLatencyMs(latency);
            chatLogMapper.insertChatLog(logEntry);
        } catch (Exception e) {
            // 静默失败：日志写不进去不影响对话
        }
    }

    /** 异常分类降级：不同错误给不同提示 */
    private String degradeMessage(Exception e) {
        String msg = e.getMessage() != null ? e.getMessage() : "";
        if (msg.contains("timeout") || msg.contains("Timeout") || msg.contains("timed out")) {
            return "AI 服务响应超时，请稍后再试。";
        }
        if (msg.contains("401") || msg.contains("403")) {
            return "AI 服务认证失败，请联系管理员。";
        }
        if (msg.contains("429") || msg.contains("Too Many Requests")) {
            return "AI 服务繁忙，请稍后再试。";
        }
        if (msg.contains("限流") || msg.contains("频繁")) {
            return "您的请求太频繁了，请稍后再试。";
        }
        return "AI 服务暂时不可用，请稍后再试。";
    }
}
