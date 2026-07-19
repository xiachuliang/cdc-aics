-- 融合展示榜表（给用户看的最终排行榜）
-- 由 cdc_hot_ranking + cdc_recommend 加权融合自动生成
-- 不手动编辑，运营调推荐榜后自动重算
DROP TABLE IF EXISTS `cdc_display_ranking`;
CREATE TABLE `cdc_display_ranking` (
    `id`            BIGINT(20)    NOT NULL AUTO_INCREMENT  COMMENT 'ID',
    `product_id`    BIGINT(20)    NOT NULL                  COMMENT '商品ID',
    `final_score`   DECIMAL(10,2) NOT NULL DEFAULT 0.00     COMMENT '最终得分（排序依据，越高越靠前）',
    `hot_score`     DECIMAL(10,2) DEFAULT 0.00              COMMENT '热销贡献分（来源：cdc_hot_ranking.sales_count 归一化）',
    `rec_score`     DECIMAL(10,2) DEFAULT 0.00              COMMENT '推荐贡献分（来源：cdc_recommend.score）',
    `source`        VARCHAR(20)   NOT NULL DEFAULT 'HOT_ONLY' COMMENT '来源（BOTH=热销+推荐 / HOT_ONLY=仅热销 / REC_ONLY=仅推荐）',
    `status`        CHAR(1)       DEFAULT '0'               COMMENT '状态（0启用 1停用）',
    `generate_time` DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT '生成时间',
    `create_by`     VARCHAR(64)   DEFAULT ''                COMMENT '创建者',
    `create_time`   DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by`     VARCHAR(64)   DEFAULT ''                COMMENT '更新者',
    `update_time`   DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark`        VARCHAR(500)  DEFAULT NULL              COMMENT '备注',
    PRIMARY KEY (`id`),
    INDEX `idx_product_id` (`product_id`),
    INDEX `idx_final_score` (`final_score`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='融合展示榜表（给用户看）';
