package com.ruoyi.business.ranking.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ruoyi.business.ranking.domain.DisplayRanking;
import com.ruoyi.business.ranking.domain.HotRanking;
import com.ruoyi.business.ranking.domain.Recommend;
import com.ruoyi.business.ranking.service.IDisplayRankingService;
import com.ruoyi.business.ranking.service.IHotRankingService;
import com.ruoyi.business.ranking.service.IRecommendService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;

@RestController
@RequestMapping("/business/ranking")
public class RankingController extends BaseController
{
    @Autowired
    private IHotRankingService hotRankingService;
    @Autowired
    private IRecommendService recommendService;
    @Autowired
    private IDisplayRankingService displayRankingService;

    // ==================== 热销排行榜（以商品为主表） ====================

    @GetMapping("/hot/list")
    public TableDataInfo hotList(HotRanking hotRanking) {
        startPage();
        List<HotRanking> list = hotRankingService.selectHotRankingList(hotRanking);
        return getDataTable(list);
    }

    /** 保存热销数据（有则更新，无则插入） */
    @PostMapping("/hot/save")
    public AjaxResult hotSave(@RequestBody HotRanking hotRanking) {
        hotRankingService.saveOrUpdate(hotRanking);
        displayRankingService.regenerateDisplayRanking();
        return success();
    }

    /** 删除热销记录（按排行表ID） */
    @DeleteMapping("/hot/{ids}")
    public AjaxResult hotRemove(@PathVariable Long[] ids) {
        hotRankingService.deleteHotRankingByIds(ids);
        displayRankingService.regenerateDisplayRanking();
        return success();
    }

    // ==================== 运营推荐榜（以商品为主表） ====================

    @GetMapping("/recommend/list")
    public TableDataInfo recommendList(Recommend recommend) {
        startPage();
        List<Recommend> list = recommendService.selectRecommendList(recommend);
        return getDataTable(list);
    }

    /** 保存推荐数据（有则更新，无则插入） */
    @PostMapping("/recommend/save")
    public AjaxResult recommendSave(@RequestBody Recommend recommend) {
        recommendService.saveOrUpdate(recommend);
        displayRankingService.regenerateDisplayRanking();
        return success();
    }

    /** 删除推荐记录（按排行表ID） */
    @DeleteMapping("/recommend/{ids}")
    public AjaxResult recommendRemove(@PathVariable Long[] ids) {
        recommendService.deleteRecommendByIds(ids);
        displayRankingService.regenerateDisplayRanking();
        return success();
    }

    // ==================== 融合展示榜 ====================

    @GetMapping("/display/list")
    public TableDataInfo displayList(DisplayRanking ranking) {
        startPage();
        List<DisplayRanking> list = displayRankingService.selectDisplayRankingList(ranking);
        return getDataTable(list);
    }

    @DeleteMapping("/display/{ids}")
    public AjaxResult displayRemove(@PathVariable Long[] ids) {
        displayRankingService.deleteDisplayRankingByIds(ids);
        return success();
    }

    @PostMapping("/display/regenerate")
    public AjaxResult displayRegenerate() {
        displayRankingService.regenerateDisplayRanking();
        return success("展示榜已重新生成");
    }
}
