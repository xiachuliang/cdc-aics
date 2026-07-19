package com.ruoyi.ai.agent;

    /**
     * 用户意图枚举
     * CHITCHAT：闲聊/打招呼/商品推荐 → 走闲聊 Agent（排行榜带货）
     * CONSULTATION：FAQ + 规则制度 → 走 RAG Agent（向量检索）
     * ANALYTICS：聚合统计 → 走 Text-to-SQL Agent
     * OPERATION：商品查询/购物车/下单 → 走 Tools Agent
     */
    public enum Intent {
        CHITCHAT,
        CONSULTATION,
        OPERATION,
        ANALYTICS
    }



