# CDC智能导购项目 — 面试题集

> 基于真实项目：若依框架 + Spring AI Alibaba + 阿里云百炼 DashScope + Milvus 向量数据库
> 四大 Agent：闲聊（ChitchatAgent）+ RAG（RagAgent）+ Text-to-SQL + Tools（Tool Calling）

---

## 一、项目架构与设计（高频）

### Q1: 介绍一下这个项目的整体架构？
**回答要点**：
- 基于若依（RuoYi）框架的多模块 Maven 项目，Java 17 + Spring Boot 3.5
- 9个模块：4个标准若依模块（common/system/framework/admin）+ 3个自定义业务模块（cdc-aics-ai/cdc-aics-business/cdc-aics-portal）+ quartz + generator
- AI 层基于 Spring AI Alibaba 1.1.2，对接阿里云百炼 DashScope
- 向量数据库用 Milvus Standalone（Docker 部署）
- 前端 Vue3 + Element Plus

### Q2: 为什么选择多模块架构？有什么好处？
**回答要点**：
- 关注点分离：AI逻辑、业务逻辑、C端接口各自独立
- 按需部署：portal 和 business 可独立扩展
- 依赖清晰：ai → portal → business → common，单向依赖
- 团队协作：不同模块可并行开发

### Q3: 你的四 Agent 架构是怎么设计的？为什么这样分？
**回答要点**：
- **CHITCHAT（闲聊Agent）**：纯 ChatClient + 排行榜 Prompt 注入，无检索无 Tool
- **CONSULTATION（RAG Agent）**：Milvus 向量检索 FAQ + 文档切片
- **ANALYTICS（Text-to-SQL Agent）**：自然语言 → SQL → JdbcTemplate 执行 → LLM 解读
- **OPERATION（Tools Agent）**：Tool Calling（商品查询 + 购物车 + 下单）
- 设计原则：每个 Agent 只干一件事，不兼职。边界模糊靠 Prompt 兜底，不靠 Router 完美分类
- 四个 Agent 共享同一个 RedisChatMemory + sessionId（记忆不分裂）

### Q4: Router 是怎么做意图分类的？
**回答要点**：
- 用 ChatClient 做轻量级 LLM 分类（不带工具、不带记忆）
- 输出格式：`CHITCHAT|原消息` / `CONSULTATION|RAG改写词` / `OPERATION|原消息` / `ANALYTICS|原消息`
- CONSULTATION 时做 Query Rewriting（去口语噪声、扩展同义词）
- 默认兜底：匹配失败走 OPERATION，异常走 CHITCHAT

### Q5: 为什么要让 Router 做 Query Rewriting？
**回答要点**：
- 用户口语化表达不适合直接向量检索
- 例：用户说"那个退货咋整" → 改写为"退货流程 退款条件"
- 去口语噪声 + 扩展同义词，提升 RAG 召回率
- 一次 LLM 调用同时完成意图分类 + 查询改写，节省延迟

---

## 二、RAG（检索增强生成）— 高频重点

### Q6: 说一下 RAG 的完整流程？
**回答要点**：
```
离线入库：文档 → TextSplitter 切片 → Embedding API → float[] 向量 → Milvus
在线检索：用户问题 → Embedding API → 查询向量 → Milvus.similaritySearch() → Top K → 拼 Prompt → LLM 生成
```

### Q7: 为什么要用 RAG？和直接 Tool Calling（SQL LIKE）有什么区别？
**回答要点**：
- SQL LIKE 只能精确匹配（搜"零食"命中"零食"，搜"好吃的"搜不到）
- RAG 做语义匹配（搜"送礼用的"命中"高档礼盒"）
- 两者互补：Tools Agent 负责结构化商品查询，RAG Agent 负责非结构化知识检索

### Q8: 你的文档是怎么切片的？为什么这么设计？
**回答要点**：
- 结构感知切片器（TextSplitter）：分隔符优先级 `\n\n` → `\n` → `。` → `！` → `？` → `；` → `，`
- 滑动窗口 + overlap（默认 50 字符），防止边界信息丢失
- 兜底策略：硬切 + 滑动窗口
- chunkSize 默认 300 字符，匹配 Embedding 模型的上下文窗口

### Q9: Milvus 的索引类型是什么？为什么选 IVF_FLAT + COSINE？
**回答要点**：
- IVF_FLAT：倒排索引 + 暴力搜索。ANN 粗筛（聚类中心定位）→ KNN 精排（候选集暴力算余弦相似度）
- COSINE：余弦相似度，对文本语义更友好（方向比绝对距离重要）
- 数据量小（<10万）时 IVF_FLAT 够用，生产可换 HNSW（图索引，速度更快）

### Q10: 你的向量检索有哪些优化策略？
**回答要点**：
- **相似度阈值过滤**（threshold=0.7）：低相关度结果不返回，减少 LLM 幻觉
- **Top-K 控制**（topK=5）：平衡覆盖度和上下文长度
- **Query Rewriting**：Router 改写用户问题提升召回率
- **混合检索**（已简化）：FAQ 类走纯向量检索，商品类走 SQL LIKE

