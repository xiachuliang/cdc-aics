package com.ruoyi.business.eval.mapper;

import java.util.List;

import com.ruoyi.business.eval.domain.EvalLog;

public interface EvalLogMapper {

    int insertEvalLog(EvalLog log);

    List<EvalLog> selectEvalLogList(EvalLog log);

    EvalLog selectEvalLogById(Long id);

    int deleteEvalLogByIds(Long[] ids);

    Double selectAvgScore();
}
