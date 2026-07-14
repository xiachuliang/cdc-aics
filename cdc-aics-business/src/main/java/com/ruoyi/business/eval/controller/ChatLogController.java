package com.ruoyi.business.eval.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ruoyi.business.eval.domain.ChatLog;
import com.ruoyi.business.eval.mapper.ChatLogMapper;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;

@RestController
@RequestMapping("/ai/chatlog")
public class ChatLogController extends BaseController {

    @Autowired
    private ChatLogMapper chatLogMapper;

    @GetMapping("/list")
    public TableDataInfo list(ChatLog log) {
        startPage();
        List<ChatLog> list = chatLogMapper.selectChatLogList(log);
        return getDataTable(list);
    }

    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id) {
        return success(chatLogMapper.selectChatLogById(id));
    }

    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        chatLogMapper.deleteChatLogByIds(ids);
        return success();
    }
}