### Q11: 你是怎么保证 Milvus 数据和 MySQL 数据一致性的？
**回答要点**：
- **全量初始化**：`KnowledgeBaseInitializer` @PostConstruct 启动时全量重建
- **增量同步**：`@FaqSync` 注解 + AOP（INSERT/UPDATE/DELETE 即时同步）
- **自调用代理**：Service 内部调用走 `AopContext.currentProxy()` 确保 AOP 触发
- **写入链路**：dropCollection → createCollection → add → flush → createIndex → loadCollection

### Q12: Milvus 写入链路为什么容易漏步骤？
**回答要点**：
- 最容易漏的两步：**createIndex** 和 **loadCollection**
- 缺这两步：Attu 显示 0 条数据、搜索返回空（数据写了但没索引、没加载到内存）
- Spring AI 1.1.2 的 `initializeSchema(true)` 在部分版本下不建索引
- 最终方案：`initializeSchema(false)` + SDK 手动管理全流程

### Q13: RAG 检索为空的时候怎么处理？
**回答要点**：
- 不在代码层硬编码拒绝
- 交给 LLM 自行判断：闲聊时正常回应，真的需要信息时告知"暂未找到相关信息，建议联系人工客服"
- System Prompt 加引导"不要推荐商品，不要编造信息"

---

## 三、Tool Calling（工具调用）

### Q14: 说一下 Tool Calling 的底层协议？
**回答要点**：
```
Java @Tool 方法 → Spring AI 扫描生成 JSON Schema（OpenAI Function Calling 格式）
→ 拼到 HTTP 请求的 tools 字段 → DashScope 返回 tool_calls JSON
→ Spring AI 反射执行方法 → 结果回传 LLM → LLM 组织语言回复
```
- 两轮 LLM 调用：第一轮决策（调哪个工具+参数），第二轮组织语言
- DashScope（阿里云）兼容 OpenAI Function Calling 协议

### Q15: 为什么用 ThreadLocal + ToolResultStore 两种方式传递工具结果？
**回答要点**：
- **同步端点**：ThreadLocal 直接取（同一线程），简单高效
- **流式端点**：subscribe 异步执行，ThreadLocal 跨线程失效 → 用 ToolResultStore（ConcurrentHashMap）
- sessionId 作为 key，drain（取后即删）防内存泄漏

### Q16: 下单流程是怎么做并发库存控制的？
**回答要点**：
- **双重保险**：
  1. 加购前：检查库存（工具层，非锁定）
  2. 下单时：`SELECT ... FOR UPDATE` 行锁（MySQL 行级锁，Service 层）
- 先锁库存行 → 校验充足 → 扣减 → 释放锁
- 库存流水表（InventoryLog）记录每次变动的 before/after 值，可追溯

---

## 四、对话记忆（ChatMemory）

### Q17: RedisChatMemory 是怎么实现的？
**回答要点**：
- 实现 Spring AI `ChatMemory` 接口
- 两条 Redis Key：`chat:memory:{id}`（窗口内完整消息）+ `chat:summary:{id}`（溢出摘要）
- TTL 30 分钟自动清理僵尸会话
- Last N + Summary 模式：窗口 10 条完整保留，超出自动溢出到摘要（截断 2000 字符）
- 自实现 `MsgRecord` 内部类做序列化（解决 `Message` 接口 Jackson 反序列化问题）

### Q18: 为什么选择 Last N + Summary 模式而不是无限窗口？
**回答要点**：
- Token 成本：无限窗口导致每轮对话 Token 线性增长
- LLM 上下文窗口限制：deepseek-v4-flash 有最大上下文限制
- 注意力衰减：LLM 对中间位置的注意力较弱
- Summary 保留了早期对话的语义，丢失细节但不丢主题

---

## 五、流式输出（SSE）

### Q19: 流式输出是怎么实现的？踩过哪些坑？
**回答要点**：
- Spring MVC（Servlet 栈）不原生支持 `Flux<String>` 返回值
- 最终方案：`ResponseBodyEmitter` + `subscribe` 异步推送
- `text/event-stream` content-type 防止浏览器缓冲
- 关键：不能在 Controller 里 `blockLast()` 阻塞 Servlet 线程
- 前端：`fetch` + `ReadableStream` + `setInterval` 打字机动画

---

## 六、生产化

### Q20: 你是怎么做限流的？
**回答要点**：
- Redis 滑动窗口限流（默认 60s/20次）
- 实现：计数器 + TTL，首次请求设置过期时间，超限返回 false
- Redis 不可用时自动放行（不阻塞业务）

### Q21: 你怎么评估 AI 回答质量？
**回答要点**：
- 真实用户对话随机抽检（10%）
- LLM-as-Judge 异步打分（@Async，不阻塞用户）
- 评分维度：相关性(0-4) + 准确性(0-3) + 完整性(0-3)
- 结果存 MySQL（cdc_eval_log 表），后台可查统计

