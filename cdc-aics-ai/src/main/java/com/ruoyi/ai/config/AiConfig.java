package com.ruoyi.ai.config;

import com.ruoyi.ai.tool.OrderTools;
import com.ruoyi.ai.tool.ProductTools;
import io.milvus.client.MilvusServiceClient;
import io.milvus.param.ConnectParam;
import io.milvus.param.IndexType;
import io.milvus.param.MetricType;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.ai.vectorstore.milvus.MilvusVectorStore;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.data.redis.core.RedisTemplate;

@Configuration
public class AiConfig {

    @Bean
    public ChatClient chatClient(ChatClient.Builder builder, ProductTools productTools, OrderTools orderTools) {
        return builder
                .defaultTools(productTools, orderTools)
                .build();
    }

    @Bean
    public ChatMemory chatMemory(RedisTemplate<String, String> redisTemplate) {
        return new RedisChatMemory(redisTemplate, 10);
    }

    @Bean("guidePrompt")
    public Resource guidePromptResource() {
        return new ClassPathResource("prompts/guide.st");
    }

    @Bean("chitchatPrompt")
    public Resource chitchatPromptResource() {
        return new ClassPathResource("prompts/chitchat.st");
    }

    /** Milvus 连接客户端 */
    @Bean
    public MilvusServiceClient milvusClient() {
        ConnectParam connectParam = ConnectParam.newBuilder()
                .withHost("localhost")
                .withPort(19530)
                .build();
        return new MilvusServiceClient(connectParam);
    }

    /** Milvus 向量库（替代 SimpleVectorStore） */
    @Bean
    public VectorStore vectorStore(MilvusServiceClient milvusClient, EmbeddingModel embeddingModel) {
        return MilvusVectorStore.builder(milvusClient, embeddingModel)
                .collectionName("cdc_products")
                .databaseName("default")
                .embeddingDimension(1024)
                .indexType(IndexType.IVF_FLAT)
                .metricType(MetricType.COSINE)
                .initializeSchema(false)
                .build();
    }
}
