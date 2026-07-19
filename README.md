# 🛒 CDC 智能导购（cdc-aishopper）

基于 [若依（RuoYi-Vue）](https://gitee.com/y_project/RuoYi-Vue) 的超市智能导购系统，集成 **Spring AI Alibaba + 阿里云百炼 DashScope**，实现多智能体协同的 AI 导购助手。（本人用于学习spring ai所用，如有需要请随意拿去修改）------ai对话（/portal/product）

---

## 🎯 核心功能

| 功能 | 说明 |
|------|------|
| 🤖 **多智能体协同** | 四 Agent：闲聊 / RAG知识检索 / Text-to-SQL / Tool Calling |
| 💬 **流式对话** | SSE 流式输出 + 打字机效果，支持连续打字+回车 |
| 🔧 **Tool Calling** | 11 个 @Tool 工具：商品搜索/加购/下单，LLM 自动决策调用 |
| 📚 **RAG 检索增强** | Milvus 向量库 + FAQ/规则制度语义检索 |
| 📊 **Text-to-SQL** | 自然语言 → SELECT → 执行 → 解读（安全沙箱：仅允许 SELECT） |
| 📷 **多模态识别** | 拍商品图片 → qwen-vl-plus 识别 → 自动搜索匹配 |
| 🛒 **AI 购物** | 加购/购物车管理/下单确认，双重库存检查防超卖 |
| 📝 **AI 评测** | 10% 随机抽检 + LLM-Judge 异步打分 + 后台管理 |
| 🛡️ **生产化** | Redis 限流、对话日志、异常降级、后台管理 |

## 🏗️ 架构

```
用户 → ChatController → ChatOrchestrator → RouterService（LLM 意图分类）
                                              ├── CHITCHAT      → 闲聊 Agent（排行榜带货）
                                              ├── CONSULTATION  → RAG Agent（FAQ/规则检索）
                                              ├── ANALYTICS     → Text-to-SQL Agent（聚合统计）
                                              └── OPERATION     → Tools Agent（商品/购物车/下单）

四个 Agent 共享 RedisChatMemory（窗口10条 + 摘要 + TTL 30min）
```

## 🛠️ 技术栈

| 层级 | 技术 |
|------|------|
| 后端框架 | Spring Boot 3.x + MyBatis + Maven 多模块 |
| AI 框架 | Spring AI Alibaba 1.1.2 |
| 大语言模型 | 阿里云百炼 DashScope（deepseek-v4-flash） |
| Embedding | text-embedding-v1 |
| 多模态 | qwen-vl-plus |
| 向量数据库 | Milvus 2.4（Docker Compose） |
| 缓存/记忆 | Redis（ChatMemory 持久化 + 限流滑动窗口） |
| 数据库 | MySQL 8.x |
| 前端 | Vue 3 + Element Plus + Vite |

## 📁 项目结构

```
cdc-aics-server/
├── ruoyi-admin/          # 启动入口 + 配置文件
├── ruoyi-framework/      # 若依框架核心（安全/限流/配置）
├── ruoyi-system/         # 系统管理（用户/角色/菜单）
├── ruoyi-common/         # 通用工具
├── ruoyi-generator/      # 代码生成器
├── ruoyi-quartz/         # 定时任务
│
├── cdc-aics-ai/          # ★ AI 核心模块
│   ├── agent/            #   Agent 层（Router / RAG）
│   ├── chat/             #   对话服务（ChatOrchestrator / 流式/同步）
│   ├── chitchat/         #   闲聊 Agent + 排行榜缓存
│   ├── config/           #   AI 配置（ChatClient / Memory / VectorStore）
│   ├── sql/              #   Text-to-SQL 服务
│   ├── tool/             #   @Tool（ProductTools / OrderTools）
│   ├── memory/           #   RedisChatMemory 实现
│   └── prompts/          #   .st Prompt 模板
│
├── cdc-aics-business/    # ★ 超市业务（商品/订单/采购/库存）
├── cdc-aics-portal/      # ★ C 端门户（免登录 API）
│
├── ruoyi-ui/             # 前端
│   └── src/
│       ├── views/portal/  #   C 端页面
│       └── components/    #   共享组件（AiChatBox）
│
└── sql/                  # 数据库脚本
```

## 🚀 快速开始

### 环境要求

- JDK 17+
- Maven 3.8+
- MySQL 8.x
- Redis 7.x
- Docker + Docker Compose（Milvus 向量库）
- Node.js 18+（前端）

### 1. 初始化数据库

```bash
mysql -u root -p < sql/cdc-aics.sql
```

### 2. 启动 Milvus

```bash
cd docker/milvus
docker compose up -d
```

### 3. 配置

`ruoyi-admin/src/main/resources/application-druid.yml`：
```yaml
datasource:
  druid:
    master:
      url: jdbc:mysql://localhost:3306/cdc-aics?...
      username: 你的MySQL用户名
      password: 你的MySQL密码
```

`ruoyi-admin/src/main/resources/application.yml`：
```yaml
spring:
  ai:
    dashscope:
      api-key: ${DASHSCOPE_API_KEY}   # 百炼平台 API Key
```

### 4. 启动后端

```bash
cd cdc-aics-server
mvn clean install -DskipTests
cd ruoyi-admin
mvn spring-boot:run
```

### 5. 启动前端

```bash
cd ruoyi-ui
npm install
npm run dev
```

- C 端门户：`http://localhost`
- 后台管理：`http://localhost:8080`

## 🧠 AI 能力详解

### 四 Agent 协作

| Agent | 意图 | 能力 | 实现方式 |
|-------|------|------|---------|
| **闲聊 Agent** | CHITCHAT | 打招呼/心情/模糊推荐 + 排行榜带货 | 纯 ChatClient，Prompt 注入 |
| **RAG Agent** | CONSULTATION | FAQ + 规则制度语义检索 | Milvus 向量相似度搜索 |
| **Text-to-SQL Agent** | ANALYTICS | NL→SQL→执行→解读 | 安全沙箱（仅 SELECT） |
| **Tools Agent** | OPERATION | 商品搜索/加购/下单/查订单 | 11 个 @Tool 注解 |

### 11 个 AI 工具

**商品查询**：searchProducts / getProductDetail / listCategories / getProductsByCategory / getRankingList

**购物操作**：addToCart / getCart / removeFromCart / updateCartQuantity / createOrder / queryOrder

## 📸 页面路由

| 页面 | 路由 | 布局 |
|------|------|------|
| 商品浏览 + AI 对话 | `/portal/product` | 左商品 右对话 |
| 商品详情 | `/portal/product/detail/:id` | 左详情 右对话 |
| AI 独立对话 | `/portal/chat` | 全屏聊天 |
| 购物车 | `/portal/cart` | 左购物车 右对话 |
| 确认订单 | `/portal/order/confirm` | 左订单 右对话 |
| 订单查询 | `/portal/order/query` | 左查询 右对话 |

## 📄 License

Apache 2.0（继承若依框架协议）。项目基于 [RuoYi-Vue](https://gitee.com/y_project/RuoYi-Vue) 构建。
