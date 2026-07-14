package com.ruoyi.business.mapper;

import java.util.List;
import com.ruoyi.business.domain.KnowledgeFaq;

public interface KnowledgeFaqMapper {

    KnowledgeFaq selectById(Long id);

    List<KnowledgeFaq> selectList(KnowledgeFaq faq);

    int insert(KnowledgeFaq faq);

    int update(KnowledgeFaq faq);

    int deleteById(Long id);

    /** 批量导入 */
    int batchInsert(List<KnowledgeFaq> list);
}
