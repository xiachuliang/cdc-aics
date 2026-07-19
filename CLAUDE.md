# CLAUDE.md

## 语言偏好

- 始终使用中文与用户对话。
- 代码、注释、文档内容保持原样，不做翻译。

---

## 项目概述

**CDC智能导购**（cdc-aics）— 基于若依（RuoYi）框架的超市智能导购系统。

### 技术栈

- **后端**: Spring Boot + MyBatis + MySQL + Redis
- **前端**: Vue3 + Element Plus (ruoyi-ui)
- **AI**: Spring AI Alibaba + 阿里云 DashScope（百炼平台）
- **构建**: Maven 多模块

### 模块结构

```
cdc-aics-server/
├── ruoyi-admin/          # 若依管理后台（启动入口）
├── ruoyi-common/         # 若依通用工具
├── ruoyi-framework/      # 若依框架核心
├── ruoyi-system/         # 若依系统管理（用户/角色/菜单）
├── ruoyi-generator/      # 若依代码生成器
├── ruoyi-quartz/         # 若依定时任务
├── cdc-aics-ai/          # ★ AI核心模块（智能体/Tool Calling/RAG）
├── cdc-aics-business/    # ★ 超市业务模块
├── cdc-aics-portal/      # ★ C端门户模块（免登录）
├── ruoyi-ui/             # 前端
└── sql/                  # 数据库脚本
```

### 三个自定义模块详情

#### 1. cdc-aics-ai（AI核心模块）

**Agent 层**：
- `ChatOrchestrator.java` — 总调度器（意图路由 → 分发到各 Agent）
- `RouterService.java` — LLM 意图分类（CHITCHAT / CONSULTATION / ANALYTICS / OPERATION）
- `ChitchatAgentService.java` — 闲聊 Agent（⭐ 纯 ChatClient + 排行榜 Prompt 注入，无 Tool、无 RAG）
- `RagAgentService.java` — RAG Agent（向量检索 FAQ + 规则制度，纯知识检索）
- `ChatServiceImpl.java` — Tools Agent（Tool Calling: 商品查询 + 购物车 + 下单）
- `TextToSqlService.java` — Text-to-SQL Agent（自然语言 → SELECT → 执行 → 解读）
- `ImageAnalysisService.java` — 多模态图片分析（qwen-vl-plus，HTTP API）

**工具层**：
- `ProductTools.java` — 5个商品查询工具（@Tool 注解 + ThreadLocal 暂存结果）
- `OrderTools.java` — 6个购物操作工具（加购/查购物车/删购物车项/改数量/下单/查订单，@Tool 注解 + ToolResultStore 暂存结果）

**基础设施层**：
- `AiConfig.java` — ChatClient + ChatMemory + VectorStore + Prompt 模板 配置
- `RedisChatMemory.java` — 自实现 ChatMemory（Redis 持久化 + 窗口10条 + 摘要 + TTL）
- `KnowledgeBaseInitializer.java` — Milvus 知识库初始化（FAQ + 文档切片，schema 检测与自动重建）
- `Intent.java` — 意图枚举（CHITCHAT / CONSULTATION / ANALYTICS / OPERATION）

**chitchat 包（闲聊 Agent + 排行榜缓存）**：
- `ChitchatAgentService.java` — 闲聊 Agent（主动带货，排行榜通过 Prompt 注入）
- `RankingCacheService.java` — 排行榜缓存（`@Scheduled` 每小时查展示榜 Top 10，格式化为文本）

**Prompt 管理**：
- `prompts/guide.st` — Tools Agent System Prompt 模板（StringTemplate 格式）
- `prompts/chitchat.st` — 闲聊 Agent System Prompt 模板（排行榜占位 `{rankingSection}`）

**评测与向量同步**：
- `EvalJudgeService.java` — LLM-Judge 异步评测（10% 抽检）
- `eval/` 包 — 评测相关 Domain / Mapper / Controller（已迁至 cdc-aics-business）
- `annotation/` 包 — ProductSync / FaqSync 等 AOP 切面注解
- 依赖 `cdc-aics-business`（Tools 需要查业务数据）

#### 2. cdc-aics-business（超市业务模块）
- Domain: Category, Product, Supplier, PurchaseOrder, PurchaseOrderItem, PortalOrder, PortalOrderItem, InventoryLog
- 完整 Mapper + Service 层
- 后台管理：商品管理/分类管理/供应商管理/采购管理/订单管理/库存管理/出入库管理

#### 3. cdc-aics-portal（C端门户模块）
- `PortalController` — 商品分类列表、商品分页、商品详情、商品搜索（全部免登录）
- `CartController` — 购物车
- `OrderController` — 订单
- 前端门户页面：`/portal/product` 商品浏览、`/portal/chat` AI导购对话、`/portal/cart` 购物车、`/portal/order/confirm` 确认订单、`/portal/order/query` 订单查询

### 当前AI能力

- ✅ 基础对话（ChatClient + DashScope + deepseek-v4-flash）
- ✅ 对话记忆（RedisChatMemory，窗口10条 + 摘要 + TTL 30min）
- ✅ 流式输出 SSE（ResponseBodyEmitter + fetch ReadableStream 打字机效果）
- ✅ Tool Calling（5个商品工具 + 6个购物工具 + ThreadLocal/ToolResultStore 卡片渲染）
- ✅ Prompt 工程化（.st 模板 + 变量注入 + 热更新）
- ✅ RAG 检索增强生成（Milvus 向量库 + FAQ + 文档切片语义检索）
- ✅ 混合检索（向量语义 + SQL LIKE + RRF 融合）
- ✅ Text-to-SQL（自然语言 → SELECT → 安全校验 → 解读）
- ✅ 多模态图片分析（qwen-vl-plus + HTTP API + 前端图片上传）
- ✅ MCP 协议概念（未写代码，Spring AI 1.1.2 无完整支持）
- ✅ 多智能体协同（四 Agent：闲聊 + RAG + Text-to-SQL + Tools）
- ✅ AI 购物能力（加购/购物车管理/下单确认，双重库存检查，低风险自动+高风险确认）
- ✅ AI 评测体系（10% 随机抽检 + LLM-Judge 异步打分 + 后台管理）
- ✅ 生产化（对话日志 + Redis 限流 + 异常降级 + 后台管理）
- ✅ AI导购聊天界面（快捷问题、会话管理、跨页面持久化）
- ✅ 闲聊带货（独立闲聊 Agent + 排行榜 Prompt 注入 + 定时刷新缓存）

---

## AI 学习路线图（高等水平）

以"智能导购助手小智"为主线项目，渐进式学习 Spring AI + 阿里云 AI 全栈技术。
**核心原则**：每个阶段学完都要能跑、能演示、能解决实际问题。新能力封装为 `@Tool`，逐步增强同一个导购。

---

### 第1阶段：Tool Calling（工具调用）

**目标**：让 AI 从纯聊天变成能实际操作业务（手和脚）

**实战问题**：
- 用户问"帮我找零食"→ AI 瞎编商品，因为没有真实查询能力
- 用户问"这件商品多少钱"→ AI 不知道价格
- 用户问"有什么分类"→ AI 凭空捏造分类名

**学习内容**：

1. **Spring AI @Tool 注解** — 把 Service 方法暴露给 AI 调用
   - `@Tool` 注解 + `ToolCallback` 自动发现
   - 工具注册：`.defaultTools(serviceInstance)` 
   - 理解 Spring AI 如何生成 JSON Schema 描述给 LLM

2. **导购工具集实现** — 真实业务工具
   ```java
   @Tool(description = "按关键词搜索商品，返回商品名/价格/图片")
   List<Product> searchProducts(String keyword);
   
   @Tool(description = "查看商品详细信息")
   Product getProductDetail(Long productId);
   
   @Tool(description = "获取所有商品分类")
   List<Category> listCategories();
   
   @Tool(description = "按分类ID查商品")
   List<Product> getProductsByCategory(Long categoryId);
   ```

3. **Tool Calling 底层协议理解**
   - OpenAI Function Calling 协议格式
   - DashScope（阿里云）的 Tool Calling 实现差异
   - 参数提取 → 工具执行 → 结果回传的完整链路

4. **工具结果渲染** — 前端卡片化展示
   - 区分"纯文本回复"和"工具调用结果"
   - 商品卡片、分类标签的 UI 组件

**学完后效果**：用户说"找零食"→ AI 调 `searchProducts("零食")` → 返回真实商品列表 → 前端卡片展示

---

### 第2阶段：流式输出（SSE / Streaming）

**目标**：AI 回复像 ChatGPT 一样逐字打字机效果，解决当前同步阻塞的体验问题

**实战问题**：
- 当前 `/ai/chat` 是同步返回，用户要等 3~10 秒才能看到完整回复
- 长回复时体验极差，用户不知道 AI 是否在工作

