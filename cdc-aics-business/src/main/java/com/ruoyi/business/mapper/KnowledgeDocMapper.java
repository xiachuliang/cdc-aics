package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.KnowledgeDoc;

/**
 * 知识库文档 Mapper
 */
public interface KnowledgeDocMapper {

    KnowledgeDoc selectById(Long id);

    List<KnowledgeDoc> selectList(KnowledgeDoc doc);

    int insert(KnowledgeDoc doc);

    int update(KnowledgeDoc doc);

    int deleteById(Long id);
}
