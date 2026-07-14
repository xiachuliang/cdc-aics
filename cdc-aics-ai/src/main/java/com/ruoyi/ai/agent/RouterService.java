package com.ruoyi.ai.agent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

/**
 * 意图路由：判断用户问题走 RAG Agent / Text-to-SQL / Tools Agent
 * 轻量判断——只做分类，不调工具，不回复用户
 */
@Service
public class RouterService {

    private static final Logger log = LoggerFactory.getLogger(RouterService.class);

    private final ChatClient routerClient;

    public RouterService(ChatClient.Builder builder) {
        this.routerClient = builder.build();
    }

    public IntentResult classify(String userMessage) {
        String prompt = """
                  你是意图分类器。根据用户输入，按以下格式回复。

                  【格式】
                  CONSULTATION|<RAG检索词>
                  OPERATION|<原消息>
                  ANALYTICS|<原消息>

                  【选 OPERATION 的情况——指定了具体某个商品查询数量或者价格等 + 写操作】
                  1. 查具体商品："有鸡蛋吗""可乐有吗""有没有牛奶"
                  2. 查价格："冰红茶多少钱""薯片什么价"
                  3. 下单/购买："帮我下单""买两箱"
                  4. 购物车："加入购物车""添加到购物车"

                  【选 ANALYTICS 的情况——只限于以下聚合统计】
                  1. 有哪些分类
                  2. 超市有多少商品
                  3. 某分类下有哪些商品
                  4. 有没有某一类商品（如"有没有零食"→ 返回分类+列表）
                  5. 帮我找找某一类商品

                  【选 CONSULTATION 的情况——FAQ + 闲聊 + 推荐】
                  - FAQ类："怎么退货""有优惠吗""运费多少""退换货流程""营业时间"
                  - 评价/推荐："哪种好""送礼推荐""哪个划算"
                  - 闲聊/打招呼："你好""在吗""介绍一下你自己"
                  - 任何不属于以上两类的问句

                  【改写规则——CONSULTATION 时输出一个 RAG 检索词】
                  去口语噪声，扩展近义词，保留一句通顺的话：
                    例："怎么退货退款" → "退换货流程 退款"
                    例："哪种牛奶好喝" → "牛奶 推荐 口感"
                    例："送礼送什么" → "送礼推荐 高档礼品"

                  用户：%s""".formatted(userMessage);

        try {
            String result = routerClient.prompt()
                    .user(prompt)
                    .call()
                    .content();

            log.info("意图识别: \"{}\" → {}", userMessage, result);

            if (result == null) {
                return new IntentResult(Intent.OPERATION, userMessage);
            }

            String trimmed = result.trim();
            if (trimmed.toUpperCase().startsWith("CONSULTATION")) {
                String[] parts = trimmed.split("\\|");
                String ragQuery = parts.length > 1 ? parts[1].trim() : userMessage;
                return new IntentResult(Intent.CONSULTATION, ragQuery);
            }

            if (trimmed.toUpperCase().startsWith("ANALYTICS")) {
                return new IntentResult(Intent.ANALYTICS, userMessage);
            }

            return new IntentResult(Intent.OPERATION, userMessage);
        } catch (Exception e) {
            log.error("意图识别失败，默认走 Tools", e);
            return new IntentResult(Intent.OPERATION, userMessage);
        }
    }
}