**学习内容**：
1. **Spring AI 流式 API** — `ChatClient.prompt().stream().content()`
2. **SSE 协议** — `text/event-stream`，Spring WebFlux / Spring MVC SSE
3. **前端 EventSource / fetch ReadableStream** 消费流式数据
4. **流式中的 Tool Calling** — 工具调用过程中如何向前端推送状态
5. **DashScope 流式 API** 的 token 级输出

**学完后效果**：AI 回复逐字出现，体验接近 ChatGPT

---

### 第3阶段：Prompt Engineering 工程化

**目标**：建立 Prompt 管理体系，不把 System Prompt 硬编码在代码里

**实战问题**：
- 当前 system prompt 写死在 `ChatServiceImpl` 里，无法动态调整
- 不同场景需要不同人设（导购模式 vs 客服模式 vs 商品审核模式）
- Prompt 需要根据上下文动态注入（用户名、当前时间、促销活动）

**学习内容**：
1. **Prompt 模板化** — Spring AI `PromptTemplate` / `Resource` 加载 `.st` 文件
2. **变量注入** — 动态拼装：`{userName}`、`{currentTime}`、`{promotions}`
3. **多角色 Prompt 切换** — 导购/客服/商品审核三种 System Prompt
4. **Few-shot Prompting** — 给出示例让 AI 模仿回答风格和格式
5. **Chain-of-Thought (CoT)** — 引导 AI 分步骤推理
6. **Prompt 版本管理与热更新** — 存数据库/Redis，支持运营修改

**学完后效果**：Prompt 模板化存储，不同场景自动切换人设，运营可调优

---

### 第4阶段：RAG 检索增强生成

**目标**：建立商品知识库，让 AI 做语义级别的智能搜索

**实战问题**：
- Tool Calling 只能精确匹配（`LIKE '%零食%'`），搜不到"好吃的"、"送礼用的"
- 商品描述、使用说明、品牌故事等长文本需要语义理解
- 新商品上架、促销活动文案需要实时索引

**学习内容**：
1. **Embedding 模型** — DashScope 提供的文本向量化 API
2. **向量存储** — Spring AI `VectorStore` 抽象
   - 方案A：阿里云 DashScope 自带向量存储
   - 方案B：Elasticsearch（已有基础设施）
   - 方案C：PGVector（PostgreSQL 插件）
3. **文档切分** — `TokenTextSplitter`，chunk size / overlap 策略
4. **ETL 管道** — 商品数据 → Document → Embedding → VectorStore 全流程
5. **检索策略** — Top-K / 相似度阈值 / 混合检索（BM25 + 向量）
6. **Re-ranking** — 用更强的模型对召回结果精排
7. **RAG 封装为 Tool** — `@Tool(description="搜索商品知识库")`，AI 自动决定何时检索

**学完后效果**："有没有适合送礼的高档商品" → 语义匹配 → 精准推荐

---

### 第5阶段：RAG 进阶 — 混合检索与高级策略

**目标**：解决 RAG 准确率不足、召回不全的实际问题

**实战问题**：
- 关键词搜"可乐"和语义搜"碳酸饮料"各自有盲区
- 用户问"最近有什么活动"需要时效性排序
- 文档太长导致检索精度下降

**学习内容**：
1. **混合检索（Hybrid Search）** — BM25 关键词 + 向量语义，加权融合
2. **Self-Query Retrieval** — LLM 先提取查询条件（分类=零食，价格<50），再检索
3. **Multi-Vector Retrieval** — 对文档摘要和原文分别建索引
4. **Parent Document Retriever** — 检索小块、返回大块，解决精度与上下文矛盾
5. **RAG 评测** — 构建测试集，量化检索命中率和答案质量
6. **GraphRAG 入门** — 商品→分类→品牌的知识图谱增强

**学完后效果**：混合检索解决"碳酸饮料 vs 可乐"的语义+关键词盲区

---

### 第6阶段：ChatMemory 对话记忆进阶

**目标**：从简单窗口记忆升级到智能持久化记忆

**实战问题**：
- 当前 `MessageWindowChatMemory` 窗口只有10条，超出就丢
- 用户昨天问过"推荐零食"，今天再来还得重新说偏好
- 记忆应该分层：近期对话 vs 长期偏好 vs 用户画像

**学习内容**：
1. **持久化记忆** — 改用 Redis/Cassandra 存储，重启不丢失
2. **Last N + Summary 模式** — 近期N条保留原文 + 更早的自动摘要
3. **用户画像记忆** — 长期追踪用户偏好（喜欢辣的、预算50以内）
4. **多会话记忆隔离** — 同一用户多个会话的上下文管理
5. **记忆检索** — 用 RAG 技术检索历史对话中相关的片段

**学完后效果**：AI 记得用户之前的偏好，跨会话保持上下文

---

### 第7阶段：Text-to-SQL 自然语言查库

**目标**：让 AI 能回答统计/分析类问题

**实战问题**：
- "本月销量Top5"、"库存不足的商品"、"哪个分类卖得最好"
- Tool Calling 只能查单个记录，无法聚合统计
- SQL 安全风险：AI 可能生成 DELETE/DROP

**学习内容**：
1. **Schema 注入** — 把表结构（DDL + 字段注释）提供给 LLM
2. **Few-shot SQL 示例** — 给 AI 看几个"问题→SQL"的例子
3. **SQL 生成 + 执行 + 解读**全链路
4. **安全沙箱** — 只允许 SELECT、禁止多语句、超时限制
5. **结果格式化** — SQL 结果 → 自然语言解读 → 前端表格/图表展示
6. **封装为 Tool** — AI 自动判断何时用 Text-to-SQL vs 普通 Tool

**学完后效果**：用户问统计类问题 → AI 生成SQL → 执行 → 解读结果

---

### 第8阶段：多模态（图片 + 语音）

**目标**：AI 能看图、能听语音

**实战问题**：
- 用户拍一张商品照片问"你们有这个吗"
- 用户想语音输入而非打字
- 商品图片自动生成描述文案

**学习内容**：
1. **图片理解** — DashScope 多模态模型，上传图片 + 文本问答
2. **以图搜商品** — 图片 → Embedding → 向量检索相似商品
3. **语音转文字** — 阿里云 ASR / DashScope 语音识别
4. **文字转语音** — TTS 合成 AI 语音回复
5. **图片生成** — 商品营销图/海报 AI 生成

**学完后效果**：拍图搜同款、语音对话、AI 自动生成商品描述

---

### 第9阶段：Tool Calling 进阶 — MCP 协议与复杂工具编排

**目标**：理解 MCP 标准协议，实现跨系统的工具复用

**实战问题**：
- 每个工具都要在代码里写 `@Tool`，耦合在 Java 代码中
- 第三方系统（ERP、物流）的工具无法直接集成
- 工具多了以后管理和发现困难

**学习内容**：
1. **MCP 协议（Model Context Protocol）** — 标准化工具接口
   - MCP Server / Client 架构
   - Tools、Resources、Prompts 三种原语
   - Spring AI MCP 集成
2. **工具的自省与发现** — AI 自己决定调用哪个工具，而非硬编码路由
3. **工具调用链（Chaining）** — 搜商品 → 查详情 → 比价 → 推荐
4. **异步工具** — 长时间运行的工具（如生成报表），异步回调
5. **工具错误处理与重试** — 工具挂了怎么办，降级策略

**学完后效果**：工具与业务解耦，支持 MCP 协议接入第三方工具

---

### 第10阶段：多智能体协同（Multi-Agent）

**目标**：多个专业 Agent 分工协作，像团队一样工作

**实战问题**：
- 单一 Agent 面对复杂任务时能力不足（既要做导购又要查订单还要做推荐）
- 不同业务需要不同的 System Prompt 和工具集
- Agent 之间需要传递上下文和中间结果

**学习内容**：
1. **Agent 角色设计**
   ```
   调度Agent（Router）→ 理解意图，分发任务
   导购Agent → searchProducts + RAG + 推荐逻辑
   订单Agent → 查订单状态 + 物流追踪
   库存Agent → 库存查询 + 补货建议
   汇总Agent → 合并多个Agent结果，生成统一回复
   ```

2. **编排模式**
   - 顺序编排（Chain）：A→B→C
   - 并行编排（Parallel）：同时调多个 Agent
   - 路由编排（Router）：按意图分发
   - 循环编排（Loop）：Agent 自己迭代优化

3. **Spring AI AgentExecutor 实战**
4. **Agent 间上下文传递** — 共享 memory / 消息总线
5. **LangChain4j 对比学习** — 了解不同框架的设计思路
6. **AutoGen 模式** — 两个 Agent 互相问答直到收敛

**学完后效果**：复杂请求自动拆解、多Agent并行处理、汇总回复

---

### 第11阶段：AI 评测体系

**目标**：量化评估 AI 回答质量，而非凭感觉说"还行"

