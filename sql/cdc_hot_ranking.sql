-- 热销排行榜表
-- 排名 = ORDER BY sales_count DESC（查询时自动算，不存死序号）
DROP TABLE IF EXISTS `cdc_hot_ranking`;
CREATE TABLE `cdc_hot_ranking` (
    `id`          BIGINT(20)   NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    `product_id`  BIGINT(20)   NOT NULL                  COMMENT '商品ID',
    `sales_count` INT(11)      DEFAULT 0                 COMMENT '销量（排序依据：越高越靠前）',
    `period`      VARCHAR(20)  DEFAULT 'WEEK'            COMMENT '统计周期（DAILY/WEEKLY/MONTHLY）',
    `status`      CHAR(1)      DEFAULT '0'               COMMENT '状态（0启用 1停用）',
    `create_by`   VARCHAR(64)  DEFAULT ''                COMMENT '创建者',
    `create_time` DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by`   VARCHAR(64)  DEFAULT ''                COMMENT '更新者',
    `update_time` DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark`      VARCHAR(500) DEFAULT NULL              COMMENT '备注',
    PRIMARY KEY (`id`),
    INDEX `idx_product_id` (`product_id`),
    INDEX `idx_period` (`period`),
    INDEX `idx_sales` (`sales_count`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='热销排行榜表';
