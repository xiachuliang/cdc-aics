package com.ruoyi.business.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * FAQ 变更同步注解：增/改/删 FAQ 时，AOP 自动拦截并同步 Milvus 向量库
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface FaqSync {

    enum Action { INSERT, UPDATE, DELETE }

    Action value();
}
