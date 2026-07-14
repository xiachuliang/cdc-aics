-- 知识库文档管理表
DROP TABLE IF EXISTS `cdc_knowledge_doc`;
CREATE TABLE `cdc_knowledge_doc` (
    `id`          BIGINT(20)   NOT NULL AUTO_INCREMENT  COMMENT '文档ID',
    `title`       VARCHAR(255) NOT NULL                  COMMENT '文档标题',
    `category`    VARCHAR(100) DEFAULT '未分类'           COMMENT '分类标签',
    `content`     LONGTEXT     NOT NULL                  COMMENT '文档全文（从Word解析的纯文本）',
    `file_size`   BIGINT(20)   DEFAULT 0                 COMMENT '原始文件大小（字节）',
    `chunked`     CHAR(1)      DEFAULT '0'               COMMENT '是否已切片（0=未切片 1=已切片）',
    `chunk_count` INT(11)      DEFAULT 0                 COMMENT '切片数量',
    `chunk_size`  INT(11)      DEFAULT 300               COMMENT '切片大小（字符）',
    `overlap`     INT(11)      DEFAULT 50                COMMENT '滑动窗口重叠（字符）',
    `doc_id`      VARCHAR(20)  DEFAULT NULL               COMMENT 'Milvus中的文档标识（用于删除）',
    `create_by`   VARCHAR(64)  DEFAULT ''                 COMMENT '创建者',
    `create_time` DATETIME     DEFAULT CURRENT_TIMESTAMP  COMMENT '创建时间',
    `update_by`   VARCHAR(64)  DEFAULT ''                 COMMENT '更新者',
    `update_time` DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark`      VARCHAR(500) DEFAULT NULL               COMMENT '备注',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='知识库文档管理表';
