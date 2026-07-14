package com.ruoyi.ai.agent;

/**
 * 意图识别结果
 *
 * intent   → 走 RAG / Text-to-SQL / Tools
 * ragQuery → RAG 向量检索用的改写词（去口语噪声，纯语义检索）
 */
public class IntentResult {

    private final Intent intent;
    private final String ragQuery;

    public IntentResult(Intent intent, String ragQuery) {
        this.intent = intent;
        this.ragQuery = ragQuery;
    }

    public Intent getIntent() { return intent; }
    public String getRagQuery() { return ragQuery; }
}
