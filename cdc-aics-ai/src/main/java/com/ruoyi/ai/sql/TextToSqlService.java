package com.ruoyi.ai.sql;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.PromptChatMemoryAdvisor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import reactor.core.publisher.Flux;

/**
 * Text-to-SQL 服务：自然语言 → LLM生成SQL → 安全校验 → 执行 → LLM解读
 *
 * 四步流水线：
 * 1. generateSql()  — LLM 将自然语言转为 SELECT 语句
 * 2. validate()     — 安全校验（只允许SELECT + 危险关键字黑名单 + 自动LIMIT）
 * 3. execute()      — JdbcTemplate 执行
 * 4. interpret()    — LLM 将结果转为通俗易懂的自然语言
 */
@Service
public class TextToSqlService {

    private static final Logger log = LoggerFactory.getLogger(TextToSqlService.class);

    // SQL 生成：纯 LLM，不要工具、不要记忆——否则 LLM 可能调工具而非生成 SQL
    private final ChatClient sqlGenClient;
    // 结果解读：带系统人设 + 记忆，保持多轮对话连贯
    private final ChatClient chatClient;
    private final JdbcTemplate jdbcTemplate;

    /**
     * 数据库 Schema——LLM 靠这个生成正确的 SQL。
     * 字段名必须和数据库完全一致，注释越详细 SQL 越准确。
     */
    private static final String DB_SCHEMA = """
              数据库表结构（MySQL）：

              cdc_product (商品表):
                id BIGINT 主键, category_id BIGINT 分类ID, barcode VARCHAR 条码,
                product_name VARCHAR 商品名, price DECIMAL(10,2) 价格, stock INT 库存,
                unit VARCHAR 单位, shelf_area VARCHAR 货架位置, image_url VARCHAR 图片,
                description VARCHAR 描述, status CHAR(1) 0上架1下架, del_flag CHAR(1) 0正常,
                create_time DATETIME, update_time DATETIME, remark VARCHAR 备注

              cdc_category (分类表):
                id BIGINT 主键, category_name VARCHAR 分类名, parent_id BIGINT 父分类ID,
                order_num INT 排序, status CHAR(1) 0启用1停用, del_flag CHAR(1) 0正常,
                create_time DATETIME, update_time DATETIME, remark VARCHAR 备注

              cdc_portal_order (订单表):
                id BIGINT 主键, order_no VARCHAR 订单编号, session_id VARCHAR 会话ID,
                customer_phone VARCHAR 手机号, customer_name VARCHAR 客户名,
                total_amount DECIMAL(10,2) 总金额, item_count INT 商品项数,
                status VARCHAR 状态(pending/confirmed/completed/cancelled),
                complete_time DATETIME 完成时间, create_time DATETIME, remark VARCHAR 备注

              cdc_portal_order_item (订单明细表):
                id BIGINT 主键, order_id BIGINT 订单ID, product_id BIGINT 商品ID,
                product_name VARCHAR 商品名, price DECIMAL(10,2) 单价,
                quantity INT 数量, shelf_area VARCHAR 货架位置, subtotal DECIMAL(10,2) 小计

              注意：查商品/分类时加 status='0' AND del_flag='0'。查订单不需要。
              """;

    public TextToSqlService(ChatClient.Builder builder, JdbcTemplate jdbcTemplate, ChatMemory chatMemory) {
        this.jdbcTemplate = jdbcTemplate;
        // SQL 生成客户端：无工具、无记忆
        this.sqlGenClient = builder.build();
        // 结果解读客户端：有系统人设 + 对话记忆
        this.chatClient = builder
                .defaultSystem("你是数据分析助手「小智」。擅长用通俗语言解读数据结果，直接给出结论，回答简洁控制在200字以内。")
                .defaultAdvisors(PromptChatMemoryAdvisor.builder(chatMemory).build())
                .build();
        log.info("Text-to-SQL Agent 初始化完成");
    }

    // ======================== 同步对话 ========================

    public String chat(String sessionId, String userMessage) {
        try {
            String rawSql = generateSql(userMessage);
            String sql = validate(rawSql);
            List<Map<String, Object>> results = execute(sql);
            return interpret(sessionId, userMessage, sql, results);
        } catch (Exception e) {
            log.error("Text-to-SQL 处理失败", e);
            return "抱歉，数据分析暂时不可用。【" + e.getMessage() + "】";
        }
    }

    // ======================== 流式对话 ========================

    public Flux<String> chatStream(String sessionId, String userMessage) {
        try {
            // 前三步同步（速度快，不需要流式）
            String rawSql = generateSql(userMessage);
            String sql = validate(rawSql);
            List<Map<String, Object>> results = execute(sql);

            if (results.isEmpty()) {
                return Flux.just("查询结果为空，可能没有符合条件的数据，换个条件试试？");
            }

            String table = formatTable(results);
            String prompt = """
                      用户问题：%s

                      执行SQL：%s

                      查询结果：
                      %s

                      请用通俗语言解读以上数据，直接回答用户问题。控制在200字以内。
                      """.formatted(userMessage, sql, table);

            // 解读步骤流式输出
            return chatClient.prompt()
                    .user(prompt)
                    .advisors(a -> a.param("chatMemoryConversationId", sessionId))
                    .stream()
                    .content()
                    .doOnError(e -> log.error("流式解读失败", e));
        } catch (Exception e) {
            log.error("Text-to-SQL 流式处理失败", e);
            return Flux.just("抱歉，数据分析暂时不可用。【" + e.getMessage() + "】");
        }
    }

