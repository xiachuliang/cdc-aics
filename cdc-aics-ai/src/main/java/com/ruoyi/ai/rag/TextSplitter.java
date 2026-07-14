package com.ruoyi.ai.rag;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.document.Document;

/**
 * 结构感知文档切片器
 *
 * <p><b>核心思路：</b>优先在语义边界（段落/句子）上切，切不动再降级，
 * 确保每个 chunk 内容完整，不会把"使用方法"切成"使用方"+"法"。
 *
 * <p><b>切分优先级：</b>
 * <pre>
 * 段落(\n\n) → 换行(\n) → 句号(。) → 逗号(，) → 空格 → 滑动窗口兜底
 * </pre>
 *
 * <p><b>滑动窗口 overlap：</b>防止关键信息恰好落在 chunk 边界上。
 * <pre>
 * chunkSize=200, overlap=40
 * Chunk 0: [0..199]
 * Chunk 1:    [160..359]  ← 40 字重叠
 * Chunk 2:       [320..519]
 * </pre>
 */
public class TextSplitter {

    private static final Logger log = LoggerFactory.getLogger(TextSplitter.class);

    // 分隔符优先级：从大到小
    private static final String[] SEPARATORS = {
            "\n\n", "\n", "。", "！", "？", "；", "，", ". ", "! ", "? ", "; ", ", ", " "
    };

    /**
     * 结构感知切片（唯一对外方法）
     *
     * @param text      原文
     * @param chunkSize 目标每块字符数（超出才切）
     * @param overlap   滑动窗口重叠字符数
     * @param metadata  基础元数据（会复制到每个 chunk）
     * @return 切片列表；原文 <= chunkSize 时只返回一个 chunk
     */
    public static List<Document> split(String text, int chunkSize, int overlap,
                                        Map<String, Object> metadata) {
        List<Document> result = new ArrayList<>();
        splitRecursive(text, chunkSize, overlap, 0, metadata, result);
        log.debug("结构感知切片: {} 字 → {} 个 chunk（chunkSize={}, overlap={}）",
                text.length(), result.size(), chunkSize, overlap);
        return result;
    }

    // ──────────────────────────────────
    // 内部递归逻辑
    // ──────────────────────────────────

    private static void splitRecursive(String text, int chunkSize, int overlap,
                                        int sepIndex, Map<String, Object> metadata,
                                        List<Document> result) {
        // 终止条件1：文本够短，直接作为一个 chunk
        if (text.length() <= chunkSize) {
            if (!text.trim().isEmpty()) {
                result.add(buildDoc(text, metadata, result.size()));
            }
            return;
        }

        // 终止条件2：所有分隔符都用过了 → 滑动窗口硬切兜底
        if (sepIndex >= SEPARATORS.length) {
            slidingWindowFallback(text, chunkSize, overlap, metadata, result);
            return;
        }

        String sep = SEPARATORS[sepIndex];
        String[] parts = text.split(sep, -1);

        // 当前分隔符没出现 → 降级到下一级
        if (parts.length <= 1) {
            splitRecursive(text, chunkSize, overlap, sepIndex + 1, metadata, result);
            return;
        }

        // 按当前分隔符合并短片段
        StringBuilder current = new StringBuilder();
        for (String part : parts) {
            if (current.length() + part.length() + sep.length() > chunkSize
                    && current.length() > 0) {
                result.add(buildDoc(current.toString(), metadata, result.size()));

                // overlap：保留尾部字符作为下一个 chunk 的上下文
                if (overlap > 0 && current.length() > overlap) {
                    current = new StringBuilder(current.substring(current.length() - overlap));
                } else {
                    current = new StringBuilder();
                }
            }
            if (current.length() > 0) current.append(sep);
            current.append(part);
        }

        // 处理最后一个 chunk
        if (current.length() > 0 && !current.toString().trim().isEmpty()) {
            if (current.length() > chunkSize) {
                splitRecursive(current.toString(), chunkSize, overlap, sepIndex + 1, metadata, result);
            } else {
                result.add(buildDoc(current.toString(), metadata, result.size()));
            }
        }
    }

    /**
     * 兜底策略：滑动窗口硬切（所有分隔符都切不动时）
     */
    private static void slidingWindowFallback(String text, int chunkSize, int overlap,
                                               Map<String, Object> metadata,
                                               List<Document> result) {
        int step = chunkSize - overlap;
        int len = text.length();
        int start = 0;
        while (start < len) {
            int end = Math.min(start + chunkSize, len);
            result.add(buildDoc(text.substring(start, end), metadata, result.size()));
            start += step;
        }
    }

    private static Document buildDoc(String text, Map<String, Object> baseMeta, int chunkIndex) {
        Map<String, Object> meta = new HashMap<>(baseMeta);
        meta.put("chunkIndex", chunkIndex);
        return new Document(text, meta);
    }
}
