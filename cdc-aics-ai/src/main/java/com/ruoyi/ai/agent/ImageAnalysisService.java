package com.ruoyi.ai.agent;

import java.util.Base64;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.multipart.MultipartFile;

/**
 * 图片分析服务：用多模态模型识别图片中的商品
 *
 * 直接用 RestClient 调 DashScope HTTP API（OpenAI 兼容格式），
 * 绕开 Spring AI Alibaba 1.1.2 的 Media/UserMessage —— 该版本多模态适配不完整
 */
@Service
public class ImageAnalysisService {

    private static final Logger log = LoggerFactory.getLogger(ImageAnalysisService.class);

    private static final String DASHSCOPE_URL = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions";

    /** 多模态模型 */
    private static final String VL_MODEL = "qwen-vl-plus";

    @Value("${spring.ai.dashscope.api-key}")
    private String apiKey;

    private final RestClient restClient;

    public ImageAnalysisService() {
        this.restClient = RestClient.builder().build();
        log.info("图片分析服务初始化完成（直接 HTTP → DashScope，模型: {}）", VL_MODEL);
    }

    /**
     * 分析图片，提取商品信息
     */
    @SuppressWarnings("unchecked")
    public String analyze(MultipartFile file, String question) {
        try {
            byte[] imageBytes = file.getBytes();
            String base64 = Base64.getEncoder().encodeToString(imageBytes);
            String mimeStr = file.getContentType();
            String imageUrl = "data:" + mimeStr + ";base64," + base64;

            String userQuestion = question != null && !question.isEmpty()
                    ? question : "请识别图片中的商品";

            log.info("图片分析开始, 文件={}, 大小={}KB", file.getOriginalFilename(), imageBytes.length / 1024);

            // 构造 OpenAI 兼容格式的多模态请求
            // messages[0].content = [{type:"text", text:"..."}, {type:"image_url", image_url:{url:"data:..."}}]
            Map<String, Object> textPart = Map.of(
                    "type", "text",
                    "text", "你是商品识别专家。请分析图片中的商品。\n输出格式：\n商品名称：[品牌+规格]\n搜索关键词：[3-5个词]\n商品描述：[一句话]\n\n用户问题：" + userQuestion
            );

            Map<String, Object> imagePart = Map.of(
                    "type", "image_url",
                    "image_url", Map.of("url", imageUrl)
            );

            Map<String, Object> userMessage = Map.of(
                    "role", "user",
                    "content", List.of(textPart, imagePart)
            );

            Map<String, Object> requestBody = Map.of(
                    "model", VL_MODEL,
                    "messages", List.of(userMessage)
            );

            // 调 DashScope API
            Map<String, Object> response = restClient.post()
                    .uri(DASHSCOPE_URL)
                    .header("Authorization", "Bearer " + apiKey)
                    .header("Content-Type", "application/json")
                    .body(requestBody)
                    .retrieve()
                    .body(Map.class);

            // 提取 choices[0].message.content
            if (response == null) return "识别失败：无响应";
            List<Map<String, Object>> choices = (List<Map<String, Object>>) response.get("choices");
            if (choices == null || choices.isEmpty()) return "识别失败：无结果";
            Map<String, Object> msg = (Map<String, Object>) choices.get(0).get("message");
            if (msg == null) return "识别失败：无消息";
            String content = (String) msg.getOrDefault("content", "未识别到内容");

            log.info("图片分析结果: {}", content);
            return content;

        } catch (Exception e) {
            log.error("图片分析失败", e);
            return "图片分析失败：" + e.getMessage();
        }
    }
}
