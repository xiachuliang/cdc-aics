package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.KnowledgeDoc;

/**
 * 知识库文档 Service 接口
 */
public interface IKnowledgeDocService {

    KnowledgeDoc selectById(Long id);

    List<KnowledgeDoc> selectList(KnowledgeDoc doc);

    int insert(KnowledgeDoc doc);

    int update(KnowledgeDoc doc);

    int deleteById(Long id);
}
