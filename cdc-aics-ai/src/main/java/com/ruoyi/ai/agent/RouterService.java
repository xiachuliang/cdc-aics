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
                  CHITCHAT|<原消息>
                  CONSULTATION|<RAG检索词>
                  OPERATION|<原消息>
                  ANALYTICS|<原消息>

                  【选 CHITCHAT 的情况——闲聊 + 商品推荐】
                  1. 打招呼/闲聊："你好""嗨""在吗""介绍一下你自己""今天天气""好无聊"
                  2. 情绪表达："心情不好""开心""累了"
                  3. 模糊推荐/求推荐："有什么好吃的""推荐一下""哪种好""哪个划算"
                     "送什么礼物好""帮我挑一个""不知道买什么"
                  4. 任何没有明确商品名和哪类商品的推荐请求

                  【选 CONSULTATION 的情况——仅限 FAQ + 规则制度】
                  - FAQ："怎么退货""有优惠吗""运费多少""退换货流程""营业时间""怎么退款"
                  - 规则制度："积分规则""会员权益""售后政策""保修多久"
                  - 不属于闲聊、推荐、操作、统计的问句才走这里

                  【选 OPERATION 的情况——商品查询 + 购物车 + 下单 + 查订单 + 下单流程中的回复】
                  1. 查具体商品（带商品名）："有鸡蛋吗""可乐有吗""有没有牛奶"
                  2. 查价格（带商品名）："冰红茶多少钱""薯片什么价"
                  3. 购买意图："我要买""帮我下单""买两箱""买2瓶可乐""来一箱"
                  4. 购物车操作："加入购物车""添加到购物车""看看购物车""移除xxx""清空购物车"
                  5. 查订单："我的订单""订单到哪了""查物流""查订单""订单状态"
                  6. 下单流程中的回复（关键！）：用户说"确认""好的""可以""是的""对""行"、
                     以及11位手机号（如"13812345678"）→ 都属于下单流程，必须走 OPERATION

                  【选 ANALYTICS 的情况——只限于以下查询聚合统计】
                  1. 有哪些分类
                  2. 超市有多少商品
                  3. 某分类下有哪些商品（如"零食有哪些"）
                  4. 有没有某一类商品（如"有没有零食"→ 返回分类+列表）
                  5. 帮我找找某一类商品（大类搜索，不含具体商品名）

                  【改写规则——CONSULTATION 时输出一个 RAG 检索词】
                  去口语噪声，扩展近义词，保留一句通顺的话：
                    例："怎么退货退款" → "退换货流程 退款"
                    例："有优惠吗" → "优惠活动 促销"
                    例："会员有什么权益" → "会员权益 积分规则"

                  【默认规则】如果无法明确判断属于哪类，默认选 CHITCHAT

                  用户：%s""".formatted(userMessage);

        try {
            String result = routerClient.prompt()
                    .user(prompt)
                    .call()
                    .content();

            log.info("意图识别: \"{}\" → {}", userMessage, result);

            if (result == null) {
                return new IntentResult(Intent.CHITCHAT, userMessage);
            }

            String trimmed = result.trim();
            if (trimmed.toUpperCase().startsWith("CHITCHAT")) {
                return new IntentResult(Intent.CHITCHAT, userMessage);
            }

            if (trimmed.toUpperCase().startsWith("CONSULTATION")) {
                String[] parts = trimmed.split("\\|");
                String ragQuery = parts.length > 1 ? parts[1].trim() : userMessage;
                return new IntentResult(Intent.CONSULTATION, ragQuery);
            }

            if (trimmed.toUpperCase().startsWith("ANALYTICS")) {
                return new IntentResult(Intent.ANALYTICS, userMessage);
            }

            // 兜底：未匹配 → OPERATION（商品操作最通用）
            return new IntentResult(Intent.OPERATION, userMessage);
        } catch (Exception e) {
            log.error("意图识别失败，默认走闲聊", e);
            return new IntentResult(Intent.CHITCHAT, userMessage);
        }
    }
}
