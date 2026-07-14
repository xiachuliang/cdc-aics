package com.ruoyi.ai.config;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.data.redis.core.RedisTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Redis 持久化对话记忆 + 溢出摘要。
 *
 * 存两条 Redis Key：
 *   chat:memory:{id}  → 窗口内完整消息（JSON 数组）
 *   chat:summary:{id} → 超出窗口的历史摘要（纯文本）
 */
public class RedisChatMemory implements ChatMemory {

    private static final Logger log = LoggerFactory.getLogger(RedisChatMemory.class);

    private static final String KEY_PREFIX = "chat:memory:";
    private static final String SUMMARY_PREFIX = "chat:summary:";
    private static final long TTL_MINUTES = 30;

    private final RedisTemplate<String, String> redisTemplate;
    private final ObjectMapper objectMapper;
    private final int maxMessages;

    public RedisChatMemory(RedisTemplate<String, String> redisTemplate, int maxMessages) {
        this.redisTemplate = redisTemplate;
        this.objectMapper = new ObjectMapper();
        this.maxMessages = maxMessages;
        log.info("RedisChatMemory 初始化完成，窗口={}条，TTL={}分钟", maxMessages, TTL_MINUTES);
    }

    @Override
    public void add(String conversationId, List<Message> messages) {
        try {
            List<MsgRecord> records = readRecords(conversationId);
            for (Message m : messages) {
                records.add(MsgRecord.from(m));
            }

            // 超出窗口 → 移到摘要
            if (records.size() > maxMessages) {
                int overflow = records.size() - maxMessages;
                List<MsgRecord> old = records.subList(0, overflow);
                appendSummary(conversationId, old);
                records = records.subList(overflow, records.size());
            }

            writeRecords(KEY_PREFIX + conversationId, records);
        } catch (Exception e) {
            log.error("Redis 写入记忆失败", e);
        }
    }

    @Override
    public List<Message> get(String conversationId) {
        List<MsgRecord> records = readRecords(conversationId);
        if (records.isEmpty()) return List.of();
        return records.stream().map(MsgRecord::toMessage).toList();
    }

    @Override
    public void clear(String conversationId) {
        redisTemplate.delete(KEY_PREFIX + conversationId);
        redisTemplate.delete(SUMMARY_PREFIX + conversationId);
        log.debug("清除会话: {}", conversationId);
    }

    /**
     * 获取溢出摘要（供 Service 层注入 System Prompt）
     */
    public String getSummary(String conversationId) {
        String summary = redisTemplate.opsForValue().get(SUMMARY_PREFIX + conversationId);
        return summary != null ? summary : "";
    }

    // ========== 内部方法 ==========

    private void appendSummary(String conversationId, List<MsgRecord> overflow) {
        StringBuilder sb = new StringBuilder();
        String existing = redisTemplate.opsForValue().get(SUMMARY_PREFIX + conversationId);
        if (existing != null && !existing.isEmpty()) {
            sb.append(existing).append("\n");
        }
        for (MsgRecord r : overflow) {
            String label = "USER".equals(r.role) ? "用户" : "AI";
            sb.append(label).append("：").append(r.content).append("\n");
        }
        // 摘要截断，避免无限膨胀
        String text = sb.toString();
        if (text.length() > 2000) {
            text = text.substring(text.length() - 2000);
        }
        redisTemplate.opsForValue().set(SUMMARY_PREFIX + conversationId, text, TTL_MINUTES, TimeUnit.MINUTES);
        log.debug("摘要已更新，长度={}", text.length());
    }

    private List<MsgRecord> readRecords(String conversationId) {
        String json = redisTemplate.opsForValue().get(KEY_PREFIX + conversationId);
        if (json == null || json.isEmpty()) return new ArrayList<>();
        try {
            return objectMapper.readValue(json,
                    objectMapper.getTypeFactory().constructCollectionType(List.class, MsgRecord.class));
        } catch (JsonProcessingException e) {
            log.error("Redis 记忆反序列化失败", e);
            return new ArrayList<>();
        }
    }

    private void writeRecords(String key, List<MsgRecord> records) {
        try {
            String json = objectMapper.writeValueAsString(records);
            redisTemplate.opsForValue().set(key, json, TTL_MINUTES, TimeUnit.MINUTES);
        } catch (JsonProcessingException e) {
            log.error("Redis 记忆序列化失败", e);
        }
    }

    public static class MsgRecord {
        public String role;
        public String content;

        public MsgRecord() {}

        public MsgRecord(String role, String content) {
            this.role = role;
            this.content = content;
        }

        static MsgRecord from(Message m) {
            if (m == null) return new MsgRecord("USER", "");
            return new MsgRecord(m.getMessageType().name(), m.getText());
        }

        Message toMessage() {
            if (content == null) return new UserMessage("");
            return switch (role) {
                case "ASSISTANT" -> new AssistantMessage(content);
                case "SYSTEM" -> new SystemMessage(content);
                default -> new UserMessage(content);
            };
        }
    }
}
