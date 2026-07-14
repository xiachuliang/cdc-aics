package com.ruoyi.ai.eval;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.ruoyi.business.eval.domain.EvalLog;
import com.ruoyi.business.eval.mapper.EvalLogMapper;

/**
 * AI 评测服务：异步 LLM-Judge 打分 + 落库
 *
 * 随机抽检：每次对话有 sampleRate 的概率触发评测（默认 10%）
 * 异步执行：不阻塞用户，Judge 评分在后台进行
 */
@Service
public class EvalJudgeService {

    private static final Logger log = LoggerFactory.getLogger(EvalJudgeService.class);

    /** 评测抽检比例（0.0 ~ 1.0），默认 10% */
    @Value("${cdc.eval.sample-rate:0.1}")
    private double sampleRate;

    private final ChatClient judgeClient;
    private final EvalLogMapper evalLogMapper;

    public EvalJudgeService(ChatClient.Builder builder, EvalLogMapper evalLogMapper) {
        this.evalLogMapper = evalLogMapper;
        this.judgeClient = builder
                .defaultSystem("你是AI评测专家。严格按评分标准打分，只输出JSON，不要废话。")
                .build();
        log.info("AI评测服务初始化完成, 抽检率={}%", (int) (sampleRate * 100));
    }

    /**
     * 判断是否触发抽检
     */
    public boolean shouldEvaluate() {
        return Math.random() < sampleRate;
    }

    /**
     * 异步评测（不阻塞主流程）
     *
     * @param sessionId 会话ID
     * @param question  用户原始问题
     * @param answer    AI 回答
     * @param intent    实际意图
     * @param latencyMs 响应耗时
     */
    @Async
    public void evaluateAsync(String sessionId, String question, String answer, String intent, long latencyMs) {
        try {
            log.info("评测抽检触发: intent={}, question=\"{}\"", intent,
                    question.length() > 40 ? question.substring(0, 40) + "..." : question);

            // 1. LLM-Judge 打分
            int score = judge(question, answer, intent);
            String reason = lastJudgeReason;

            // 2. 构建记录
            EvalLog logEntry = new EvalLog();
            logEntry.setSessionId(sessionId);
            logEntry.setQuestion(question);
            logEntry.setAnswer(answer.length() > 500 ? answer.substring(0, 500) : answer);
            logEntry.setIntent(intent);
            logEntry.setScore(score);
            logEntry.setJudgeReason(reason);
            logEntry.setLatencyMs(latencyMs);

            // 3. 入库
            evalLogMapper.insertEvalLog(logEntry);
            log.info("评测结果已保存: id={}, score={}/10, intent={}", logEntry.getId(), score, intent);

        } catch (Exception e) {
            log.error("异步评测失败", e);
        }
    }

    // ======================== LLM-as-Judge ========================

    private String lastJudgeReason = "";

    private int judge(String question, String answer, String intent) {
        String prompt = """
                请对以下AI导购的回答打分（1-10分）。

                【用户问题】%s
                【AI意图】%s
                【AI回答】%s

                【评分维度】
                - 相关性(0-4分)：是否切题，有无答非所问
                - 准确性(0-3分)：信息是否可信，不能凭空编造
                - 完整性(0-3分)：是否完整回答了用户问题

                【输出格式】只输出一行JSON：{"score":8,"reason":"评分理由"}
                """.formatted(question, intent, answer);

        try {
            String result = judgeClient.prompt().user(prompt).call().content();
            if (result == null) { lastJudgeReason = "返回空"; return 5; }

            // 解析 JSON
            String json = result.trim()
                    .replaceAll("```json|```", "").trim();
            String[] parts = json.replace("{", "").replace("}", "").split(",");
            int score = 5;
            for (String part : parts) {
                String[] kv = part.split(":", 2);
                String key = kv[0].trim().replace("\"", "");
                String value = kv[1].trim().replace("\"", "");
                if ("score".equals(key)) score = Integer.parseInt(value);
                if ("reason".equals(key)) lastJudgeReason = value;
            }
            return Math.max(1, Math.min(10, score)); // 限制 1~10
        } catch (Exception e) {
            log.warn("Judge 评分异常", e);
            lastJudgeReason = "评分异常: " + e.getMessage();
            return 5;
        }
    }
}