**实战问题**：
- 怎么知道改了一行 Prompt 后效果变好还是变差？
- 如何衡量 Tool Calling 的准确率？
- RAG 召回率到底是多少？

**学习内容**：
1. **评测指标设计** — 准确性、相关性、响应时间、工具调用正确率
2. **测试集构建** — 从真实用户对话中抽取，标注期望答案
3. **LLM-as-Judge** — 用另一个模型给回答打分
4. **A/B 对比测试** — 两个 Prompt / 两个模型并排对比
5. **回归测试** — 每次改动自动跑评测集
6. **线上监控指标** — 用户点赞/点踩、重复提问率

**学完后效果**：有量化的评测数据，知道每次改动是否真正改善

---

### 第12阶段：生产化（安全 · 监控 · 成本 · 降级）

**目标**：从 Demo 级变成生产级

**实战问题**：
- API Key 泄露、Prompt 注入攻击
- 并发高了 Redis 扛不住、AI 调用超时
- Token 消耗无底洞，成本不可控
- 某家模型挂了需要自动切换备用模型

**学习内容**：
1. **安全防护**
   - Prompt 注入防护（输入清洗 + 角色限定）
   - 内容安全审核（敏感词过滤 + AI 输出安全）
   - API Key 安全存储（配置中心加密）
   - 越狱攻击防御

2. **可观测性**
   - Spring AI Tracing（链路追踪）
   - Token 消耗监控
   - 工具调用链路日志
   - 接入 Prometheus + Grafana 仪表盘

3. **性能优化**
   - ChatClient 连接池配置
   - 工具调用超时与降级
   - Redis 缓存策略（相同问题缓存回答）

4. **成本控制**
   - Token 用量统计与预警
   - 模型路由（简单问题用小模型，复杂问题用大模型）
   - 多模型备选（DashScope / OpenAI / 开源模型）
   - 限流熔断（Sentinel / Resilience4j）

5. **灰度发布与策略管理**
   - Prompt 灰度（10% 用户用新版 Prompt）
   - 模型切换热更新
   - 运营后台：可视化配置 AI 策略

**学完后效果**：安全可控、可观测、可降级、成本优化 —— 达到生产级标准

---

### 🗺️ 学习路线全景

```
基础能力层                        进阶能力层                        生产级能力层
───────────────────────────────────────────────────────────────────────────

阶段1: Tool Calling ──→ 阶段4: RAG基础 ──→ 阶段5: RAG进阶
阶段2: 流式输出 SSE      阶段7: Text-to-SQL    阶段9: 工具进阶 MCP
阶段3: Prompt工程        阶段6: 记忆进阶        阶段10: 多智能体
阶段8: 多模态                                  阶段11: 评测体系
                                               阶段12: 生产化

每个阶段的可交付物：
  ├── 可运行的代码（在 cdc-aics-ai 模块）
  ├── 前端交互验证（在 ruoyi-ui portal/chat 页面）
  └── 该阶段解决的核心问题 demo
```

### 技术栈全景图

```
应用层    | 智能导购  | AI客服  | 商品审核 | 数据分析 | ← 多Agent编排
         |          |         |          |          |
AI能力层 | ChatClient | Tool Calling | RAG | Text2SQL | Multi-Agent
         | Prompt Template | Streaming | Memory | MCP    |
         |                                                  |
模型层   | DashScope (阿里云百炼) ←→ OpenAI 备用             |
         | 通义千问 / Embedding / 多模态 / 语音              |
         |                                                  |
框架层   | Spring AI Alibaba | Spring AI | LangChain4j     |
         | Spring Boot | MyBatis | Redis | MySQL            |
         |                                                  |
工程层   | 安全防护 | 限流熔断 | 链路追踪 | 成本监控 | 灰度发布 |
```

---

---

### 当前进度（2026-07-14 更新）

- [x] ✅ 项目框架搭建（若依 + 三模块）
- [x] ✅ 基础对话（ChatClient + DashScope）
- [x] ✅ 对话记忆（MessageWindowChatMemory）
- [x] ✅ AI导购聊天UI（portal/chat）
- [x] ✅ **阶段1：Tool Calling** ← 已完成
   - [x] 原理讲解（LLM不执行代码，只决策调哪个工具传什么参数）
   - [x] Spring（IoC/DI/Bean/接口vs实现类）
   - [x] 创建 ProductTools.java（5个工具）
   - [x] 修改 AiConfig.java 注册工具（.defaultTools(productTools)）
   - [x] 修复 ChatServiceImpl：去掉 @Log、mutate() 不重复注册工具
   - [x] 模型锁定：application.yml 配 model: qwen-turbo（全态用完，换大语言模型）
   - [x] 踩坑：Product 字段是 productName 不是 name
   - [x] 踩坑：mutate() 继承父 ChatClient 的工具，重复注册报 Multiple tools 错误
   - [x] 踩坑：@Log 注解在 @Anonymous 接口上 SecurityUtils.getLoginUser() 报错
   - [x] 理解：@Anonymous → PermitAllUrlProperties 自动扫描 → SecurityConfig 白名单
   - [x] Tool Calling 底层协议：Java 方法 → JSON Schema → HTTP → LLM 决策 → 反射执行
   - [x] 前端工具调用结果卡片渲染（ThreadLocal + ChatResult + 商品卡片）
   - [x] 工具调用错误处理（try-catch 静默降级，避免堆栈暴露）
   - [x] 前端全页面 3:1 布局（左商品 3 + 右 AI 对话 1，全部 C 端页面统一）
   - [x] 跨页面对话持久化（localStorage 共享 sessionId + messages）
   - [x] 踩坑：.iml sourceFolder 错误 → 同包类爆红 → 修复为 src/main/java
- [x] ✅ **阶段2：流式输出 SSE** ← 已完成
   - [x] 原理：同步 vs 流式、SSE 协议、Flux\<String\>
   - [x] 后端：IChatService 新增 Flux\<String\> chatStream()
   - [x] 后端：ChatServiceImpl 实现 .stream().content() + .doOnNext(log) 调试
   - [x] 后端：ChatController 新增 /ai/chat/stream 端点
   - [x] 前端：fetch + ReadableStream 逐块读取 + setInterval 30ms 打字机动画
   - [x] 踩坑：Flux\<String\> 返回 404 → Vite 代理只转发 /dev-api 前缀 → fetch URL 加 /dev-api
   - [x] 踩坑：Spring MVC 不支持直接返回 Flux → 尝试 SseEmitter、StreamingResponseBody、HttpServletResponse
   - [x] 踩坑：blockLast() 阻塞 Servlet 线程 → 响应不提交 → 前端收不到流 → 换 ResponseBodyEmitter + subscribe 异步
   - [x] 踩坑：content-type 影响浏览器缓冲 → text/event-stream 才能实时推送
   - [x] 已验证：ResponseBodyEmitter 方案前端没有成功
- [x] ✅ **阶段3：Prompt 工程化** ← 已完成
   - [x] 新建 `prompts/guide.st` StringTemplate 模板文件
   - [x] AiConfig 加 `guidePromptResource()` Bean 加载模板
   - [x] ChatServiceImpl 注入 Resource，读取模板 + .replace() 替换变量
   - [x] 兜底机制：模板加载失败用硬编码 systemPrompt
   - [x] 踩坑：PromptTemplate API 版本不兼容 → 改用 Resource.getContentAsString() + String.replace()
   - [x] 踩坑：getContentAsString() 抛 IOException → try-catch 包住
- [x] ✅ **阶段4：RAG 检索增强生成** ← 已完成
   - [x] 原理：Embedding 向量化 → 向量相似度 → 语义搜索
   - [x] SimpleVectorStore 内存向量库（零依赖，学习过渡用）
   - [x] 新建 KnowledgeBaseInitializer.java：@PostConstruct 启动时加载商品到向量库
   - [x] 新建 RagAgentService.java：手动检索 VectorStore → 拼上下文 → LLM 回答
   - [x] RAG 检索结果存入 ChatMemory（对话历史），下次对话自动引用
   - [x] 踩坑：Spring AI 1.1.2 无 QuestionAnswerAdvisor，改用手动检索
   - [x] 踩坑：SimpleVectorStore.builder() 1.1.2 需要传 EmbeddingModel 参数
   - [x] Docker 安装成功，Milvus 镜像拉取失败（网络问题），生产环境再换
   - [x] 认知：Chat 模型（deepseek-v4-flash）和 Embedding 模型（text-embedding-v1）独立
   - [x] 🔄 **重构（2026-07-13）：移除商品向量化**
     - [x] Milvus 向量库不再存商品，只存 FAQ + 文档切片
     - [x] 商品查询统一走 Tools Agent（ProductTools.searchProducts → SQL LIKE）
     - [x] KnowledgeBaseInitializer 改为加载 FAQ + 文档切片（非商品）
     - [x] 废弃 ProductSync AOP 注解和相关代码
     - [x] Collection schema 修复：id(Int64) → doc_id(VarChar)，适配 Spring AI MilvusVectorStore
     - [x] RAG Agent 检索为空时不硬编码拒绝，交 LLM 自行判断（闲聊兜底）
