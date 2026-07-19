package com.ruoyi.business.ranking.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.business.ranking.domain.HotRanking;
import com.ruoyi.business.ranking.mapper.HotRankingMapper;
import com.ruoyi.business.ranking.service.IHotRankingService;

@Service
public class HotRankingServiceImpl implements IHotRankingService
{
    @Autowired
    private HotRankingMapper hotRankingMapper;

    @Override
    public HotRanking selectHotRankingById(Long id) {
        return hotRankingMapper.selectHotRankingById(id);
    }

    @Override
    public List<HotRanking> selectHotRankingList(HotRanking hotRanking) {
        return hotRankingMapper.selectHotRankingList(hotRanking);
    }

    @Override
    public List<HotRanking> selectHotRankingByPeriod(String period) {
        return hotRankingMapper.selectHotRankingByPeriod(period);
    }

    @Override
    @Transactional
    public HotRanking saveOrUpdate(HotRanking h) {
        HotRanking exist = hotRankingMapper.selectByProductId(h.getProductId());
        if (exist != null) {
            h.setId(exist.getId());
            hotRankingMapper.updateHotRanking(h);
        } else {
            hotRankingMapper.insertHotRanking(h);
        }
        return hotRankingMapper.selectByProductId(h.getProductId());
    }

    @Override
    @Transactional
    public void incrementSales(Long productId, int delta) {
        HotRanking exist = hotRankingMapper.selectByProductId(productId);
        if (exist != null) {
            exist.setSalesCount(Math.max(0, (exist.getSalesCount() != null ? exist.getSalesCount() : 0) + delta));
            hotRankingMapper.updateHotRanking(exist);
        } else {
            HotRanking hr = new HotRanking();
            hr.setProductId(productId);
            hr.setSalesCount(Math.max(0, delta));
            hr.setPeriod("DAILY");
            hr.setStatus("0");
            hr.setRemark("下单自动创建");
            hotRankingMapper.insertHotRanking(hr);
        }
    }

    @Override
    public void deleteHotRankingByIds(Long[] ids) {
        hotRankingMapper.deleteHotRankingByIds(ids);
    }
}
