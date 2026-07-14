-- AI 评测日志表
CREATE TABLE IF NOT EXISTS cdc_eval_log (
    id          BIGINT(20)   NOT NULL AUTO_INCREMENT COMMENT '主键',
    session_id  VARCHAR(64)  DEFAULT ''  COMMENT '会话ID',
    question    VARCHAR(500) DEFAULT ''  COMMENT '用户问题',
    answer      TEXT                     COMMENT 'AI回答',
    intent      VARCHAR(50)  DEFAULT ''  COMMENT '意图分类',
    score       INT(2)       DEFAULT 0   COMMENT '评分(1-10)',
    judge_reason VARCHAR(500) DEFAULT '' COMMENT '评分理由',
    latency_ms  BIGINT(20)   DEFAULT 0   COMMENT '响应耗时(毫秒)',
    create_time DATETIME                 COMMENT '创建时间',
    PRIMARY KEY (id),
    INDEX idx_create_time (create_time),
    INDEX idx_score (score)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI评测日志表';
