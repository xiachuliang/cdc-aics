package com.ruoyi.framework.web;

import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * SPA fallback：Vue history 模式路由刷新时，浏览器将前端路径当后端请求发送，
 * 后端没有对应接口时需要转发到 index.html 让 Vue Router 接管。
 * <p>
 * 为什么不用 ResourcesConfig.addViewControllers？
 * ViewControllerRegistry 不支持 {path:regex} 路径变量正则，
 * 而 @RequestMapping 通过 PathPattern 天然支持，因此用 @Controller 更可靠。
 * <p>
 * Spring MVC 按优先级匹配 Handler，显式的 @GetMapping("/captchaImage") 等
 * 优先级高于通配符 /{path:[^.]+}，所以 API 不会被误转发。
 *
 * @author ruoyi
 */
@Controller
public class SpaFallbackController {

    private static final Logger log = LoggerFactory.getLogger(SpaFallbackController.class);

    /**
     * 单段路径：/index、/login、/register、/lock
     * [^.]+ = 路径不含点号，避免匹配静态资源（/favicon.ico 等）
     */
    @GetMapping("/{path:[^.]+}")
    public String forwardSingle(HttpServletRequest request) {
        log.debug("SPA fallback (single): {} -> /index.html", request.getRequestURI());
        return "forward:/index.html";
    }

    /**
     * 多段路径：/ai/eval、/business/product、/system/user 等
     */
    @GetMapping("/{path:[^.]+}/**")
    public String forwardNested(HttpServletRequest request) {
        log.debug("SPA fallback (nested): {} -> /index.html", request.getRequestURI());
        return "forward:/index.html";
    }
}
