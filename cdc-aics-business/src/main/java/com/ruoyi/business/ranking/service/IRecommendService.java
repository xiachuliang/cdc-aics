package com.ruoyi.business.ranking.service;

import java.util.List;
import com.ruoyi.business.ranking.domain.Recommend;

public interface IRecommendService
{
    public Recommend selectRecommendById(Long id);
    public List<Recommend> selectRecommendList(Recommend recommend);
    public List<Recommend> selectEnabledRecommends();
    /** 保存或更新（按 productId 判断） */
    public Recommend saveOrUpdate(Recommend recommend);
    public void deleteRecommendByIds(Long[] ids);
}