### Q22: 异常降级是怎么做的？
**回答要点**：
- 分类降级：超时/认证失败/限流/通用，不同错误不同提示
- 工具调用异常：try-catch 静默降级，返回空集合让 LLM 自然说"查不到"
- AI 服务不可用：返回友好提示而非堆栈

---

## 七、Text-to-SQL

### Q23: Text-to-SQL 的安全是怎么保证的？
**回答要点**：
- 只允许 SELECT 开头
- 危险关键字黑名单：DROP/DELETE/INSERT/UPDATE/ALTER/TRUNCATE/CREATE/EXEC/GRANT/REVOKE
- 自动加 LIMIT 50 防全表扫描
- 清理 markdown 包裹（```sql ... ```）

### Q24: RAG 和 Text-to-SQL 有什么区别？什么时候用哪个？
**回答要点**：
- RAG：语义理解（同义词/模糊表达），适合 FAQ、文档检索
- Text-to-SQL：结构化计算（COUNT/SUM/GROUP BY），适合聚合统计
- 两者互补：RAG 解决"是什么"，SQL 解决"有多少"

---

## 八、Spring Boot / Java 基础

### Q25: @PostConstruct 和构造器注入有什么区别？
- @PostConstruct：Bean 初始化后执行，适合需要依赖注入完成后的初始化
- 构造器注入：创建 Bean 时执行，支持 final 字段，编译期检查依赖

### Q26: @Async 的原理是什么？需要注意什么？
- Spring AOP 代理，提交给线程池异步执行
- 必须加 @EnableAsync
- self-call（类内部调用）不触发代理，需走 `AopContext.currentProxy()`
- 默认线程池是 SimpleAsyncTaskExecutor（不复用线程），生产需自定义

### Q27: @Transactional 自调用为什么不生效？
- Spring AOP 代理机制：外部调用走代理（触发事务），内部调用走 this（不触发）
- 解决方案：`AopContext.currentProxy()` + `@EnableAspectJAutoProxy(exposeProxy = true)`

### Q28: MyBatis 中 #{} 和 ${} 的区别？
- `#{}`：预编译，防 SQL 注入
- `${}`：字符串替换，有注入风险，用于动态表名/列名

---

## 九、Redis

### Q29: 购物车为什么用 Redis 而不是 MySQL？
**回答要点**：
- 购物车是临时状态，读写频繁，Redis 内存操作快
- TTL 2 小时自动清理，无需手动维护
- 数据结构：Hash（`cart:{sessionId}` → `Map<productId, CartItem>`）

### Q30: Redis 挂了怎么办？
**回答要点**：
- 限流：自动放行（不阻塞业务）
- 购物车：用户无法使用购物车功能，但不影响商品浏览
- 对话记忆：丢失历史上下文，但不影响单轮对话
- 生产方案：Redis Sentinel / Cluster 高可用

---

## 十、综合开放题

### Q31: 如果你的 RAG 系统准确率只有 60%，你会怎么优化？
**回答要点**：
- 首先定位问题：召回率低？精确率低？LLM 幻觉？
- 建立评测集，量化每个环节的表现
- 召回优化：Query Rewriting、HyDE（假设文档嵌入）、混合检索
- 精确率优化：相似度阈值、Re-ranking
- 幻觉优化：Prompt 约束（"如果不知道就说不知道"）、事实校验层

### Q32: 这个系统如果要支撑 1000 QPS，瓶颈在哪？怎么优化？
**回答要点**：
- LLM API 调用是最大瓶颈（网络延迟 + 模型推理时间）
- 优化方向：缓存相同/相似问题、模型路由（简单问题用小模型）、异步化
- Milvus 检索：索引优化（HNSW）、连接池
- 数据库：读写分离、连接池调优
- Redis：集群模式

### Q33: 如果要接入一个新的 LLM（比如 OpenAI），需要改哪些地方？
**回答要点**：
- 改 `application.yml` 配置（api-key、base-url、model）
- Spring AI 抽象层屏蔽了底层差异，代码层面改动很小
- 但如果模型 Tool Calling 格式不同，可能需要适配

### Q34: 你在这个项目中遇到的最难的问题是什么？怎么解决的？
（开放式回答，以下是建议方向）
- Milvus 维度不匹配 → 发现实际 1024 而非 1536
- 流式输出 Servlet 栈兼容 → ResponseBodyEmitter
- Spring AI 1.1.2 多模态适配 bug → 绕过框架直调 HTTP API
- Tool Calling 跨线程结果传递 → ToolResultStore

### Q35: 如果让你重新设计这个系统，你会做哪些改进？
（开放式回答，以下是建议方向）
- Spring AI 版本升级到最新（解决多模态、MCP 等兼容问题）
- Router 智能体化（带 ChatMemory，看历史对话理解上下文）
- 引入 MCP 协议接入第三方工具
- GraphRAG 构建商品知识图谱
- 用户画像 + 个性化推荐
- 多模型路由（简单问题用小模型降成本）
