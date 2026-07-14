package com.ruoyi.ai.chat;

import java.util.List;
import com.ruoyi.business.domain.Category;
import com.ruoyi.business.domain.Product;

/**
 * AI 对话返回结果，包含文本回复 + 工具调用数据（用于前端卡片渲染）
 */
public class ChatResult {

    /** AI 文本回复 */
    private String answer;

    /** 调用的工具名称（null = 纯聊天，没调工具） */
    private String toolCalled;

    /** 工具返回的商品列表 */
    private List<Product> products;

    /** 工具返回的分类列表 */
    private List<Category> categories;

    public String getAnswer() { return answer; }
    public void setAnswer(String answer) { this.answer = answer; }
    public String getToolCalled() { return toolCalled; }
    public void setToolCalled(String toolCalled) { this.toolCalled = toolCalled; }
    public List<Product> getProducts() { return products; }
    public void setProducts(List<Product> products) { this.products = products; }
    public List<Category> getCategories() { return categories; }
    public void setCategories(List<Category> categories) { this.categories = categories; }
}