- [x] ✅ **阶段5：RAG 进阶 — 混合检索与高级策略** ← 已完成
   - [x] 相似度阈值过滤（similarityThreshold=0.7）：低相关度结果不返回，减少幻觉
   - [x] 混合检索：向量语义 + SQL LIKE 关键词，两路互补
   - [x] RRF 排名融合算法（k=60）：排名加权 + 去重 + 分数叠加
   - [x] Query Rewriting：Router 一次调用输出意图 + RAG 改写词 + SQL 关键词
   - [x] IntentResult 类：intent + ragQuery + sqlKeyword 三段结构
   - [x] RagAgentService 注入 IProductService 做关键词检索
   - [x] Router Prompt 优化：明确 CONSULTATION 为默认，OPERATION 限三类
   - [x] 认知：大厂用 ES BM25 替代 SQL LIKE，学习阶段 SQL LIKE 够用
   - [x] 认知：混合检索 + RRF 融合是生产级做法，LLM Query Rewrite 代替正则
   - [x] 🔄 **重构（2026-07-13）：简化混合检索**
     - [x] 移除 RagAgentService 中的 IProductService 注入（商品不再走向量混合检索）
     - [x] RAG Agent 专注纯向量语义检索（FAQ + 文档切片）
     - [x] 商品关键词搜索走 Tools Agent（SQL LIKE），不再和向量检索混合
- [x] ✅ **阶段10：多智能体协同** ← 提前引入
   - [x] 双 Agent 架构：RAG Agent（知识咨询）+ Tools Agent（操作/下单）
   - [x] RouterService：LLM 意图分类 → CONSULTATION 或 OPERATION
   - [x] ChatOrchestrator：调度器 → 意图路由 → 分发到对应 Agent
   - [x] 两个 Agent 共享 ChatMemory + sessionId（对话记忆不分裂）
   - [x] 流式/同步统一路由逻辑
   - [x] Intent 枚举：CONSULTATION / OPERATION
   - [x] 知识库全部查询走 RAG，只有写操作走 Tools
   - [x] 前端 detail.vue 加"新对话"按钮（清空 localStorage + 重建 sessionId）
   - [x] 🔄 **架构演进（2026-07-13）**
     - [x] v3（当前）：四 Agent 架构 — CHITCHAT + CONSULTATION + ANALYTICS + OPERATION
     - [x] 新增 CHITCHAT 闲聊 Agent（纯 ChatClient，无检索、无 Tool），待实现
     - [x] Router 智能体化计划（带 ChatMemory，看历史对话理解上下文），待实现
- [x] ✅ **阶段6：ChatMemory 进阶** ← 已完成
   - [x] 持久化记忆：RedisChatMemory 实现 ChatMemory 接口，存 Redis 替代 JVM 内存
   - [x] MsgRecord 内部结构：role + content，Jackson 友好，解决接口反序列化问题
   - [x] Last N + Summary：窗口 10 条完整保留，超出自动移到 chat:summary 摘要
   - [x] 摘要注入 System Prompt：RagAgentService 和 ChatServiceImpl 自动带入历史摘要
   - [x] TTL 30 分钟自动清理僵尸会话
   - [x] 踩坑：1.1.2 API 变更 — add(List)、get(String)单参、getText()替代getContent()
   - [x] 认知：Redis RDB 快照防重启丢失，生产可开 AOF；永久持久化需 Cassandra/MySQL
- [x] ✅ **阶段7：Text-to-SQL** ← 已完成
   - [x] 新增 ANALYTICS 意图（三 Agent 架构：RAG + Text-to-SQL + Tools）
   - [x] TextToSqlService：生成 SQL → 安全校验 → JdbcTemplate 执行 → LLM 解读
   - [x] 路由：CONSULTATION→RAG（语义）/ ANALYTICS→SQL（计算）/ OPERATION→Tools（写操作）
   - [x] 安全：只允许 SELECT + 危险关键字黑名单 + 自动 LIMIT
   - [x] 踩坑：1.1.2 API — Media 构造用 URI、UserMessage 用 Builder、ChatClient 用 .messages()
   - [x] 认知：Text-to-SQL 是概念不是 @Tool，是独立 Agent，RAG 和 SQL 互补而非替代
- [x] ✅ **阶段8：多模态** ← 已完成
   - [x] ImageAnalysisService：图片 → base64 → UserMessage(Media) → qwen-vl-plus → 商品描述
   - [x] ChatController 新增 /ai/chat/image：图片上传 → 识别 → 丢给 ChatOrchestrator
   - [x] DashScopeChatOptions.withModel("qwen-vl-plus") 指定多模态模型
   - [x] 踩坑：1.1.2 — Media 用 URI 构造、UserMessage.builder().text().media().build()、ChatClient.messages()
   - [x] 认知：多模态模型把图片"翻译"成文字，后续 RAG/Router/Memory 全部复用
- [x] ✅ **阶段9：MCP 协议** ← 概念已学（Spring AI 1.1.2 无完整支持，未写代码）
   - [x] 理解 MCP 三种原语（Tools/Resources/Prompts）+ JSON-RPC 通信
   - [x] 理解 MCP vs @Tool 的区别：跨进程/跨语言 vs 单 JVM
   - [x] 认知：MCP = AI 世界的 USB 协议，@Tool = 单机版
- [x] ✅ **阶段11：AI 评测体系** ← 已完成
   - [x] 真实用户对话随机抽检（`cdc.eval.sample-rate: 0.1`，默认10%）
   - [x] LLM-as-Judge 异步打分（@Async，不阻塞用户）
   - [x] 评测结果存 MySQL（cdc_eval_log 表）
   - [x] 后台管理页面（统计卡片 + 筛选 + 列表 + 详情弹窗）
   - [x] 踩坑：`@EnableAsync` 要加在 ApplicationConfig 上
   - [x] 认知：用真实用户数据评测比预设用例更有价值，随机抽检控制成本
- [x] ✅ **阶段12：生产化** ← 已完成
   - [x] cdc_chat_log 对话日志表（100%记录所有对话：question/answer/intent/agent/latency_ms）
   - [x] Redis 滑动窗口限流（默认 60s/20次），Redis 挂了自动放行
   - [x] 异常分类降级：超时/认证失败/限流/通用，不同错误不同提示
   - [x] ChatOrchestrator 增加 RateLimitService + ChatLogMapper
   - [x] 后台管理：对话日志页面（筛选意图/Agent + 详情弹窗）
   - [x] 两个表分离：cdc_chat_log(100%记录) vs cdc_eval_log(10%抽检打分)
- [x] ✅ **操作智能体完善（购物车 + 下单）** ← 已完成（2026-07-14）
   - [x] 新建 OrderTools.java（6个工具：addToCart / getCart / removeFromCart / updateCartQuantity / createOrder / queryOrder）
   - [x] 新建 ToolResultStore.java（ConcurrentHashMap 跨线程共享，解决流式端点无法返回卡片数据的问题）
   - [x] 统一 SessionId：5个前端页面 `cdc_session_id` → `cdc_chat_session_id`（AI 和购物车用同一个 ID）
   - [x] ChatResult 扩展：加 cartItems / order / orderItems 字段
   - [x] AiConfig 注册 OrderTools 为 defaultTools
   - [x] ChatServiceImpl：ThreadLocal 传递 sessionId，drain 两个 Tool 结果，存 ToolResultStore
   - [x] ChatController：同步端点返回 cart/order 数据，新增 GET /ai/chat/tool-data 端点
   - [x] 前端：流式结束轮询 tool-data，渲染购物车卡片 + 订单成功卡片
   - [x] 加购前库存检查（工具层）+ 下单时行锁防超卖（Service 层）= 双重保险
   - [x] 下单确认流程：LLM 多轮对话 → 查购物车 → 确认 → 收集手机号 → createOrder
   - [x] 设计原则：低风险（加购）AI 直接操作，高风险（下单）LLM 多轮确认
