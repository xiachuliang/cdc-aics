package com.ruoyi.business.ranking.mapper;

import java.util.List;
import com.ruoyi.business.ranking.domain.HotRanking;

public interface HotRankingMapper
{
    public HotRanking selectHotRankingById(Long id);
    public List<HotRanking> selectHotRankingList(HotRanking hotRanking);
    public HotRanking selectByProductId(Long productId);
    public int insertHotRanking(HotRanking hotRanking);
    public int updateHotRanking(HotRanking hotRanking);
    public int deleteHotRankingByIds(Long[] ids);
    public List<HotRanking> selectHotRankingByPeriod(String period);
}
