package com.ruoyi.ai.chitchat;

import java.util.List;
import java.util.concurrent.atomic.AtomicReference;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.ruoyi.business.ranking.domain.DisplayRanking;
import com.ruoyi.business.ranking.service.IDisplayRankingService;

/**
 * 排行榜缓存服务——定时刷新融合展示榜，供闲聊 Agent 注入 Prompt
 * <p>
 * 每小时查一次 cdc_display_ranking Top 10，格式化为文本缓存到内存。
 * 闲聊 Agent 直接从缓存读取，不需要每次调 DB。
 */
@Service
public class RankingCacheService {

    private static final Logger log = LoggerFactory.getLogger(RankingCacheService.class);

    private final IDisplayRankingService displayRankingService;
    private final AtomicReference<String> cachedRanking = new AtomicReference<>("（暂无排行榜数据）");

    public RankingCacheService(IDisplayRankingService displayRankingService) {
        this.displayRankingService = displayRankingService;
        refresh(); // 启动时立即加载一次
    }

    /**
     * 每小时刷新一次（3600000ms = 1h）
     */
    @Scheduled(fixedRate = 3_600_000)
    public void refresh() {
        try {
            List<DisplayRanking> list = displayRankingService.selectDisplayRankingTopN(10);
            if (list == null || list.isEmpty()) {
                String fallback = "（暂无热销推荐，请根据对话自然回应）";
                cachedRanking.set(fallback);
                log.info("排行榜缓存已刷新：暂无数据");
                return;
            }

            StringBuilder sb = new StringBuilder();
            int rank = 1;
            for (DisplayRanking r : list) {
                String name = r.getProductName() != null ? r.getProductName() : "商品" + r.getProductId();
                String price = r.getProductPrice() != null ? r.getProductPrice().toString() : "暂无";
                sb.append(rank++).append(". ")
                  .append(name).append(" — ¥").append(price)
                  .append("（综合评分").append(r.getFinalScore()).append("）\n");
            }
            cachedRanking.set(sb.toString());
            log.info("排行榜缓存已刷新，Top {} 条", list.size());
        } catch (Exception e) {
            log.error("排行榜缓存刷新失败，沿用旧缓存", e);
        }
    }

    /** 获取格式化的 Top 10 排名文本 */
    public String getFormattedTop10() {
        return cachedRanking.get();
    }
}
