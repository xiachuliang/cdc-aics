package com.ruoyi.ai.chat;

import reactor.core.publisher.Flux;

public interface IChatService {
    /**
     * AI 对话（同步）
     */
    ChatResult chat(String sessionId, String message);

    /**
     * AI 对话（流式 SSE）
     */
    Flux<String> chatStream(String sessionId, String message);

    /**
     * 生成新会话ID
     */
    String newSessionId();
}
