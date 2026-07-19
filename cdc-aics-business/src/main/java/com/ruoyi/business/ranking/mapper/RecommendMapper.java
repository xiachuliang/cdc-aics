package com.ruoyi.business.ranking.mapper;

import java.util.List;
import com.ruoyi.business.ranking.domain.Recommend;

public interface RecommendMapper
{
    public Recommend selectRecommendById(Long id);
    public List<Recommend> selectRecommendList(Recommend recommend);
    public Recommend selectByProductId(Long productId);
    public int insertRecommend(Recommend recommend);
    public int updateRecommend(Recommend recommend);
    public int deleteRecommendByIds(Long[] ids);
    public List<Recommend> selectEnabledRecommends();
}
