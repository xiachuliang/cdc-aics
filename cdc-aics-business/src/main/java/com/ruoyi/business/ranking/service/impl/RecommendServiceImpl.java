package com.ruoyi.business.ranking.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.business.ranking.domain.Recommend;
import com.ruoyi.business.ranking.mapper.RecommendMapper;
import com.ruoyi.business.ranking.service.IRecommendService;

@Service
public class RecommendServiceImpl implements IRecommendService
{
    @Autowired
    private RecommendMapper recommendMapper;

    @Override
    public Recommend selectRecommendById(Long id) {
        return recommendMapper.selectRecommendById(id);
    }

    @Override
    public List<Recommend> selectRecommendList(Recommend recommend) {
        return recommendMapper.selectRecommendList(recommend);
    }

    @Override
    public List<Recommend> selectEnabledRecommends() {
        return recommendMapper.selectEnabledRecommends();
    }

    @Override
    @Transactional
    public Recommend saveOrUpdate(Recommend r) {
        Recommend exist = recommendMapper.selectByProductId(r.getProductId());
        if (exist != null) {
            r.setId(exist.getId());
            recommendMapper.updateRecommend(r);
        } else {
            recommendMapper.insertRecommend(r);
        }
        return recommendMapper.selectByProductId(r.getProductId());
    }

    @Override
    public void deleteRecommendByIds(Long[] ids) {
        recommendMapper.deleteRecommendByIds(ids);
    }
}
