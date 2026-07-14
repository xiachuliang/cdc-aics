-- 对话日志表（记录100%的AI对话，用于监控、计费、问题排查）
CREATE TABLE IF NOT EXISTS cdc_chat_log (
    id          BIGINT(20)   NOT NULL AUTO_INCREMENT COMMENT '主键',
    session_id  VARCHAR(64)  DEFAULT ''  COMMENT '会话ID',
    question    VARCHAR(500) DEFAULT ''  COMMENT '用户问题',
    answer      TEXT                     COMMENT 'AI回答',
    intent      VARCHAR(50)  DEFAULT ''  COMMENT '意图分类',
    agent       VARCHAR(50)  DEFAULT ''  COMMENT '处理Agent(RAG/TextToSQL/Tools)',
    latency_ms  BIGINT(20)   DEFAULT 0   COMMENT '响应耗时(毫秒)',
    create_time DATETIME                 COMMENT '创建时间',
    PRIMARY KEY (id),
    INDEX idx_session_id (session_id),
    INDEX idx_intent (intent),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI对话日志表';
