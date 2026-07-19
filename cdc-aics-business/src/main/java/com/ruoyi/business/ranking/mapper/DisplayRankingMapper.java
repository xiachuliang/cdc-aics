package com.ruoyi.business.ranking.mapper;

import java.util.List;
import com.ruoyi.business.ranking.domain.DisplayRanking;

/**
 * 融合展示榜 数据层
 *
 * @author cdc-aics
 */
public interface DisplayRankingMapper
{
    /** 查询列表（联表） */
    public List<DisplayRanking> selectDisplayRankingList(DisplayRanking ranking);

    /** 清空展示榜 */
    public int truncateDisplayRanking();

    /** 批量插入 */
    public int batchInsertDisplayRanking(List<DisplayRanking> list);

    /** 批量删除 */
    public int deleteDisplayRankingByIds(Long[] ids);

    /** 查询 Top N 给 C 端看（只查启用、商品上架的） */
    public List<DisplayRanking> selectDisplayRankingTopN(int limit);
}