    // ======================== 第1步：生成 SQL ========================

    private String generateSql(String question) {
        String prompt = """
                  你是SQL专家。根据数据库表结构，将用户问题转为一条SELECT查询。

                  ## 数据库结构
                  %s

                  ## 规则
                  - 只输出SELECT语句，不要任何解释
                  - 查商品/分类时必须加 status='0' AND del_flag='0'
                  - 聚合查询加合理别名（AS xxx）
                  - 排序默认降序 DESC
                  - 用 LIMIT 限制返回行数（最多50行）
                  - 不要使用子查询，尽量用 JOIN

                  ## 用户问题
                  %s

                  ## SQL
                  """.formatted(DB_SCHEMA, question);

        try {
            String sql = sqlGenClient.prompt()
                    .user(prompt)
                    .call()
                    .content();
            log.info("SQL 生成: \"{}\" → {}", question, sql);
            return sql;
        } catch (Exception e) {
            log.error("SQL 生成失败", e);
            throw new RuntimeException("SQL生成失败: " + e.getMessage());
        }
    }

    // ======================== 第2步：安全校验 ========================

    private String validate(String rawSql) {
        if (rawSql == null || rawSql.isBlank()) {
            throw new IllegalArgumentException("生成的SQL为空");
        }

        // 去掉 markdown 的 ```sql ... ``` 包裹
        String sql = rawSql.trim();
        if (sql.startsWith("```sql")) sql = sql.substring(6);
        if (sql.startsWith("```")) sql = sql.substring(3);
        if (sql.endsWith("```")) sql = sql.substring(0, sql.length() - 3);
        sql = sql.trim();

        // 去掉末尾分号（JdbcTemplate 不需要）
        if (sql.endsWith(";")) sql = sql.substring(0, sql.length() - 1);

        String upper = sql.toUpperCase().trim();

        // ① 只允许 SELECT
        if (!upper.startsWith("SELECT")) {
            throw new IllegalArgumentException("只允许SELECT查询，收到: "
                    + upper.substring(0, Math.min(50, upper.length())));
        }

        // ② 危险关键字黑名单
        String[] forbidden = {"DROP", "DELETE", "UPDATE", "INSERT", "ALTER",
                "TRUNCATE", "CREATE", "EXEC", "EXECUTE", "GRANT", "REVOKE"};
        for (String kw : forbidden) {
            if (upper.contains(kw)) {
                throw new IllegalArgumentException("SQL包含危险关键字: " + kw);
            }
        }

        // ③ 自动加 LIMIT（防全表扫描）
        if (!upper.contains("LIMIT")) {
            sql += " LIMIT 50";
        }

        return sql;
    }

    // ======================== 第3步：执行 SQL ========================

    private List<Map<String, Object>> execute(String sql) {
        log.info("执行 SQL: {}", sql);
        long start = System.currentTimeMillis();
        List<Map<String, Object>> results = jdbcTemplate.queryForList(sql);
        log.info("SQL 执行完成, 耗时={}ms, 行数={}", System.currentTimeMillis() - start, results.size());
        return results;
    }

    // ======================== 第4步：LLM 解读 ========================

    private String interpret(String sessionId, String question, String sql, List<Map<String, Object>> results) {
        if (results.isEmpty()) {
            return "查询结果为空，可能没有符合条件的数据，换个条件试试？";
        }

        String table = formatTable(results);

        String prompt = """
                  用户问题：%s

                  执行SQL：%s

                  查询结果：
                  %s

                  请用通俗语言解读以上数据，直接回答用户问题。控制在200字以内。
                  """.formatted(question, sql, table);

        return chatClient.prompt()
                .user(prompt)
                .advisors(a -> a.param("chatMemoryConversationId", sessionId))
                .call()
                .content();
    }

    // ======================== 工具方法 ========================

    /**
     * 将查询结果格式化为 Markdown 表格
     */
    private String formatTable(List<Map<String, Object>> results) {
        if (results.isEmpty()) return "(空)";

        List<String> columns = results.get(0).keySet().stream().toList();

        StringBuilder sb = new StringBuilder();
        // 表头
        sb.append("| ").append(String.join(" | ", columns)).append(" |\n");
        // 分隔线
        sb.append("|").append(columns.stream().map(c -> "---").collect(Collectors.joining("|"))).append("|\n");
        // 数据行（最多 20 行）
        int maxRows = Math.min(results.size(), 20);
        for (int i = 0; i < maxRows; i++) {
            Map<String, Object> row = results.get(i);
            sb.append("| ");
            sb.append(columns.stream()
                    .map(col -> {
                        Object val = row.get(col);
                        return val == null ? "" : val.toString();
                    })
                    .collect(Collectors.joining(" | ")));
            sb.append(" |\n");
        }
        if (results.size() > 20) {
            sb.append("\n...（共 ").append(results.size()).append(" 行，仅显示前 20 行）\n");
        }
        return sb.toString();
    }
}