- [x] ✅ **闲聊 Agent 拆分** ← 已完成（2026-07-14）
   - [x] 新增 CHITCHAT 意图：Router 识别闲聊/打招呼/情绪表达/模糊推荐
   - [x] 新建 `chitchat/ChitchatAgentService.java`：纯 ChatClient + ChatMemory，无检索、无 Tool
   - [x] 新建 `chitchat/RankingCacheService.java`：`@Scheduled` 每小时查展示榜 Top 10，缓存为文本
   - [x] 新建 `prompts/chitchat.st`：闲聊 Agent 专属 Prompt 模板
   - [x] ChatOrchestrator 新增 CHITCHAT 分支（同步 + 流式）
   - [x] 四 Agent 架构：CHITCHAT（主动带货）+ CONSULTATION（FAQ规则）+ ANALYTICS（统计）+ OPERATION（商品操作）
   - [x] 核心原则：每个 Agent 只干一件事，不兼职
   - [x] RAG Agent 去掉闲聊兜底，纯 FAQ + 规则制度检索
   - [x] 排行榜通过 Prompt 注入而非 Tool Calling（更自然，减少 LLM 决策）
   - [x] 四个 Agent 共享同一个 RedisChatMemory + sessionId（记忆不分裂）
   - [x] @EnableScheduling 定时任务（ApplicationConfig 加注解）
   - [x] 两 Resource Bean 用 @Qualifier 区分（guidePrompt / chitchatPrompt）
- [ ] ⬜ **Router 智能体化** ← 待实现
   - [ ] Router 本身做成一个 Agent（带 ChatMemory + System Prompt）
   - [ ] 意图分类同时输出：意图 + 改写查询词（ragQuery / sqlKeyword）+ 简要理由
   - [ ] 好处：Router 能看历史对话，理解上下文后分类更准（如"它呢"需要结合上文才知道指什么）

---

### 阶段1 详细教学记录（2026-07-11 ~ 2026-07-12）

**已完成的教学内容：**

1. **Tool Calling 原理**：完整链路——用户消息 + 工具列表 → LLM 决策（返回 toolName + args）→ Spring AI 反射执行方法 → 结果回传 LLM → LLM 组织语言回复。

2. **Spring 基础概念**：IoC、DI、Bean、@Component vs @Service、接口 vs 实现类

3. **Tool Calling 底层协议**：Spring AI 扫描 @Tool 注解 → 生成 JSON Schema（OpenAI Function Calling 格式）→ 拼到 HTTP 请求的 tools 字段 → DashScope 返回 tool_calls JSON → Spring AI 反射执行方法。两轮 LLM 调用导致 ~2秒延迟。

4. **前端工具结果卡片渲染**：
   - 新建 `ChatResult.java`（包裹 answer + toolCalled + products + categories）
   - `ProductTools` 加 `ThreadLocal<ToolResult>` 暂存工具结果
   - `ChatServiceImpl` 取 ThreadLocal 组装 ChatResult
   - 前端 `index.vue` 渲染商品卡片（可点击跳详情）+ 分类标签（可切换分类）
   - **核心认知**：不让 LLM 生成 JSON，而是 ThreadLocal 绕过 LLM 直接给前端原始数据

5. **前端 3:1 布局**：所有 C 端页面（商品浏览/详情/购物车/订单确认/订单查询）统一左3右1布局，AI 对话框始终在右边。

6. **跨页面对话持久化**：所有页面通过 `localStorage` 共享 `cdc_chat_session_id` 和 `cdc_chat_messages`，页面切换不丢对话。AI 图标改为固定标题栏（`.chat-title`），快捷问题始终在输入框上方。

7. **模型锁定**：百炼全态大模型额度用完 → `application.yml` 配 `spring.ai.dashscope.chat.options.model: qwen-turbo` 锁定大语言模型。

8. **工具错误处理**：5个工具方法加 try-catch，异常时返回空集合/空对象（静默降级），LLM 自然地说"查不到"而非输出异常堆栈。

9. **代码最终状态**：
   - `cdc-aics-ai/.../tool/ProductTools.java` — 5个工具 + ThreadLocal + try-catch
   - `cdc-aics-ai/.../config/AiConfig.java` — .defaultTools(productTools) 注册
   - `cdc-aics-ai/.../chat/ChatServiceImpl.java` — mutate() 加 system prompt + 取 ThreadLocal 组装 ChatResult
   - `cdc-aics-ai/.../chat/ChatResult.java` — 响应 DTO（answer + toolCalled + products + categories）
   - `cdc-aics-ai/.../chat/ChatController.java` — 适配新返回结构
   - 前端 `portal/index.vue` — 组合页面（商品网格 + AI对话 + 卡片渲染）
   - 前端 `portal/product/detail.vue` — 详情 + AI对话 + watch 路由参数刷新
   - 前端 `portal/cart/index.vue`、`order/confirm.vue`、`order/query.vue` — 统一布局

10. **踩坑记录**：
    - `Product.setProductName()` 不是 `setName()`
    - `mutate()` 继承父 ChatClient 的工具，重复注册报 Multiple tools
    - `@Log` 在 `@Anonymous` 接口上 SecurityUtils.getLoginUser() 报错
    - `@Anonymous` → PermitAllUrlProperties 自动扫描加入白名单
    - `.iml` sourceFolder 错指向 `.../com/ruoyi/ai` → 同包类爆红 → 改为 `.../src/main/java`
    - `router.push` 同一组件不刷新 → productId 改 let + watch route.params.id
    - 页面切换对话丢失 → localStorage 持久化 messages
    - 全态大模型额度用完 → 配 model: qwen-turbo 锁定大语言模型

---

### 阶段2 教学记录（2026-07-12）：流式输出 SSE

**原理**：
- 同步：`chatClient.call().content()` → 一次性 String → 用户干等 2~10s
- 流式：`chatClient.stream().content()` → `Flux<String>` → 逐 token 返回 → 打字机效果
- SSE 协议：`text/event-stream`，服务端持续推送，前端 `ReadableStream` 逐块消费

**代码**：
- `IChatService` 新增 `Flux<String> chatStream(sessionId, message)`
- `ChatServiceImpl` 实现：`.stream().content()` + `.doOnNext(log)` + `.doOnComplete(计时)`
- `ChatController` 新增 `/ai/chat/stream`，用 `ResponseBodyEmitter` + `subscribe` 异步推送
- 前端：`fetch` + `response.body.getReader()` + `setInterval` 30ms 逐字打字机动画

**踩坑（重要）**：
1. `/ai/chat/stream` 返回 404 → Vite 代理只转发 `/dev-api` 前缀 → fetch URL 要写 `/dev-api/ai/chat/stream`
2. Spring MVC 不支持直接返回 `Flux<String>` → 尝试 `SseEmitter`、`StreamingResponseBody`、`HttpServletResponse`
3. `Flux<String>` + `produces = text/event-stream` → Spring MVC 可能不映射端点 → 去掉 produces
4. `HttpServletResponse` + `writer.flush()` + `blockLast()` → blockLast 阻塞 Servlet 线程 → 响应不提交 → 前端收不到数据 → 换 `ResponseBodyEmitter` + `subscribe` 异步
5. 后端 log 确认 token 逐条发出，但前端等全部完成才显示 → 浏览器对非 SSE 格式缓冲 → 需要 `text/event-stream` content-type

**核心认知**：Spring MVC（Servlet 栈）对响应式返回支持有限，`ResponseBodyEmitter` 是最兼容的方案。关键是不能在 Controller 方法里 `blockLast()` 阻塞线程。

---

### 🔧 Bug 修复记录（2026-07-19）：流式输出前端"全部一起出"

**问题现象**：后端 token 逐个发（log 可证），前端 `reader.read()` 也逐 chunk 收到（20 chunks / 900ms），但页面显示是全部一起出，没有打字机效果。

**排查过程**：

1. **加诊断日志双向对比**：后端 `emitter.send()` 加 Sysout + 时间戳，前端 `reader.read()` 加 `console.log` + `performance.now()`。确认后端流式正常，前端也收到多个 chunk。

2. **初步怀疑 `content-type=null`**：`ResponseBodyEmitter` 未设 Content-Type，可能导致代理/浏览器缓冲。加上 `produces = "text/event-stream;charset=UTF-8"` 并 `emitter.send("")` 首帧推送。

3. **发现 `setInterval` 只触发 1 次**：流式 20 chunks 跨 900ms，理论上 30ms 间隔的 setInterval 应触发 ~30 次，但只触发了 1 次。

4. **根因一：微任务饿死宏任务（JS 事件循环）**：
   - `reader.read()` 返回的 Promise 在**微任务**中 resolve
   - `while(true)` 循环持续消费微任务，微任务队列必须清空才轮到宏任务
   - `setInterval` 是**宏任务**，被微任务无限循环饿死
   - 修法：每读到 chunk 后 `await new Promise(r => setTimeout(r, 5))` 主动让出控制权

5. **根因二：Vue 3 响应式 Proxy 陷阱（真正元凶）**：
   - `messages.value.push(aiMsg)` 时，Vue 调用 `reactive(aiMsg)` 把对象包了一层 **Proxy** 存入数组
   - 但 `aiMsg` 变量仍指向**原始裸对象**（Proxy 的 target）
   - `aiMsg.content += 'x'` 直接改裸对象属性 → **Proxy 的 `set` 陷阱不触发** → Vue 不知道数据变了
   - 只有最后 `chatLoading.value = false` 触发唯一一次重渲染 → 全部文字一次性出来
   - 修法：`messages.value[aiIdx].content += 'x'`（通过 Proxy 操作，触发响应式）

