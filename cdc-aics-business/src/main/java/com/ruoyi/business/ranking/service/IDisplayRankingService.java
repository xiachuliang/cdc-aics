package com.ruoyi.business.ranking.service;

import java.util.List;
import com.ruoyi.business.ranking.domain.DisplayRanking;

/**
 * 融合展示榜 服务层
 *
 * @author cdc-aics
 */
public interface IDisplayRankingService
{
    /** 查询展示榜列表 */
    public List<DisplayRanking> selectDisplayRankingList(DisplayRanking ranking);

    /** 删除展示榜记录 */
    public void deleteDisplayRankingByIds(Long[] ids);

    /** 重新生成展示榜（热销 + 推荐 加权融合） */
    public void regenerateDisplayRanking();

    /** 查询 Top N */
    public List<DisplayRanking> selectDisplayRankingTopN(int limit);
}
