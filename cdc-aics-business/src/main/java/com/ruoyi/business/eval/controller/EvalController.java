package com.ruoyi.business.eval.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ruoyi.business.eval.domain.EvalLog;
import com.ruoyi.business.eval.mapper.EvalLogMapper;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;

@RestController
@RequestMapping("/ai/eval")
public class EvalController extends BaseController {

    @Autowired
    private EvalLogMapper evalLogMapper;

    @GetMapping("/list")
    public TableDataInfo list(EvalLog log) {
        startPage();
        List<EvalLog> list = evalLogMapper.selectEvalLogList(log);
        return getDataTable(list);
    }

    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id) {
        return success(evalLogMapper.selectEvalLogById(id));
    }

    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        evalLogMapper.deleteEvalLogByIds(ids);
        return success();
    }

    @GetMapping("/stats")
    public AjaxResult stats() {
        Double avgScore = evalLogMapper.selectAvgScore();
        Map<String, Object> data = new HashMap<>();
        data.put("avgScore", avgScore != null ? String.format("%.1f", avgScore) : "暂无数据");
        int total = evalLogMapper.selectEvalLogList(new EvalLog()).size();
        data.put("totalCount", total);
        return success(data);
    }
}
