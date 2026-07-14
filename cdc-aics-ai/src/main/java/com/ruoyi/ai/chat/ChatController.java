package com.ruoyi.ai.chat;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyEmitter;

import com.ruoyi.ai.agent.ImageAnalysisService;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;

@Anonymous
@RestController
@RequestMapping("/ai")
public class ChatController extends BaseController {

    @Autowired
    private ChatOrchestrator orchestrator;

    @Autowired
    private ImageAnalysisService imageAnalysisService;

    /**
     * AI 对话（同步）
     */
    @PostMapping("/chat")
    public AjaxResult chat(@RequestBody Map<String, String> params) {
        String sessionId = params.getOrDefault("sessionId", orchestrator.newSessionId());
        String message = params.getOrDefault("message", params.get("question"));

        ChatResult result = orchestrator.chat(sessionId, message);

        Map<String, Object> data = new HashMap<>();
        data.put("sessionId", sessionId);
        data.put("answer", result.getAnswer());
        data.put("toolCalled", result.getToolCalled());
        data.put("products", result.getProducts());
        data.put("categories", result.getCategories());
        return success(data);
    }

    /**
     * AI 对话（流式）
     * ResponseBodyEmitter：异步线程写 + 立即返回，每个 send() 自动 flush
     */
    @PostMapping("/chat/stream")
    public ResponseBodyEmitter chatStream(@RequestBody Map<String, String> params) {
        String sessionId = params.getOrDefault("sessionId", orchestrator.newSessionId());
        String message = params.getOrDefault("message", params.get("question"));

        ResponseBodyEmitter emitter = new ResponseBodyEmitter();
        orchestrator.chatStream(sessionId, message)
                .subscribe(
                        token -> {
                            try { emitter.send(token); } catch (IOException e) { emitter.completeWithError(e); }
                        },
                        emitter::completeWithError,
                        emitter::complete
                );
        return emitter;
    }

    /**
     * 图片对话（多模态）
     * 用户拍照上传 + 文字提问 → AI 识别商品 → 搜索 → 回复
     */
    @PostMapping("/chat/image")
    public AjaxResult chatWithImage(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "message", required = false, defaultValue = "请识别图片中的商品") String message,
            @RequestParam(value = "sessionId", required = false) String sessionId) {

        // 1. 图片 → 文字描述（qwen-vl-plus 多模态模型）
        String description = imageAnalysisService.analyze(file, message);

        // 2. 文字描述 → 走正常对话流程（Router → Agent → 回复）
        if (sessionId == null || sessionId.isEmpty()) {
            sessionId = orchestrator.newSessionId();
        }
        ChatResult chatResult = orchestrator.chat(sessionId, description);

        // 3. 组装返回
        Map<String, Object> data = new HashMap<>();
        data.put("answer", chatResult.getAnswer());
        data.put("products", chatResult.getProducts());
        data.put("imageDescription", description);
        data.put("sessionId", sessionId);

        return success(data);
    }

    /**
     * 生成新会话
     */
    @PostMapping("/chat/session")
    public AjaxResult newSession() {
        Map<String, String> data = new HashMap<>();
        data.put("sessionId", orchestrator.newSessionId());
        return success(data);
    }
}
