package com.ruoyi.business.service.impl;

import java.util.List;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.business.annotation.FaqSync;
import com.ruoyi.business.annotation.FaqSync.Action;
import com.ruoyi.business.domain.KnowledgeFaq;
import com.ruoyi.business.mapper.KnowledgeFaqMapper;
import com.ruoyi.business.service.IKnowledgeFaqService;
import com.ruoyi.common.utils.StringUtils;

@Service
public class KnowledgeFaqServiceImpl implements IKnowledgeFaqService {

    @Autowired
    private KnowledgeFaqMapper mapper;

    @Override
    public KnowledgeFaq selectById(Long id) {
        return mapper.selectById(id);
    }

    @Override
    public List<KnowledgeFaq> selectList(KnowledgeFaq faq) {
        return mapper.selectList(faq);
    }

    @Override
    @FaqSync(Action.INSERT)
    public int insert(KnowledgeFaq faq) {
        if (faq.getEnabled() == null) faq.setEnabled("1");
        return mapper.insert(faq);
    }

    @Override
    @FaqSync(Action.UPDATE)
    public int update(KnowledgeFaq faq) {
        return mapper.update(faq);
    }

    @Override
    @FaqSync(Action.DELETE)
    public int deleteById(Long id) {
        return mapper.deleteById(id);
    }

    @Override
    public String importFaqs(List<KnowledgeFaq> list, String operName) {
        int success = 0, fail = 0;
        for (KnowledgeFaq faq : list) {
            try {
                if (StringUtils.isEmpty(faq.getQuestion()) || StringUtils.isEmpty(faq.getAnswer())) {
                    fail++; continue;
                }
                faq.setCreateBy(operName);
                if (faq.getEnabled() == null) faq.setEnabled("1");
                // self-call 不触发 AOP，必须走代理
                ((IKnowledgeFaqService) AopContext.currentProxy()).insert(faq);
                success++;
            } catch (Exception e) {
                fail++;
            }
        }
        return String.format("导入完成：成功 %d 条，失败 %d 条", success, fail);
    }
}
