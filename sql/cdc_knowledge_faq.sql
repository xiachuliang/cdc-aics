-- 知识库 FAQ 问答表
DROP TABLE IF EXISTS `cdc_knowledge_faq`;
CREATE TABLE `cdc_knowledge_faq` (
    `id`          BIGINT(20)   NOT NULL AUTO_INCREMENT  COMMENT 'FAQ ID',
    `question`    VARCHAR(500) NOT NULL                  COMMENT '问题',
    `answer`      TEXT         NOT NULL                  COMMENT '回答',
    `category`    VARCHAR(100) DEFAULT '通用'             COMMENT '分类标签',
    `enabled`     CHAR(1)      DEFAULT '1'               COMMENT '状态（0=禁用 1=启用）',
    `order_num`   INT(11)      DEFAULT 0                 COMMENT '排序',
    `create_by`   VARCHAR(64)  DEFAULT ''                 COMMENT '创建者',
    `create_time` DATETIME     DEFAULT CURRENT_TIMESTAMP  COMMENT '创建时间',
    `update_by`   VARCHAR(64)  DEFAULT ''                 COMMENT '更新者',
    `update_time` DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark`      VARCHAR(500) DEFAULT NULL               COMMENT '备注',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='知识库FAQ问答表';