**涉及知识点**：

| 知识点 | 说明 |
|--------|------|
| **JS 事件循环（Event Loop）** | 微任务（Promise.then/await）vs 宏任务（setInterval/setTimeout/I/O）。每轮：1 个宏任务 → 清空所有微任务 → 渲染。微任务无限循环会饿死宏任务 |
| **Vue 3 响应式原理** | `reactive()` 返回 `new Proxy(target, handlers)`，不是原对象。`push` 时 Vue 自动 wrap，但原变量引用仍指向裸对象。必须通过 Proxy 路径操作才能触发 `set` 陷阱 |
| **ReadableStream API** | `fetch().body.getReader()` + `TextDecoder.decode(value, {stream:true})`。`{stream:true}` 保留不完整的多字节 UTF-8 序列 |
| **SSE 协议** | `text/event-stream` Content-Type 告诉浏览器/代理"这是流，不要缓冲"。`ResponseBodyEmitter` 不设 produces 时默认无 Content-Type |
| **诊断方法论** | 双向打点（后端 emit + 前端 reader.read 时间戳），对比各环节延迟定位瓶颈 |

**代码改动**：

| 文件 | 改动 |
|------|------|
| `ChatController.java` | `produces = "text/event-stream;charset=UTF-8"`，首帧 `emitter.send("")` |
| `portal/index.vue` | 删 `setInterval` + `raw` 缓冲，改为 while 循环内逐字追加。**关键**：`messages.value[aiIdx].content += char` 非 `aiMsg.content += char` |

---

### 阶段3 教学记录（2026-07-12）：Prompt 工程化

**原理**：System Prompt 从"代码里的硬编码字符串"升级为"独立的 .st 模板文件 + 变量注入"。

**代码**：
- 新建 `cdc-aics-ai/src/main/resources/prompts/guide.st` — StringTemplate 格式模板，变量用 `{key}` 占位
- `AiConfig` 加 `guidePromptResource()` Bean — `new ClassPathResource("prompts/guide.st")`
- `ChatServiceImpl` 注入 `Resource guidePrompt`，构造器中读取模板 + 替换变量渲染 systemPrompt

**模板内容**：
```
你是{role}「{name}」。你的职责：{duty}
{extraRules}
回答要求：- {style} - 回答控制在{maxWords}字以内
```

**踩坑**：
- `PromptTemplate.builder().templateResource()` 不存在 → 当前 Spring AI 版本 API 不兼容 → 改用 `Resource.getContentAsString()` + `String.replace()`
- `getContentAsString()` 抛 `IOException` → try-catch 兜底硬编码

**好处**：改 Prompt 只需编辑 `.st` 文件，重启生效，不再碰 Java 代码。

---

### 阶段4 教学记录（2026-07-12）：RAG 检索增强生成

**原理**：Tool Calling 只能 SQL LIKE 精确匹配（搜"零食"命中"零食"），RAG 做语义匹配（搜"送礼用的"命中"礼盒"）。

**核心流程**：
```
入库：商品文本 → Embedding API → float[] 向量 → VectorStore
检索：用户问题 → Embedding API → float[] 向量 → VectorStore.similaritySearch() → Top 5 结果
```

**代码**：
- 新建 `KnowledgeBaseInitializer.java`：@PostConstruct 启动时读取 MySQL 商品 → Document → Embedding → VectorStore
- 新建 `RagAgentService.java`：手动检索 VectorStore → 拼上下文 → System Prompt → LLM 回答
- `AiConfig` 创建 `SimpleVectorStore` Bean（1.1.2 API: `SimpleVectorStore.builder(embeddingModel).build()`）
- 删除了 `RagTools.java`（不再作为 @Tool，RAG 改为独立 Agent）
- 流式同步均支持：`.call().content()` / `.stream().content()`

**两阶段检索（ANN + KNN）**：
- 用户消息 → Embedding API → float[1536] 查询向量
- ANN 粗筛（IVF）：1000 条 → 10 条候选（快速定位大致范围）
- KNN 精排（FLAT）：10 条候选逐一算余弦相似度 → Top 5
- SimpleVectorStore 直接暴力 KNN（数据少无需 ANN），Milvus 才走 IVF_FLAT

**核心认知**：
- `vectorStore.add(docs)` 内部自动调 Embedding API，不需要手写向量化代码
- Chat 模型（deepseek-v4-flash）和 Embedding 模型（text-embedding-v1 自动默认）完全独立
- 每件商品一个 Document（一个向量），不是所有商品一个向量
- SimpleVectorStore：JVM 内存 Map，重启就丢，每次启动重新调 Embedding API
- Milvus 持久化到磁盘，支持增量增删改，生产环境用。Docker 已装，镜像拉取网络问题未解决

**踩坑**：
- Spring AI 1.1.2 无 `QuestionAnswerAdvisor`，改用手动检索（search → 拼 Prompt → LLM）
- `SimpleVectorStore.builder()` 1.1.2 必须传 `EmbeddingModel` 参数
- spring-ai-milvus-store 依赖缺版本号 + cdc-aics-business 重复声明 → 已修复

---

### 阶段10 教学记录（2026-07-12 ~ 2026-07-13）：多智能体协同

**架构演进**：
```
v1（07-12）: 双 Agent — RAG + Tools
v2（07-13）: 三 Agent — RAG + Text-to-SQL + Tools
v3（07-14）: 四 Agent — 闲聊 + RAG + Text-to-SQL + Tools（✅ 已完成）
```

**设计原则**：
- 每个 Agent 只干一件事，不兼职
- 闲聊 Agent 无检索无 Tool，纯 ChatClient + 排行榜 Prompt 带货
- RAG Agent 专注 FAQ + 规则制度向量检索，检索为空直接告知无法回答
- 闲聊和 RAG 边界清晰：推荐带货 → 闲聊，FAQ/规则 → RAG
- 四个 Agent 共享同一个 ChatMemory + sessionId（对话记忆不分裂）

```
ChatController → ChatOrchestrator → RouterService.classify()
                                       ├── CHITCHAT      → ChitchatAgentService（闲聊带货 + 排行榜，✅）
                                       ├── CONSULTATION  → RagAgentService（FAQ + 规则制度检索）
                                       ├── ANALYTICS     → TextToSqlService（SQL生成 + 执行 + 解读）
                                       └── OPERATION     → ChatServiceImpl（Tool Calling: 商品+购物车+下单）
四个 Agent 共享 ChatMemory + sessionId（对话记忆不分裂）
```

**文件清单**：
| 文件 | 说明 |
|------|------|
| `Intent.java` | 意图枚举（CHITCHAT / CONSULTATION / ANALYTICS / OPERATION）|
| `RouterService.java` | LLM 意图分类（不带工具、不带 Advisor）|
| `chitchat/ChitchatAgentService.java` | 闲聊 Agent（⭐⭐ 纯 ChatClient + 排行榜 Prompt 注入）|
| `chitchat/RankingCacheService.java` | 排行榜缓存（@Scheduled 每小时刷新）|
| `agent/RagAgentService.java` | RAG Agent（纯 FAQ+规则检索，不含闲聊兜底）|
| `chat/ChatOrchestrator.java` | 调度器（四 Agent 统一路由）|
| `chat/ChatServiceImpl.java` | Tools Agent（不变）|
| `sql/TextToSqlService.java` | Text-to-SQL Agent（不变）|
| `prompts/chitchat.st` | 闲聊 Agent Prompt 模板 |
| `config/AiConfig.java` | ChatClient + ChatMemory + 两个 Prompt 资源 Bean |
- ANALYTICS：聚合统计（走 Text-to-SQL）
- OPERATION：商品查询 + 写操作（下单/加购/修改订单）→ SQL Tool

**记忆共享**：
- 两个 Agent 用同一个 `ChatMemory` Bean + 同一个 `sessionId`
- `PromptChatMemoryAdvisor` 在构造方法中通过 `defaultAdvisors` 挂载
- 每次调用 `.advisors(a -> a.param("chatMemoryConversationId", sessionId))` 指定会话

**Router 关键认知**：Router 不是 Agent——只做分类，不调工具，不回复用户，相当于"门禁"。

**检索 vs 历史**：RAG 检索只用当前 userMessage（不用历史），历史对话由 PromptChatMemoryAdvisor 自动注入 LLM，各司其职。

---

### 阶段6 教学记录（2026-07-12）：ChatMemory 进阶

