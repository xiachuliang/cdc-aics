package com.ruoyi.ai.knowledge;

import java.io.IOException;
import java.io.InputStream;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Word 文档解析器 — 从 .docx 中提取纯文本
 *
 * <p>.docx 本质是一个 ZIP 包，里面是 XML 文件。
 * Apache POI 帮我们解析 XML，按段落（paragraph）提取文字。
 */
public class WordParser {

    private static final Logger log = LoggerFactory.getLogger(WordParser.class);

    /**
     * 解析 .docx 文件，提取纯文本
     *
     * <p>每个段落作为一个逻辑块，段落之间用双换行分隔，
     * 这样 TextSplitter 的递归切分会在段落边界上切。
     *
     * @param inputStream 文件输入流
     * @param filename    原始文件名
     * @return ParseResult（标题 + 全文）
     */
    public static ParseResult parse(InputStream inputStream, String filename) {
        StringBuilder fullText = new StringBuilder();
        try (XWPFDocument doc = new XWPFDocument(inputStream)) {
            for (XWPFParagraph para : doc.getParagraphs()) {
                String text = para.getText().trim();
                if (!text.isEmpty()) {
                    if (fullText.length() > 0) {
                        fullText.append("\n\n");  // 段落间双换行 → TextSplitter 优先在这里切
                    }
                    fullText.append(text);
                }
            }
        } catch (IOException e) {
            log.error("Word 解析失败: {}", filename, e);
            throw new RuntimeException("Word 文档解析失败: " + e.getMessage(), e);
        }

        // 标题：取文件名（去掉 .docx 后缀）
        String title = filename;
        if (title.toLowerCase().endsWith(".docx")) {
            title = title.substring(0, title.length() - 5);
        }

        log.info("Word 解析完成: {} → {} 段，{} 字符", filename,
                fullText.toString().split("\n\n").length, fullText.length());
        return new ParseResult(title, fullText.toString());
    }

    /**
     * 解析结果
     */
    public record ParseResult(String title, String content) {
    }
}
