package com.ruoyi.ai.config;

import java.time.Duration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

/**
 * 简易接口限流（基于 Redis 计数器 + TTL）
 *
 * 限流策略：同一 key 在 60 秒内最多 N 次请求
 * 超过限制返回 false，调用方自行决定降级方式
 */
@Service
public class RateLimitService {

    private static final Logger log = LoggerFactory.getLogger(RateLimitService.class);

    @Value("${cdc.rate-limit.max-requests:20}")
    private int maxRequests;

    @Value("${cdc.rate-limit.window-seconds:60}")
    private int windowSeconds;

    @Autowired
    private RedisTemplate<String, String> redisTemplate;

    /**
     * @param key 限流标识（如 sessionId 或 ip）
     * @return true=放行, false=被限流
     */
    public boolean tryAcquire(String key) {
        try {
            String redisKey = "rate:limit:" + key;
            Long count = redisTemplate.opsForValue().increment(redisKey);
            if (count != null && count == 1) {
                redisTemplate.expire(redisKey, Duration.ofSeconds(windowSeconds));
            }
            return count != null && count <= maxRequests;
        } catch (Exception e) {
            // Redis 挂了不阻塞业务
            log.warn("限流 Redis 异常，放行: {}", e.getMessage());
            return true;
        }
    }
}