**持久化记忆（RedisChatMemory）**：
- Spring AI 1.1.2 无内置 Redis 实现 → 手写 `RedisChatMemory implements ChatMemory`
- Redis Key：`chat:memory:{sessionId}` → JSON 数组，`chat:summary:{sessionId}` → 纯文本
- TTL 30 分钟自动清理僵尸会话
- 内部用 `MsgRecord`（role + content）做序列化，解决 `Message` 接口 Jackson 反序列化问题
- `AiConfig` 改：`new RedisChatMemory(redisTemplate, 10)` 替代 `MessageWindowChatMemory.builder()`
- 两个 Agent 通过同一个 `ChatMemory` Bean 自动切换，业务代码零改动

**Last N + Summary 模式**：
- 窗口保持 10 条完整消息，超出移到 summary（纯文本拼接，截断 2000 字符防膨胀）
- `getSummary(sessionId)` 返回溢出摘要
- `RagAgentService.buildSystemPrompt()`：摘要 + 检索结果合并为 System Prompt
- `ChatServiceImpl`：摘要拼接在 user message 前注入
- 用户重启应用 → Redis 数据还在 → LLM 依然记得用户偏好

**踩坑（1.1.2 API 变更）**：
- `ChatMemory` 接口：`add(String, List<Message>)` → 抽象方法；`add(String, Message)` → default
- `get(String)` 单参数（无 lastN），返回全部消息；窗口截断在 add 时做
- `Message.getText()` 替代 `Message.getContent()`（来自 `Content` 接口）
- `UserMessage`/`AssistantMessage`/`SystemMessage` 构造方法接受 String，`MessageType` 枚举区分

**认知**：
- Redis RDB 快照防重启丢失，生产环境开 AOF `appendfsync everysec`
- 真正永久持久化需换 Cassandra/MySQL ChatMemory 实现
- PromptChatMemoryAdvisor 自动读 ChatMemory 注入 LLM，和自定义 summary 互补不冲突

---

### 阶段7 教学记录（2026-07-13）：Text-to-SQL 自然语言查库

**原理**：用户说人话 → LLM 生成 SELECT → JdbcTemplate 执行 → LLM 解读结果为自然语言。让 AI 能回答"本月销量Top5""库存不足的商品"等聚合统计问题。

**架构演进历程**：
```
v1: 双 Agent → CONSULTATION + OPERATION
v2: 三 Agent → CONSULTATION + ANALYTICS + OPERATION
v3: 四 Agent → CHITCHAT + CONSULTATION + ANALYTICS + OPERATION（当前目标）
```

**四 Agent 架构（目标）**：
```
RouterService.classify()
├── CHITCHAT      → 闲聊 Agent      打招呼/心情/无目的闲聊（无检索、无Tool）
├── CONSULTATION  → RAG Agent       语义理解（商品咨询/FAQ/推荐/文档）
├── ANALYTICS     → Text-to-SQL      结构化计算（聚合/统计/分组/多表）
└── OPERATION     → Tools Agent      纯写操作（下单/加购）
```

**核心原则**：每个 Agent 只干一件事，不兼职。边界模糊靠各 Agent 内部 Prompt 兜底，不靠 Router 完美分类。

**关键区分**：RAG 负责"语义理解"（同义词/模糊表达），SQL 负责"计算答案"（COUNT/SUM/GROUP BY），两者互补。

**TextToSqlService 四步流水线**：
1. `generateSql()` — LLM 生成 SELECT（带 Schema + Few-shot 规则）
2. `validate()` — 安全校验（只允许 SELECT + 危险关键字黑名单 + 自动 LIMIT）
3. `execute()` — JdbcTemplate.queryForList()
4. `interpret()` — LLM 解读结果为自然语言

**两个 ChatClient 分离**：
- `sqlGenClient`：无工具、无记忆、无人设——只做 SQL 生成
- `chatClient`：有人设 + 记忆——解读结果，保持多轮对话连贯

**安全设计**：
- 只允许 SELECT 开头
- 危险关键字黑名单（DROP/DELETE/INSERT/UPDATE/ALTER/TRUNCATE/CREATE/EXEC/GRANT/REVOKE）
- 自动加 LIMIT 50 防全表扫描
- 清理 markdown 包裹（```sql ... ```）

**踩坑**：
- 错误将 chatStream 逻辑粘到 newSessionId 方法内 → 重复定义 → 删掉只保留一个
- JdbcTemplate 在 Spring Boot + MyBatis 下自动配置，无需额外依赖

**认知**：
- Text-to-SQL 是技术概念，不是 @Tool 注解。用 ChatClient + JdbcTemplate 实现
- 和 ProductTools (@Tool) 的关系：Tools 走固定 SQL 模板（安全精确），Text-to-SQL 走动态生成（灵活）
- LLM 生成的 SQL 直接执行有风险，必须加安全校验

---

### 阶段8 教学记录（2026-07-13）：多模态图片分析

**原理**：多模态模型（qwen-vl-plus）能同时看图片和读文字。图片 → base64 → 和文字一起发给模型 → 模型返回商品描述 → 后续流程（RAG/Router/Memory）完全不变。

**核心认知**：多模态模型把图片"翻译"成文字，拿到文字后整个系统逻辑不用改。

**代码**：
- 新建 `ImageAnalysisService.java`：图片 → base64 → Media → UserMessage → qwen-vl-plus → 商品描述
- 修改 `ChatController.java`：新增 `/ai/chat/image` 端点

**DashScopeChatOptions 指定模型**：
```java
DashScopeChatOptions options = DashScopeChatOptions.builder()
    .withModel("qwen-vl-plus")
    .build();
```

**Spring AI 1.1.2 API 适配（重要）**：
- `Media` 构造：`new Media(MimeType, URI.create(dataUrl))` — 用 URI 而非 String
- `UserMessage` 构造：`UserMessage.builder().text().media(List.of()).build()` — 用 Builder 模式
- `ChatClient` 调用：`.messages(userMsg)` — 用 .messages() 而非 .user()

**为什么不用 DashboardChatOptions 每个请求指定？**
- 默认模型 `deepseek-v4-flash` 是纯文本，看不懂图片
- 必须 override 为 `qwen-vl-plus`（多模态版本）
- `.options(options)` 只影响当前请求，不影响全局配置

**数据流**：
```
用户拍照 → /ai/chat/image → analyze() → qwen-vl-plus 识别 → 商品描述文字
  → ChatOrchestrator.chat(描述) → Router → RAG → 匹配商品
  → 前端展示（文本回复 + 商品卡片 + 图片描述）
```

**踩坑**：
- 1.1.2 API 版本差异：Media 用 URI 而非 String、UserMessage 用 Builder、ChatClient 用 .messages()
- ⚠️ **Spring AI Alibaba 1.1.2 多模态适配有 bug**：Media/UserMessage 转 DashScope 格式时 URL 无效 → 阿里云一直报 `url error`
- **最终方案**：绕开 Spring AI，用 `RestClient` 直接调 DashScope HTTP API（OpenAI 兼容格式），`content` 数组里 `{type:"text"}` + `{type:"image_url", image_url:{url:"data:..."}}`
- `qwen-vl-plus` 模型名称可能随百炼平台更新变化，需确认
- 图片按像素计 token，大图烧钱，建议前端压缩
- **核心认知**：框架有 bug 就绕过——直接调 HTTP API 永远是最可靠的后手

**前端图片上传（2026-07-13 补充）**：
- `portal/index.vue` AI 对话框输入区左侧加相机按钮（Picture 图标）
- 选中图片后显示缩略图预览 + 可 ✕ 取消
- 有图片时走 `/ai/chat/image`（FormData 上传），无图片走原流式 `/ai/chat/stream`
- 用户消息中显示图片缩略图（imageUrl 字段）
- 新增方法：pickImage、handleImageUpload、clearPendingImage、uploadImageAndChat
- 发送按钮 disabled 条件改为 `(!text && !pendingImage) || chatLoading`

---

### 阶段9 教学记录（2026-07-13）：MCP 协议概念

**未实现代码，纯学概念。原因：Spring AI Alibaba 1.1.2 没有完整 MCP 支持，1.2.x 以后才稳定。**

**MCP 是什么**：Model Context Protocol — AI 工具调用的"USB 协议"，约定好插头和插座的形状，任何厂家的设备都能插。

**没有 MCP 之前**：每个第三方服务 → 手写 Java 代码 → @Tool 注解 → Spring AI → LLM。对接 10 个服务要写 10 段不同代码。

**有了 MCP 之后**：服务商提供 MCP Server（标准化 HTTP/stdio 服务）→ AI 客户端自动发现所有工具 → 统一调用。不需写任何对接代码。

**MCP 三种原语**：
| 原语 | 作用 | 类比 |
|------|------|------|
| Tools | 可调用的方法 | 遥控器按钮 |
| Resources | 可读取的数据 | 说明书 |
| Prompts | 预设提示词模板 | 快捷指令 |

**底层协议**：JSON-RPC。`{"jsonrpc":"2.0","method":"tools/call","params":{...}}`

