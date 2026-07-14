package com.ruoyi.business.service;

import java.util.List;
import com.ruoyi.business.domain.KnowledgeFaq;

public interface IKnowledgeFaqService {

    KnowledgeFaq selectById(Long id);

    List<KnowledgeFaq> selectList(KnowledgeFaq faq);

    int insert(KnowledgeFaq faq);

    int update(KnowledgeFaq faq);

    int deleteById(Long id);

    /** 批量导入 */
    String importFaqs(List<KnowledgeFaq> list, String operName);
}
