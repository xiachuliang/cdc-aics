package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.domain.KnowledgeDoc;
import com.ruoyi.business.mapper.KnowledgeDocMapper;
import com.ruoyi.business.service.IKnowledgeDocService;

/**
 * 知识库文档 Service 实现
 */
@Service
public class KnowledgeDocServiceImpl implements IKnowledgeDocService {

    @Autowired
    private KnowledgeDocMapper mapper;

    @Override
    public KnowledgeDoc selectById(Long id) {
        return mapper.selectById(id);
    }

    @Override
    public List<KnowledgeDoc> selectList(KnowledgeDoc doc) {
        return mapper.selectList(doc);
    }

    @Override
    public int insert(KnowledgeDoc doc) {
        return mapper.insert(doc);
    }

    @Override
    public int update(KnowledgeDoc doc) {
        return mapper.update(doc);
    }

    @Override
    public int deleteById(Long id) {
        return mapper.deleteById(id);
    }
}