**MCP vs @Tool**：
| | @Tool | MCP |
|------|------|------|
| 工具位置 | Java 代码里 | 独立进程/服务 |
| 谁提供 | 自己写 | 第三方可提供 |
| 语言 | 只能 Java | 任何语言 |
| 部署 | 和项目一起 | 独立部署扩缩容 |

**核心价值**：MCP 把"工具提供者"和"AI 调用者"解耦，就像 USB 把设备制造商和电脑厂商解耦。

**MCP 协议本身免费**（只是通信规范），收费的是 MCP Server 里调用的那个 API（如天气 API）。

---

### 阶段11 教学记录（2026-07-13）：AI 评测体系

**方案进化**：
1. 最初设计：预设6条测试用例，手动 POST `/ai/eval/run` 一键跑分
2. 用户质疑：为什么不随机触发用户真实提问？
3. 最终方案：**真实用户对话随机抽检** — 10% 的对话自动触发 LLM-Judge 异步评分 → 存 MySQL

**架构**：
```
用户消息 → ChatOrchestrator.chat() → AI回答 → 返回给用户
                                   │
                              Math.random() < 0.1 ?
                                   │ Yes
                                   ▼
                        EvalJudgeService.evaluateAsync() [@Async]
                                   │
                         LLM-Judge 打分 (1-10)
                                   │
                         cdc_eval_log INSERT
```

**文件清单**：
| 操作 | 文件 | 说明 |
|------|------|------|
| 执行SQL | `cdc_eval_log` 表 | 评测日志表（question/answer/intent/score/judge_reason/latency_ms） |
| 新建 | `eval/domain/EvalLog.java` | 实体类 |
| 新建 | `eval/mapper/EvalLogMapper.java` | Mapper 接口 |
| 新建 | `resources/mapper/eval/EvalLogMapper.xml` | SQL 映射 |
| 新建 | `eval/EvalJudgeService.java` | 异步 Judge + 落库（@Async + @Value sample-rate） |
| 新建 | `eval/EvalController.java` | 后台管理接口（list/detail/delete/stats） |
| 修改 | `chat/ChatOrchestrator.java` | 注入 EvalJudgeService + 回答后抽检 |
| 修改 | `framework/config/ApplicationConfig.java` | 加 @EnableAsync |
| 修改 | `ruoyi-admin/.../application.yml` | 加 `cdc.eval.sample-rate: 0.1` |
| 新建 | `ruoyi-ui/.../ai/eval/index.vue` | 后台评测管理页面（统计卡片+筛选+表格+详情弹窗） |
| 新建 | `ruoyi-ui/.../api/ai/eval.js` | 前端 API 函数 |

**LLM-Judge 评分维度**：
- 相关性(0-4分)：是否切题，有无答非所问
- 准确性(0-3分)：信息是否可信，不能编造
- 完整性(0-3分)：是否完整回答了用户问题

**随机抽检设计**：
```java
@Value("${cdc.eval.sample-rate:0.1}")
private double sampleRate;

public boolean shouldEvaluate() {
    return Math.random() < sampleRate;
}
```
- 默认 10%，可在 application.yml 调整
- @Async 异步执行，不阻塞用户
- 异常全部 try-catch，不影响主流程

**踩坑**：
- `@EnableAsync` 容易忘记——不加的话 @Async 方法会同步执行，阻塞用户
- 配置冲突：`ai.eval.sample-rate` 会和 `spring.ai.**` 冲突 → 改为 `cdc.eval.sample-rate`
- EvalController 路由因 `/ai` 已有 ChatController，需确保端点不冲突（/ai/eval vs /ai/chat）

**认知**：
- 真实用户数据比预设用例更能发现实际问题
- LLM-as-Judge 虽然不完美（自己评自己），但和人工评分相关性 80%+
- 随机抽检是成本和覆盖度的平衡——10% 足够看出趋势，又不过度消耗 token
- EvalController 流式评测：用 `StringBuilder` + `Flux.doOnNext` + `.doFinally` 收集完整回答后再异步 Judge
- eval 包从 cdc-aics-ai 迁移到 cdc-aics-business（Domain+Mapper+Controller 属于业务层）
- 后台刷新 404：ErrorController 在 Spring Boot 3.5.x 不生效 → 改 ResourcesConfig.addViewControllers 正则匹配
- **RAG 空结果不应调 LLM**（2026-07-13 已修正）：最初担心 LLM 不遵循 Prompt 会瞎编 → 改为检索空时不硬编码拒绝，交 LLM 自行判断（闲聊时正常回应，真的需要信息时说找不到）。System Prompt 加引导"用户大概率在闲聊，不要推荐商品"
- **事实校验缺失**：LLM-Judge 只能评文本质量，评不了事实真假——后续需加数据库校验层

---

### Milvus 向量数据库迁移（2026-07-13）

**SimpleVectorStore → MilvusVectorStore**

**环境安装**：
- Docker Compose 部署 Milvus Standalone（etcd + minio + milvus 三容器）
- 官方 docker-compose.yml → D:\milvus\ → `docker compose up -d`
- 踩坑：官方默认 `v3.0-beta` 与 Spring AI 1.1.2 + SDK 2.5.8 不兼容 → 降回 `v2.4.0`
- 镜像拉取：quay.io 国内慢 → 换成 `quay.io/coreos/etcd:v3.5.5` 成功
- Attu 可视化工具：`docker run -d --name attu -p 8000:3000 -e MILVUS_URL=host.docker.internal:19530 zilliz/attu:latest`
- MinIO 管理后台：`http://localhost:9001`（Milvus 的文件存储层，不用管）

**代码变更**：
| 文件 | 改动 |
|------|------|
| `cdc-aics-ai/pom.xml` | 加 `spring-ai-milvus-store:1.1.2` + `spring-boot-starter-aop` |
| `AiConfig.java` | `SimpleVectorStore` → `MilvusVectorStore` + 新增 `MilvusServiceClient` Bean |
| `KnowledgeBaseInitializer.java` | 完全重写：用 SDK 手动删旧→建 collection→加数据→建索引→load |

**Milvus 完整写入链路（踩坑总结）**：
```
1. dropCollection      → 删旧
2. createCollection    → 建新（id + metadata(JSON) + content(VarChar) + embedding(FloatVector,1024维)）
3. vectorStore.add()   → 分批写入（Embedding API 限 10 条/次）
4. createIndex         → 建 IVF_FLAT + COSINE 索引 ← 容易漏！
5. loadCollection      → 加载到内存才能查询 ← 容易漏！
```
缺第 4/5 步 Attu 显示 0 条数据、搜索返回空。

**维度踩坑**：
- 代码写了 1536，实际 Embedding 模型输出 1024 → `ParamException: dimension 1024 != 1536`
- 改 collection schema 需要先删旧 collection（Milvus 不支持修改维度）
- `DataType.VarChar` 存 metadata 报错 `Type mismatch` → 改成 `DataType.JSON`

**initializeSchema 踩坑**：
- Spring AI 1.1.2 `initializeSchema(true)` 在 v3.0-beta 下静默失败
- 在 v2.4.0 下创建 collection 但不建索引
- 最终方案：`initializeSchema(false)` + SDK 手动管理全流程

---

### 商品增量向量同步（2026-07-13）

**自定义注解 + AOP 方案**：

```
ProductServiceImpl
  @ProductSync(INSERT) → AOP → vectorStore.add() + load
  @ProductSync(UPDATE) → AOP → vectorStore.add() + load（1.1.2 不支持 update，追加新版本）
  @ProductSync(DELETE) → AOP → vectorStore.add(status=offline) + load

updateStock → AopContext.currentProxy().updateProduct() → 触发 AOP（self-call 必须走代理）
```

**文件清单**：
| 操作 | 文件 | 说明 |
|------|------|------|
| 新建 | `annotation/ProductSync.java` | 自定义注解（business） |
| 新建 | `agent/ProductSyncAspect.java` | AOP 切面（ai，注入 MilvusServiceClient） |
| 修改 | `ProductServiceImpl.java` | 加 3 个注解 + updateStock 走代理 |
| 修改 | `cdc-aics-ai/pom.xml` | 加 spring-boot-starter-aop |

**踩坑**：
- self-call 不触发 AOP → `((IProductService) AopContext.currentProxy()).updateProduct()`
- DELETE 用 @Around + 删前查 Product，删后标记 offline
- metadata 是 JSON 类型，商品来源存 `productId` + `productName`
- 文档切片时 metadata 可塞任意 key（docName/chunkIndex/version），和商品数据混存不冲突

**其他修复**：
- `ProductMapper.xml` INSERT 补 `scene_id = 1`（表字段 NOT NULL 无默认值）
- `KnowledgeBaseInitializer` 每次启动删旧全量重建（29 件，3 秒完成）

---
