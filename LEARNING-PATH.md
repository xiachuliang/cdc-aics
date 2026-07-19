# AI 应用开发进阶学习路线

> 基于 Java AI 应用开发面试要求，对照当前项目技能缺口制定。
> 当前日期：2026-07-14
> 参考节奏：12 个阶段 3 天 → 每天约 4 个阶段

---

## 学习时长总览（按你的速度）

| 优先级 | 内容 | 时间 | 类型 |
|--------|------|------|------|
| P0 | Python 基础 | 1-2 天 | 语法 + 脚本 |
| P0 | LangChain4j | 1-2 天 | 框架重写 |
| P1 | 大模型底层原理 | 2-3 天 | 纯理论 |
| P1 | RAGAS + Re-ranking | 1 天 | 接入框架 |
| P2 | MCP 实战 | 1 天 | 写代码 |
| P2 | Docker + docker-compose | 1 天 | 实操 |
| P3 | GraphRAG | 2-3 天 | 新概念 + 写代码 |
| P3 | Fine-tuning 入门 | 1-2 天 | 平台操作 |
| P2 | 消息队列 + CI/CD | 1-2 天 | 实操 |

**总计约 10-16 天**，按你的节奏约 2 周。

---

## P0：Python 基础（1-2 天）

Java 程序员学 Python 的捷径：语法对照着写。

### 只学这些
- 变量、函数、类、装饰器（和 Java 注解类比）
- pip + 虚拟环境
- requests 调 HTTP API
- FastAPI 写一个简单接口
- pandas 读 CSV / 处理数据

### 实战
- 用 Python 调 DashScope Embedding API 批量向量化商品
- 写一个 FastAPI 接口：接收商品名 → 返回 Embedding 向量

**跳过**：多线程、异步、Django、爬虫

---

## P0：LangChain4j（1-2 天）

### 学什么
- AiServices（和 Spring AI ChatClient 对比）
- ToolSpecification（和 @Tool 对比）
- ChatMemory（和 RedisChatMemory 对比）
- OnnxRuntime 本地模型（LangChain4j 独有）

### 实战
- 用 LangChain4j 重写 Tools Agent（ChatServiceImpl）
- 整理一份对比表：Spring AI vs LangChain4j

**不学**：LangChain Python 版（以后用到再说）

---

## P1：大模型底层原理（2-3 天）

面试必考，纯理论，不需要写代码。

### 学什么
- Transformer 架构图刻在脑子里（Encoder → Self-Attention → FFN → Decoder）
- Self-Attention 公式：`softmax(QK^T/√d_k)V`
- 训练流程：Pre-training → SFT → RLHF → DPO
- Token / Tokenization / Embedding 三者关系
- Temperature / Top-p / Top-k 区别
- 7B/13B/70B 模型分别多大显存

### 资源
- 李沐 Transformer 论文精读（2 小时）
- Andrej Karpathy "Let's build GPT"（2 小时视频）
- Jay Alammar "The Illustrated Transformer"（图文，30 分钟）

---

## P1：RAGAS + Re-ranking（1 天）

### 学什么
- RAGAS 四个指标：Faithfulness / Answer Relevancy / Context Precision / Context Recall
- Cross-Encoder Re-ranking（和 Bi-Encoder 的区别）
- 在你的项目上跑一次 RAGAS 评测

### 实战
- 构造 20 条测试问题 → Milvus 检索 → 跑 RAGAS → 出分
- 接入 DashScope Re-rank API 做精排

---

## P2：MCP 实战（1 天）

### 学什么
- MCP Server 两种模式：stdio / HTTP
- Spring AI MCP Client 怎么发现和调用工具

### 实战
- 把 ProductTools 拆成独立 MCP Server（HTTP 模式）
- 项目通过 MCP Client 调用（替代 @Tool 注解）

---

## P2：Docker（1 天）

### 学什么
- Dockerfile 多阶段构建
- docker-compose 编排 MySQL + Redis + Milvus + 应用
- 镜像推送到阿里云容器镜像服务

### 实战
- 给 CDC 智能导购写 Dockerfile + docker-compose.yml
- `docker compose up` 一键启动

---

## P3：GraphRAG（2-3 天）

### 学什么
- 知识图谱：节点、关系、属性
- Neo4j Cypher 查询语言基础
- GraphRAG：实体提取 → 图遍历 → 上下文拼装

### 实战
- 构建商品知识图谱：Product → BELONGS_TO → Category → HAS_BRAND → Brand
- 实现"高蛋白零食推荐"：分类→商品→属性→图遍历→LLM 解读

---

## P3：Fine-tuning 入门（1-2 天）

### 学什么
- 什么时候微调、什么时候 Prompt 就够了
- LoRA 原理（不改变原权重，旁路加低秩矩阵）
- QLoRA（量化 → 消费级显卡可跑）

### 实战
- 阿里云百炼平台用你的对话数据微调一次 qwen-turbo
- 对比微调前后：同一个问题，回复质量差异

---

## P2：消息队列 + CI/CD（1-2 天）

### 消息队列
- RabbitMQ 基础概念
- 实战：AI 生成报表 → MQ → 异步返回

### CI/CD
- GitHub Actions 配置
- 提交代码 → 自动构建 → 跑测试

---

## 建议顺序

```
第 1-2 天：Python + LangChain4j（双线，切换脑子不累）
第 3-5 天：大模型原理（理论为主，看视频 + 画图）
第 6-7 天：RAGAS + MCP（两个都是给现有项目加功能）
第 8-9 天：Docker + 消息队列 + CI/CD（工程三件套）
第 10-12 天：GraphRAG（难度最高，放到后面）
第 13-14 天：Fine-tuning（收尾，轻松）
```

---

## 学完后的简历关键词

> Java AI 应用开发 | Spring AI + LangChain4j 双框架 | RAG（IVF_FLAT + RAGAS 评估 + Re-ranking）| GraphRAG | 多 Agent 协同 | MCP Server 实战 | Function Calling | Prompt 工程化 | LoRA 微调 | 多模态 | SSE 流式输出 | Docker + CI/CD | Python
