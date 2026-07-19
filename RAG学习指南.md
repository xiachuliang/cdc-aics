# RAG（检索增强生成）完整学习指南

> 基于 CDC 智能导购项目（Spring AI Alibaba + Milvus）实战经验总结
> 从原理到代码，从基础到进阶

---

## 目录

1. [RAG 是什么？解决什么问题？](#一rag-是什么解决什么问题)
2. [RAG 核心 5 步链路](#二rag-核心-5-步链路)
3. [Embedding 向量嵌入 — 数学基础](#三embedding-向量嵌入--数学基础)
4. [文档切分 Text Splitting — 最容易出错的环节](#四文档切分-text-splitting--最容易出错的环节)
5. [向量数据库 VectorStore](#五向量数据库-vectorstore)
6. [检索策略](#六检索策略)
7. [RAG 进阶技术](#七rag-进阶技术)
8. [RAG 评测体系](#八rag-评测体系)
9. [本项目 RAG 实战总结](#九本项目-rag-实战总结)
10. [踩坑记录](#十踩坑记录)
11. [学习资源推荐](#十一学习资源推荐)

---

## 一、RAG 是什么？解决什么问题？

### 1.1 LLM 的三大缺陷

| 问题 | 说明 | 例子 |
|------|------|------|
| **知识时效性** | 训练数据有截止日期，不知道新信息 | "今天有什么促销活动？" |
| **幻觉问题** | LLM 会自信地编造不存在的事实 | "你们的退货政策是7天无理由" (实际是15天) |
| **领域知识缺失** | 通用模型不懂企业内部知识 | "会员积分规则是什么？" |

### 1.2 RAG 怎么解决

```
没有 RAG：用户问 → LLM 直接回答（可能瞎编）
有 RAG：  用户问 → 向量检索 → 找到相关文档 → 拼 Prompt → LLM 基于资料回答（有据可查）
```

**RAG = Retrieval Augmented Generation（检索增强生成）**

核心思想：**LLM 是"开卷考试"，不是"闭卷考试"**。给它参考资料再回答。

### 1.3 本项目中的例子

```
用户问"退货流程是什么？"
  ↓
Milvus 向量检索 → 命中 FAQ "退货政策：15天无理由退货，需携带小票..."
  ↓
拼到 Prompt 里 → "请根据以下资料回答：\n【参考资料】\n退货政策：15天...\n【用户问题】\n退货流程是什么？"
  ↓
LLM → "您好！我们的退货政策是15天无理由退货，需要携带购物小票..."
```

---

## 二、RAG 核心 5 步链路

```
┌─────────────────────────────────────────────────────────────┐
│ 离线入库（Ingestion）                                        │
│ 原始文档 → TextSplitter 切片 → Embedding 向量化 → VectorStore │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 在线检索（Retrieval）                                        │
│ 用户问题 → Embedding 向量化 → VectorStore.similaritySearch()  │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 增强生成（Augmented Generation）                             │
│ System Prompt + 检索结果 + 用户问题 → LLM 生成               │
└─────────────────────────────────────────────────────────────┘
```

### 步骤详解

**第1步：文档入库**
- 源文档（FAQ、Word 文档、网页等）→ 切分成小块（chunk）
- 每个 chunk → Embedding API → 浮点数向量
- 向量 + 原文本 → 存入向量数据库

**第2步：查询向量化**
- 用户问题 → 同一个 Embedding 模型 → 查询向量
- **必须用同一个模型**！不同模型的向量空间不兼容

**第3步：相似检索**
- 查询向量 vs 库里所有向量 → 计算相似度 → Top K 最相关的文档

**第4步：上下文拼装**
- 检索到的文档 + System Prompt + 对话历史 + 用户问题 → 完整 Prompt

**第5步：生成回答**
- 完整 Prompt → LLM → 基于参考资料的答案

### 本项目代码对应

| 步骤 | 代码位置 |
|------|----------|
| 入库（全量） | `KnowledgeBaseInitializer.java` — @PostConstruct 启动时执行 |
| 入库（增量） | `FaqSyncAspect.java` — @FaqSync 注解 + AOP 实时同步 |
| 检索 | `RagAgentService.vectorSearch()` — Milvus similaritySearch |
| 拼装 | `RagAgentService.buildSystemPrompt()` — 摘要 + 检索结果合并 |
| 生成 | `RagAgentService.chat()` / `chatStream()` — ChatClient 调用 |

---

## 三、Embedding 向量嵌入 — 数学基础

### 3.1 什么是 Embedding

把一段文本变成一个固定长度的浮点数数组（向量）。**语义相似的文本，向量也相似**。

```
"我饿了想吃饭"     → [0.12, -0.34, 0.56, ..., -0.09]  (1024维浮点数)
"我肚子饿了想吃饭" → [0.13, -0.32, 0.55, ..., -0.08]  ↑ 和上面很接近!
"今天天气真好"     → [-0.78, 0.45, -0.12, ..., 0.67]  ↓ 和上面差很远!
```

### 3.2 相似度度量

**余弦相似度 (COSINE)** — 最常用
```
similarity = cos(θ) = (A · B) / (|A| × |B|)

值域: [-1, 1]
1 = 方向完全一致
0 = 正交（无关）
-1 = 方向完全相反
```

**为什么用 COSINE 而不是 L2 距离？**
- L2 距离受文本长度影响大（长文本向量模长更大）
- COSINE 只看方向，不看长度，对文本语义更友好

**欧氏距离 (L2)**
```
distance = √(Σ(Ai - Bi)²)

值域: [0, ∞)
0 = 完全一致
越大越不相似
```

### 3.3 Embedding 模型选型

| 模型 | 维度 | 中文效果 | 成本 |
|------|------|----------|------|
| DashScope text-embedding-v1 | 1024 | 好 | 付费 API |
| OpenAI text-embedding-3-small | 1536 | 中 | 付费 API |
| BGE-large-zh (BAAI) | 1024 | 最好 | 免费自部署 |
| BGE-M3 | 1024 | 最好（多语言）| 免费自部署 |

### 3.4 本项目配置

```yaml
# application.yml
spring.ai.dashscope.chat.options.model: deepseek-v4-flash  # Chat 模型
# Embedding 模型默认 text-embedding-v1（DashScope 自动使用）
```

**关键认知**：
- Chat 模型和 Embedding 模型是**两个独立的模型**
- `vectorStore.add(docs)` 内部自动调 Embedding API，**不需要手写向量化代码**
- 踩坑：代码写了 1536 维，实际 Embedding 输出 1024 维 → Milvus 报错

---

## 四、文档切分 Text Splitting — 最容易出错的环节

### 4.1 为什么要切片？

1. **LLM 上下文窗口有限**：即使 128K，全塞进去也贵且慢
2. **检索精度**：大段文档语义混杂，检索不准
3. **Token 成本**：每次只传 Top K 切片

### 4.2 切片策略

#### 策略1：固定长度切分（最简单）

```java
// 按字符数硬切，不考虑语义边界
chunkSize = 300
overlap = 50
```

优点：简单。缺点：可能在句子中间切断。

#### 策略2：结构感知切分（本项目方案）

```
分隔符优先级：\n\n → \n → 。 → ！ → ？ → ； → ， → 英文标点 → 空格
```

先按大边界切（段落），再按小边界切（句子），尽量保持语义完整性。

#### 策略3：语义切分（最先进）

用 Embedding 模型计算相邻句子的相似度，在"语义转折点"切分。

### 4.3 chunkSize 怎么选？

| chunkSize | 优点 | 缺点 |
|-----------|------|------|
| 小 (100-300) | 检索精准 | 信息不完整，丢失上下文 |
| 中 (300-800) | 平衡 | - |
| 大 (800-2000) | 信息完整 | 检索不准，噪音多 |

**经验法则**：
- FAQ 场景：200-400 字（题+答约300字）
- 长文档：500-1000 字
- 代码：按函数/类切分

### 4.4 overlap（滑动窗口重叠）

```
切片1: ...关于退货政策的具体说明，包括退
切片2:     包括退货条件、退款流程和所需材料...
        ↑ overlap = 50 字符保证关键词不断裂
```

没有 overlap → 关键信息可能正好在边界上丢失。
overlap 太大 → 冗余数据多，浪费存储。

**推荐：chunkSize 的 10%-20%**

### 4.5 本项目的 TextSplitter 实现

```java
// cdc-aics-ai/rag/TextSplitter.java
public static List<String> splitByStructure(String text, int chunkSize, int overlap) {
    // 1. 按 \n\n 分成段落
    // 2. 段落过长按 \n 分行
    // 3. 行过长按中文标点（。！？；，）分句
    // 4. 句子过长按英文标点（. ! ? ; ,）分词
    // 5. 仍然过长按空格分词
    // 6. 兜底：硬切 + 滑动窗口
    // 每步都递归检查，保证 chunk 不超过 chunkSize
}
```

---

## 五、向量数据库 VectorStore

### 5.1 为什么不用 MySQL 存向量？

| | MySQL | Milvus |
|------|------|------|
| 向量存储 | 不支持（只能 BLOB） | 原生支持 FloatVector |
| 相似度计算 | SQL 不支持 COSINE | 内置 COSINE/IP/L2 |
| ANN 索引 | 无 | IVF_FLAT / HNSW / IVF_PQ 等 |
| 查询速度 | 全表扫描 O(n) | ANN 近似检索 O(log n) |
| 适用规模 | < 1000 条 | 百万～十亿级 |

### 5.2 Milvus 核心概念

| 概念 | 说明 | 本项目配置 |
|------|------|-----------|
| Collection | 相当于 MySQL 的表 | `cdc_products` |
| Field | 字段（列） | doc_id(VarChar PK) + metadata(JSON) + content(VarChar) + embedding(FloatVector 1024维) |
| Index | 向量索引类型 | IVF_FLAT |
| Metric | 相似度度量 | COSINE |
| Load | 加载到内存 | 必须执行，否则查不到 |

### 5.3 Milvus 完整写入链路（5步，缺一不可！）

```java
// 本项目踩坑总结 — KnowledgeBaseInitializer.java
// ⚠️ 缺任何一步搜索都返回空！

1. dropCollection()      // 删旧 collection
2. createCollection()    // 建新（定义 schema: id + metadata + content + embedding）
3. vectorStore.add()     // 分批写入（Embedding API 限 10 条/次）
4. createIndex()         // 建 IVF_FLAT + COSINE 索引 ← 最容易漏！
5. loadCollection()      // 加载到内存 ← 最容易漏！
```

**为什么 4/5 容易漏？**
- Spring AI 1.1.2 的 `initializeSchema(true)` 在部分版本下不建索引
- 数据写入了但没建索引 → 搜索不走索引
- 建了索引但没 load → 没加载到内存 → 搜索返回空
- 最终方案：`initializeSchema(false)` + SDK 手动管理全流程

### 5.4 索引类型对比

| 索引 | 原理 | 速度 | 内存 | 精度 | 适用 |
|------|------|------|------|------|------|
| **FLAT** | 暴力搜索 | 最慢 | 最低 | 100% | <1万条 |
| **IVF_FLAT** | 聚类 + 暴力 | 快 | 中 | 98%+ | 1万-百万 |
| **IVF_PQ** | 聚类 + 压缩 | 很快 | 低 | 95%+ | 百万-千万 |
| **HNSW** | 图索引 | 最快 | 高 | 99%+ | 百万-亿 |

### 5.5 本项目为什么选 IVF_FLAT + COSINE

- 数据量小（FAQ + 文档切片，几千条）
- IVF_FLAT 足够快，且精度高
- COSINE 对语义搜索更友好
- 如果数据增长到 10 万+，可切换 HNSW

### 5.6 SimpleVectorStore vs Milvus

| | SimpleVectorStore | Milvus |
|------|------|------|
| 存储位置 | JVM 内存 | 磁盘 + 内存 |
| 持久化 | 重启丢失 | 永久保留 |
| 适用场景 | 学习/开发 | 生产环境 |
| 增量操作 | 不支持 | 支持增删改查 |

---

## 六、检索策略

### 6.1 相似度阈值过滤

```java
// RagAgentService.java
List<Document> docs = vectorStore.similaritySearch(
    SearchRequest.query(query)
        .withTopK(5)
        .withSimilarityThreshold(0.7)  // ⭐ 关键：过滤低相关度结果
);
```

| threshold | 效果 | 风险 |
|-----------|------|------|
| 0.5 | 召回多 | 噪音多，LLM 容易被误导 |
| **0.7** | 平衡 | 本项目选择 ✅ |
| 0.9 | 精准 | 召回不足，很多问题搜不到 |

### 6.2 Top-K 选择

- K=3：信息可能不足
- **K=5**：平衡（本项目选择）✅
- K=10：上下文太长，Token 浪费

### 6.3 Query Rewriting（查询改写）

```
用户原始："退货咋整啊"
     ↓ LLM 改写
重写后的查询："退货流程 退款条件"
     ↓ 向量检索
更准确的结果
```

**本项目实现在 RouterService.classify() 中**：
- 一次 LLM 调用同时输出：意图 + RAG 改写查询词
- 去掉口语噪声（"咋整"→"流程"）、扩展同义词（"退货"→"退货 退款"）

### 6.4 混合检索（Hybrid Search）

#### 为什么需要混合检索？

| | 纯向量 | 纯关键词 |
|------|------|------|
| "碳酸饮料" | ✅ 能搜到"可乐" | ❌ 搜不到 |
| "可乐500ml" | ❌ 可能偏到其他饮料 | ✅ 精确命中 |

**两者互补！**

#### RRF（倒数排名融合）算法

```
RRF_score(doc) = Σ 1/(k + rank_i)

k = 60（经验值）
rank_i = 文档在第 i 个检索器中的排名

例：文档在向量检索排第 1，关键词检索排第 3
RRF = 1/(60+1) + 1/(60+3) = 0.0323

最后按 RRF 分数降序排列
```

### 6.5 Multi-Stage（多阶段检索）

```
粗筛阶段（Fast Retriever）：
  向量检索 Top 50 → BM25 Top 50 → RRF 合并 → Top 20

精排阶段（Re-ranker）：
  Top 20 → Cross-Encoder 逐条打分 → 选 Top 5 → 最终送入 LLM
```

---

## 七、RAG 进阶技术

### 7.1 Re-ranking（重排序）

**为什么需要？**
向量检索的 Top 1 不一定是语义最匹配的。Bi-Encoder（Embedding 模型）精度不如 Cross-Encoder。

```
Bi-Encoder（Embedding）：文本A → 向量A，文本B → 向量B，cos(A,B)
  - 速度快（可以预计算所有文档向量）
  - 精度低（文本 A 和 B 在编码时互不可见）

Cross-Encoder（如 bge-reranker）：文本A + 文本B → 一起打分
  - 速度慢（不能预计算，必须逐对打分）
  - 精度高（文本 A 和 B 可以交互）
```

**REALM（Retrieve And Rerank）**：
```
向量检索 Top 20 → Cross-Encoder 逐条打分 → 取 Top 5 → 送给 LLM
```

### 7.2 HyDE（假设文档嵌入）

**场景**：用户问题太短/太模糊，直接向量检索效果差。

```
用户："有什么好吃的？"
  ↓ Step 1: 让 LLM 先写一个假设答案
LLM："好吃的包括各种零食，如薯片、饼干、坚果、肉干等"
  ↓ Step 2: 用答案文本做向量检索
→ 命中相关商品 ✅
```

### 7.3 Parent Document Retriever（父文档检索器）

**矛盾**：切片太大检索不准，切片太小丢上下文。

```
入库时同时存两种 chunk：
  Parent (2000字) — 大块，保留完整上下文
  Child (300字)   — 小块，用于精确检索

检索时：用小块的向量检索 → 返回对应的大块

效果：检索精准 + 上下文完整
```

### 7.4 Self-RAG（自省 RAG）

```
用户问题
  ↓
LLM 判断：需要检索吗？
  ├── 不需要（如"你好"）→ 直接回答
  └── 需要 → 检索 → LLM 评价检索结果质量
                    ├── 相关 → 基于结果回答
                    └── 不相关 → 尝试其他检索（改写查询/补充检索）
```

不是每个问题都需要 RAG！

### 7.5 Corrective RAG (CRAG)

在 Self-RAG 基础上增加纠错能力：
```
检索 → 评价相关度 → 不相关 → LLM 自己搜索/改写 → 再次检索 → 回答
```

### 7.6 GraphRAG（知识图谱增强 RAG）

```
传统 RAG：搜"低脂零食推荐" → 向量搜出几段文档 → LLM 总结

GraphRAG：
  商品 ← 属于 ← 分类
    ↓
  营养成分 → 低脂标签
    ↓
  用户评价 → 好评
    ↓
  LLM 基于子图推理："这个分类下哪些商品符合低脂标准且评价好"

优势：理解实体间关系，适合复杂推荐和多跳推理
```

### 7.7 多向量表示 (ColBERT)

传统：每段文档一个向量。ColBERT：文档中每个 Token 一个向量，查询时做细粒度匹配。

---

## 八、RAG 评测体系

### 8.1 核心指标

| 指标 | 含义 | 计算公式 |
|------|------|----------|
| **Recall@K** | 正确答案在 Top K 中的比例 | 命中数 / 应有正确答案数 |
| **Precision@K** | Top K 中相关文档的比例 | 相关文档数 / K |
| **MRR** | 第一个相关结果排名的倒数均值 | Σ(1/第一个命中的排名) / 查询数 |
| **NDCG** | 考虑排序位置的归一化指标 | 越靠前得分越高 |
| **Faithfulness** | LLM 是否忠于检索结果 | LLM-Judge 评分 |
| **Answer Relevance** | 回答是否切题 | LLM-Judge 评分 |

### 8.2 本项目的评测做法

```
真实用户对话 100% → 10% 随机抽检 → LLM-as-Judge 异步打分 → 存 MySQL

评分维度：
  - 相关性(0-4分)：是否切题
  - 准确性(0-3分)：信息是否可信
  - 完整性(0-3分)：是否回答了用户问题

统计：平均分、意图分布、趋势
```

### 8.3 LLM-as-Judge 的局限性

- 自己评自己 → 评分有偏差
- 评不出事实对错 → 只能评文本质量
- 解决方案：人工抽检校准 + 数据库事实校验

---

## 九、本项目 RAG 实战总结

### 9.1 架构

```
用户消息 → ChatOrchestrator → RouterService.classify()
                                  ↓
                             CONSULTATION
                                  ↓
                          RagAgentService
                            ├── vectorSearch(query) → Milvus
                            ├── buildSystemPrompt(docs) → 拼装
                            └── chat/chatStream → LLM 生成
```

### 9.2 检索范围

- ✅ FAQ（`cdc_knowledge_faq` 表）：question + answer 向量化
- ✅ 文档切片（`cdc_knowledge_doc` 表）：Word 文档 → TextSplitter → 向量化
- ❌ 商品不走向量检索（走 Tools Agent SQL LIKE）

### 9.3 关键设计决策

| 决策 | 理由 |
|------|------|
| FAQ + 文档走 RAG | 非结构化文本，语义匹配 |
| 商品走 Tools Agent | 结构化数据，精确查询 |
| 闲聊独立 Agent | 不让 RAG 管闲聊，职责分离 |
| 检索为空不硬编码拒绝 | 交给 LLM 自行判断 |

### 9.4 数据一致性保证

```
全量：KnowledgeBaseInitializer.@PostConstruct → 启动时全量重建
增量：@FaqSync + AOP → INSERT/UPDATE/DELETE 实时同步
```

---

## 十、踩坑记录

### 坑1：Milvus 维度不匹配
- **现象**：`ParamException: dimension 1024 != 1536`
- **原因**：代码写了 1536 维，实际 text-embedding-v1 输出 1024 维
- **解决**：改为 1024，注意要删 collection 重建（Milvus 不支持修改维度）

### 坑2：搜索返回空
- **现象**：数据写入了但相似度搜索返回 []
- **原因**：缺 createIndex 或 loadCollection
- **解决**：SDK 手动管理全流程，不依赖框架的 auto init

### 坑3：SimpleVectorStore 重启丢数据
- **现象**：每次重启应用都要重新调用 Embedding API
- **原因**：SimpleVectorStore 存 JVM 内存
- **解决**：迁移到 Milvus 持久化

### 坑4：Spring AI 1.1.2 初始化 Schema 不稳定
- **现象**：initializeSchema=true 静默失败
- **解决**：设 false，手动用 SDK 创建 collection

---

## 十一、学习资源推荐

### 论文（必读）

| 论文 | 说明 |
|------|------|
| [Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks](https://arxiv.org/abs/2005.11401) | RAG 原始论文 (Lewis et al., 2020) |
| [Self-RAG: Learning to Retrieve, Generate, and Critique](https://arxiv.org/abs/2310.11511) | 自省 RAG |
| [GraphRAG: Unlocking the Power of Knowledge Graphs](https://arxiv.org/abs/2501.00309) | 微软知识图谱 RAG |

### 工具和框架

| 工具 | 说明 |
|------|------|
| [Milvus 官方文档](https://milvus.io/docs) | 向量数据库权威 |
| [LangChain RAG](https://python.langchain.com/docs/tutorials/rag/) | Python RAG 教程 |
| [BGE 模型系列](https://huggingface.co/BAAI) | 中文最强 Embedding |
| [LlamaIndex](https://docs.llamaindex.ai) | 数据框架（RAG 专用） |
| [RAGAS](https://docs.ragas.io) | RAG 评测框架 |

### 博客和视频

- [Anthropic RAG 最佳实践](https://www.anthropic.com/news/retrieval-augmented-generation)
- [为什么 RAG 不会死](https://www.pinecone.io/learn/)
- [Milvus 中文社区](https://milvus.io/zh)

---

> 最后更新：2026-07-19
> 基于项目：CDC 智能导购 (cdc-aics-server)
> 技术栈：Spring AI Alibaba 1.1.2 + Milvus 2.4.0 + DashScope + Redis + MySQL
