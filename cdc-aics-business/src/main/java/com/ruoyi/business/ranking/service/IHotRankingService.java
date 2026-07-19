package com.ruoyi.business.ranking.service;

import java.util.List;
import com.ruoyi.business.ranking.domain.HotRanking;

public interface IHotRankingService
{
    public HotRanking selectHotRankingById(Long id);
    public List<HotRanking> selectHotRankingList(HotRanking hotRanking);
    public List<HotRanking> selectHotRankingByPeriod(String period);
    /** 保存或更新（按 productId 判断），返回更新后的记录 */
    public HotRanking saveOrUpdate(HotRanking hotRanking);
    /** 累加商品销量（下单后自动同步），delta为正数表示卖出，负数表示退货 */
    public void incrementSales(Long productId, int delta);
    public void deleteHotRankingByIds(Long[] ids);
}
