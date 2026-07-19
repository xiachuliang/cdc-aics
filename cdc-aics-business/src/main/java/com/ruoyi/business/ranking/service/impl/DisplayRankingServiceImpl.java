package com.ruoyi.business.ranking.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ruoyi.business.ranking.domain.DisplayRanking;
import com.ruoyi.business.ranking.domain.HotRanking;
import com.ruoyi.business.ranking.domain.Recommend;
import com.ruoyi.business.ranking.mapper.DisplayRankingMapper;
import com.ruoyi.business.ranking.mapper.HotRankingMapper;
import com.ruoyi.business.ranking.mapper.RecommendMapper;
import com.ruoyi.business.ranking.service.IDisplayRankingService;

/**
 * 融合展示榜 服务层实现
 * 融合算法：热销 sales_count 归一化 × 0.6 + 推荐 score 归一化 × 0.4 → final_score
 *
 * @author cdc-aics
 */
@Service
public class DisplayRankingServiceImpl implements IDisplayRankingService
{
    private static final Logger log = LoggerFactory.getLogger(DisplayRankingServiceImpl.class);

    /** 热销权重 */
    private static final double HOT_WEIGHT = 0.6;
    /** 推荐权重 */
    private static final double REC_WEIGHT = 0.4;

    @Autowired
    private DisplayRankingMapper displayRankingMapper;

    @Autowired
    private HotRankingMapper hotRankingMapper;

    @Autowired
    private RecommendMapper recommendMapper;

    @Override
    public List<DisplayRanking> selectDisplayRankingList(DisplayRanking ranking)
    {
        return displayRankingMapper.selectDisplayRankingList(ranking);
    }

    @Override
    public void deleteDisplayRankingByIds(Long[] ids)
    {
        displayRankingMapper.deleteDisplayRankingByIds(ids);
    }

    @Override
    public List<DisplayRanking> selectDisplayRankingTopN(int limit)
    {
        return displayRankingMapper.selectDisplayRankingTopN(limit);
    }

    /**
     * 重新生成展示榜（热销 + 推荐 加权融合）
     *
     * 算法：
     * 1. 收集所有热销商品（sales_count 归一化到 0-100）
     * 2. 收集所有推荐商品（score 本来就是 0-100）
     * 3. 合并：finalScore = hotNormalized × 0.6 + recScore × 0.4
     *    - 两边都有 → source = BOTH
     *    - 仅热销   → source = HOT_ONLY
     *    - 仅推荐   → source = REC_ONLY
     * 4. 清空旧数据 → 批量插入新数据
     */
    @Override
    @Transactional
    public void regenerateDisplayRanking()
    {
        log.info("开始重新生成展示榜...");

        // 1. 查询所有启用的热销和推荐
        HotRanking hotQuery = new HotRanking();
        hotQuery.setStatus("0");
        List<HotRanking> hotList = hotRankingMapper.selectHotRankingList(hotQuery);

        Recommend recQuery = new Recommend();
        recQuery.setStatus("0");
        List<Recommend> recList = recommendMapper.selectRecommendList(recQuery);

        // 2. 热销销量归一化（sales_count / maxSalesCount * 100）
        int maxSales = 1;
        for (HotRanking h : hotList) {
            if (h.getSalesCount() != null && h.getSalesCount() > maxSales) {
                maxSales = h.getSalesCount();
            }
        }

        Map<Long, BigDecimal> hotScoreMap = new HashMap<>();
        for (HotRanking h : hotList) {
            // 只处理有实际热销记录的商品（id != null，即 cdc_hot_ranking 表中有数据）
            if (h.getId() == null) continue;
            BigDecimal normalized = BigDecimal.valueOf(h.getSalesCount())
                .multiply(BigDecimal.valueOf(100))
                .divide(BigDecimal.valueOf(maxSales), 2, RoundingMode.HALF_UP);
            hotScoreMap.put(h.getProductId(), normalized);
        }

        // 3. 收集所有涉及的商品ID
        Map<Long, BigDecimal> recScoreMap = new HashMap<>();
        for (Recommend r : recList) {
            // 只处理有实际推荐记录的商品（id != null，即 cdc_recommend 表中有数据）
            if (r.getId() == null) continue;
            recScoreMap.put(r.getProductId(), BigDecimal.valueOf(r.getScore()));
        }

        // 4. 合并所有商品ID
        java.util.Set<Long> allProductIds = new java.util.HashSet<>();
        allProductIds.addAll(hotScoreMap.keySet());
        allProductIds.addAll(recScoreMap.keySet());

        // 5. 计算最终得分
        List<DisplayRanking> results = new ArrayList<>();
        for (Long productId : allProductIds) {
            BigDecimal hotScore = hotScoreMap.getOrDefault(productId, BigDecimal.ZERO);
            BigDecimal recScore = recScoreMap.getOrDefault(productId, BigDecimal.ZERO);

            BigDecimal finalScore = hotScore.multiply(BigDecimal.valueOf(HOT_WEIGHT))
                .add(recScore.multiply(BigDecimal.valueOf(REC_WEIGHT)))
                .setScale(2, RoundingMode.HALF_UP);

            String source;
            if (hotScoreMap.containsKey(productId) && recScoreMap.containsKey(productId)) {
                source = "BOTH";
            } else if (hotScoreMap.containsKey(productId)) {
                source = "HOT_ONLY";
            } else {
                source = "REC_ONLY";
            }

            DisplayRanking dr = new DisplayRanking();
            dr.setProductId(productId);
            dr.setFinalScore(finalScore);
            dr.setHotScore(hotScore);
            dr.setRecScore(recScore);
            dr.setSource(source);
            dr.setStatus("0");
            results.add(dr);
        }

        // 按 finalScore 降序排列
        results.sort((a, b) -> b.getFinalScore().compareTo(a.getFinalScore()));

        // 6. 清空旧数据，批量插入新数据
        displayRankingMapper.truncateDisplayRanking();
        if (!results.isEmpty()) {
            displayRankingMapper.batchInsertDisplayRanking(results);
        }

        log.info("展示榜生成完成，共 {} 条", results.size());
    }
}
