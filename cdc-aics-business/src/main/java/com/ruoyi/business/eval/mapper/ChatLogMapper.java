package com.ruoyi.business.eval.mapper;

import java.util.List;
import com.ruoyi.business.eval.domain.ChatLog;

public interface ChatLogMapper {

    int insertChatLog(ChatLog log);

    List<ChatLog> selectChatLogList(ChatLog log);

    ChatLog selectChatLogById(Long id);

    int deleteChatLogByIds(Long[] ids);
}
