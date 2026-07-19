-- 运营推荐榜表
-- 优先级 = ORDER BY score DESC（查询时自动算，不存死序号）
-- 运营只需改 score 值即可调整优先级，不影响其他行
DROP TABLE IF EXISTS `cdc_recommend`;
CREATE TABLE `cdc_recommend` (
    `id`          BIGINT(20)   NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    `product_id`  BIGINT(20)   NOT NULL                  COMMENT '商品ID',
    `score`       INT(11)      NOT NULL DEFAULT 50       COMMENT '推荐指数（0-100，越高越优先，排序依据）',
    `reason`      VARCHAR(255) DEFAULT ''                COMMENT '推荐理由（如"新品上市""季节性热销"）',
    `status`      CHAR(1)      DEFAULT '0'               COMMENT '状态（0启用 1停用）',
    `create_by`   VARCHAR(64)  DEFAULT ''                COMMENT '创建者',
    `create_time` DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by`   VARCHAR(64)  DEFAULT ''                COMMENT '更新者',
    `update_time` DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark`      VARCHAR(500) DEFAULT NULL              COMMENT '备注',
    PRIMARY KEY (`id`),
    INDEX `idx_product_id` (`product_id`),
    INDEX `idx_score` (`score`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='运营推荐榜表';
