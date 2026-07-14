package com.ruoyi.ai.agent;

    /**
     * 用户意图枚举
     * CONSULTATION：知识咨询 → 走 RAG Agent
     * OPERATION：操作/聚合查询 → 走 Tools Agent
     */
    public enum Intent {
        CONSULTATION,
        OPERATION,
        ANALYTICS
    }



