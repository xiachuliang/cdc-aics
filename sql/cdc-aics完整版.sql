/*
 Navicat Premium Dump SQL

 Source Server         : xjpk
 Source Server Type    : MySQL
 Source Server Version : 80037 (8.0.37)
 Source Host           : localhost:3306
 Source Schema         : cdc-aics

 Target Server Type    : MySQL
 Target Server Version : 80037 (8.0.37)
 File Encoding         : 65001

 Date: 19/07/2026 14:43:31
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cdc_category
-- ----------------------------
DROP TABLE IF EXISTS `cdc_category`;
CREATE TABLE `cdc_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `scene_id` bigint NOT NULL COMMENT '所属场景ID',
  `category_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父分类ID（0=顶级）',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0启用 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_category
-- ----------------------------
INSERT INTO `cdc_category` VALUES (1, 1, '零食', 0, 1, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_category` VALUES (2, 1, '饮料', 0, 2, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_category` VALUES (3, 1, '日用品', 0, 3, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_category` VALUES (4, 1, '生鲜', 0, 4, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_category` VALUES (5, 1, '调味品', 0, 5, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_category` VALUES (6, 1, '酒类', 0, 6, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_category` VALUES (7, 2, '感冒用药', 0, 1, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_category` VALUES (8, 2, '消炎药', 0, 2, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_category` VALUES (9, 2, '消化用药', 0, 3, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_category` VALUES (10, 2, '保健品', 0, 4, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_category` VALUES (11, 2, '外用药', 0, 5, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_category` VALUES (12, 3, '文学小说', 0, 1, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_category` VALUES (13, 3, '计算机', 0, 2, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_category` VALUES (14, 3, '经管励志', 0, 3, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_category` VALUES (15, 3, '少儿读物', 0, 4, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_category` VALUES (16, 3, '文具用品', 0, 5, '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');

-- ----------------------------
-- Table structure for cdc_chat_log
-- ----------------------------
DROP TABLE IF EXISTS `cdc_chat_log`;
CREATE TABLE `cdc_chat_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `session_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '会话ID',
  `question` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户问题',
  `answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'AI回答',
  `intent` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '意图分类',
  `agent` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '处理Agent(RAG/TextToSQL/Tools)',
  `latency_ms` bigint NULL DEFAULT 0 COMMENT '响应耗时(毫秒)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_session_id`(`session_id` ASC) USING BTREE,
  INDEX `idx_intent`(`intent` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 122 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI对话日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_chat_log
-- ----------------------------
INSERT INTO `cdc_chat_log` VALUES (1, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么推荐？', '抱歉，没有找到相关商品，您可以换个关键词试试。', 'CONSULTATION', 'CONSULTATION', 1934, '2026-07-13 14:36:13');
INSERT INTO `cdc_chat_log` VALUES (2, 'cba0c777a1084ea5a022f79ffcc7342f', '最便宜的是什么？', '抱歉，没有找到相关商品，您可以换个关键词试试。', 'CONSULTATION', 'CONSULTATION', 1283, '2026-07-13 14:36:20');
INSERT INTO `cdc_chat_log` VALUES (3, 'cba0c777a1084ea5a022f79ffcc7342f', '帮我找零食', '抱歉，没有找到相关商品，您可以换个关键词试试。', 'CONSULTATION', 'CONSULTATION', 1177, '2026-07-13 14:36:23');
INSERT INTO `cdc_chat_log` VALUES (4, 'cba0c777a1084ea5a022f79ffcc7342f', '有笔吗', '有的！超市**文具区**有**晨光中性笔**（K-35按动款），0.5mm黑色，书写顺滑，**2.5元/支**。需要帮您拿一支吗？✍️', 'CONSULTATION', 'CONSULTATION', 3064, '2026-07-13 14:36:56');
INSERT INTO `cdc_chat_log` VALUES (5, 'cba0c777a1084ea5a022f79ffcc7342f', '帮我找零食', '抱歉，没有找到相关商品，您可以换个关键词试试。', 'CONSULTATION', 'CONSULTATION', 1302, '2026-07-13 14:38:50');
INSERT INTO `cdc_chat_log` VALUES (6, 'cba0c777a1084ea5a022f79ffcc7342f', '帮我找零食', '帮你找到了5种零食：乐事原味薯片（8.5元/袋）、奥利奥夹心饼干（12.8元/盒）、三只松鼠每日坚果（45元/盒）、良品铺子牛肉干（29.9元/袋）和旺旺仙贝（15元/袋）。都摆放在**A区**，库存充足。比较推荐乐事薯片和奥利奥饼干，性价比高～😊 想了解哪个的具体位置？', 'ANALYTICS', 'ANALYTICS', 4639, '2026-07-13 14:40:59');
INSERT INTO `cdc_chat_log` VALUES (7, 'cba0c777a1084ea5a022f79ffcc7342f', '有哪些饮料', '帮你找到了5种饮料：可口可乐（3元/瓶）、农夫山泉矿泉水（2元/瓶）、蒙牛纯牛奶（5.5元/盒）、统一冰红茶（3.5元/瓶）和美汁源果粒橙（4元/瓶）。都在**B区**，库存很充足！推荐性价比高的矿泉水，或者冰镇可乐更爽口🥤', 'ANALYTICS', 'ANALYTICS', 3621, '2026-07-13 14:41:19');
INSERT INTO `cdc_chat_log` VALUES (8, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么推荐？', '抱歉，没有找到相关商品，您可以换个关键词试试。', 'CONSULTATION', 'CONSULTATION', 1053, '2026-07-13 14:41:28');
INSERT INTO `cdc_chat_log` VALUES (9, 'cba0c777a1084ea5a022f79ffcc7342f', '有笔吗', '当然有！我们店里有一款**晨光K-35按动中性笔**，0.5mm黑色笔芯，书写顺滑，非常适合日常办公或学习使用。价格只要 **2.50元** 一支，很实惠哦！需要帮您拿一支吗？😊', 'CONSULTATION', 'CONSULTATION', 4032, '2026-07-13 16:15:09');
INSERT INTO `cdc_chat_log` VALUES (10, 'cba0c777a1084ea5a022f79ffcc7342f', '有活着这本书吗', '有的！余华的《活着》是北京十月文艺出版社的版本，讲述了一个人一生的故事，展现中国近现代历史的变迁，豆瓣评分高达9.4。价格是**35.00元**，非常值得一读！需要帮您拿一本吗？😊', 'CONSULTATION', 'CONSULTATION', 2548, '2026-07-13 16:15:45');
INSERT INTO `cdc_chat_log` VALUES (11, 'cba0c777a1084ea5a022f79ffcc7342f', '帮我找零食', '抱歉，数据分析暂时不可用。【SQL包含危险关键字: CREATE】', 'ANALYTICS', 'ANALYTICS', 4389, '2026-07-13 19:30:27');
INSERT INTO `cdc_chat_log` VALUES (12, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么零食', 'AI 服务暂时不可用，请稍后再试。', 'CONSULTATION', 'CONSULTATION', 1908, '2026-07-13 19:31:05');
INSERT INTO `cdc_chat_log` VALUES (13, 'cba0c777a1084ea5a022f79ffcc7342f', '有可乐吗', 'AI 服务暂时不可用，请稍后再试。', 'CONSULTATION', 'CONSULTATION', 2003, '2026-07-13 19:31:31');
INSERT INTO `cdc_chat_log` VALUES (14, 'cba0c777a1084ea5a022f79ffcc7342f', '有哪些商品', '抱歉，数据分析暂时不可用。【SQL包含危险关键字: CREATE】', 'ANALYTICS', 'ANALYTICS', 2666, '2026-07-13 19:33:13');
INSERT INTO `cdc_chat_log` VALUES (15, 'cba0c777a1084ea5a022f79ffcc7342f', '冰红茶', 'AI 服务暂时不可用，请稍后再试。', 'CONSULTATION', 'CONSULTATION', 2176, '2026-07-13 19:34:39');
INSERT INTO `cdc_chat_log` VALUES (16, 'cba0c777a1084ea5a022f79ffcc7342f', '你好', 'AI 服务暂时不可用，请稍后再试。', 'CONSULTATION', 'CONSULTATION', 1340, '2026-07-13 20:36:48');
INSERT INTO `cdc_chat_log` VALUES (17, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么推荐？', 'AI 服务暂时不可用，请稍后再试。', 'CONSULTATION', 'CONSULTATION', 3490, '2026-07-13 21:32:51');
INSERT INTO `cdc_chat_log` VALUES (18, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么推荐？', 'AI 服务暂时不可用，请稍后再试。', 'CONSULTATION', 'CONSULTATION', 2200, '2026-07-13 21:46:55');
INSERT INTO `cdc_chat_log` VALUES (19, 'cba0c777a1084ea5a022f79ffcc7342f', '你好', '抱歉，没有找到相关信息，您可以换个问法试试。', 'CONSULTATION', 'CONSULTATION', 2445, '2026-07-13 21:53:30');
INSERT INTO `cdc_chat_log` VALUES (20, 'cba0c777a1084ea5a022f79ffcc7342f', '你好', '抱歉，没有找到相关信息，您可以换个问法试试。', 'CONSULTATION', 'CONSULTATION', 3170, '2026-07-13 22:17:52');
INSERT INTO `cdc_chat_log` VALUES (21, 'cba0c777a1084ea5a022f79ffcc7342f', '怎么退货', '退货需在购买后7天内，带购物小票和商品到服务台办理。商品要原包装完好，食品类开封后不退。退款3个工作日内原路返回。如有其他问题，随时问我哦~', 'CONSULTATION', 'CONSULTATION', 3580, '2026-07-13 22:18:00');
INSERT INTO `cdc_chat_log` VALUES (22, 'cba0c777a1084ea5a022f79ffcc7342f', '有啤酒吗', '我帮您查一下有没有啤酒！\n\n有呢！🍺 **青岛啤酒经典1903**，330ml罐装，**5元/罐**，库存充足有200罐～\n\n📍 在 **F区-1排-1层** 就能找到，清爽口感，来几罐？😄', 'OPERATION', 'OPERATION', 2365, '2026-07-13 22:18:10');
INSERT INTO `cdc_chat_log` VALUES (23, 'cba0c777a1084ea5a022f79ffcc7342f', '你们商城有哪些商品', '目前商城共有30种商品在售，涵盖零食、饮品、日用品、生鲜和调料等品类。零食区有薯片、饼干、坚果等，价格从8.5元到45元；饮品区有可乐、矿泉水、牛奶和啤酒，2-5元；日用品区有洗衣液、纸巾、牙膏等，15-45元；生鲜区有五花肉、西红柿、苹果，6.8-28元；调料区有酱油和食用油，12.8-59.9元。库存充足，随时可购买！', 'ANALYTICS', 'ANALYTICS', 4078, '2026-07-13 22:18:29');
INSERT INTO `cdc_chat_log` VALUES (24, 'cba0c777a1084ea5a022f79ffcc7342f', '微信看看饮料有哪些', '商城饮料有6种，都在B区哦！🍹\n\n- **可口可乐** 3元/瓶，库存200瓶\n- **农夫山泉矿泉水** 2元/瓶，库存300瓶\n- **蒙牛纯牛奶** 5.5元/盒，库存150盒\n- **统一冰红茶** 3.5元/瓶，库存180瓶\n- **美汁源果粒橙** 4元/瓶，库存120瓶\n- **茶派** 5元/件，库存超多11000件\n\n价格2-5.5元，都很实惠，快来选购吧！😄', 'ANALYTICS', 'ANALYTICS', 4978, '2026-07-13 22:18:47');
INSERT INTO `cdc_chat_log` VALUES (25, 'cba0c777a1084ea5a022f79ffcc7342f', '你好', '你好呀！我是小智，很高兴为你服务！😊 有什么需要帮忙的吗？', 'CONSULTATION', 'CONSULTATION', 3940, '2026-07-13 22:27:40');
INSERT INTO `cdc_chat_log` VALUES (26, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么推荐', '你好呀！😊 欢迎随时逛逛，我们商城商品种类挺丰富的～零食、饮料、日用品、生鲜都有，比如乐事薯片、可口可乐、蓝月亮洗衣液都很受欢迎。你想看看哪类商品呢？我帮你详细介绍！', 'CONSULTATION', 'CONSULTATION', 3479, '2026-07-13 22:28:02');
INSERT INTO `cdc_chat_log` VALUES (27, 'cba0c777a1084ea5a022f79ffcc7342f', '蓝月亮洗衣液', '蓝月亮洗衣液目前有售，**29.9元/瓶**，库存80瓶，在**C区-1排-1层**，欢迎来选购！😊', 'CONSULTATION', 'CONSULTATION', 2742, '2026-07-13 22:29:47');
INSERT INTO `cdc_chat_log` VALUES (28, 'cba0c777a1084ea5a022f79ffcc7342f', '蓝月亮', '好的，我帮你查一下蓝月亮洗衣液的信息蓝月亮洗衣液有售哦！🧼\n\n**商品信息：**\n- **名称：** 蓝月亮洗衣液（薰衣草香，1kg瓶装）\n- **价格：** **29.9元/瓶**\n- **库存：** 80瓶\n- **位置：** C区-1排-1层\n- **特点：** 深层清洁，薰衣草清香\n\n库存充足，价格实惠，欢迎来C区选购！😊', 'OPERATION', 'OPERATION', 4642, '2026-07-13 22:31:05');
INSERT INTO `cdc_chat_log` VALUES (29, 'cba0c777a1084ea5a022f79ffcc7342f', '蓝月亮洗衣液', '好的，我帮你查一下蓝月亮洗衣液的信息蓝月亮洗衣液有售哦！🧼\n\n**商品信息：**\n- **名称：** 蓝月亮洗衣液（薰衣草香，1kg瓶装）\n- **价格：** **29.9元/瓶**\n- **库存：** 80瓶\n- **位置：** C区-1排-1层\n- **特点：** 深层清洁，薰衣草清香\n\n库存充足，价格实惠，欢迎来C区选购！😊', 'OPERATION', 'OPERATION', 4651, '2026-07-13 22:32:21');
INSERT INTO `cdc_chat_log` VALUES (30, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么推荐？', '你好呀！😊 我们超市商品种类挺丰富的～零食、饮料、日用品、生鲜都有。你刚才问的蓝月亮洗衣液就很不错哦！想看看其他哪类商品呢？我帮你详细介绍！', 'CONSULTATION', 'CONSULTATION', 3143, '2026-07-13 22:33:22');
INSERT INTO `cdc_chat_log` VALUES (31, 'cba0c777a1084ea5a022f79ffcc7342f', '最便宜的是什么？', '最便宜的商品是**农夫山泉矿泉水**，只要2块钱！', 'ANALYTICS', 'ANALYTICS', 4741, '2026-07-14 09:32:49');
INSERT INTO `cdc_chat_log` VALUES (32, 'cba0c777a1084ea5a022f79ffcc7342f', '我想买草房子这本书', '好的，我来帮您搜索一下！\n\n找到啦！📚 **《草房子》** 售价 **20元/件**，目前库存充足（100件）。\n\n请问您想要买几本呢？', 'OPERATION', 'OPERATION', 5470, '2026-07-14 10:03:09');
INSERT INTO `cdc_chat_log` VALUES (33, 'cba0c777a1084ea5a022f79ffcc7342f', '1本', '好的，我先查一下《草房子》的详细信息确认商品ID，然后帮您加购好的，我来帮您把1本《草房子》加入购物车！\n\n好的！**《草房子》1本已加入购物车** ✅ 合计**20元**。\n\n请问您还需要再买点别的吗？如果不需要，我可以帮您下单～', 'OPERATION', 'OPERATION', 6860, '2026-07-14 10:03:28');
INSERT INTO `cdc_chat_log` VALUES (34, 'cba0c777a1084ea5a022f79ffcc7342f', '帮我下单', '好的，我来先查看一下您的购物车内容，请您确认！\n\n好的！我来帮您确认一下购物车内容 🛒\n\n**购物车清单：**\n- 📚 **《草房子》** × 1本 — **20元**\n- **合计：20元**\n\n确认没问题的话，请提供您的 **手机号**，我马上帮您下单！', 'OPERATION', 'OPERATION', 5354, '2026-07-14 10:06:10');
INSERT INTO `cdc_chat_log` VALUES (35, 'cba0c777a1084ea5a022f79ffcc7342f', '15519142296', '好的，我现在就帮您下单！📝\n\n看起来系统出现了技术问题，下单时遇到了一点小故障 😅\n\n我已经记录了您的手机号 **15519142296**，但系统暂时无法完成下单操作。请您稍后再试，或者联系超市工作人员处理。\n\n目前您的购物车内容如下：\n- 📚 **《草房子》** × 1本 — **20元**\n\n非常抱歉给您带来不便！您看需要我再帮您试试吗？', 'OPERATION', 'OPERATION', 5454, '2026-07-14 10:06:27');
INSERT INTO `cdc_chat_log` VALUES (36, 'cba0c777a1084ea5a022f79ffcc7342f', '我想买草房子这本书', '好的，我先搜索一下《草房子》这本书的信息找到了！📚 **《草房子》** 售价 **20元/件**，库存充足（100件）。\n\n请问您想要买几本呢？', 'OPERATION', 'OPERATION', 2619, '2026-07-14 10:10:08');
INSERT INTO `cdc_chat_log` VALUES (37, 'cba0c777a1084ea5a022f79ffcc7342f', '1', '好的，我先搜索一下《草房子》这本书的信息好的！📚 **《草房子》** 售价 **20元/件**，库存充足（100件）。请问您想要买几本呢？', 'OPERATION', 'OPERATION', 4686, '2026-07-14 10:10:19');
INSERT INTO `cdc_chat_log` VALUES (38, 'cba0c777a1084ea5a022f79ffcc7342f', '1本', '好的，我先搜索一下《草房子》这本书的信息。\n\n好的，我来帮您把1本《草房子》加入购物车！\n\n让我查看一下购物车目前的情况我看到当前购物车中已经有2本《草房子》了，刚才又加购了1本，我来帮您整理一下。\n\n好的！根据之前的信息，您的购物车中已有**2本《草房子》**，现在又帮您加入了**1本**。不过系统显示当前购物车总共有 **2本**（合计40元），似乎是此前已加购了2本。\n\n请您查看一下当前购物车内容 🛒\n\n**购物车清单：**\n- 📚 **《草房子》** × **2本** — **40元**\n\n请问您是想要总共买1本，还是保持现在的2本呢？我可以帮您调整数量！', 'OPERATION', 'OPERATION', 12793, '2026-07-14 10:10:43');
INSERT INTO `cdc_chat_log` VALUES (39, 'cba0c777a1084ea5a022f79ffcc7342f', '你好', '哈喽，你好呀！😊 我是超市智能导购小智，很高兴为你服务！有什么想买的、想聊的，尽管告诉我，我随时在线～', 'CONSULTATION', 'CONSULTATION', 3929, '2026-07-14 10:18:37');
INSERT INTO `cdc_chat_log` VALUES (40, 'cba0c777a1084ea5a022f79ffcc7342f', '我想买可口可乐', '好的，我先搜索一下可口可乐的信息找到了！🥤 **可口可乐** 售价 **3元/瓶**，库存充足（200瓶），在 **B区-1排-1层** 货架。\n\n请问您想买几瓶呢？😊', 'OPERATION', 'OPERATION', 3929, '2026-07-14 10:18:55');
INSERT INTO `cdc_chat_log` VALUES (41, 'cba0c777a1084ea5a022f79ffcc7342f', '来一瓶', '好的，我先搜索一下可口可乐的商品信息！\n\n好的！🥤 **可口可乐** 售价 **3元/瓶**，库存充足（200瓶）。您说\"来一瓶\"，我帮您加购1瓶到购物车哈好嘞！🥤 已帮您将 **1瓶可口可乐（3元）** 加入购物车啦！\n\n目前购物车内容如下：\n- 📚 **《草房子》** × **2本** — 40元\n- 🥤 **可口可乐** × **1瓶** — 3元\n- **总计：43元**\n\n请问还需要加点什么吗？如果现在想下单，随时告诉我～😊', 'OPERATION', 'OPERATION', 4858, '2026-07-14 10:19:09');
INSERT INTO `cdc_chat_log` VALUES (42, 'cba0c777a1084ea5a022f79ffcc7342f', '我的购物车里有哪些东西', '好的，我马上帮您查看购物车！\n\n好的！我来看看您的购物车📋\n\n目前购物车里有 **2种商品**，总计 **43元**：\n\n1. 🥤 **可口可乐** × **1瓶** — 3元\n2. 📚 **草房子** × **2本** — 40元\n\n请问还需要加点什么吗？如果想下单，告诉我一声就好～😊', 'OPERATION', 'OPERATION', 2938, '2026-07-14 10:20:09');
INSERT INTO `cdc_chat_log` VALUES (43, 'mrk13lel', '你好', '哈喽你好呀！😊 我是超市智能导购小智，很高兴为你服务！有什么想买的或者想聊的，尽管告诉我，我随时在线～', 'CONSULTATION', 'CONSULTATION', 2897, '2026-07-14 10:25:12');
INSERT INTO `cdc_chat_log` VALUES (44, 'mrk13lel', '我想买可口可乐', '好的，我先搜索一下可口可乐的信息找到了！🥤 **可口可乐** 售价 **3元/瓶**，库存充足（200瓶），在 **B区-1排-1层** 货架。\n\n请问您想买几瓶呢？😊', 'OPERATION', 'OPERATION', 3284, '2026-07-14 10:25:29');
INSERT INTO `cdc_chat_log` VALUES (45, 'mrk13lel', '1瓶', '好的，我先搜索一下可口可乐的信息确认库存好的，我来帮您加购1瓶！\n\n不过我看到您的购物车里已经有 **1瓶可口可乐（3元）** 了，再加上这次的1瓶，总数量会变成 **2瓶**，我帮您加进去，可以吗？😊\n\n还是说您想先确认一下再说？', 'OPERATION', 'OPERATION', 3068, '2026-07-14 10:25:39');
INSERT INTO `cdc_chat_log` VALUES (46, 'mrk13lel', '我的购物车里有什么', '好的，我马上帮您查看购物车！\n\n好的！来看看您的购物车📋\n\n目前有 **2种商品**，总计 **43元**：\n\n1. 🥤 **可口可乐** × **1瓶** — 3元\n2. 📚 **草房子** × **2本** — 40元\n\n请问还需要加购什么吗？或者想直接下单呢？😊', 'OPERATION', 'OPERATION', 4113, '2026-07-14 10:26:01');
INSERT INTO `cdc_chat_log` VALUES (47, 'mrk24ik2', '你好', '你好呀！我是小智，很高兴为你服务！有什么需要帮忙的吗？😊', 'CONSULTATION', 'CONSULTATION', 4379, '2026-07-14 10:53:59');
INSERT INTO `cdc_chat_log` VALUES (48, 'mrk24ik2', '我想买可口可乐一瓶', '好的，我先搜索一下可口可乐的信息好的！找到了～**可口可乐**，3.00元/瓶，库存还有200瓶，在B区-1排-1层。\n\n请问您要买 **1瓶** 吗？我直接帮您加购物车～😊', 'OPERATION', 'OPERATION', 4087, '2026-07-14 10:54:40');
INSERT INTO `cdc_chat_log` VALUES (49, 'mrk24ik2', '加入购物车', '好的，我先查一下可口可乐的商品ID，然后帮您加购物车好的，之前已经查到可口可乐信息了！现在帮您加购1瓶～\n\n已经帮您把 **1瓶可口可乐** 加入购物车啦！🎉\n\n📌 **购物车当前内容：**\n- 可口可乐 × 1瓶 — **¥3.00**\n\n✅ 总共 **¥3.00**\n\n需要下单购买吗？或者还想再逛逛其他商品？😊', 'OPERATION', 'OPERATION', 4853, '2026-07-14 10:54:53');
INSERT INTO `cdc_chat_log` VALUES (50, 'mrk24ik2', '我的购物车里有什么', '好的，我帮您查一下购物车内容您购物车目前有：\n\n🛒 **1种商品，合计¥3.00**\n- 可口可乐 × **1瓶** — **¥3.00**\n\n需要下单购买吗？或者再逛逛加购其他东西？😊', 'OPERATION', 'OPERATION', 2996, '2026-07-14 10:55:03');
INSERT INTO `cdc_chat_log` VALUES (51, 'mrk2krc7', '有没有矿泉水，我想来一瓶', '我来搜索一下矿泉水找到了！**农夫山泉矿泉水**，2.00元/瓶，库存还有300瓶，在B区-1排-2层。\n\n请问要帮您加购 **1瓶** 吗？😊', 'OPERATION', 'OPERATION', 3200, '2026-07-14 11:06:46');
INSERT INTO `cdc_chat_log` VALUES (52, 'mrk2krc7', '来一瓶', '好的，我先查一下之前搜到的农夫山泉矿泉水的商品ID，帮您加购1瓶好的，之前已经查到了！**农夫山泉矿泉水**，**2.00元/瓶**，库存充足～帮您加购1瓶！\n\n好嘞！已经帮您加购 **1瓶农夫山泉矿泉水** 🎉\n\n🛒 **当前购物车内容：**\n- 可口可乐 × 1瓶 — ¥3.00\n- 农夫山泉矿泉水 × 1瓶 — ¥2.00\n\n✅ **合计：¥5.00**\n\n需要下单购买吗？还是再逛逛其他商品？😊', 'OPERATION', 'OPERATION', 4392, '2026-07-14 11:07:19');
INSERT INTO `cdc_chat_log` VALUES (53, 'mrk2krc7', '我的购物车里有什么', '好的，我帮您查一下购物车内容您购物车目前有：\n\n🛒 **2种商品，合计¥5.00**\n- 可口可乐 × **1瓶** — **¥3.00**\n- 农夫山泉矿泉水 × **1瓶** — **¥2.00**\n\n需要下单购买吗？还是再逛逛加购其他东西？😊', 'OPERATION', 'OPERATION', 4238, '2026-07-14 11:07:34');
INSERT INTO `cdc_chat_log` VALUES (54, 'mrk2krc7', '我的购物车里有什么', '好的，我帮您查一下购物车内容您购物车目前有：\n\n🛒 **2种商品，合计¥5.00**\n- 可口可乐 × **1瓶** — **¥3.00**\n- 农夫山泉矿泉水 × **1瓶** — **¥2.00**\n\n需要下单购买吗？还是再逛逛加购其他东西？😊', 'OPERATION', 'OPERATION', 6003, '2026-07-14 11:13:56');
INSERT INTO `cdc_chat_log` VALUES (55, 'mrk2krc7', '你好', '你好呀！我是超市智能导购小智，很高兴为你服务！有需要了解的商品吗，或者想看看购物车？😊', 'CONSULTATION', 'CONSULTATION', 6037, '2026-07-14 11:23:51');
INSERT INTO `cdc_chat_log` VALUES (56, 'mrk2krc7', '我想买啤酒', '好的，我马上帮您搜索啤酒！\n\n找到啦！**青岛啤酒**，5.00元/罐，库存200罐，在F区-1排-1层。🍺\n\n请问您想要几罐呢？😊', 'OPERATION', 'OPERATION', 6084, '2026-07-14 11:24:18');
INSERT INTO `cdc_chat_log` VALUES (57, 'mrk2krc7', '来10罐吧', '好的，马上帮您加购10罐青岛啤酒看起来加购的商品ID不对，我先查一下啤酒的商品信息好的，之前搜到的是**青岛啤酒**，5.00元/罐，库存200罐，够的！我来帮您加购10罐～\n\n不过刚才加购的好像是乐事薯片，我先查一下青岛啤酒的商品ID。\n\n抱歉，刚才加购错了，先帮您把薯片移除，重新加购10罐青岛啤酒！\n\n好嘞！已经帮您加购 **10罐青岛啤酒** 🍺🎉\n\n🛒 **当前购物车内容：**\n- 青岛啤酒 × **10罐** — **¥50.00**\n\n✅ **合计：¥50.00**\n\n库存充足，放心下单！需要帮您下单购买吗？😊', 'OPERATION', 'OPERATION', 13246, '2026-07-14 11:24:44');
INSERT INTO `cdc_chat_log` VALUES (58, 'mrk2krc7', '我的购物车里有什么', '好的，我帮您查一下购物车内容！\n\n好的，您购物车目前有：\n\n🛒 **1种商品，合计¥50.00**\n- 青岛啤酒 × **10罐** — **¥50.00**\n\n库存充足，需要帮您下单购买吗？😊', 'OPERATION', 'OPERATION', 3436, '2026-07-14 11:25:20');
INSERT INTO `cdc_chat_log` VALUES (59, 'mrk2krc7', '下单，号码15519142296', '好的，我先查一下购物车内容让您确认！\n\n好的，我来帮您确认一下购物车内容：\n\n🛒 **购物车确认：**\n- 青岛啤酒 × **10罐** — **¥50.00**\n- **合计：¥50.00**\n\n确认没问题，现在帮您下单！📦好的，先帮您确认一下购物车内容 ✅\n\n🛒 **购物车确认：**\n- 青岛啤酒 × **10罐** — **¥50.00**\n\n**合计：¥50.00**\n\n现在帮您下单～\n\n🎉 **下单成功！** 🎉\n\n📋 **订单信息：**\n- **订单号：** XS202607140001\n- **商品：** 青岛啤酒 × 10罐\n- **总金额：** ¥50.00\n- **手机号：** 155****2296\n\n感谢您的购买，小智祝您喝得开心！🍺😊', 'OPERATION', 'OPERATION', 8696, '2026-07-14 11:26:22');
INSERT INTO `cdc_chat_log` VALUES (60, 'mrk2krc7', '啤酒', '好的，我来查查超市有哪些啤酒！\n\n找到了！🍺\n\n**青岛啤酒**（经典1903，330ml罐装）\n- 💰 价格：**5.00元/罐**\n- 📦 库存：190罐，充足！\n- 📍 位置：**F区-1排-1层**\n\n请问您想买几罐呢？😊', 'OPERATION', 'OPERATION', 6244175, '2026-07-14 16:19:25');
INSERT INTO `cdc_chat_log` VALUES (61, 'mrk2krc7', '你好', '你好！欢迎光临，我是小智！😊 有什么需要帮忙的吗？比如想找什么商品、了解优惠活动，或者随便聊聊都可以哦～', 'CONSULTATION', 'CONSULTATION', 4052, '2026-07-14 16:20:07');
INSERT INTO `cdc_chat_log` VALUES (62, 'mrk2krc7', '啤酒', '好的，我来帮您查一下啤酒的信息！\n\n找到啦！🍺\n\n**青岛啤酒**（经典1903，330ml罐装）\n- 💰 **5元/罐**\n- 📦 库存充足（190罐）\n- 📍 **F区-1排-1层**\n\n请问您想要几罐呢？我来帮您加入购物车～', 'OPERATION', 'OPERATION', 5910, '2026-07-14 18:25:58');
INSERT INTO `cdc_chat_log` VALUES (63, 'mrk2krc7', '来2瓶', '好的，我来帮您加购2罐青岛啤酒！\n\n看起来刚才加购的是薯片，我再查一下啤酒的商品ID，重新帮您加购啤酒哈～先搜索一下啤酒的信息。\n\n抱歉，刚才系统有点小状况！我来重新帮您加购啤酒🍺\n\n青岛啤酒（经典1903，330ml罐装）**5元/罐**，您要2罐，我这就帮您加购～\n\n好嘞！🍺 已经帮您把 **2罐青岛啤酒** 加入购物车啦～\n\n当前购物车内容：\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🍺 青岛啤酒 ×2 | 2罐 | ¥10.00 |\n| 🥔 乐事原味薯片×2 | - | ¥17.00 |\n| **合计** | | **¥27.00** |\n\n请问还需要加购其他商品吗？如果没问题，要帮您下单吗😊', 'OPERATION', 'OPERATION', 8779, '2026-07-14 18:26:13');
INSERT INTO `cdc_chat_log` VALUES (64, 'mrk2krc7', '下单，15519142296', '好的！我先查一下购物车的最新内容，让您确认一下好的，我先帮您确认一下购物车内容 🛒\n\n**当前购物车：**\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🥔 乐事原味薯片 | ×2 | ¥17.00 |\n| 🍺 青岛啤酒（经典1903） | ×2 | ¥10.00 |\n| **合计** | | **¥27.00** |\n\n请问要使用手机号 **155****2296** 下单吗？另外，方便告诉我您的姓名吗😊', 'OPERATION', 'OPERATION', 4774, '2026-07-14 18:26:33');
INSERT INTO `cdc_chat_log` VALUES (65, 'mrk2krc7', '朱茂林', '好的，我来先查一下购物车的最新内容，让您最后确认一下，然后帮您下单好的！购物车确认没问题，现在帮您下单～\n\n**购物车内容：**\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🥔 乐事原味薯片 | ×2 | ¥17.00 |\n| 🍺 青岛啤酒 | ×2 | ¥10.00 |\n| **合计** | | **¥27.00** |\n\n正在为您下单，手机号 **155****2296**，姓名 **朱茂林** 🎉\n\n好的，朱茂林先生！我已经看到您的信息啦～\n\n不过系统显示下单时出现了订单号重复的临时故障，让我再帮您试一次下单 😊\n\n不好意思，朱先生，系统出现了一个小故障导致下单失败（订单号重复问题），非常抱歉！😅\n\n麻烦您再跟我说一下\"下单\"，我重新帮您提交一次，好吗？', 'OPERATION', 'OPERATION', 8599, '2026-07-14 18:26:50');
INSERT INTO `cdc_chat_log` VALUES (66, 'mrk2krc7', '我的购物车里有什么', '好的，我帮您查看一下购物车内容！\n\n朱茂林先生，您当前购物车里有：🛒\n\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🍺 青岛啤酒（经典1903） | ×2 | ¥10.00 |\n| **合计** | | **¥10.00** |\n\n刚刚薯片已经下单成功了，所以现在只剩啤酒啦～需要继续加购其他商品，或者直接下单吗😊', 'OPERATION', 'OPERATION', 5066, '2026-07-14 18:27:22');
INSERT INTO `cdc_chat_log` VALUES (67, 'mrk2krc7', '为什么要名字，之前下单不是号码就行了嘛', '之前下单需要手机号来联系您，而姓名是为了确认收货人信息更准确，避免送错哦～不过您放心，现在系统已经记录您的信息了，下次来直接说“下单”就行，很方便吧😊 需要我帮您继续下单吗？', 'CONSULTATION', 'CONSULTATION', 4275, '2026-07-14 18:27:55');
INSERT INTO `cdc_chat_log` VALUES (68, 'mrk2krc7', '下单。', '好的，我先查一下购物车最新内容，让您确认！\n\n好的，朱茂林先生！先给您展示一下购物车内容确认：\n\n**当前购物车：🛒**\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🍺 青岛啤酒（经典1903） | ×2 | ¥10.00 |\n| **合计** | | **¥10.00** |\n\n确认没问题，我现在帮您下单，手机号 **155****2296**，姓名 **朱茂林** 🎉\n\n朱先生，不好意思，系统又出现了和之前一样的订单号重复故障 😅\n\n麻烦您再跟我说一次\"下单\"，我重新帮您提交，应该就能成功了！', 'OPERATION', 'OPERATION', 8812, '2026-07-14 18:28:12');
INSERT INTO `cdc_chat_log` VALUES (69, 'mrk2krc7', '我的购物车里有什么', '好的，我帮您查一下购物车内容朱茂林先生，您当前购物车里有：🛒\n\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🍺 青岛啤酒（经典1903） | ×2 | ¥10.00 |\n| **合计** | | **¥10.00** |\n\n之前乐事薯片已经下单成功啦，所以现在就剩啤酒啦～需要继续加购其他商品，或者直接下单吗😊', 'OPERATION', 'OPERATION', 6684, '2026-07-14 18:31:56');
INSERT INTO `cdc_chat_log` VALUES (70, 'mrk2krc7', '下单', '好的，我先查一下购物车最新内容，让您确认好的，朱茂林先生！先给您展示购物车确认：\n\n**当前购物车：🛒**\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🍺 青岛啤酒（经典1903） | ×2 | ¥10.00 |\n| **合计** | | **¥10.00** |\n\n确认没问题，现在帮您下单！手机号 **155****2296**，姓名 **朱茂林** 🎉\n\n朱茂林先生，下单成功啦！🎉\n\n**订单信息：**\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🍺 青岛啤酒（经典1903） | ×2 | ¥10.00 |\n| **合计** | | **¥10.00** |\n\n**订单号：** XS202607140002\n**收货手机：** 155****2296\n\n这次系统没再出故障，顺利搞定～感谢您的支持，欢迎下次再来超市逛逛😊', 'OPERATION', 'OPERATION', 6807, '2026-07-14 18:32:19');
INSERT INTO `cdc_chat_log` VALUES (71, 'mrk2krc7', '给我买东西，一瓶矿泉水', '好的！我先搜索一下矿泉水的商品信息。\n\n查到了！**农夫山泉矿泉水**，550ml瓶装，**2.00元/瓶**，货架在B区-1排-2层，库存充足。\n\n确认一下，您要买 **1瓶** 对吗？我这就帮您加入购物车~', 'OPERATION', 'OPERATION', 4726, '2026-07-14 20:20:24');
INSERT INTO `cdc_chat_log` VALUES (72, 'mrk2krc7', '1瓶', '好的，我来帮您把1瓶农夫山泉矿泉水加入购物车好的！我来帮您加购 **1瓶农夫山泉矿泉水**，库存充足，马上加入购物车好嘞！**1瓶农夫山泉矿泉水（550ml）** 已加入购物车，共 **¥2.00** ✅\n\n请问还需要加购其他商品吗？如果不需要，我可以帮您**下单**，需要您提供一下手机号～', 'OPERATION', 'OPERATION', 8683, '2026-07-14 20:20:45');
INSERT INTO `cdc_chat_log` VALUES (73, 'mrk2krc7', '下单', '好的，我先查看一下您的购物车内容，请您确认后再下单好的！您的购物车内容如下：\n\n🛒 **购物车清单**\n- 农夫山泉矿泉水（550ml）× **1瓶** — **¥2.00**\n- **合计：¥2.00**\n\n确认下单吗？如果没问题，请提供您的**手机号**，我马上帮您下单～😊', 'OPERATION', 'OPERATION', 5638, '2026-07-14 20:21:06');
INSERT INTO `cdc_chat_log` VALUES (76, 'mrk2krc7', '你好', '你好呀！我是小智，很高兴见到你！今天心情怎么样？有什么需要我帮忙的吗？比如找点好吃的或者好用的，我都可以帮你推荐哦～😊', 'CHITCHAT', 'CHITCHAT', 4477, '2026-07-14 21:20:06');
INSERT INTO `cdc_chat_log` VALUES (77, 'mrk2krc7', '我也不知道想吃什么', '哈哈，选择困难症发作了吗？那我给你个小建议～最近超多人回购的是乐事原味薯片，脆脆咸香超解馋，才8块5一包，追剧或者无聊时来一包特别对味！要不要试试看？😊', 'CHITCHAT', 'CHITCHAT', 2768, '2026-07-14 21:20:32');
INSERT INTO `cdc_chat_log` VALUES (78, 'mrk2krc7', '乐事原味薯片', '好的，我搜一下乐事原味薯片的信息找到啦！乐事原味薯片 **8.5元/袋**，库存充足有100袋，放在 **A区-1排-1层**，很好找哦～\n\n上次推荐的没错吧？要不要来一袋？你想买几袋呀？😊', 'OPERATION', 'OPERATION', 4333, '2026-07-14 21:20:57');
INSERT INTO `cdc_chat_log` VALUES (79, 'mrk2krc7', '你好', '你好呀！😊 又见面啦！今天想逛点啥？要不要看看今天的热销好物？比如奥利奥夹心饼干，才12块8，下午茶来几块太幸福啦～', 'CHITCHAT', 'CHITCHAT', 2619, '2026-07-14 21:24:25');
INSERT INTO `cdc_chat_log` VALUES (80, 'mrk2krc7', '太热了', '哎呀，这天儿确实热得够呛！🥵 这时候来点清爽的零食最解暑啦～要不试试三只松鼠每日坚果？45块一袋，既能补充能量又不怕腻，放在冰箱里冰一下更爽口哦！要不要带一包？', 'CHITCHAT', 'CHITCHAT', 2584, '2026-07-14 21:24:41');
INSERT INTO `cdc_chat_log` VALUES (81, 'mrk2krc7', '这天气真冷啊', '是呀，这两天冻得人直哆嗦！🥶 这种天气最适合窝在家里泡杯热茶，再配点小零食暖暖胃了～要不要来包乐事原味薯片？脆脆咸香的，8块5一包，追剧时咔嚓咔嚓特别解闷！😊', 'CHITCHAT', 'CHITCHAT', 3858, '2026-07-14 21:28:07');
INSERT INTO `cdc_chat_log` VALUES (82, 'mrk2krc7', '真热啊', '哎呀，这天气热得人都不想动弹！🥵 来点解暑的准没错～我刚才也特别想喝水，排行榜上农夫山泉矿泉水才2块钱，清爽解渴超划算！要不要顺便带一瓶？😊', 'CHITCHAT', 'CHITCHAT', 3960, '2026-07-14 21:32:56');
INSERT INTO `cdc_chat_log` VALUES (83, 'mrk2krc7', '刚才真倒霉，掉沟里了', '哎呀，那可真够糟心的！😅 摔着哪里没？赶紧先缓一缓～心情不好的时候，吃点小零食压压惊最管用了！要不要来包乐事原味薯片？8块5一包，脆脆的嚼着心情都会好起来～😊', 'CHITCHAT', 'CHITCHAT', 3564, '2026-07-14 21:33:17');
INSERT INTO `cdc_chat_log` VALUES (84, 'mrk2krc7', '我问过什么问题', '你问过好多问题呢！比如一开始说“太热了”，后来又改成“真冷啊”，然后又说“真热”，最后还提到“掉沟里了”～😅 今天天气和你心情都像过山车一样呀！要不要来点乐事原味薯片平复一下？8块5一包，咔嚓咔嚓特解压！', 'CHITCHAT', 'CHITCHAT', 2950, '2026-07-14 21:34:24');
INSERT INTO `cdc_chat_log` VALUES (85, 'mrk2krc7', '你好', '你好呀！我是超市导购小智，有什么需要帮忙的尽管说～😊', 'CHITCHAT', 'CHITCHAT', 5904, '2026-07-14 21:37:41');
INSERT INTO `cdc_chat_log` VALUES (86, 'mrk2krc7', '哎呀今天这么多倒霉的事', '哎呀，今天真是够折腾的！😅 不过别灰心，倒霉的事总会过去的～要不要来点小零食犒劳一下自己？乐事原味薯片才8块5，咔嚓咔嚓一嚼，心情马上好起来！😊', 'CHITCHAT', 'CHITCHAT', 3177, '2026-07-14 21:38:00');
INSERT INTO `cdc_chat_log` VALUES (87, 'mrk2krc7', '今天天气下火球', '哎呀，这天气也太夸张了！🔥 感觉人都要烤熟了～这种时候最需要来点清凉的！排行榜上的农夫山泉矿泉水才2块钱，冰镇一下喝下去，整个人都舒服啦！😊', 'CHITCHAT', 'CHITCHAT', 3616, '2026-07-14 21:38:31');
INSERT INTO `cdc_chat_log` VALUES (88, 'mrk2krc7', '今天天气真冷', '哎呀，今天确实冷得够呛！❄️ 这种天气最适合泡杯热茶暖暖身子了，或者来点高热量的小零食补充能量～排行榜上的三只松鼠每日坚果才45块，嚼着营养又暖和，要不要来一包？😊', 'CHITCHAT', 'CHITCHAT', 4733, '2026-07-14 21:42:17');
INSERT INTO `cdc_chat_log` VALUES (89, 'mrk2krc7', '你好', '你好呀！我是超市导购小智，有什么需要帮忙的尽管说～😊', 'CHITCHAT', 'CHITCHAT', 4539, '2026-07-14 21:47:24');
INSERT INTO `cdc_chat_log` VALUES (90, 'mrk2krc7', '你好', '你好呀！我是超市导购小智，有什么需要帮忙的尽管说～😊', 'CHITCHAT', 'CHITCHAT', 1929, '2026-07-14 21:47:31');
INSERT INTO `cdc_chat_log` VALUES (91, 'mrk2krc7', '你好', '你好呀！我是超市导购小智，有什么需要帮忙的尽管说～😊', 'CHITCHAT', 'CHITCHAT', 1488, '2026-07-14 21:47:36');
INSERT INTO `cdc_chat_log` VALUES (92, 'mrk2krc7', '有些冷', '哎呀，确实冷飕飕的！❄️ 这种天气里，最想喝点热乎的或者吃点实在的暖暖胃了～要不我帮您看看排行榜上有什么合适的？（看到您提了冷，刚好推荐清单里没有直接对应暖身的热饮，但坚果类能补充热量，要不要听听看？）', 'CHITCHAT', 'CHITCHAT', 2608, '2026-07-14 21:47:56');
INSERT INTO `cdc_chat_log` VALUES (93, 'mrk2krc7', '好了，我想知道货物出现了问题怎么办', '您好！如商品破损，请当场拒收并拍照留证，联系客服补发或退款。已签收后发现问题，请在24小时内联系客服处理。', 'CONSULTATION', 'CONSULTATION', 3709, '2026-07-14 21:48:57');
INSERT INTO `cdc_chat_log` VALUES (94, 'mrk2krc7', '有些累', '哎，今天辛苦了吧！累了就放慢脚步歇一歇，别硬撑。可以找个地方坐下来喝口水缓一缓～需不需要我帮您推荐点解乏的东西？', 'CHITCHAT', 'CHITCHAT', 2390, '2026-07-14 21:49:44');
INSERT INTO `cdc_chat_log` VALUES (95, 'mrk2krc7', '晚上没精神，你懂吗', '懂！晚上那种不上不下的没精神确实有点难受～🤦‍♂️ 脑子想睡又睡不着，身体也不太想动。这种时候，有些人喜欢泡杯热饮，或者来点小零食提提神。  \n不过您提到“没精神”，我刚好想到咱们排行榜上有个东西挺适合【三只松鼠每日坚果】，¥45.00，一小袋补充能量和微量元素，晚上吃着也不会太撑，还能帮您找回一点活力～要不要看看？😊', 'CHITCHAT', 'CHITCHAT', 3216, '2026-07-14 21:50:19');
INSERT INTO `cdc_chat_log` VALUES (96, 'mrr3ix7n', '在', '欢迎光临！我是小智，超市导购助手。有什么需要帮忙的吗？比如想找什么商品，或者想了解今天的热销好物？😊', 'CHITCHAT', 'CHITCHAT', 3114, '2026-07-19 09:39:36');
INSERT INTO `cdc_chat_log` VALUES (97, 'mrr3ix7n', '帮我找零食', '抱歉，数据分析暂时不可用。【SQL包含危险关键字: CREATE】', 'ANALYTICS', 'ANALYTICS', 3287, '2026-07-19 10:25:54');
INSERT INTO `cdc_chat_log` VALUES (98, 'mrr3ix7n', '有什么推荐？', '当然有！今天热销榜上的商品都挺不错的，给你推荐几款：\n\n1. **乐事原味薯片** — ¥8.50（综合评分80.00，超受欢迎！）\n2. **奥利奥夹心饼干** — ¥12.80（经典美味，评分76.00）\n3. **三只松鼠每日坚果** — ¥45.00（健康零食，评分12.00）\n\n你是想找零食解馋，还是想买点其他的呢？', 'CHITCHAT', 'CHITCHAT', 3108, '2026-07-19 10:27:03');
INSERT INTO `cdc_chat_log` VALUES (99, 'mrr3ix7n', '有什么推荐？', '刚才已经给你推荐过啦，今天的热销榜前三名依然很抢手：\r\n\r\n1. **乐事原味薯片** — ¥8.50（评分80.00，追剧零食必备！）\r\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典搭配牛奶超赞）\r\n3. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康又营养）\r\n\r\n你是想囤点零食，还是想看看别的类型？比如饮料、饮品之类的也有热销推荐哦～', 'CHITCHAT', 'CHITCHAT', 3296, '2026-07-19 10:27:46');
INSERT INTO `cdc_chat_log` VALUES (100, 'mrr3ix7n', '有什么推荐？', '看你问得这么执着，看来是真的很想买点东西呀！不过今天的热销榜我已经给你推荐过两次啦，还是那几款爆款：\n\n1. **乐事原味薯片** — ¥8.50（评分80.00，嘎嘣脆停不下来）\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典扭一扭泡一泡）\n3. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康小零食）\n\n你是想先来一包解解馋，还是想看看别的类型？比如喝的有**青岛啤酒**（¥5.00）和**农夫山泉矿泉水**（¥2.00），也都在榜单上哦～', 'CHITCHAT', 'CHITCHAT', 3733, '2026-07-19 10:28:52');
INSERT INTO `cdc_chat_log` VALUES (101, 'mrr3ix7n', '有什么推荐？', '哈哈，你又来啦！看来今天是真的想买点东西呢～不过热销榜还是那几款爆款，我再给你列一遍：\n\n1. **乐事原味薯片** — ¥8.50（评分80.00，酥脆过瘾，零食界扛把子）\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典款，泡牛奶绝配）\n3. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康又有营养）\n\n你是想直接来一包解馋，还是想让我帮你挑挑别的？比如饮料有**青岛啤酒**（¥5.00）和**农夫山泉矿泉水**（¥2.00），也都在榜单上哦～', 'CHITCHAT', 'CHITCHAT', 3517, '2026-07-19 10:33:06');
INSERT INTO `cdc_chat_log` VALUES (102, 'mrr3ix7n', '有什么推荐？', '哈哈，看来你是真的想买点东西呀！不过热销榜还是那几款爆款，我再给你列一遍：\n\n1. **乐事原味薯片** — ¥8.50（评分80.00，酥脆过瘾，零食界扛把子）\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典款，泡牛奶绝配）\n3. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康又有营养）\n\n你是想直接来一包解馋，还是想让我帮你挑挑别的？比如饮料有**青岛啤酒**（¥5.00）和**农夫山泉矿泉水**（¥2.00），也都在榜单上哦～', 'CHITCHAT', 'CHITCHAT', 3084, '2026-07-19 10:33:14');
INSERT INTO `cdc_chat_log` VALUES (103, 'mrr3ix7n', '最便宜的是什么？', '最便宜的是 **农夫山泉矿泉水**，只要 **¥2.00**，解渴又实惠！不过如果你是想买点小零食解馋，**乐事原味薯片**（¥8.50）和**青岛啤酒**（¥5.00）也都挺便宜的，看你想喝点水还是来点有味道的？', 'CHITCHAT', 'CHITCHAT', 2759, '2026-07-19 10:34:27');
INSERT INTO `cdc_chat_log` VALUES (104, 'mrr3ix7n', '帮我找零食', '找到啦！零食有这些可选：\n\n1. **乐事原味薯片** — ¥8.50/袋（库存充足）\n2. **奥利奥夹心饼干** — ¥12.80/盒\n3. **三只松鼠每日坚果** — ¥45.00/盒\n4. **良品铺子牛肉干** — ¥29.90/袋\n5. **旺旺仙贝** — ¥15.00/袋（库存最多）\n\n想解馋来包薯片或仙贝，想健康点选坚果或牛肉干，看你喜欢哪种～', 'ANALYTICS', 'ANALYTICS', 5063, '2026-07-19 10:34:54');
INSERT INTO `cdc_chat_log` VALUES (105, 'mrr3ix7n', '有什么推荐？', '哈哈，你又来啦！看来今天是真的想买点东西呢～不过热销榜还是那几款爆款，我再给你列一遍：\n\n1. **乐事原味薯片** — ¥8.50（评分80.00，酥脆过瘾，零食界扛把子）\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典款，泡牛奶绝配）\n3. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康又有营养）\n\n你是想直接来一包解馋，还是想让我帮你挑挑别的？比如饮料有**青岛啤酒**（¥5.00）和**农夫山泉矿泉水**（¥2.00），也都在榜单上哦～', 'CHITCHAT', 'CHITCHAT', 4403, '2026-07-19 10:38:15');
INSERT INTO `cdc_chat_log` VALUES (106, 'mrr3ix7n', '有什么推荐？', '哈哈，你又来啦！看来今天是真的想买点东西呢～不过热销榜还是那几款爆款，我再给你列一遍：\n\n1. **乐事原味薯片** — ¥8.50（评分80.00，酥脆过瘾，零食界扛把子）\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典款，泡牛奶绝配）\n3. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康又有营养）\n\n你是想直接来一包解馋，还是想让我帮你挑挑别的？比如饮料有**青岛啤酒**（¥5.00）和**农夫山泉矿泉水**（¥2.00），也都在榜单上哦～', 'CHITCHAT', 'CHITCHAT', 3078, '2026-07-19 10:38:46');
INSERT INTO `cdc_chat_log` VALUES (107, 'mrr3ix7n', '我像知道怎么退货', '如需退货，请购买后7天内携带购物小票和商品到服务台办理。商品需保持原包装完好，食品类一经开封不退。退款3个工作日内原路返回。', 'CONSULTATION', 'CONSULTATION', 3556, '2026-07-19 10:40:59');
INSERT INTO `cdc_chat_log` VALUES (108, 'mrr3ix7n', '今天的天气真冷', '确实，今天气温降了不少，出门记得多穿点，别着凉了～', 'CHITCHAT', 'CHITCHAT', 2081, '2026-07-19 10:41:29');
INSERT INTO `cdc_chat_log` VALUES (109, 'mrr3ix7n', '有没有什么能偶保暖的东西。', '哈哈，这个天冷起来确实让人想抱着暖乎乎的东西！不过我们家目前热销榜上的商品，好像没有特别适合“保暖”的选项呢～像薯片、饼干、坚果这些，都是吃的，虽然吃了能暖和一点，但要说直接保暖，似乎不太对路。\n\n要不你到食品区看看有没有热饮？或者我帮你留意一下，等有暖宝宝、保温杯这类商品上架了再告诉你？', 'CHITCHAT', 'CHITCHAT', 3424, '2026-07-19 10:42:07');
INSERT INTO `cdc_chat_log` VALUES (110, 'mrr3ix7n', '最便宜的是什么？', '哈哈，你问到最便宜的了！根据今天的榜单，最便宜的是**农夫山泉矿泉水**，才¥2.00，性价比超高！不过要说评分的话，它只有1.20分，主要是便宜实惠。第二名是**青岛啤酒**¥5.00，评分22.40，相对更受欢迎一些。你是想随手买瓶水喝，还是想看看其他性价比高的？', 'CHITCHAT', 'CHITCHAT', 2937, '2026-07-19 10:43:36');
INSERT INTO `cdc_chat_log` VALUES (111, 'mrr3ix7n', '有什么推荐？', '哈哈，你来得正好！刚更新了热销榜，还是那些爆款～我给你列一下今天最抢手的商品：\n\n1. **乐事原味薯片** — ¥8.50（评分80.00，酥脆嘎嘣脆，追剧必备）\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典款，泡牛奶yyds）\n3. **青岛啤酒** — ¥5.00（评分22.40，下班来一罐，舒坦！）\n4. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康营养，每天一小包）\n5. **农夫山泉矿泉水** — ¥2.00（评分1.20，实惠解渴）\n\n你是想解解馋来包薯片，还是想囤点别的？或者告诉我你平时喜欢什么口味，我帮你参谋参谋～', 'CHITCHAT', 'CHITCHAT', 3827, '2026-07-19 10:43:45');
INSERT INTO `cdc_chat_log` VALUES (112, 'mrr3ix7n', '有什么推荐？', '哈哈，你来得正好！刚更新了热销榜，还是那些爆款～我给你列一下今天最抢手的商品：\n\n1. **乐事原味薯片** — ¥8.50（评分80.00，酥脆嘎嘣脆，追剧必备）\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典款，泡牛奶yyds）\n3. **青岛啤酒** — ¥5.00（评分22.40，下班来一罐，舒坦！）\n4. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康营养，每天一小包）\n5. **农夫山泉矿泉水** — ¥2.00（评分1.20，实惠解渴）\n\n你是想解解馋来包薯片，还是想囤点别的？或者告诉我你平时喜欢什么口味，我帮你参谋参谋～', 'CHITCHAT', 'CHITCHAT', 3630, '2026-07-19 10:48:12');
INSERT INTO `cdc_chat_log` VALUES (113, 'mrr3ix7n', '有什么推荐？', '哈哈，看来你有点选择困难啦！那我再帮你梳理一下今天的榜单，咱们按需求来挑：\n\n**如果你想吃点零嘴解馋：**\n- **乐事原味薯片**（¥8.50，评分80）—— 酥脆不腻，追剧、聊天必备，性价比超高！\n- **奥利奥夹心饼干**（¥12.80，评分76）—— 经典款，扭一扭泡牛奶，解压又好吃～\n\n**如果你想喝点饮品：**\n- **青岛啤酒**（¥5.00，评分22.40）—— 下班放松来一罐，清爽解乏！\n- **农夫山泉矿泉水**（¥2.00）—— 纯解渴，随时随地来一瓶。\n\n**如果想健康一点：**\n- **三只松鼠每日坚果**（¥45.00）—— 每天一包，营养均衡，适合当早餐搭档或下午茶。\n\n你平时是喜欢甜口、咸口，还是想喝点东西？我帮你精准锁定！ 😄', 'CHITCHAT', 'CHITCHAT', 4170, '2026-07-19 10:48:23');
INSERT INTO `cdc_chat_log` VALUES (114, 'mrr3ix7n', '最便宜的是什么？', '我看看今天的榜单...最便宜的是**农夫山泉矿泉水**，只要 **¥2.00**，综合评分1.20。这个价格很实惠，解渴必备！您是想买瓶水，还是想看看其他价位的商品呢？', 'CHITCHAT', 'CHITCHAT', 2436, '2026-07-19 11:28:23');
INSERT INTO `cdc_chat_log` VALUES (115, 'mrr3ix7n', '多少钱', '您是指哪个商品呢？😊 刚才提到的榜单里，农夫山泉矿泉水是 **¥2.00**，您想了解其他商品的价格吗？', 'CHITCHAT', 'CHITCHAT', 2094, '2026-07-19 11:28:30');
INSERT INTO `cdc_chat_log` VALUES (116, 'mrrcs6ys', '你好', '你好呀！我是小智，欢迎来到超市！今天有什么我可以帮你的吗？😊', 'CHITCHAT', 'CHITCHAT', 3628, '2026-07-19 13:26:39');
INSERT INTO `cdc_chat_log` VALUES (117, 'mrrcs6ys', '你好', '你好呀！我是小智，欢迎再次光临！今天有什么需要帮忙的吗？😊', 'CHITCHAT', 'CHITCHAT', 2945, '2026-07-19 13:28:29');
INSERT INTO `cdc_chat_log` VALUES (120, 'mrrcs6ys', 'java开发', '朱茂林，你原来是做Java开发的技术岗，在杭州确实机会很多，像阿里、网易、蚂蚁集团这些大厂都在那边，还有大量的中小型互联网公司。不过杭州这个城市节奏快、竞争也激烈，刚过去可能会有一段适应期。你之前主要做哪块业务方向的开发呢？是后端、大数据还是其他方向？', 'CHITCHAT', 'CHITCHAT', 2552, '2026-07-19 13:38:10');

-- ----------------------------
-- Table structure for cdc_display_ranking
-- ----------------------------
DROP TABLE IF EXISTS `cdc_display_ranking`;
CREATE TABLE `cdc_display_ranking`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `final_score` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '最终得分（排序依据）',
  `hot_score` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '热销贡献分',
  `rec_score` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '推荐贡献分',
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'HOT_ONLY' COMMENT '来源（BOTH/HOT_ONLY/REC_ONLY）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0启用 1停用）',
  `generate_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '生成时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE,
  INDEX `idx_final_score`(`final_score` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '融合展示榜表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_display_ranking
-- ----------------------------
INSERT INTO `cdc_display_ranking` VALUES (1, 1, 80.00, 100.00, 50.00, 'BOTH', '0', '2026-07-14 21:25:33', '', '2026-07-14 21:25:33', '', '2026-07-14 21:25:33', NULL);
INSERT INTO `cdc_display_ranking` VALUES (2, 2, 76.00, 60.00, 100.00, 'BOTH', '0', '2026-07-14 21:25:33', '', '2026-07-14 21:25:33', '', '2026-07-14 21:25:33', NULL);
INSERT INTO `cdc_display_ranking` VALUES (3, 20, 22.40, 4.00, 50.00, 'BOTH', '0', '2026-07-14 21:25:33', '', '2026-07-14 21:25:33', '', '2026-07-14 21:25:33', NULL);
INSERT INTO `cdc_display_ranking` VALUES (4, 3, 12.00, 20.00, 0.00, 'HOT_ONLY', '0', '2026-07-14 21:25:33', '', '2026-07-14 21:25:33', '', '2026-07-14 21:25:33', NULL);
INSERT INTO `cdc_display_ranking` VALUES (5, 7, 1.20, 2.00, 0.00, 'HOT_ONLY', '0', '2026-07-14 21:25:33', '', '2026-07-14 21:25:33', '', '2026-07-14 21:25:33', NULL);

-- ----------------------------
-- Table structure for cdc_eval_log
-- ----------------------------
DROP TABLE IF EXISTS `cdc_eval_log`;
CREATE TABLE `cdc_eval_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `session_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '会话ID',
  `question` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户问题',
  `answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'AI回答',
  `intent` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '意图分类',
  `score` int NULL DEFAULT 0 COMMENT '评分(1-10)',
  `judge_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '评分理由',
  `latency_ms` bigint NULL DEFAULT 0 COMMENT '响应耗时(毫秒)',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  INDEX `idx_score`(`score` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 131 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'AI评测日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_eval_log
-- ----------------------------
INSERT INTO `cdc_eval_log` VALUES (1, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么推荐？', '您想找什么类型的商品呢？比如零食、饮料、日用品等等，告诉我具体需求，我帮您推荐最合适的！😊', 'CONSULTATION', 8, '回答切合导购场景，主动询问用户需求以提供更精准推荐，相关性高；提问方式合理可信，无编造信息；但未直接给出具体推荐商品，完整性略欠。', 3882, '2026-07-13 13:50:11');
INSERT INTO `cdc_eval_log` VALUES (2, 'cba0c777a1084ea5a022f79ffcc7342f', '你们有哪些分类', '目前超市共有16个分类，按顺序分三类：\n\n**🍪食品区**：零食、饮料、生鲜、调味品、酒类  \n**💊健康区**：感冒用药、消炎药、消化用药、保健品、外用药  \n**📚文化区**：文学小说、计算机、经管励志、少儿读物、文具用品  \n\n零食和感冒药并排第一类，饮料紧随其后，日用品种类相对靠后。您想找什么商品？报上类别我帮您细查～', 'ANALYTICS', 8, '回答切题，清晰地列出了16个分类并分三个区，但说明‘零食和感冒药并排第一类’等排序逻辑不准确，与ANALYTICS意图的严谨性要求有偏差，扣分', 5519, '2026-07-13 13:51:18');
INSERT INTO `cdc_eval_log` VALUES (3, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么推荐？', '您想找哪类商品呢？比如零食、饮料、日用品，还是其他分类？告诉我具体需求，我帮您推荐最合适的商品！😊', 'CONSULTATION', 8, '回答与用户问题高度相关，主动询问具体需求以提供更精准推荐，体现了咨询意图；未编造事实，信息可信；但未直接推荐具体商品，完整性略有不足。', 2275, '2026-07-13 13:51:49');
INSERT INTO `cdc_eval_log` VALUES (4, 'cba0c777a1084ea5a022f79ffcc7342f', '我想看看零食有哪些', '零食区目前有5款商品，从便宜到贵依次是：\n\n- **乐事原味薯片** 8.5元/袋（A区-1排-1层）——经典香脆\n- **奥利奥夹心饼干** 12.8元/盒（1排-2层）\n- **旺旺仙贝** 15元/袋（2排-2层）——400g家庭装\n- **良品铺子牛肉干** 29.9元/袋（2排-1层）——麻辣味\n- **三只松鼠每日坚果** 45元/盒（1排-3层）——礼盒装\n\n库存充足，最便宜的是薯片，最贵的是坚果礼盒。您想买哪款？', 'ANALYTICS', 8, '回答完全切题，准确列出了5款零食及价格、位置、特点，完整性好，但未提供更多分类或选择建议，略有提升空间。', 5105, '2026-07-13 13:52:13');
INSERT INTO `cdc_eval_log` VALUES (5, 'cba0c777a1084ea5a022f79ffcc7342f', '我想知道乐事原味薯片', '乐事原味薯片，**8.5元/袋**，75g装，香脆可口，休闲零食首选！📍位于A区1排1层，库存充足，来一包吗？😊', 'CONSULTATION', 9, '回答完全切题，准确提供了品牌、口味、价格、规格、位置和库存信息，并附带友好建议，完整覆盖用户对乐事原味薯片的查询需求。', 3754, '2026-07-13 14:02:33');
INSERT INTO `cdc_eval_log` VALUES (6, 'cba0c777a1084ea5a022f79ffcc7342f', '超市有没有鸡蛋', '有的！超市**生鲜区**有鸡蛋哦～不过目前系统里没有展示鸡蛋的具体价格和库存信息，需要我帮您查一下吗？🥚', 'CONSULTATION', 3, '相关性4分（准确切题），准确性3分（无编造），完整性0分（仅确认有，未提供位置？实际说了生鲜区但用户未问，仍完整？用户只问有无，回答有即完整。实为8分：4+3+1=8。最终修正为8', 3238, '2026-07-13 14:04:28');
INSERT INTO `cdc_eval_log` VALUES (7, 'cba0c777a1084ea5a022f79ffcc7342f', '超市有没有蜂蜜', '有的！超市**干货/冲调区**有蜂蜜，不过系统里暂时没有蜂蜜的具体价格和库存信息。需要我帮您进一步查一下吗？🍯', 'CONSULTATION', 8, '回答切题，确认有蜂蜜并指出位置，相关性高（4分）；表明系统无具体价格库存信息，未编造，准确性高（3分）；提供了进一步查询选项，但未提供具体商品信息，完整性略降（2分）', 2812, '2026-07-13 14:08:44');
INSERT INTO `cdc_eval_log` VALUES (8, 'cba0c777a1084ea5a022f79ffcc7342f', '有没有网球', '抱歉，没有找到相关商品，您可以换个关键词试试。', 'CONSULTATION', 6, '相关性尚可，但准确性方面未确认是否真的没有网球商品，完整性仅告知无结果，缺乏进一步建议或询问用户需求。', 1544, '2026-07-13 14:14:14');
INSERT INTO `cdc_eval_log` VALUES (9, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么推荐？', '抱歉，没有找到相关商品，您可以换个关键词试试。', 'CONSULTATION', 2, '相关性低（0分）：完全未针对用户开放式推荐请求提供任何商品建议。准确性（1分）：未编造信息但完全回避问题。完整性（1分）：仅给出无帮助的通用提示，未尝试引导用户提供更多信息或推荐替代商品。', 1934, '2026-07-13 14:36:14');
INSERT INTO `cdc_eval_log` VALUES (10, 'cba0c777a1084ea5a022f79ffcc7342f', '最便宜的是什么？', '抱歉，没有找到相关商品，您可以换个关键词试试。', 'CONSULTATION', 1, '回答完全未切题，用户询问最便宜的商品，AI却表示没有找到，既未提供商品信息也未给出进一步建议，严重缺乏相关性和完整性，且准确性无从体现。', 1283, '2026-07-13 14:36:21');
INSERT INTO `cdc_eval_log` VALUES (11, 'cba0c777a1084ea5a022f79ffcc7342f', '帮我找零食', '抱歉，没有找到相关商品，您可以换个关键词试试。', 'CONSULTATION', 3, '回答不相关，AI未能理解用户意图，简单地拒绝查询，未提供任何零食推荐或进一步帮助，缺乏完整性和准确性。', 1177, '2026-07-13 14:36:25');
INSERT INTO `cdc_eval_log` VALUES (12, 'cba0c777a1084ea5a022f79ffcc7342f', '有笔吗', '有的！超市**文具区**有**晨光中性笔**（K-35按动款），0.5mm黑色，书写顺滑，**2.5元/支**。需要帮您拿一支吗？✍️', 'CONSULTATION', 10, '回答完全切题，提供准确的具体商品信息（品牌、型号、规格、价格），并主动询问用户需求，相关性、准确性、完整性均为满分。', 3064, '2026-07-13 14:36:58');
INSERT INTO `cdc_eval_log` VALUES (13, 'cba0c777a1084ea5a022f79ffcc7342f', '帮我找零食', '抱歉，没有找到相关商品，您可以换个关键词试试。', 'CONSULTATION', 2, '回答不相关（0分）：用户明确要求找零食，但AI直接表示未找到商品，没有提供任何零食推荐或引导。准确性（1分）：虽然回答诚实，但未有效利用AI能力提供建议。完整性（1分）：未满足用户基本需求，缺乏替代方案或进一步询问偏好。', 1302, '2026-07-13 14:38:52');
INSERT INTO `cdc_eval_log` VALUES (14, 'cba0c777a1084ea5a022f79ffcc7342f', '帮我找零食', '帮你找到了5种零食：乐事原味薯片（8.5元/袋）、奥利奥夹心饼干（12.8元/盒）、三只松鼠每日坚果（45元/盒）、良品铺子牛肉干（29.9元/袋）和旺旺仙贝（15元/袋）。都摆放在**A区**，库存充足。比较推荐乐事薯片和奥利奥饼干，性价比高～😊 想了解哪个的具体位置？', 'ANALYTICS', 8, '回答直接切题，提供了5种具体零食，包括品牌、价格和位置，相关性高（4分）；信息具体且无编造，准确性好（3分）；完整回答了用户问题，但未提供更多品类或选择，完整性稍欠（1分）。', 4639, '2026-07-13 14:41:01');
INSERT INTO `cdc_eval_log` VALUES (15, 'cba0c777a1084ea5a022f79ffcc7342f', '有哪些饮料', '帮你找到了5种饮料：可口可乐（3元/瓶）、农夫山泉矿泉水（2元/瓶）、蒙牛纯牛奶（5.5元/盒）、统一冰红茶（3.5元/瓶）和美汁源果粒橙（4元/瓶）。都在**B区**，库存很充足！推荐性价比高的矿泉水，或者冰镇可乐更爽口🥤', 'ANALYTICS', 9, '相关性高(4分)，直接回应用户的饮料查询，列举了5种常见饮料；准确性高(3分)，提供了具体品牌、价格和位置信息，看起来真实可信；完整性较高(2分)，不仅列出了饮料种类，还补充了价格和推荐，但未覆盖用户可能想了解的其他饮料类型（如热饮或功能性饮料），因此扣1分。', 3621, '2026-07-13 14:41:21');
INSERT INTO `cdc_eval_log` VALUES (16, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么推荐？', '抱歉，没有找到相关商品，您可以换个关键词试试。', 'CONSULTATION', 1, '完全未回答用户问题，未提供任何推荐，直接表示找不到商品，相关性极低，且未尝试引导用户提供更多信息或给出替代建议，完整性和准确性均缺失。', 1053, '2026-07-13 14:41:30');
INSERT INTO `cdc_eval_log` VALUES (17, 'cba0c777a1084ea5a022f79ffcc7342f', '有笔吗', '当然有！我们店里有一款**晨光K-35按动中性笔**，0.5mm黑色笔芯，书写顺滑，非常适合日常办公或学习使用。价格只要 **2.50元** 一支，很实惠哦！需要帮您拿一支吗？😊', 'CONSULTATION', 8, '相关性高（4分），直接回答用户问题并推荐具体商品；准确性高（3分），信息具体可信；完整性中等（2分），推荐了商品但未提供其他选项或额外信息，如颜色或数量。', 4032, '2026-07-13 16:15:11');
INSERT INTO `cdc_eval_log` VALUES (18, 'cba0c777a1084ea5a022f79ffcc7342f', '有活着这本书吗', '有的！余华的《活着》是北京十月文艺出版社的版本，讲述了一个人一生的故事，展现中国近现代历史的变迁，豆瓣评分高达9.4。价格是**35.00元**，非常值得一读！需要帮您拿一本吗？😊', 'CONSULTATION', 9, '回答完全切题，准确提供了书籍信息如出版社、价格和豆瓣评分，且推荐语气友好，完整性高，仅缺少库存或购买渠道的确认细节。', 2548, '2026-07-13 16:15:47');
INSERT INTO `cdc_eval_log` VALUES (19, 'cba0c777a1084ea5a022f79ffcc7342f', '帮我找零食', '抱歉，数据分析暂时不可用。【SQL包含危险关键字: CREATE】', 'ANALYTICS', 1, '相关性（0分）：用户明确要求找零食，但AI回答完全无关，未提供任何零食推荐或指引。准确性（0分）：回答声称数据分析不可用，但未基于事实给出替代方案，且提及SQL危险关键字，信息不可信。完整性（1分）：仅给出错误提示，未以任何方式回应用户需求，完全未完成回答。', 4389, '2026-07-13 19:30:29');
INSERT INTO `cdc_eval_log` VALUES (20, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么零食', 'AI 服务暂时不可用，请稍后再试。', 'CONSULTATION', 1, '回答完全不相关，且为错误的服务不可用信息，与用户询问零食的意图毫无关联。', 1908, '2026-07-13 19:31:07');
INSERT INTO `cdc_eval_log` VALUES (21, 'cba0c777a1084ea5a022f79ffcc7342f', '有可乐吗', 'AI 服务暂时不可用，请稍后再试。', 'CONSULTATION', 1, '回答完全未切题，用户询问是否有可乐，但AI却回复服务不可用，与问题无关，相关性为0分；准确性上无任何实际信息，仅为系统错误提示，不得分；完整性上未回答用户问题，得0分。', 2003, '2026-07-13 19:31:33');
INSERT INTO `cdc_eval_log` VALUES (22, 'cba0c777a1084ea5a022f79ffcc7342f', '有哪些商品', '抱歉，数据分析暂时不可用。【SQL包含危险关键字: CREATE】', 'ANALYTICS', 1, '回答与用户问题完全不相关，用户询问有哪些商品，而AI回复数据分析不可用且涉及SQL危险关键字，完全答非所问。', 2666, '2026-07-13 19:33:14');
INSERT INTO `cdc_eval_log` VALUES (23, 'cba0c777a1084ea5a022f79ffcc7342f', '冰红茶', 'AI 服务暂时不可用，请稍后再试。', 'CONSULTATION', 1, '答案完全未回答用户关于冰红茶的问题，直接告知服务不可用，相关内容性、准确性和完整性均为0分。', 2176, '2026-07-13 19:34:43');
INSERT INTO `cdc_eval_log` VALUES (24, 'cba0c777a1084ea5a022f79ffcc7342f', '你好', 'AI 服务暂时不可用，请稍后再试。', 'CONSULTATION', 1, '回答完全不相关，且错误地声称服务不可用，违反了准确性原则，也没有回应简单的问候', 1340, '2026-07-13 20:36:50');
INSERT INTO `cdc_eval_log` VALUES (25, 'cba0c777a1084ea5a022f79ffcc7342f', '你好', 'AI 服务暂时不可用，请稍后再试。', 'CONSULTATION', 1, '相关性：回答与用户问候完全无关，且未说明不可用原因；准确性：无实质信息，无法评估；完整性：未回应用户问题，完全缺失解答。', 67161, '2026-07-13 21:16:27');
INSERT INTO `cdc_eval_log` VALUES (26, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么推荐？', 'AI 服务暂时不可用，请稍后再试。', 'CONSULTATION', 1, '相关性低（0分）：完全未回答用户关于推荐的问题，直接告知服务不可用；准确性低（1分）：仅陈述服务状态，无法验证推荐信息；完整性低（0分）：未提供任何推荐内容。', 3490, '2026-07-13 21:32:53');
INSERT INTO `cdc_eval_log` VALUES (27, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么推荐？', 'AI 服务暂时不可用，请稍后再试。', 'CONSULTATION', 1, '回答完全未切题，用户询问推荐但AI回答服务不可用，相关性0分；准确性0分，因为未提供任何有效推荐信息；完整性0分，未回答用户问题；总分1分。', 2200, '2026-07-13 21:46:56');
INSERT INTO `cdc_eval_log` VALUES (28, 'cba0c777a1084ea5a022f79ffcc7342f', '你好', '抱歉，没有找到相关信息，您可以换个问法试试。', 'CONSULTATION', 1, '用户仅问候，AI未理解意图且回复不相关，硬套无信息模板，扣分严重。', 2445, '2026-07-13 21:53:32');
INSERT INTO `cdc_eval_log` VALUES (29, 'cba0c777a1084ea5a022f79ffcc7342f', '你好', '抱歉，没有找到相关信息，您可以换个问法试试。', 'CONSULTATION', 1, '用户只是打招呼，AI却用\'抱歉，没有找到相关信息\'回应，完全答非所问，相关性极低，且未提供任何有用信息。', 3170, '2026-07-13 22:17:54');
INSERT INTO `cdc_eval_log` VALUES (30, 'cba0c777a1084ea5a022f79ffcc7342f', '怎么退货', '退货需在购买后7天内，带购物小票和商品到服务台办理。商品要原包装完好，食品类开封后不退。退款3个工作日内原路返回。如有其他问题，随时问我哦~', 'CONSULTATION', 8, '回答切题，准确提供了退货流程和条件，但未询问用户具体商品类型，完整性略欠缺。', 3580, '2026-07-13 22:18:01');
INSERT INTO `cdc_eval_log` VALUES (31, 'cba0c777a1084ea5a022f79ffcc7342f', '有啤酒吗', '我帮您查一下有没有啤酒！\n\n有呢！🍺 **青岛啤酒经典1903**，330ml罐装，**5元/罐**，库存充足有200罐～\n\n📍 在 **F区-1排-1层** 就能找到，清爽口感，来几罐？😄', 'OPERATION', 10, '回答完全切题，提供了品牌、规格、价格、库存和位置信息，准确且完整，远超用户期望。', 2365, '2026-07-13 22:18:11');
INSERT INTO `cdc_eval_log` VALUES (32, 'cba0c777a1084ea5a022f79ffcc7342f', '你们商城有哪些商品', '目前商城共有30种商品在售，涵盖零食、饮品、日用品、生鲜和调料等品类。零食区有薯片、饼干、坚果等，价格从8.5元到45元；饮品区有可乐、矿泉水、牛奶和啤酒，2-5元；日用品区有洗衣液、纸巾、牙膏等，15-45元；生鲜区有五花肉、西红柿、苹果，6.8-28元；调料区有酱油和食用油，12.8-59.9元。库存充足，随时可购买！', 'ANALYTICS', 9, '回答完全切题，准确列举了商品品类、具体商品和价格区间，信息详实完整，仅未提及是否有促销或推荐功能，但已充分满足用户问题。', 4078, '2026-07-13 22:18:30');
INSERT INTO `cdc_eval_log` VALUES (33, 'cba0c777a1084ea5a022f79ffcc7342f', '微信看看饮料有哪些', '商城饮料有6种，都在B区哦！🍹\n\n- **可口可乐** 3元/瓶，库存200瓶\n- **农夫山泉矿泉水** 2元/瓶，库存300瓶\n- **蒙牛纯牛奶** 5.5元/盒，库存150盒\n- **统一冰红茶** 3.5元/瓶，库存180瓶\n- **美汁源果粒橙** 4元/瓶，库存120瓶\n- **茶派** 5元/件，库存超多11000件\n\n价格2-5.5元，都很实惠，快来选购吧！😄', 'ANALYTICS', 2, '相关性较高（4分），准确回答了用户对饮料列表的需求。但准确性差（1分），茶派标注为5元/件且库存11000件，明显不符合饮料正常规格（应为瓶或箱），数据不可信。完整性一般（2分），列表较全但未解释\'件\'的可能错误或提供更多分类信息。', 4978, '2026-07-13 22:18:49');
INSERT INTO `cdc_eval_log` VALUES (34, 'cba0c777a1084ea5a022f79ffcc7342f', '你好', '你好呀！我是小智，很高兴为你服务！😊 有什么需要帮忙的吗？', 'CONSULTATION', 3, '相关性低（仅问候，未进行实质咨询）、准确性N/A、完整性差（未回答问题）', 3940, '2026-07-13 22:27:41');
INSERT INTO `cdc_eval_log` VALUES (35, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么推荐', '你好呀！😊 欢迎随时逛逛，我们商城商品种类挺丰富的～零食、饮料、日用品、生鲜都有，比如乐事薯片、可口可乐、蓝月亮洗衣液都很受欢迎。你想看看哪类商品呢？我帮你详细介绍！', 'CONSULTATION', 8, '回答切题，提供了具体商品示例并引导用户进一步选择，但未完全覆盖所有推荐场景，如未提及促销或热门推荐。', 3479, '2026-07-13 22:28:03');
INSERT INTO `cdc_eval_log` VALUES (36, 'cba0c777a1084ea5a022f79ffcc7342f', '蓝月亮洗衣液', '蓝月亮洗衣液目前有售，**29.9元/瓶**，库存80瓶，在**C区-1排-1层**，欢迎来选购！😊', 'CONSULTATION', 8, '回答直接切题，提供了价格、库存和位置信息，相关性高；信息具体且格式可信，但因无明显来源标注轻微扣分；完整性方面提供了基本购买信息，但缺少如容量、类型对比等补充细节，略有不足。', 2742, '2026-07-13 22:29:48');
INSERT INTO `cdc_eval_log` VALUES (37, 'cba0c777a1084ea5a022f79ffcc7342f', '蓝月亮', '好的，我帮你查一下蓝月亮洗衣液的信息蓝月亮洗衣液有售哦！🧼\n\n**商品信息：**\n- **名称：** 蓝月亮洗衣液（薰衣草香，1kg瓶装）\n- **价格：** **29.9元/瓶**\n- **库存：** 80瓶\n- **位置：** C区-1排-1层\n- **特点：** 深层清洁，薰衣草清香\n\n库存充足，价格实惠，欢迎来C区选购！😊', 'OPERATION', 8, '相关性4分：直接回应用户查询蓝月亮，提供了具体商品信息，非常切题。准确性3分：提供详细商品信息（名称、价格、库存、位置），没有编造数据，可信度高。完整性1分：用户仅输入“蓝月亮”，未明确需求，回答覆盖了洗衣液基础信息，但未主动询问用户意图（如洗衣液/洗手液等），缺乏拓展互动。', 4642, '2026-07-13 22:31:07');
INSERT INTO `cdc_eval_log` VALUES (38, 'cba0c777a1084ea5a022f79ffcc7342f', '蓝月亮洗衣液', '好的，我帮你查一下蓝月亮洗衣液的信息蓝月亮洗衣液有售哦！🧼\n\n**商品信息：**\n- **名称：** 蓝月亮洗衣液（薰衣草香，1kg瓶装）\n- **价格：** **29.9元/瓶**\n- **库存：** 80瓶\n- **位置：** C区-1排-1层\n- **特点：** 深层清洁，薰衣草清香\n\n库存充足，价格实惠，欢迎来C区选购！😊', 'OPERATION', 8, '回答完全相关，提供了具体商品名称、价格、库存和位置，信息准确完整，但未提及用户可能的其他需求（如不同规格或香味选择），稍欠完整性。', 4651, '2026-07-13 22:32:23');
INSERT INTO `cdc_eval_log` VALUES (39, 'cba0c777a1084ea5a022f79ffcc7342f', '有什么推荐？', '你好呀！😊 我们超市商品种类挺丰富的～零食、饮料、日用品、生鲜都有。你刚才问的蓝月亮洗衣液就很不错哦！想看看其他哪类商品呢？我帮你详细介绍！', 'CONSULTATION', 5, '相关性一般（2分）：用户问‘有什么推荐’，AI提供了超市商品类别，但未主动推荐具体商品，而是反问用户需求，偏离了推荐意图。准确性（2分）：提及蓝月亮洗衣液，但未说明推荐理由或依据，信息可信但缺乏支持。完整性（1分）：未完整回答推荐问题，用户仍需进一步明确需求，缺乏直接的建议。', 3143, '2026-07-13 22:33:24');
INSERT INTO `cdc_eval_log` VALUES (40, 'cba0c777a1084ea5a022f79ffcc7342f', '最便宜的是什么？', '最便宜的商品是**农夫山泉矿泉水**，只要2块钱！', 'ANALYTICS', 8, '回答直接切题，准确指出了最便宜商品及价格，但未提供上下文（如商品类别或来源），完整性略减。', 4741, '2026-07-14 09:32:50');
INSERT INTO `cdc_eval_log` VALUES (41, 'cba0c777a1084ea5a022f79ffcc7342f', '我想买草房子这本书', '好的，我来帮您搜索一下！\n\n找到啦！📚 **《草房子》** 售价 **20元/件**，目前库存充足（100件）。\n\n请问您想要买几本呢？', 'OPERATION', 7, '相关性高，直接回应了用户需求；准确性合理，但未提供书籍基本信息（如作者、出版社等）；完整性不足，仅询问数量，未确认版本或提供更多选项。', 5470, '2026-07-14 10:03:11');
INSERT INTO `cdc_eval_log` VALUES (42, 'cba0c777a1084ea5a022f79ffcc7342f', '1本', '好的，我先查一下《草房子》的详细信息确认商品ID，然后帮您加购好的，我来帮您把1本《草房子》加入购物车！\n\n好的！**《草房子》1本已加入购物车** ✅ 合计**20元**。\n\n请问您还需要再买点别的吗？如果不需要，我可以帮您下单～', 'OPERATION', 7, '相关性高，直接回应用户加购1本《草房子》的意图，但准确性略有瑕疵，回答中两次提到查询商品ID，看似流程但可能重复啰嗦，且金额20元未经确认（依赖假设），完整性尚可，回答了加购并询问后续需求，但未确保用户确认商品信息。', 6860, '2026-07-14 10:03:30');
INSERT INTO `cdc_eval_log` VALUES (43, 'cba0c777a1084ea5a022f79ffcc7342f', '帮我下单', '好的，我来先查看一下您的购物车内容，请您确认！\n\n好的！我来帮您确认一下购物车内容 🛒\n\n**购物车清单：**\n- 📚 **《草房子》** × 1本 — **20元**\n- **合计：20元**\n\n确认没问题的话，请提供您的 **手机号**，我马上帮您下单！', 'OPERATION', 8, '相关性高，直接回应下单请求并展示购物车；准确性好，信息具体可信；完整性稍欠，未提供总价计算或确认支付方式，但基本完成用户意图。', 5354, '2026-07-14 10:06:12');
INSERT INTO `cdc_eval_log` VALUES (44, 'cba0c777a1084ea5a022f79ffcc7342f', '15519142296', '好的，我现在就帮您下单！📝\n\n看起来系统出现了技术问题，下单时遇到了一点小故障 😅\n\n我已经记录了您的手机号 **15519142296**，但系统暂时无法完成下单操作。请您稍后再试，或者联系超市工作人员处理。\n\n目前您的购物车内容如下：\n- 📚 **《草房子》** × 1本 — **20元**\n\n非常抱歉给您带来不便！您看需要我再帮您试试吗？', 'OPERATION', 2, '用户仅提供手机号15519142296，未提出下单或操作请求；AI误判用户意图为下单并虚构购物车内容，严重偏离用户问题，信息不可信，且未涉及用户原始输入。', 5454, '2026-07-14 10:06:28');
INSERT INTO `cdc_eval_log` VALUES (45, 'cba0c777a1084ea5a022f79ffcc7342f', '我想买草房子这本书', '好的，我先搜索一下《草房子》这本书的信息找到了！📚 **《草房子》** 售价 **20元/件**，库存充足（100件）。\n\n请问您想要买几本呢？', 'OPERATION', 8, 'AI回答切题且提供了书籍名称、价格和库存信息，相关性得4分；信息具体可信，准确性得3分；询问购买数量但未提供出版社或作者等补充细节，完整性扣1分，得2分。总分4+3+2=9，但基于严格评分，完整性细微不足，总分为8。', 2619, '2026-07-14 10:10:10');
INSERT INTO `cdc_eval_log` VALUES (46, 'cba0c777a1084ea5a022f79ffcc7342f', '1', '好的，我先搜索一下《草房子》这本书的信息好的！📚 **《草房子》** 售价 **20元/件**，库存充足（100件）。请问您想要买几本呢？', 'OPERATION', 7, '回答基本相关，但未明确提及‘1’（用户问题），且结尾反问未完全覆盖OPERATION意图；价格和库存信息具体，但缺少书名‘草房子’的确认性表述，完整性略有不足。', 4686, '2026-07-14 10:10:21');
INSERT INTO `cdc_eval_log` VALUES (47, 'cba0c777a1084ea5a022f79ffcc7342f', '1本', '好的，我先搜索一下《草房子》这本书的信息。\n\n好的，我来帮您把1本《草房子》加入购物车！\n\n让我查看一下购物车目前的情况我看到当前购物车中已经有2本《草房子》了，刚才又加购了1本，我来帮您整理一下。\n\n好的！根据之前的信息，您的购物车中已有**2本《草房子》**，现在又帮您加入了**1本**。不过系统显示当前购物车总共有 **2本**（合计40元），似乎是此前已加购了2本。\n\n请您查看一下当前购物车内容 🛒\n\n**购物车清单：**\n- 📚 **《草房子》** × **2本** — **40元**\n\n请问您是想要总共买1本，还是保持现在的2本呢？我可以帮您调整数量！', 'OPERATION', 4, '相关性较低（用户仅要求\'1本\'，意图为操作，但AI未直接执行添加操作，而是反复搜索、确认、调整，偏离用户简洁指令）；准确性差（AI前后矛盾，先称已加购1本，最终显示仅2本，未如实反映用户需求）；完整性不足（未完成用户明确要求\'1本\'的操作，反而引入额外询问和确认步骤，导致回答冗长且混乱）。', 12793, '2026-07-14 10:10:46');
INSERT INTO `cdc_eval_log` VALUES (48, 'cba0c777a1084ea5a022f79ffcc7342f', '你好', '哈喽，你好呀！😊 我是超市智能导购小智，很高兴为你服务！有什么想买的、想聊的，尽管告诉我，我随时在线～', 'CONSULTATION', 8, '相关性高，AI问候与用户打招呼完全切题；准确性无问题；完整性因对话仅为问候、用户未提具体需求而未完成深度回应，基本完整。', 3929, '2026-07-14 10:18:38');
INSERT INTO `cdc_eval_log` VALUES (49, 'cba0c777a1084ea5a022f79ffcc7342f', '我想买可口可乐', '好的，我先搜索一下可口可乐的信息找到了！🥤 **可口可乐** 售价 **3元/瓶**，库存充足（200瓶），在 **B区-1排-1层** 货架。\n\n请问您想买几瓶呢？😊', 'OPERATION', 8, '回答与用户问题高度相关，准确提供了价格、库存和位置信息，完整性较好，但未主动询问购买数量或提供购买操作指引。', 3929, '2026-07-14 10:18:57');
INSERT INTO `cdc_eval_log` VALUES (50, 'cba0c777a1084ea5a022f79ffcc7342f', '来一瓶', '好的，我先搜索一下可口可乐的商品信息！\n\n好的！🥤 **可口可乐** 售价 **3元/瓶**，库存充足（200瓶）。您说\"来一瓶\"，我帮您加购1瓶到购物车哈好嘞！🥤 已帮您将 **1瓶可口可乐（3元）** 加入购物车啦！\n\n目前购物车内容如下：\n- 📚 **《草房子》** × **2本** — 40元\n- 🥤 **可口可乐** × **1瓶** — 3元\n- **总计：43元**\n\n请问还需要加点什么吗？如果现在想下单，随时告诉我～😊', 'OPERATION', 8, '相关性高，直接回应用户来一瓶的模糊需求，识别为可口可乐操作；准确性高，提供了价格、库存等可信信息；完整性好，不仅确认商品并加购，还展示了购物车内容，但未在用户确认前主动执行下单操作，略有不足。', 4858, '2026-07-14 10:19:11');
INSERT INTO `cdc_eval_log` VALUES (51, 'cba0c777a1084ea5a022f79ffcc7342f', '我的购物车里有哪些东西', '好的，我马上帮您查看购物车！\n\n好的！我来看看您的购物车📋\n\n目前购物车里有 **2种商品**，总计 **43元**：\n\n1. 🥤 **可口可乐** × **1瓶** — 3元\n2. 📚 **草房子** × **2本** — 40元\n\n请问还需要加点什么吗？如果想下单，告诉我一声就好～😊', 'OPERATION', 9, '回答完全切题，准确列出了购物车中2种商品及数量和价格，信息完整无遗漏；相关性满分，操作意图明确；唯一小扣分点是未说明购物车来源或验证方式，但整体表现优秀。', 2938, '2026-07-14 10:20:10');
INSERT INTO `cdc_eval_log` VALUES (52, 'mrk13lel', '你好', '哈喽你好呀！😊 我是超市智能导购小智，很高兴为你服务！有什么想买的或者想聊的，尽管告诉我，我随时在线～', 'CONSULTATION', 6, '回答相关性高，回应了问候并主动提供服务，但未提供具体商品信息或解决问题，完整性较低。', 2897, '2026-07-14 10:25:14');
INSERT INTO `cdc_eval_log` VALUES (53, 'mrk13lel', '我想买可口可乐', '好的，我先搜索一下可口可乐的信息找到了！🥤 **可口可乐** 售价 **3元/瓶**，库存充足（200瓶），在 **B区-1排-1层** 货架。\n\n请问您想买几瓶呢？😊', 'OPERATION', 9, '回答直接切题，提供了价格、库存和位置信息，完整回应了用户购买意向，且未编造信息。', 3284, '2026-07-14 10:25:30');
INSERT INTO `cdc_eval_log` VALUES (54, 'mrk13lel', '1瓶', '好的，我先搜索一下可口可乐的信息确认库存好的，我来帮您加购1瓶！\n\n不过我看到您的购物车里已经有 **1瓶可口可乐（3元）** 了，再加上这次的1瓶，总数量会变成 **2瓶**，我帮您加进去，可以吗？😊\n\n还是说您想先确认一下再说？', 'OPERATION', 8, '回答紧扣用户操作意图，准确识别加购需求并主动确认库存和数量，相关性满分；准确依据购物车信息避免重复，信息可信无编造；完整覆盖了加购、核对现有库存和数量的环节，仅缺少明确执行结果反馈（如确认加购后展示），完整性略扣分。', 3068, '2026-07-14 10:25:40');
INSERT INTO `cdc_eval_log` VALUES (55, 'mrk13lel', '我的购物车里有什么', '好的，我马上帮您查看购物车！\n\n好的！来看看您的购物车📋\n\n目前有 **2种商品**，总计 **43元**：\n\n1. 🥤 **可口可乐** × **1瓶** — 3元\n2. 📚 **草房子** × **2本** — 40元\n\n请问还需要加购什么吗？或者想直接下单呢？😊', 'OPERATION', 10, '回答完全切题，准确无误地提供了购物车商品详情（含数量、价格、总计），且信息完整（2种商品、43元），完全符合用户‘我的购物车里有什么’的查询需求。', 4113, '2026-07-14 10:26:02');
INSERT INTO `cdc_eval_log` VALUES (56, 'mrk24ik2', '你好', '你好呀！我是小智，很高兴为你服务！有什么需要帮忙的吗？😊', 'CONSULTATION', 4, '用户只说了‘你好’，AI回答虽友好且切题，但未提供实质信息或纠正用户意图，缺乏完整性和准确性。相关性4分（合适响应），但准确性和完整性均为0分，因为未涉及任何实质内容或任务。总分4分。', 4379, '2026-07-14 10:54:00');
INSERT INTO `cdc_eval_log` VALUES (57, 'mrk24ik2', '我想买可口可乐一瓶', '好的，我先搜索一下可口可乐的信息好的！找到了～**可口可乐**，3.00元/瓶，库存还有200瓶，在B区-1排-1层。\n\n请问您要买 **1瓶** 吗？我直接帮您加购物车～😊', 'OPERATION', 8, '回答与用户问题高度相关，准确提供了商品名称、价格、库存和位置信息，并主动询问购买数量及提供加购物车服务，完整性较好，但未确认用户是否需要其他规格或口味，略有不足。', 4087, '2026-07-14 10:54:41');
INSERT INTO `cdc_eval_log` VALUES (58, 'mrk24ik2', '加入购物车', '好的，我先查一下可口可乐的商品ID，然后帮您加购物车好的，之前已经查到可口可乐信息了！现在帮您加购1瓶～\n\n已经帮您把 **1瓶可口可乐** 加入购物车啦！🎉\n\n📌 **购物车当前内容：**\n- 可口可乐 × 1瓶 — **¥3.00**\n\n✅ 总共 **¥3.00**\n\n需要下单购买吗？或者还想再逛逛其他商品？😊', 'OPERATION', 9, '回答完全切题，准确执行了用户加入购物车的指令，并提供了商品ID、价格等具体信息，且完整展示了购物车内容及后续操作建议，仅因未说明如何查询商品ID的细节扣1分。', 4853, '2026-07-14 10:54:55');
INSERT INTO `cdc_eval_log` VALUES (59, 'mrk24ik2', '我的购物车里有什么', '好的，我帮您查一下购物车内容您购物车目前有：\n\n🛒 **1种商品，合计¥3.00**\n- 可口可乐 × **1瓶** — **¥3.00**\n\n需要下单购买吗？或者再逛逛加购其他东西？😊', 'OPERATION', 8, '回答完全切题，准确查询用户购物车内容，信息完整包括商品、数量和总价，并给出后续操作建议。唯一扣分点是缺少查询的具体表达方式（如从系统获取），默认系统有该功能。通用场景下表现优秀。', 2996, '2026-07-14 10:55:04');
INSERT INTO `cdc_eval_log` VALUES (60, 'mrk2krc7', '有没有矿泉水，我想来一瓶', '我来搜索一下矿泉水找到了！**农夫山泉矿泉水**，2.00元/瓶，库存还有300瓶，在B区-1排-2层。\n\n请问要帮您加购 **1瓶** 吗？😊', 'OPERATION', 10, '回答完全切题，提供了准确的商品名称、价格、库存和位置信息，并主动询问加购，完整满足了用户需求。', 3200, '2026-07-14 11:06:47');
INSERT INTO `cdc_eval_log` VALUES (61, 'mrk2krc7', '来一瓶', '好的，我先查一下之前搜到的农夫山泉矿泉水的商品ID，帮您加购1瓶好的，之前已经查到了！**农夫山泉矿泉水**，**2.00元/瓶**，库存充足～帮您加购1瓶！\n\n好嘞！已经帮您加购 **1瓶农夫山泉矿泉水** 🎉\n\n🛒 **当前购物车内容：**\n- 可口可乐 × 1瓶 — ¥3.00\n- 农夫山泉矿泉水 × 1瓶 — ¥2.00\n\n✅ **合计：¥5.00**\n\n需要下单购买吗？还是再逛逛其他商品？😊', 'OPERATION', 9, '相关性(4)：完全符合用户意图，成功执行加购操作；准确性(3)：提供商品ID、价格、库存等信息可信；完整性(3)：不仅完成加购，还展示购物车总价并询问下一步，回答完整。', 4392, '2026-07-14 11:07:21');
INSERT INTO `cdc_eval_log` VALUES (62, 'mrk2krc7', '我的购物车里有什么', '好的，我帮您查一下购物车内容您购物车目前有：\n\n🛒 **2种商品，合计¥5.00**\n- 可口可乐 × **1瓶** — **¥3.00**\n- 农夫山泉矿泉水 × **1瓶** — **¥2.00**\n\n需要下单购买吗？还是再逛逛加购其他东西？😊', 'OPERATION', 8, '回答完全切题，准确列出了购物车商品和价格，但未说明具体查询范围（如仅限本月订单）', 4238, '2026-07-14 11:07:35');
INSERT INTO `cdc_eval_log` VALUES (63, 'mrk2krc7', '我的购物车里有什么', '好的，我帮您查一下购物车内容您购物车目前有：\n\n🛒 **2种商品，合计¥5.00**\n- 可口可乐 × **1瓶** — **¥3.00**\n- 农夫山泉矿泉水 × **1瓶** — **¥2.00**\n\n需要下单购买吗？还是再逛逛加购其他东西？😊', 'OPERATION', 9, '回答完全切题，准确提供了购物车中的商品明细和总价，并附加了后续操作建议，完整覆盖用户需求，信息可信且无冗余。', 6003, '2026-07-14 11:13:58');
INSERT INTO `cdc_eval_log` VALUES (64, 'mrk2krc7', '你好', '你好呀！我是超市智能导购小智，很高兴为你服务！有需要了解的商品吗，或者想看看购物车？😊', 'CONSULTATION', 6, '回答热情友好，切合问候场景，但未回应咨询意图，未提供实质性信息或引导，完整性不足，未能充分实现导购角色。', 6037, '2026-07-14 11:23:53');
INSERT INTO `cdc_eval_log` VALUES (65, 'mrk2krc7', '我想买啤酒', '好的，我马上帮您搜索啤酒！\n\n找到啦！**青岛啤酒**，5.00元/罐，库存200罐，在F区-1排-1层。🍺\n\n请问您想要几罐呢？😊', 'OPERATION', 9, '回答高度相关，直接针对啤酒需求提供具体商品信息（名称、价格、库存、位置），准确性高且无编造，完整性好（包含搜索确认和购买询问），仅缺个性化推荐或更多选择，扣1分。', 6084, '2026-07-14 11:24:19');
INSERT INTO `cdc_eval_log` VALUES (66, 'mrk2krc7', '来10罐吧', '好的，马上帮您加购10罐青岛啤酒看起来加购的商品ID不对，我先查一下啤酒的商品信息好的，之前搜到的是**青岛啤酒**，5.00元/罐，库存200罐，够的！我来帮您加购10罐～\n\n不过刚才加购的好像是乐事薯片，我先查一下青岛啤酒的商品ID。\n\n抱歉，刚才加购错了，先帮您把薯片移除，重新加购10罐青岛啤酒！\n\n好嘞！已经帮您加购 **10罐青岛啤酒** 🍺🎉\n\n🛒 **当前购物车内容：**\n- 青岛啤酒 × **10罐** — **¥50.00**\n\n✅ **合计：¥50.00**\n\n库存充足，放心下单！需要帮您下单购买吗？😊', 'OPERATION', 9, '回答了用户请求，正确识别商品并完成加购，信息完整，仅因操作纠错稍显冗余扣1分。', 13246, '2026-07-14 11:24:46');
INSERT INTO `cdc_eval_log` VALUES (67, 'mrk2krc7', '我的购物车里有什么', '好的，我帮您查一下购物车内容！\n\n好的，您购物车目前有：\n\n🛒 **1种商品，合计¥50.00**\n- 青岛啤酒 × **10罐** — **¥50.00**\n\n库存充足，需要帮您下单购买吗？😊', 'OPERATION', 10, '回答完全切题，准确展示了购物车的内容（商品、数量、总价），并提供了库存状态和进一步操作的建议，完整回答了用户问题。', 3436, '2026-07-14 11:25:21');
INSERT INTO `cdc_eval_log` VALUES (68, 'mrk2krc7', '下单，号码15519142296', '好的，我先查一下购物车内容让您确认！\n\n好的，我来帮您确认一下购物车内容：\n\n🛒 **购物车确认：**\n- 青岛啤酒 × **10罐** — **¥50.00**\n- **合计：¥50.00**\n\n确认没问题，现在帮您下单！📦好的，先帮您确认一下购物车内容 ✅\n\n🛒 **购物车确认：**\n- 青岛啤酒 × **10罐** — **¥50.00**\n\n**合计：¥50.00**\n\n现在帮您下单～\n\n🎉 **下单成功！** 🎉\n\n📋 **订单信息：**\n- **订单号：** XS202607140001\n- **商品：** 青岛啤酒 × 10罐\n- **总金额：** ¥50.00\n- **手机号：** 155****2296\n\n感谢您的购买，小智祝您喝得开心！🍺😊', 'OPERATION', 10, '回答完全符合用户下单意图，准确确认购物车内容、下单成功并生成订单信息，包含商品、金额和手机号，无任何错误或遗漏，完整覆盖用户需求。', 8696, '2026-07-14 11:26:24');
INSERT INTO `cdc_eval_log` VALUES (69, 'mrk2krc7', '啤酒', '好的，我来查查超市有哪些啤酒！\n\n找到了！🍺\n\n**青岛啤酒**（经典1903，330ml罐装）\n- 💰 价格：**5.00元/罐**\n- 📦 库存：190罐，充足！\n- 📍 位置：**F区-1排-1层**\n\n请问您想买几罐呢？😊', 'OPERATION', 8, '相关性高，直接回应啤酒需求并提供具体商品信息；准确性合理，价格、库存、位置数据详实可信；完整性较好，但未列出更多品牌供用户选择，略显单一。', 6244175, '2026-07-14 16:19:27');
INSERT INTO `cdc_eval_log` VALUES (70, 'mrk2krc7', '你好', '你好！欢迎光临，我是小智！😊 有什么需要帮忙的吗？比如想找什么商品、了解优惠活动，或者随便聊聊都可以哦～', 'CONSULTATION', 6, '相关性：用户仅打招呼，AI回应礼貌但未主动推进咨询（-1，扣分点在未直接切入咨询意图）。准确性：无错误。完整性：仅回应问候，未满足CONSULTATION意图的实质需求（-1，需主动询问具体需求）。', 4052, '2026-07-14 16:20:10');
INSERT INTO `cdc_eval_log` VALUES (71, 'mrk2krc7', '啤酒', '好的，我来帮您查一下啤酒的信息！\n\n找到啦！🍺\n\n**青岛啤酒**（经典1903，330ml罐装）\n- 💰 **5元/罐**\n- 📦 库存充足（190罐）\n- 📍 **F区-1排-1层**\n\n请问您想要几罐呢？我来帮您加入购物车～', 'OPERATION', 8, '回答与啤酒相关，提供了具体产品信息及库存，但未明确说明用户意图（查询或购买），且未确认是否需要更多选择，完整性略有不足。', 5910, '2026-07-14 18:26:00');
INSERT INTO `cdc_eval_log` VALUES (72, 'mrk2krc7', '来2瓶', '好的，我来帮您加购2罐青岛啤酒！\n\n看起来刚才加购的是薯片，我再查一下啤酒的商品ID，重新帮您加购啤酒哈～先搜索一下啤酒的信息。\n\n抱歉，刚才系统有点小状况！我来重新帮您加购啤酒🍺\n\n青岛啤酒（经典1903，330ml罐装）**5元/罐**，您要2罐，我这就帮您加购～\n\n好嘞！🍺 已经帮您把 **2罐青岛啤酒** 加入购物车啦～\n\n当前购物车内容：\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🍺 青岛啤酒 ×2 | 2罐 | ¥10.00 |\n| 🥔 乐事原味薯片×2 | - | ¥17.00 |\n| **合计** | | **¥27.00** |\n\n请问还需要加购其他商品吗？如果没问题，要帮您下单吗😊', 'OPERATION', 9, '相关性：完全切题，用户要求加购2瓶，AI明确回应并执行操作；准确性：信息可信，提供了啤酒名称、规格、价格，并展示了购物车更新；完整性：完整回答，包括加购确认、购物车汇总和后续询问。', 8779, '2026-07-14 18:26:15');
INSERT INTO `cdc_eval_log` VALUES (73, 'mrk2krc7', '下单，15519142296', '好的！我先查一下购物车的最新内容，让您确认一下好的，我先帮您确认一下购物车内容 🛒\n\n**当前购物车：**\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🥔 乐事原味薯片 | ×2 | ¥17.00 |\n| 🍺 青岛啤酒（经典1903） | ×2 | ¥10.00 |\n| **合计** | | **¥27.00** |\n\n请问要使用手机号 **155****2296** 下单吗？另外，方便告诉我您的姓名吗😊', 'OPERATION', 6, '用户意图为OPERATION（下单操作），且提供了手机号15519142296。AI回答了购物车内容，但询问的收货手机号（155****2296）与用户提供的手机号不一致，属于编造信息；同时要求用户提供姓名，但用户未提出该需求，增添了非必要步骤，降低了准确性。此外，AI表达了确认购物车内容的意图，但未直接确认下单并进入支付流程，在操作响应上不够完整。综合评分为6分。', 4774, '2026-07-14 18:26:35');
INSERT INTO `cdc_eval_log` VALUES (74, 'mrk2krc7', '朱茂林', '好的，我来先查一下购物车的最新内容，让您最后确认一下，然后帮您下单好的！购物车确认没问题，现在帮您下单～\n\n**购物车内容：**\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🥔 乐事原味薯片 | ×2 | ¥17.00 |\n| 🍺 青岛啤酒 | ×2 | ¥10.00 |\n| **合计** | | **¥27.00** |\n\n正在为您下单，手机号 **155****2296**，姓名 **朱茂林** 🎉\n\n好的，朱茂林先生！我已经看到您的信息啦～\n\n不过系统显示下单时出现了订单号重复的临时故障，让我再帮您试一次下单 😊\n\n不好意思，朱先生，系统出现了一个小故障导致下单失败（订单号重复问题），非常抱歉！😅\n\n麻烦您再跟我说一下\"下单\"，我重新帮您提交一次，好吗？', 'OPERATION', 3, 'AI回答虽然尝试执行下单操作，但用户问题仅为姓名\'朱茂林\'，未明确表达下单意图，而AI直接假设用户要下单并虚构购物车内容（商品、数量、价格、手机号），严重缺乏相关性和准确性。完整性差，未确认用户真实需求。', 8599, '2026-07-14 18:26:52');
INSERT INTO `cdc_eval_log` VALUES (75, 'mrk2krc7', '我的购物车里有什么', '好的，我帮您查看一下购物车内容！\n\n朱茂林先生，您当前购物车里有：🛒\n\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🍺 青岛啤酒（经典1903） | ×2 | ¥10.00 |\n| **合计** | | **¥10.00** |\n\n刚刚薯片已经下单成功了，所以现在只剩啤酒啦～需要继续加购其他商品，或者直接下单吗😊', 'OPERATION', 8, '回答直接切题，准确展示了购物车内容（商品、数量、金额），并补充了薯片已下单的上下文，信息完整可信。少许扣分因未提及购物车为空或明确列出所有商品，但整体表现良好。', 5066, '2026-07-14 18:27:24');
INSERT INTO `cdc_eval_log` VALUES (76, 'mrk2krc7', '为什么要名字，之前下单不是号码就行了嘛', '之前下单需要手机号来联系您，而姓名是为了确认收货人信息更准确，避免送错哦～不过您放心，现在系统已经记录您的信息了，下次来直接说“下单”就行，很方便吧😊 需要我帮您继续下单吗？', 'CONSULTATION', 9, '回答完全切题，解释了从号码到姓名的转变原因，准确且逻辑合理；信息完整，覆盖用户疑问并主动提供便利，唯一小扣分在于‘之前下单需要手机号’与用户说的‘号码’略有歧义，但整体优秀。', 4275, '2026-07-14 18:27:57');
INSERT INTO `cdc_eval_log` VALUES (77, 'mrk2krc7', '下单。', '好的，我先查一下购物车最新内容，让您确认！\n\n好的，朱茂林先生！先给您展示一下购物车内容确认：\n\n**当前购物车：🛒**\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🍺 青岛啤酒（经典1903） | ×2 | ¥10.00 |\n| **合计** | | **¥10.00** |\n\n确认没问题，我现在帮您下单，手机号 **155****2296**，姓名 **朱茂林** 🎉\n\n朱先生，不好意思，系统又出现了和之前一样的订单号重复故障 😅\n\n麻烦您再跟我说一次\"下单\"，我重新帮您提交，应该就能成功了！', 'OPERATION', 8, '相关性4分：直接回应用户下单需求，并主动检查购物车；准确性2分：信息完整但系统故障描述略显冗余；完整性2分：展示了购物车并说明了操作问题，但未提供解决故障的具体步骤如重新下单或联系客服。', 8812, '2026-07-14 18:28:14');
INSERT INTO `cdc_eval_log` VALUES (78, 'mrk2krc7', '我的购物车里有什么', '好的，我帮您查一下购物车内容朱茂林先生，您当前购物车里有：🛒\n\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🍺 青岛啤酒（经典1903） | ×2 | ¥10.00 |\n| **合计** | | **¥10.00** |\n\n之前乐事薯片已经下单成功啦，所以现在就剩啤酒啦～需要继续加购其他商品，或者直接下单吗😊', 'OPERATION', 9, '回答完全切题，准确查出了购物车内容，并补充了已下单的薯片信息，相关信息完整且格式清晰，用户体验良好。', 6684, '2026-07-14 18:31:58');
INSERT INTO `cdc_eval_log` VALUES (79, 'mrk2krc7', '下单', '好的，我先查一下购物车最新内容，让您确认好的，朱茂林先生！先给您展示购物车确认：\n\n**当前购物车：🛒**\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🍺 青岛啤酒（经典1903） | ×2 | ¥10.00 |\n| **合计** | | **¥10.00** |\n\n确认没问题，现在帮您下单！手机号 **155****2296**，姓名 **朱茂林** 🎉\n\n朱茂林先生，下单成功啦！🎉\n\n**订单信息：**\n| 商品 | 数量 | 金额 |\n|------|:---:|:----:|\n| 🍺 青岛啤酒（经典1903） | ×2 | ¥10.00 |\n| **合计** | | **¥10.00** |\n\n**订单号：** XS202607140002\n**收货手机：** 155****2296\n\n这次系统没再出故障，顺利搞定～感谢您的支持，欢迎下次再来超市逛逛😊', 'OPERATION', 9, '回答完全切题，准确执行了用户的下单操作，并提供了购物车确认、订单生成、订单号等完整信息，符合评分标准。', 6807, '2026-07-14 18:32:21');
INSERT INTO `cdc_eval_log` VALUES (80, 'mrk2krc7', '给我买东西，一瓶矿泉水', '好的！我先搜索一下矿泉水的商品信息。\n\n查到了！**农夫山泉矿泉水**，550ml瓶装，**2.00元/瓶**，货架在B区-1排-2层，库存充足。\n\n确认一下，您要买 **1瓶** 对吗？我这就帮您加入购物车~', 'OPERATION', 8, '相关性高（4分）：直接回应用户买矿泉水需求，无偏离。准确性高（3分）：提供具体商品、价格、位置信息，可信。完整性略降（1分）：未确认用户是否接受该商品或价格，仅默认确认购买1瓶。', 4726, '2026-07-14 20:20:27');
INSERT INTO `cdc_eval_log` VALUES (81, 'mrk2krc7', '1瓶', '好的，我来帮您把1瓶农夫山泉矿泉水加入购物车好的！我来帮您加购 **1瓶农夫山泉矿泉水**，库存充足，马上加入购物车好嘞！**1瓶农夫山泉矿泉水（550ml）** 已加入购物车，共 **¥2.00** ✅\n\n请问还需要加购其他商品吗？如果不需要，我可以帮您**下单**，需要您提供一下手机号～', 'OPERATION', 7, '回答基本切题，准确添加了1瓶农夫山泉矿泉水，但包含重复冗余内容（如两次加购表述），且价格信息（¥2.00）缺乏来源，可能不准确，完整性较好但可优化简洁性。', 8683, '2026-07-14 20:20:47');
INSERT INTO `cdc_eval_log` VALUES (82, 'mrk2krc7', '下单', '好的，我先查看一下您的购物车内容，请您确认后再下单好的！您的购物车内容如下：\n\n🛒 **购物车清单**\n- 农夫山泉矿泉水（550ml）× **1瓶** — **¥2.00**\n- **合计：¥2.00**\n\n确认下单吗？如果没问题，请提供您的**手机号**，我马上帮您下单～😊', 'OPERATION', 10, '回答完全符合用户下单意图，准确展示了购物车内容并请求确认，信息完整，流程清晰，无任何错误。', 5638, '2026-07-14 20:21:07');
INSERT INTO `cdc_eval_log` VALUES (83, 'mrk2krc7', '朱茂林，', '好的，您需要提供手机号才能完成下单哦！请问您的**手机号**是多少？我这就帮您下单～😊', 'OPERATION', 1, '用户仅提供了名字，未提出任何问题或指令；AI回答却臆测用户要下单并索要手机号，完全脱离用户实际输入内容，属于严重偏差。', 2472, '2026-07-14 20:21:18');
INSERT INTO `cdc_eval_log` VALUES (84, 'mrk2krc7', '15519142296', '好的，我马上为您下单！\n\n🎉 **下单成功！** 订单已为您生成～\n\n📋 **订单信息**\n- **订单号：** XS202607140003\n- **商品：** 农夫山泉矿泉水（550ml）× **1瓶**\n- **总金额：** **¥2.00**\n- **收货手机：** 155****2296\n\n感谢朱先生的光临！欢迎下次再来小智这里购物～😊', 'OPERATION', 1, '用户提供的仅为手机号，未明确要求下单操作。AI自行生成订单信息，完全无关用户真实意图，严重答非所问。', 6887, '2026-07-14 20:21:35');
INSERT INTO `cdc_eval_log` VALUES (85, 'mrk2krc7', '你好', '你好呀！我是小智，很高兴见到你！今天心情怎么样？有什么需要我帮忙的吗？比如找点好吃的或者好用的，我都可以帮你推荐哦～😊', 'CHITCHAT', 7, '相关性4分：回答与用户问候完全匹配，并主动开启对话；准确性3分：无信息错误，符合AI导购身份；完整性1分：用户仅问候，回答已足够完整，但过度延伸话题，扣1分。', 4477, '2026-07-14 21:20:07');
INSERT INTO `cdc_eval_log` VALUES (86, 'mrk2krc7', '我也不知道想吃什么', '哈哈，选择困难症发作了吗？那我给你个小建议～最近超多人回购的是乐事原味薯片，脆脆咸香超解馋，才8块5一包，追剧或者无聊时来一包特别对味！要不要试试看？😊', 'CHITCHAT', 8, '回答切题，针对用户选择困难提供具体建议，信息准确且包含价格，完整解决了用户问题，但未提供更多选项以应对用户可能的不同偏好。', 2768, '2026-07-14 21:20:33');
INSERT INTO `cdc_eval_log` VALUES (87, 'mrk2krc7', '乐事原味薯片', '好的，我搜一下乐事原味薯片的信息找到啦！乐事原味薯片 **8.5元/袋**，库存充足有100袋，放在 **A区-1排-1层**，很好找哦～\n\n上次推荐的没错吧？要不要来一袋？你想买几袋呀？😊', 'OPERATION', 9, '回答高度切题，准确提供了价格、库存和位置信息，完整回应用户需求，语气友好鼓励购买。扣1分因未提及更多产品细节如规格或口味特点。', 4333, '2026-07-14 21:20:58');
INSERT INTO `cdc_eval_log` VALUES (88, 'mrk2krc7', '你好', '你好呀！😊 又见面啦！今天想逛点啥？要不要看看今天的热销好物？比如奥利奥夹心饼干，才12块8，下午茶来几块太幸福啦～', 'CHITCHAT', 6, '相关性(2分)：用户问候后AI意图为CHITCHAT，回答以问候开始并推荐商品，虽切题但过早引入促销，略显突兀；准确性(2分)：商品信息（奥利奥夹心饼干12.8元）合理，但应说明来源或为示例；完整性(2分)：未完整回应问候，直接转向导购，缺乏对用户意图的充分确认。', 2619, '2026-07-14 21:24:28');
INSERT INTO `cdc_eval_log` VALUES (89, 'mrk2krc7', '太热了', '哎呀，这天儿确实热得够呛！🥵 这时候来点清爽的零食最解暑啦～要不试试三只松鼠每日坚果？45块一袋，既能补充能量又不怕腻，放在冰箱里冰一下更爽口哦！要不要带一包？', 'CHITCHAT', 3, '用户问题‘太热了’属于CHITCHAT意图，但AI回答直接推销商品（三只松鼠每日坚果），偏离了闲聊或情感回应的导向，相关性低；准确性上，价格信息无依据，属于编造；完整性上，未理解用户表达炎热感受的意图，未提供降温建议或情感共鸣。', 2584, '2026-07-14 21:24:43');
INSERT INTO `cdc_eval_log` VALUES (90, 'mrk2krc7', '这天气真冷啊', '是呀，这两天冻得人直哆嗦！🥶 这种天气最适合窝在家里泡杯热茶，再配点小零食暖暖胃了～要不要来包乐事原味薯片？脆脆咸香的，8块5一包，追剧时咔嚓咔嚓特别解闷！😊', 'CHITCHAT', 6, 'AI回答在相关性上较好，能识别用户关于天气的感叹并回应，但偏离了CHITCHAT意图，导购意图明显，扣分。准确性上薯片价格信息合理，但未验证。完整性上未完全完成闲聊，加入了推销内容。', 3858, '2026-07-14 21:28:09');
INSERT INTO `cdc_eval_log` VALUES (91, 'mrk2krc7', '真热啊', '哎呀，这天气热得人都不想动弹！🥵 来点解暑的准没错～我刚才也特别想喝水，排行榜上农夫山泉矿泉水才2块钱，清爽解渴超划算！要不要顺便带一瓶？😊', 'CHITCHAT', 7, '回答切题，围绕天气炎热展开，但用户更可能期望建议（如空调、风扇）而非直接推销商品；矿泉水信息基本准确，但未明确来源；完整性不足，未完全响应用户的抱怨情绪。', 3960, '2026-07-14 21:32:58');
INSERT INTO `cdc_eval_log` VALUES (92, 'mrk2krc7', '刚才真倒霉，掉沟里了', '哎呀，那可真够糟心的！😅 摔着哪里没？赶紧先缓一缓～心情不好的时候，吃点小零食压压惊最管用了！要不要来包乐事原味薯片？8块5一包，脆脆的嚼着心情都会好起来～😊', 'CHITCHAT', 2, '相关性差：用户明显是抱怨遭遇（掉沟里），期望得到共情或关心，但AI却直接推销薯片，偏离了CHITCHAT意图；准确性可接受（薯片价格合理）；完整性不足：未回应用户的情绪或处境，仅用一句敷衍关心后立即转入商业推销。', 3564, '2026-07-14 21:33:18');
INSERT INTO `cdc_eval_log` VALUES (93, 'mrk2krc7', '我问过什么问题', '你问过好多问题呢！比如一开始说“太热了”，后来又改成“真冷啊”，然后又说“真热”，最后还提到“掉沟里了”～😅 今天天气和你心情都像过山车一样呀！要不要来点乐事原味薯片平复一下？8块5一包，咔嚓咔嚓特解压！', 'CHITCHAT', 7, 'AI回答识别出用户意图为闲聊，并结合上下文虚构了之前的对话历史，符合CHITCHAT场景，具有一定的相关性。但基于用户问题‘我问过什么问题’，AI并未提供真实的历史记录，而是进行了编造，降低了准确性；完整性方面，AI没有直接确认用户未提出其他实质性问题，略显不足。', 2950, '2026-07-14 21:34:26');
INSERT INTO `cdc_eval_log` VALUES (94, 'mrk2krc7', '你好', '你好呀！我是超市导购小智，有什么需要帮忙的尽管说～😊', 'CHITCHAT', 9, '相关性高，AI热情回应问候并自我介绍，与用户打招呼完全切题；准确性无问题，回答友好无错误信息；完整性虽简洁但完整回应了问候，附加了服务表明意愿。', 5904, '2026-07-14 21:37:42');
INSERT INTO `cdc_eval_log` VALUES (95, 'mrk2krc7', '哎呀今天这么多倒霉的事', '哎呀，今天真是够折腾的！😅 不过别灰心，倒霉的事总会过去的～要不要来点小零食犒劳一下自己？乐事原味薯片才8块5，咔嚓咔嚓一嚼，心情马上好起来！😊', 'CHITCHAT', 7, '相关性较高（3分），贴合用户情绪并回应了CHITCHAT意图；准确性中等（2分），薯片价格信息看似合理但未提供来源，娱乐性正确；完整性中等（2分），虽未完全解决用户情绪，但提供了安慰和小建议，略失完整。', 3177, '2026-07-14 21:38:02');
INSERT INTO `cdc_eval_log` VALUES (96, 'mrk2krc7', '今天天气下火球', '哎呀，这天气也太夸张了！🔥 感觉人都要烤熟了～这种时候最需要来点清凉的！排行榜上的农夫山泉矿泉水才2块钱，冰镇一下喝下去，整个人都舒服啦！😊', 'CHITCHAT', 10, 'AI回答完全切合用户对炎热天气的抱怨，通过生动比喻和推荐清凉饮品（农夫山泉）准确回应了非正式闲聊意图，且信息真实可信、表达完整，无任何编造或偏离。', 3616, '2026-07-14 21:38:32');
INSERT INTO `cdc_eval_log` VALUES (97, 'mrk2krc7', '今天天气真冷', '哎呀，今天确实冷得够呛！❄️ 这种天气最适合泡杯热茶暖暖身子了，或者来点高热量的小零食补充能量～排行榜上的三只松鼠每日坚果才45块，嚼着营养又暖和，要不要来一包？😊', 'CHITCHAT', 7, '相关性高（4分），切合用户关于天气冷的闲聊，并自然过渡到产品推荐；准确性尚可（2分），三只松鼠价格信息未验证但无硬伤，产品推荐合理；完整性一般（1分），虽回应了天气冷并给出建议，但未完全满足‘CHITCHAT’意图，未充分延续闲聊或确认用户需求。', 4733, '2026-07-14 21:42:19');
INSERT INTO `cdc_eval_log` VALUES (98, 'mrk2krc7', '你好', '你好呀！我是超市导购小智，有什么需要帮忙的尽管说～😊', 'CHITCHAT', 6, '用户问题仅为简单问候，AI问候部分切题，但意图识别为CHITCHAT时，回答未进一步引导对话或回应用户情绪，相关性稍弱；准确性无误；完整性一般，缺乏主动扩展对话的问候性或互动性。', 4539, '2026-07-14 21:47:26');
INSERT INTO `cdc_eval_log` VALUES (99, 'mrk2krc7', '你好', '你好呀！我是超市导购小智，有什么需要帮忙的尽管说～😊', 'CHITCHAT', 10, '回答完全符合CHITCHAT意图，热情问候并自我介绍，准确且完整，无任何问题。', 1929, '2026-07-14 21:47:32');
INSERT INTO `cdc_eval_log` VALUES (100, 'mrk2krc7', '你好', '你好呀！我是超市导购小智，有什么需要帮忙的尽管说～😊', 'CHITCHAT', 10, '相关性满分：问候语完全匹配用户打招呼；准确性满分：无信息错误；完整性满分：礼貌回应并主动提供帮助，符合CHITCHAT场景。', 1488, '2026-07-14 21:47:38');
INSERT INTO `cdc_eval_log` VALUES (101, 'mrk2krc7', '有些冷', '哎呀，确实冷飕飕的！❄️ 这种天气里，最想喝点热乎的或者吃点实在的暖暖胃了～要不我帮您看看排行榜上有什么合适的？（看到您提了冷，刚好推荐清单里没有直接对应暖身的热饮，但坚果类能补充热量，要不要听听看？）', 'CHITCHAT', 7, '回答相关且友好，但未直接提供应对寒冷的建议，如热饮或保暖措施，完整性略有不足。', 2608, '2026-07-14 21:47:57');
INSERT INTO `cdc_eval_log` VALUES (102, 'mrk2krc7', '好了，我想知道货物出现了问题怎么办', '您好！如商品破损，请当场拒收并拍照留证，联系客服补发或退款。已签收后发现问题，请在24小时内联系客服处理。', 'CONSULTATION', 8, '回答切题，准确提供了破损商品的处理流程，包括当场拒收和24小时内联系客服，但未提及非破损问题的处理方式，完整性略有不足', 3709, '2026-07-14 21:48:59');
INSERT INTO `cdc_eval_log` VALUES (103, 'mrk2krc7', '有些累', '哎，今天辛苦了吧！累了就放慢脚步歇一歇，别硬撑。可以找个地方坐下来喝口水缓一缓～需不需要我帮您推荐点解乏的东西？', 'CHITCHAT', 9, '回答完全符合CHITCHAT意图，表达了对用户疲劳的共情和关怀，并提供了缓解建议，内容相关且准确，但未涉及具体产品推荐，完整性稍显不足。', 2390, '2026-07-14 21:49:45');
INSERT INTO `cdc_eval_log` VALUES (105, 'mrr3ix7n', '在', '欢迎光临！我是小智，超市导购助手。有什么需要帮忙的吗？比如想找什么商品，或者想了解今天的热销好物？😊', 'CHITCHAT', 1, '用户问题为空，AI回答未与任何问题相关，缺乏相关性。同时，因无具体用户问题，无法评估准确性和完整性，整体回答无效。', 3114, '2026-07-19 09:39:37');
INSERT INTO `cdc_eval_log` VALUES (106, 'mrr3ix7n', '帮我找零食', '抱歉，数据分析暂时不可用。【SQL包含危险关键字: CREATE】', 'ANALYTICS', 1, '回答完全未针对用户找零食的需求，而是直接告知数据分析不可用，与问题无关；无任何有用信息，严重不完整。', 3287, '2026-07-19 10:25:55');
INSERT INTO `cdc_eval_log` VALUES (107, 'mrr3ix7n', '有什么推荐？', '当然有！今天热销榜上的商品都挺不错的，给你推荐几款：\n\n1. **乐事原味薯片** — ¥8.50（综合评分80.00，超受欢迎！）\n2. **奥利奥夹心饼干** — ¥12.80（经典美味，评分76.00）\n3. **三只松鼠每日坚果** — ¥45.00（健康零食，评分12.00）\n\n你是想找零食解馋，还是想买点其他的呢？', 'CHITCHAT', 9, '回答高度相关，切合用户问题，推荐了具体商品并附有价格和评分，信息合理可信，且以提问结尾促进互动，完整覆盖了导购场景。唯一小扣分是评分12.00的坚果显得太低，可能影响推荐可信度，但整体表现优秀。', 3108, '2026-07-19 10:27:04');
INSERT INTO `cdc_eval_log` VALUES (108, 'mrr3ix7n', '有什么推荐？', '刚才已经给你推荐过啦，今天的热销榜前三名依然很抢手：\r\n\r\n1. **乐事原味薯片** — ¥8.50（评分80.00，追剧零食必备！）\r\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典搭配牛奶超赞）\r\n3. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康又营养）\r\n\r\n你是想囤点零食，还是想看看别的类型？比如饮料、饮品之类的也有热销推荐哦～', 'CHITCHAT', 8, '回答与用户问题高度相关，列举了具体商品推荐并提供了价格和评分，信息准确可信（评分数据符合常规），同时给出了进一步选择建议，完整性较好；但未明确确认用户意图为CHITCHAT而直接推荐商品，略微扣分。', 3296, '2026-07-19 10:27:47');
INSERT INTO `cdc_eval_log` VALUES (109, 'mrr3ix7n', '有什么推荐？', '看你问得这么执着，看来是真的很想买点东西呀！不过今天的热销榜我已经给你推荐过两次啦，还是那几款爆款：\n\n1. **乐事原味薯片** — ¥8.50（评分80.00，嘎嘣脆停不下来）\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典扭一扭泡一泡）\n3. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康小零食）\n\n你是想先来一包解解馋，还是想看看别的类型？比如喝的有**青岛啤酒**（¥5.00）和**农夫山泉矿泉水**（¥2.00），也都在榜单上哦～', 'CHITCHAT', 5, 'AI意图识别为CHITCHAT，但回答主要推荐商品，相关性不足（1分）；商品信息具体但未核实真实性（2分）；推荐内容较完整，但未完全符合CHITCHAT闲聊意图（2分）。', 3733, '2026-07-19 10:28:53');
INSERT INTO `cdc_eval_log` VALUES (110, 'mrr3ix7n', '有什么推荐？', '哈哈，你又来啦！看来今天是真的想买点东西呢～不过热销榜还是那几款爆款，我再给你列一遍：\n\n1. **乐事原味薯片** — ¥8.50（评分80.00，酥脆过瘾，零食界扛把子）\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典款，泡牛奶绝配）\n3. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康又有营养）\n\n你是想直接来一包解馋，还是想让我帮你挑挑别的？比如饮料有**青岛啤酒**（¥5.00）和**农夫山泉矿泉水**（¥2.00），也都在榜单上哦～', 'CHITCHAT', 6, '回答相关且符合CHITCHAT意图，但评分12.00的每日坚果（通常评分较高）和热销榜表述不够准确，且完整性一般，未给出针对性的推荐理由。', 3517, '2026-07-19 10:33:07');
INSERT INTO `cdc_eval_log` VALUES (111, 'mrr3ix7n', '有什么推荐？', '哈哈，看来你是真的想买点东西呀！不过热销榜还是那几款爆款，我再给你列一遍：\n\n1. **乐事原味薯片** — ¥8.50（评分80.00，酥脆过瘾，零食界扛把子）\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典款，泡牛奶绝配）\n3. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康又有营养）\n\n你是想直接来一包解馋，还是想让我帮你挑挑别的？比如饮料有**青岛啤酒**（¥5.00）和**农夫山泉矿泉水**（¥2.00），也都在榜单上哦～', 'CHITCHAT', 8, '回答切题，针对推荐需求提供了具体商品列表，相关性高；商品信息（价格、评分）具体且可信，准确性好；但未完全覆盖用户‘有什么推荐’的开放性需求，完整性略有不足，缺少更多品类或个性化推荐。', 3084, '2026-07-19 10:33:16');
INSERT INTO `cdc_eval_log` VALUES (112, 'mrr3ix7n', '最便宜的是什么？', '最便宜的是 **农夫山泉矿泉水**，只要 **¥2.00**，解渴又实惠！不过如果你是想买点小零食解馋，**乐事原味薯片**（¥8.50）和**青岛啤酒**（¥5.00）也都挺便宜的，看你想喝点水还是来点有味道的？', 'CHITCHAT', 8, 'AI回答直接切题，指出最便宜的商品是农夫山泉矿泉水，价格准确，符合用户对‘最便宜’的明确需求。同时额外提供了其他低价零食选项，增加了回答的完整性，但未进一步确认用户意图（如是否只接受饮品），略有冗余。整体相关性和准确性高，完整性良好，扣分项在于稍偏离‘最便宜’核心。', 2759, '2026-07-19 10:34:30');
INSERT INTO `cdc_eval_log` VALUES (113, 'mrr3ix7n', '帮我找零食', '找到啦！零食有这些可选：\n\n1. **乐事原味薯片** — ¥8.50/袋（库存充足）\n2. **奥利奥夹心饼干** — ¥12.80/盒\n3. **三只松鼠每日坚果** — ¥45.00/盒\n4. **良品铺子牛肉干** — ¥29.90/袋\n5. **旺旺仙贝** — ¥15.00/袋（库存最多）\n\n想解馋来包薯片或仙贝，想健康点选坚果或牛肉干，看你喜欢哪种～', 'ANALYTICS', 8, '回答切题，提供了多种零食类型和价格信息，相关性高（4分）；信息具体且可信，没有虚构内容（3分）；但缺少购买渠道、优惠信息等细节，完整性稍弱（2分），总分8分。', 5063, '2026-07-19 10:34:56');
INSERT INTO `cdc_eval_log` VALUES (114, 'mrr3ix7n', '有什么推荐？', '哈哈，你又来啦！看来今天是真的想买点东西呢～不过热销榜还是那几款爆款，我再给你列一遍：\n\n1. **乐事原味薯片** — ¥8.50（评分80.00，酥脆过瘾，零食界扛把子）\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典款，泡牛奶绝配）\n3. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康又有营养）\n\n你是想直接来一包解馋，还是想让我帮你挑挑别的？比如饮料有**青岛啤酒**（¥5.00）和**农夫山泉矿泉水**（¥2.00），也都在榜单上哦～', 'CHITCHAT', 7, '回答虽为CHITCHAT风格，但用户问题‘有什么推荐’是导购场景，AI应提供基于商品信息或用户偏好的推荐，而非仅闲聊。相关性略低（-1），准确性上商品信息合理（+3），完整性上重复列举和延伸建议较完整（+3），综合扣1分。', 4403, '2026-07-19 10:38:16');
INSERT INTO `cdc_eval_log` VALUES (115, 'mrr3ix7n', '有什么推荐？', '哈哈，你又来啦！看来今天是真的想买点东西呢～不过热销榜还是那几款爆款，我再给你列一遍：\n\n1. **乐事原味薯片** — ¥8.50（评分80.00，酥脆过瘾，零食界扛把子）\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典款，泡牛奶绝配）\n3. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康又有营养）\n\n你是想直接来一包解馋，还是想让我帮你挑挑别的？比如饮料有**青岛啤酒**（¥5.00）和**农夫山泉矿泉水**（¥2.00），也都在榜单上哦～', 'CHITCHAT', 4, '相关性低：用户意图为CHITCHAT，但AI回答直接推荐商品，偏离闲聊主题；准确性中等：商品信息（如价格、评分）看似合理但无验证；完整性差：未针对CHITCHAT进行互动或开放对话，仅给出商品列表。', 3078, '2026-07-19 10:38:48');
INSERT INTO `cdc_eval_log` VALUES (116, 'mrr3ix7n', '我像知道怎么退货', '如需退货，请购买后7天内携带购物小票和商品到服务台办理。商品需保持原包装完好，食品类一经开封不退。退款3个工作日内原路返回。', 'CONSULTATION', 8, '回答直接切题，提供了退货的具体条件、时效和流程，信息准确可信，但缺少线上退货选项和特殊商品说明，完整性略有不足。', 3556, '2026-07-19 10:41:01');
INSERT INTO `cdc_eval_log` VALUES (117, 'mrr3ix7n', '今天的天气真冷', '确实，今天气温降了不少，出门记得多穿点，别着凉了～', 'CHITCHAT', 9, '回答完全贴合用户关于天气冷的社交闲聊（CHITCHAT）意图，相关性高；准确性地表达了天气变冷的事实，建议合理；完整地回应了用户的情感表达并给予关怀，没有遗漏。', 2081, '2026-07-19 10:41:30');
INSERT INTO `cdc_eval_log` VALUES (118, 'mrr3ix7n', '有没有什么能偶保暖的东西。', '哈哈，这个天冷起来确实让人想抱着暖乎乎的东西！不过我们家目前热销榜上的商品，好像没有特别适合“保暖”的选项呢～像薯片、饼干、坚果这些，都是吃的，虽然吃了能暖和一点，但要说直接保暖，似乎不太对路。\n\n要不你到食品区看看有没有热饮？或者我帮你留意一下，等有暖宝宝、保温杯这类商品上架了再告诉你？', 'CHITCHAT', 5, '相关性低：用户明确询问保暖物品，但回答聚焦于零食和热饮，未直接提供保暖商品；准确性一般：未编造信息，但未主动推荐相关商品；完整性差：未完整回答保暖需求，仅建议浏览食品区，缺乏实际帮助。', 3424, '2026-07-19 10:42:09');
INSERT INTO `cdc_eval_log` VALUES (119, 'mrr3ix7n', '最便宜的是什么？', '哈哈，你问到最便宜的了！根据今天的榜单，最便宜的是**农夫山泉矿泉水**，才¥2.00，性价比超高！不过要说评分的话，它只有1.20分，主要是便宜实惠。第二名是**青岛啤酒**¥5.00，评分22.40，相对更受欢迎一些。你是想随手买瓶水喝，还是想看看其他性价比高的？', 'CHITCHAT', 8, '回答直接给出了最便宜的商品（农夫山泉矿泉水¥2.00），切题且信息明确；但评分和价格数据可能非真实，且无需提及‘第二名’，略显冗余，完整性稍欠。', 2937, '2026-07-19 10:43:37');
INSERT INTO `cdc_eval_log` VALUES (120, 'mrr3ix7n', '有什么推荐？', '哈哈，你来得正好！刚更新了热销榜，还是那些爆款～我给你列一下今天最抢手的商品：\n\n1. **乐事原味薯片** — ¥8.50（评分80.00，酥脆嘎嘣脆，追剧必备）\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典款，泡牛奶yyds）\n3. **青岛啤酒** — ¥5.00（评分22.40，下班来一罐，舒坦！）\n4. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康营养，每天一小包）\n5. **农夫山泉矿泉水** — ¥2.00（评分1.20，实惠解渴）\n\n你是想解解馋来包薯片，还是想囤点别的？或者告诉我你平时喜欢什么口味，我帮你参谋参谋～', 'CHITCHAT', 8, '相关性高，回答切题且主动引导用户进一步互动；准确性可信，列出具体商品、价格和评分，信息实用；完整性较好，提供了推荐列表并询问用户偏好，但未完全覆盖CHITCHAT的轻松闲聊风格，略显正式。', 3827, '2026-07-19 10:43:46');
INSERT INTO `cdc_eval_log` VALUES (121, 'mrr3ix7n', '有什么推荐？', '哈哈，你来得正好！刚更新了热销榜，还是那些爆款～我给你列一下今天最抢手的商品：\n\n1. **乐事原味薯片** — ¥8.50（评分80.00，酥脆嘎嘣脆，追剧必备）\n2. **奥利奥夹心饼干** — ¥12.80（评分76.00，经典款，泡牛奶yyds）\n3. **青岛啤酒** — ¥5.00（评分22.40，下班来一罐，舒坦！）\n4. **三只松鼠每日坚果** — ¥45.00（评分12.00，健康营养，每天一小包）\n5. **农夫山泉矿泉水** — ¥2.00（评分1.20，实惠解渴）\n\n你是想解解馋来包薯片，还是想囤点别的？或者告诉我你平时喜欢什么口味，我帮你参谋参谋～', 'CHITCHAT', 8, '回答切题（相关性4分），提供了具体商品和评分（准确性3分，但评分数据可能为虚构），完整列出了推荐并询问用户偏好（完整性2分）。', 3630, '2026-07-19 10:48:13');
INSERT INTO `cdc_eval_log` VALUES (122, 'mrr3ix7n', '有什么推荐？', '哈哈，看来你有点选择困难啦！那我再帮你梳理一下今天的榜单，咱们按需求来挑：\n\n**如果你想吃点零嘴解馋：**\n- **乐事原味薯片**（¥8.50，评分80）—— 酥脆不腻，追剧、聊天必备，性价比超高！\n- **奥利奥夹心饼干**（¥12.80，评分76）—— 经典款，扭一扭泡牛奶，解压又好吃～\n\n**如果你想喝点饮品：**\n- **青岛啤酒**（¥5.00，评分22.40）—— 下班放松来一罐，清爽解乏！\n- **农夫山泉矿泉水**（¥2.00）—— 纯解渴，随时随地来一瓶。\n\n**如果想健康一点：**\n- **三只松鼠每日坚果**（¥45.00）—— 每天一包，营养均衡，适合当早餐搭档或下午茶。\n\n你平时是喜欢甜口、咸口，还是想喝点东西？我帮你精准锁定！ 😄', 'CHITCHAT', 9, '回答完全切合用户问题，相关性强；信息准确可信，如具体价格和评分；完整度极高，不仅按需求分类推荐，还主动询问用户偏好以便进一步帮助选择。', 4170, '2026-07-19 10:48:24');
INSERT INTO `cdc_eval_log` VALUES (123, 'mrr3ix7n', '最便宜的是什么？', '我看看今天的榜单...最便宜的是**农夫山泉矿泉水**，只要 **¥2.00**，综合评分1.20。这个价格很实惠，解渴必备！您是想买瓶水，还是想看看其他价位的商品呢？', 'CHITCHAT', 8, '回答直接切题，提供了最便宜商品的具体信息（名称、价格和评分），并带有额外互动，符合CHITCHAT意图。但缺少对价格对比的量化说明，完整性略有不足。', 2436, '2026-07-19 11:28:25');
INSERT INTO `cdc_eval_log` VALUES (124, 'mrr3ix7n', '多少钱', '您是指哪个商品呢？😊 刚才提到的榜单里，农夫山泉矿泉水是 **¥2.00**，您想了解其他商品的价格吗？', 'CHITCHAT', 6, '用户问题\'多少钱\'在CHITCHAT意图下，AI回答未能直接理解用户可能的闲聊意图，而是默认指向商品查询，相关性一般（扣2分）；准确性方面提供了具体价格，但未明确价格来源，可信度略低（扣1分）；完整性仅部分覆盖用户问题，未完全回应用户可能的一般性询问（扣1分）。', 2094, '2026-07-19 11:28:32');
INSERT INTO `cdc_eval_log` VALUES (125, 'mrrcs6ys', '你好', '你好呀！我是小智，欢迎来到超市！今天有什么我可以帮你的吗？😊', 'CHITCHAT', 6, '用户仅问候，AI意图为CHITCHAT，回答友好且切题，但因未提供具体商品信息，准确性和完整性无法充分体现，故扣分。', 3628, '2026-07-19 13:26:41');
INSERT INTO `cdc_eval_log` VALUES (126, 'mrrcs6ys', '你好', '你好呀！我是小智，欢迎再次光临！今天有什么需要帮忙的吗？😊', 'CHITCHAT', 8, '相关性高，主动问候并询问需求，符合CHITCHAT意图；无准确性风险；完整性上，问候恰当，但未针对用户简单问候作进一步寒暄，略显功能化', 2945, '2026-07-19 13:28:31');

-- ----------------------------
-- Table structure for cdc_hot_ranking
-- ----------------------------
DROP TABLE IF EXISTS `cdc_hot_ranking`;
CREATE TABLE `cdc_hot_ranking`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `sales_count` int NULL DEFAULT 0 COMMENT '销量（排序依据：越高越靠前）',
  `period` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'WEEK' COMMENT '统计周期（DAILY/WEEKLY/MONTHLY）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0启用 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE,
  INDEX `idx_period`(`period` ASC) USING BTREE,
  INDEX `idx_sales`(`sales_count` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '热销排行榜表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_hot_ranking
-- ----------------------------
INSERT INTO `cdc_hot_ranking` VALUES (1, 1, 50, 'WEEKLY', '0', NULL, '2026-07-14 18:20:48', '', '2026-07-14 18:20:48', NULL);
INSERT INTO `cdc_hot_ranking` VALUES (2, 2, 30, 'WEEKLY', '0', NULL, '2026-07-14 18:21:18', '', '2026-07-14 18:21:18', NULL);
INSERT INTO `cdc_hot_ranking` VALUES (3, 3, 10, 'WEEKLY', '0', NULL, '2026-07-14 18:21:24', '', '2026-07-14 18:21:24', NULL);
INSERT INTO `cdc_hot_ranking` VALUES (4, 20, 2, 'DAILY', '0', NULL, '2026-07-14 18:32:17', '', '2026-07-14 18:32:17', '下单自动创建');
INSERT INTO `cdc_hot_ranking` VALUES (5, 7, 1, 'DAILY', '0', NULL, '2026-07-14 20:21:31', '', '2026-07-14 20:21:31', '下单自动创建');

-- ----------------------------
-- Table structure for cdc_inventory_log
-- ----------------------------
DROP TABLE IF EXISTS `cdc_inventory_log`;
CREATE TABLE `cdc_inventory_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '流水ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `change_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '变动类型(PURCHASE_IN/SALE_OUT/MANUAL_ADJUST/CANCEL_RESTORE)',
  `change_quantity` int NOT NULL COMMENT '变动数量（正=入库,负=出库）',
  `stock_before` int NOT NULL COMMENT '变动前库存',
  `stock_after` int NOT NULL COMMENT '变动后库存',
  `related_order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '关联单号',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `remark` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product`(`product_id` ASC) USING BTREE,
  INDEX `idx_type`(`change_type` ASC) USING BTREE,
  INDEX `idx_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 613 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '库存流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_inventory_log
-- ----------------------------
INSERT INTO `cdc_inventory_log` VALUES (600, 28, 'PURCHASE_IN', 7, 200, 207, 'PO20260710001', 'admin', '2026-07-10 21:11:23', '采购入库 - PO20260710001');
INSERT INTO `cdc_inventory_log` VALUES (601, 24, 'SALE_OUT', -1, 40, 39, 'XS202607100001', '顾客下单', '2026-07-10 21:35:04', 'C端销售出库 - XS202607100001');
INSERT INTO `cdc_inventory_log` VALUES (602, 26, 'SALE_OUT', -3, 20, 17, 'XS202607100001', '顾客下单', '2026-07-10 21:35:04', 'C端销售出库 - XS202607100001');
INSERT INTO `cdc_inventory_log` VALUES (603, 27, 'SALE_OUT', -23, 25, 2, 'XS202607100001', '顾客下单', '2026-07-10 21:35:04', 'C端销售出库 - XS202607100001');
INSERT INTO `cdc_inventory_log` VALUES (604, 28, 'SALE_OUT', -2, 207, 205, 'XS202607100001', '顾客下单', '2026-07-10 21:35:04', 'C端销售出库 - XS202607100001');
INSERT INTO `cdc_inventory_log` VALUES (605, 27, 'SALE_OUT', -1, 2, 1, 'XS202607110001', '顾客下单', '2026-07-11 15:41:23', 'C端销售出库 - XS202607110001');
INSERT INTO `cdc_inventory_log` VALUES (606, 28, 'SALE_OUT', -1, 205, 204, 'XS202607110001', '顾客下单', '2026-07-11 15:41:23', 'C端销售出库 - XS202607110001');
INSERT INTO `cdc_inventory_log` VALUES (607, 28, 'PURCHASE_IN', 4, 204, 208, 'PO20260711001', 'admin', '2026-07-11 15:46:59', '采购入库 - PO20260711001');
INSERT INTO `cdc_inventory_log` VALUES (608, 1000, 'PURCHASE_IN', 11000, 0, 11000, 'PO20260713001', 'admin', '2026-07-13 17:51:38', '采购入库 - PO20260713001');
INSERT INTO `cdc_inventory_log` VALUES (609, 17, 'SALE_OUT', -1, 40, 39, 'XS202607130001', '顾客下单', '2026-07-13 18:09:28', 'C端销售出库 - XS202607130001');
INSERT INTO `cdc_inventory_log` VALUES (610, 20, 'SALE_OUT', -10, 200, 190, 'XS202607140001', '顾客下单', '2026-07-14 11:26:20', 'C端销售出库 - XS202607140001');
INSERT INTO `cdc_inventory_log` VALUES (611, 20, 'SALE_OUT', -2, 190, 188, 'XS202607140002', '顾客下单', '2026-07-14 18:32:17', 'C端销售出库 - XS202607140002');
INSERT INTO `cdc_inventory_log` VALUES (612, 7, 'SALE_OUT', -1, 300, 299, 'XS202607140003', '顾客下单', '2026-07-14 20:21:31', 'C端销售出库 - XS202607140003');

-- ----------------------------
-- Table structure for cdc_knowledge_doc
-- ----------------------------
DROP TABLE IF EXISTS `cdc_knowledge_doc`;
CREATE TABLE `cdc_knowledge_doc`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文档ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文档标题',
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '未分类' COMMENT '分类标签',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文档全文（从Word解析的纯文本）',
  `file_size` bigint NULL DEFAULT 0 COMMENT '原始文件大小（字节）',
  `chunked` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '是否已切片（0=未切片 1=已切片）',
  `chunk_count` int NULL DEFAULT 0 COMMENT '切片数量',
  `chunk_size` int NULL DEFAULT 300 COMMENT '切片大小（字符）',
  `overlap` int NULL DEFAULT 50 COMMENT '滑动窗口重叠（字符）',
  `doc_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Milvus中的文档标识（用于删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '知识库文档管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_knowledge_doc
-- ----------------------------
INSERT INTO `cdc_knowledge_doc` VALUES (3, 'CDC超市规章制度及热卖商品', '规章制度', 'CDC 超市规章制度\n\n第一章  总则\n\n第一条  为规范超市经营管理，保障消费者权益，提高服务质量，特制定本制度。\n\n第二条  本制度适用于 CDC 超市所有门店及全体员工，各部门应严格遵照执行。\n\n第三条  超市经营应当遵循\"诚信为本、顾客至上、质量第一\"的基本原则，持续提升顾客满意度。\n\n第二章  商品质量管理\n\n第四条  所有上架商品必须具备完整的质量合格证明，严禁销售\"三无\"产品及过期变质商品。采购部门应严格审核供应商资质，确保货源可追溯。\n\n第五条  生鲜类商品（蔬菜、水果、肉类、水产等）实行\"日清日结\"制度，当日未售出的生鲜商品须在闭店后 2 小时内完成下架处理，并记录报废台账。\n\n第六条  常温商品须在保质期前 30 天进行临期预警，保质期前 15 天下架或转入临期专区降价销售。临期商品须在显著位置标明\"临期商品\"字样。\n\n第三章  员工行为规范\n\n第七条  员工上岗须穿着统一工装，佩戴工牌，保持仪容整洁。男员工不得留长发，女员工长发须束起。\n\n第八条  员工应使用文明用语，主动为顾客提供导购服务。严禁与顾客发生争执，如有投诉须第一时间上报值班经理处理。\n\n第九条  收银员须严格按操作规程收款，唱收唱付，确保账款相符。每日交接班须清点备用金，差异超过 10 元须查明原因并上报。\n\n第四章  安全管理制度\n\n第十条  消防通道须保持 24 小时畅通，灭火器每月巡检一次，消防栓每季度试水一次。全体员工每年至少参加一次消防演练。\n\n第十一条  监控系统须覆盖卖场、仓库、收银台、出入口等关键区域，录像资料保存不少于 30 天。严禁私自删除或篡改监控记录。\n\n第十二条  食品安全实行店长负责制，每周至少进行一次全面卫生检查。熟食区操作人员须持健康证上岗，每日晨检体温并记录。\n\n附：本周热卖商品推荐\n\n以下为本周期（7月第二周）销量排名前列的热卖商品，供各门店参考备货：\n\n备货建议\n\n一、粮油调味类：五常大米和金龙鱼花生油为持续热销品，建议各门店保持日均库存不低于 50 件。夏季高温，食用油储存须避开阳光直射区域。\n\n二、饮料冲调类：农夫山泉矿泉水为季节性爆品，建议增加堆头陈列面积 30%，收银台旁设置随手购专区，单瓶售价 1.5 元。\n\n三、休闲零食类：良品铺子每日坚果可搭配牛奶做捆绑销售（坚果+牛奶立减10元），预计可提升客单价 15%-20%。\n\n四、冷冻食品类：速冻水饺主攻年轻客群，建议在学生公寓周边门店增加铺货，配合晚间 18:00-21:00 的限时折扣活动。\n\n五、乳制品类：特仑苏和安慕希均为高频复购品，保持端架陈列，每周五至周日为销售高峰，请提前补货确保周末库存充足。\n\n本周促销活动安排\n\n活动一\"清凉一夏\"（7月14日-7月20日）：饮料冲调类满 50 减 10，农夫山泉、可口可乐、统一冰红茶等 30 余款参与。\n\n活动二\"周末囤货日\"（7月18日-7月19日）：粮油调味 8.8 折，会员双倍积分。五常大米限购 2 袋/人，先到先得。\n\n活动三\"零食大礼包\"（7月14日-7月20日）：休闲零食满 99 赠良品铺子坚果试吃装 1 份，新品薯片买一送一。\n\nCDC 超市运营管理部\n\n2026年7月13日', 11, '1', 6, 300, 50, 'c6891200', NULL, '2026-07-13 21:30:27', '', '2026-07-13 21:30:27', NULL);

-- ----------------------------
-- Table structure for cdc_knowledge_faq
-- ----------------------------
DROP TABLE IF EXISTS `cdc_knowledge_faq`;
CREATE TABLE `cdc_knowledge_faq`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'FAQ ID',
  `question` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '问题',
  `answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '回答',
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '通用' COMMENT '分类标签',
  `enabled` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '状态（0=禁用 1=启用）',
  `order_num` int NULL DEFAULT 0 COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '知识库FAQ问答表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_knowledge_faq
-- ----------------------------
INSERT INTO `cdc_knowledge_faq` VALUES (3, '退换货流程是什么', '如需退换货，请在购买后7天内携带购物小票和商品到服务台办理。商品需保持原包装完好，食品类商品一经开封概不退换。退款将在3个工作日内原路返回。', '售后服务', '1', NULL, 'admin', '2026-07-13 21:24:19', '', '2026-07-13 21:24:19', NULL);
INSERT INTO `cdc_knowledge_faq` VALUES (4, '运费怎么算', '满99元包邮，不满99元收取10元运费。生鲜类商品满199元包邮。部分偏远地区（西藏、新疆、内蒙古）运费另计，下单时系统会自动计算。', '配送物流', '1', NULL, 'admin', '2026-07-13 21:24:21', '', '2026-07-13 21:24:21', NULL);
INSERT INTO `cdc_knowledge_faq` VALUES (5, '有没有优惠活动', '!目前有三大优惠活动：1. 新用户首单满50减10元；2. 每周五六日粮油8.8折；3. 会员积分可兑换优惠券，100积分=5元。具体活动以页面展示为准。', '促销活动', '1', NULL, 'admin', '2026-07-13 21:24:21', 'admin', '2026-07-13 21:28:55', NULL);
INSERT INTO `cdc_knowledge_faq` VALUES (6, '会员积分怎么用', '每消费1元积1分，100积分可兑换5元优惠券。积分在订单签收后次日到账，有效期一年。积分可在\"我的-积分商城\"中兑换优惠券或商品。', '会员服务', '1', NULL, 'admin', '2026-07-13 21:24:21', '', '2026-07-13 21:24:21', NULL);
INSERT INTO `cdc_knowledge_faq` VALUES (7, '超市营业时间', '周一至周五：8:00-22:00；周六日及节假日：8:00-22:30。春节期间营业时间另行通知。线上商城24小时可下单，配送时间为8:30-21:00。', '门店信息', '1', NULL, 'admin', '2026-07-13 21:24:22', '', '2026-07-13 21:24:22', NULL);
INSERT INTO `cdc_knowledge_faq` VALUES (8, '怎么联系客服', '您可以通过以下方式联系客服：1. 拨打客服热线 400-888-6666（8:00-22:00）；2. 在APP/小程序中点击\"在线客服\"；3. 发送邮件至 service@cdc-market.com。', '售后服务', '1', NULL, 'admin', '2026-07-13 21:24:22', '', '2026-07-13 21:24:22', NULL);
INSERT INTO `cdc_knowledge_faq` VALUES (9, '可以开发票吗', '可以的。下单时在结算页面勾选\"需要发票\"，填写发票抬头和税号即可。电子发票在签收后24小时内发送到您的邮箱，纸质发票随包裹寄出。企业用户支持增值税专用发票。', '售后服务', '1', NULL, 'admin', '2026-07-13 21:24:22', '', '2026-07-13 21:24:22', NULL);
INSERT INTO `cdc_knowledge_faq` VALUES (10, '如何修改订单', '订单在\"待发货\"状态时可以修改收货地址和联系方式。如需修改商品，请取消订单后重新下单。订单状态查询路径：我的 → 我的订单 → 查看详情。', '订单相关', '1', NULL, 'admin', '2026-07-13 21:24:22', '', '2026-07-13 21:24:22', NULL);
INSERT INTO `cdc_knowledge_faq` VALUES (11, '商品破损怎么办', '收货时请当面验货。如发现商品破损、漏液等问题，请拒收并拍照留证，联系客服申请补发或退款。已签收后发现的质量问题，请在24小时内联系客服处理。', '售后服务', '1', NULL, 'admin', '2026-07-13 21:24:22', '', '2026-07-13 21:24:22', NULL);
INSERT INTO `cdc_knowledge_faq` VALUES (12, '有没有生鲜配送', '有生鲜配送服务，覆盖门店周边5公里范围。生鲜订单满199元包邮，不满199元收取15元运费。生鲜商品在8:30-11:00下单，当日14:00前送达；11:00后下单，次日送达。', '配送物流', '1', NULL, 'admin', '2026-07-13 21:24:23', '', '2026-07-13 21:24:23', NULL);
INSERT INTO `cdc_knowledge_faq` VALUES (13, '怎么注销账号', '如需注销账号，请在APP\"设置-账号安全-注销账号\"中提交申请。注销后账户余额、积分、优惠券将全部清空且不可恢复，请谨慎操作。注销审核需1-3个工作日。', '会员服务', '1', NULL, 'admin', '2026-07-13 21:24:23', '', '2026-07-13 21:24:23', NULL);
INSERT INTO `cdc_knowledge_faq` VALUES (14, '哪些商品支持七天无理由退货', '非食品类商品（日用品、家居用品、个护清洁等）支持七天无理由退货。食品、生鲜、个人护理（已开封）、内衣裤袜等特殊商品不支持无理由退货，具体以商品详情页标注为准。', '售后服务', '1', NULL, 'admin', '2026-07-13 21:24:23', '', '2026-07-13 21:24:23', NULL);

-- ----------------------------
-- Table structure for cdc_portal_order
-- ----------------------------
DROP TABLE IF EXISTS `cdc_portal_order`;
CREATE TABLE `cdc_portal_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单号（SO+日期+序号）',
  `session_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '匿名会话ID',
  `customer_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '取货手机号',
  `customer_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '取货人姓名',
  `total_amount` decimal(10, 2) NOT NULL COMMENT '订单总金额',
  `item_count` int NOT NULL COMMENT '商品件数',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'pending' COMMENT '状态(pending/confirmed/completed/cancelled)',
  `complete_time` datetime NULL DEFAULT NULL COMMENT '完成/取消时间',
  `remark` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '顾客备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_phone`(`customer_phone` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_session`(`session_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 410 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'C端订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_portal_order
-- ----------------------------
INSERT INTO `cdc_portal_order` VALUES (400, 'XS202607100001', 'mreyvfqg', '15519214229', '', 1824.50, 29, 'completed', '2026-07-10 21:35:16', '', '2026-07-10 21:35:04');
INSERT INTO `cdc_portal_order` VALUES (401, 'XS202607110001', 'mreyvfqg', '15519142296', '', 70.50, 2, 'completed', '2026-07-11 15:42:26', '', '2026-07-11 15:41:23');
INSERT INTO `cdc_portal_order` VALUES (402, 'XS202607130001', 'mrgg7gsg', '12345678912', '', 9.90, 1, 'pending', NULL, '', '2026-07-13 18:09:28');
INSERT INTO `cdc_portal_order` VALUES (403, 'XS202607140001', 'mrk2krc7', '15519142296', '', 50.00, 10, 'pending', NULL, '', '2026-07-14 11:26:20');
INSERT INTO `cdc_portal_order` VALUES (408, 'XS202607140002', 'mrk2krc7', '155****2296', '朱茂林', 10.00, 2, 'pending', NULL, '', '2026-07-14 18:32:17');
INSERT INTO `cdc_portal_order` VALUES (409, 'XS202607140003', 'mrk2krc7', '15519142296', '朱茂林', 2.00, 1, 'pending', NULL, '', '2026-07-14 20:21:31');

-- ----------------------------
-- Table structure for cdc_portal_order_item
-- ----------------------------
DROP TABLE IF EXISTS `cdc_portal_order_item`;
CREATE TABLE `cdc_portal_order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `product_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称（快照）',
  `price` decimal(10, 2) NOT NULL COMMENT '单价（快照）',
  `quantity` int NOT NULL COMMENT '购买数量',
  `shelf_area` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '货架位置（快照）',
  `subtotal` decimal(10, 2) NOT NULL COMMENT '小计',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 510 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'C端订单明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_portal_order_item
-- ----------------------------
INSERT INTO `cdc_portal_order_item` VALUES (500, 400, 24, '阿莫西林胶囊', 18.50, 1, 'B区-3排-1层', 18.50);
INSERT INTO `cdc_portal_order_item` VALUES (501, 400, 26, '深入理解Java虚拟机', 79.00, 3, 'B区-2排-1层', 237.00);
INSERT INTO `cdc_portal_order_item` VALUES (502, 400, 27, '原则', 68.00, 23, 'C区-1排-1层', 1564.00);
INSERT INTO `cdc_portal_order_item` VALUES (503, 400, 28, '晨光中性笔', 2.50, 2, 'D区-1排-1层', 5.00);
INSERT INTO `cdc_portal_order_item` VALUES (504, 401, 27, '原则', 68.00, 1, 'C区-1排-1层', 68.00);
INSERT INTO `cdc_portal_order_item` VALUES (505, 401, 28, '晨光中性笔', 2.50, 1, 'D区-1排-1层', 2.50);
INSERT INTO `cdc_portal_order_item` VALUES (506, 402, 17, '富士苹果', 9.90, 1, 'D区-2排-1层', 9.90);
INSERT INTO `cdc_portal_order_item` VALUES (507, 403, 20, '青岛啤酒', 5.00, 10, 'F区-1排-1层', 50.00);
INSERT INTO `cdc_portal_order_item` VALUES (508, 408, 20, '青岛啤酒', 5.00, 2, 'F区-1排-1层', 10.00);
INSERT INTO `cdc_portal_order_item` VALUES (509, 409, 7, '农夫山泉矿泉水', 2.00, 1, 'B区-1排-2层', 2.00);

-- ----------------------------
-- Table structure for cdc_product
-- ----------------------------
DROP TABLE IF EXISTS `cdc_product`;
CREATE TABLE `cdc_product`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `scene_id` bigint NOT NULL COMMENT '所属场景ID',
  `category_id` bigint NULL DEFAULT NULL COMMENT '商品分类ID',
  `barcode` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '商品条码',
  `product_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称',
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '价格',
  `stock` int NULL DEFAULT 0 COMMENT '库存数量',
  `unit` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '件' COMMENT '单位（件/盒/瓶/袋）',
  `shelf_area` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '货架位置（如 A区-3排-2层）',
  `image_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '商品图片URL',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '商品详细说明（用于AI知识检索）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0上架 1下架）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_scene_category`(`scene_id` ASC, `category_id` ASC) USING BTREE,
  INDEX `idx_product_name`(`product_name` ASC) USING BTREE,
  INDEX `idx_barcode`(`barcode` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1002 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_product
-- ----------------------------
INSERT INTO `cdc_product` VALUES (1, 1, 1, '6901234560001', '乐事原味薯片', 8.50, 100, '袋', 'A区-1排-1层', '', '乐事经典原味薯片，75g袋装，香脆可口，休闲零食首选。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (2, 1, 1, '6901234560002', '奥利奥夹心饼干', 12.80, 80, '盒', 'A区-1排-2层', '', '奥利奥原味夹心饼干，194g盒装，经典黑白配。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (3, 1, 1, '6901234560003', '三只松鼠每日坚果', 45.00, 50, '盒', 'A区-1排-3层', '', '三只松鼠每日坚果，750g礼盒装，混合坚果+果干，健康零食。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (4, 1, 1, '6901234560004', '良品铺子牛肉干', 29.90, 60, '袋', 'A区-2排-1层', '', '良品铺子麻辣牛肉干，200g袋装，精选牛后腿肉。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (5, 1, 1, '6901234560005', '旺旺仙贝', 15.00, 120, '袋', 'A区-2排-2层', '', '旺旺仙贝米饼，400g家庭装，酥脆可口。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (6, 1, 2, '6901234560006', '可口可乐', 3.00, 200, '瓶', 'B区-1排-1层', '', '可口可乐碳酸饮料，500ml瓶装，冰镇更佳。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (7, 1, 2, '6901234560007', '农夫山泉矿泉水', 2.00, 299, '瓶', 'B区-1排-2层', '', '农夫山泉天然矿泉水，550ml瓶装，源自天然水源。', '0', '0', 'admin', '2026-07-10 18:46:59', '', '2026-07-14 20:21:31', '');
INSERT INTO `cdc_product` VALUES (8, 1, 2, '6901234560008', '蒙牛纯牛奶', 5.50, 150, '盒', 'B区-1排-3层', '', '蒙牛纯牛奶，250ml盒装，高钙营养。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (9, 1, 2, '6901234560009', '统一冰红茶', 3.50, 180, '瓶', 'B区-2排-1层', '', '统一冰红茶柠檬味，500ml瓶装，清爽解渴。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (10, 1, 2, '6901234560010', '美汁源果粒橙', 4.00, 120, '瓶', 'B区-2排-2层', '', '美汁源果粒橙，420ml瓶装，含真实果粒。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (11, 1, 3, '6901234560011', '蓝月亮洗衣液', 29.90, 80, '瓶', 'C区-1排-1层', '', '蓝月亮薰衣草香洗衣液，1kg瓶装，深层清洁。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (12, 1, 3, '6901234560012', '维达抽纸', 18.90, 100, '提', 'C区-1排-2层', '', '维达超韧抽纸，3层130抽×6包，柔软亲肤。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (13, 1, 3, '6901234560013', '佳洁士牙膏', 15.80, 90, '支', 'C区-1排-3层', '', '佳洁士草本牙膏，140g，清新口气防蛀牙。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (14, 1, 3, '6901234560014', '海飞丝洗发水', 45.00, 60, '瓶', 'C区-2排-1层', '', '海飞丝去屑洗发水，400ml瓶装，清爽控油。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (15, 1, 4, '6901234560015', '优选五花肉', 28.00, 30, '斤', 'D区-1排-1层', '', '新鲜五花肉，肥瘦相间，适合红烧、炖煮。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (16, 1, 4, '6901234560016', '有机西红柿', 6.80, 50, '斤', 'D区-1排-2层', '', '有机种植西红柿，新鲜采摘，酸甜可口。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (17, 1, 4, '6901234560017', '富士苹果', 9.90, 39, '斤', 'D区-2排-1层', '', '山东烟台富士苹果，脆甜多汁，单果约200g。', '0', '0', 'admin', '2026-07-10 18:46:59', '', '2026-07-13 18:09:28', '');
INSERT INTO `cdc_product` VALUES (18, 1, 5, '6901234560018', '海天酱油', 12.80, 100, '瓶', 'E区-1排-1层', '', '海天金标生抽，500ml瓶装，酿造酱油。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (19, 1, 5, '6901234560019', '金龙鱼食用油', 59.90, 70, '桶', 'E区-1排-2层', '', '金龙鱼花生油，5L桶装，物理压榨。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (20, 1, 6, '6901234560020', '青岛啤酒', 5.00, 188, '罐', 'F区-1排-1层', '', '青岛啤酒经典1903，330ml罐装，清爽口感。', '0', '0', 'admin', '2026-07-10 18:46:59', '', '2026-07-14 18:32:17', '');
INSERT INTO `cdc_product` VALUES (21, 1, 6, '6901234560021', '张裕干红葡萄酒', 88.00, 40, '瓶', 'F区-1排-2层', '', '张裕解百纳干红葡萄酒，750ml瓶装，橡木桶陈酿。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (22, 2, 7, '6901234560022', '感康复方氨酚烷胺片', 15.80, 50, '盒', 'B区-2排-3层', '', '复方氨酚烷胺片，12片/盒。用于缓解普通感冒及流行性感冒引起的发热、头痛、鼻塞、流涕等症状。成人一日2次，每次1片。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (23, 2, 7, '6901234560023', '布洛芬缓释胶囊', 22.00, 30, '盒', 'B区-2排-4层', '', '布洛芬缓释胶囊，0.3g×20粒/盒。用于缓解头痛、牙痛、痛经等轻中度疼痛，也用于普通感冒引起的发热。饭后服用，成人每日不超过2.4g。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (24, 2, 8, '6901234560024', '阿莫西林胶囊', 18.50, 39, '盒', 'B区-3排-1层', '', '阿莫西林胶囊，0.5g×24粒/盒。青霉素类抗生素，用于敏感菌引起的呼吸道感染、泌尿道感染等。需遵医嘱使用。', '0', '0', 'admin', '2026-07-10 18:46:59', '', '2026-07-10 21:35:04', '');
INSERT INTO `cdc_product` VALUES (25, 3, 12, '9787111111111', '活着', 35.00, 30, '本', 'A区-1排-1层', '', '余华代表作《活着》，北京十月文艺出版社。讲述了一个人一生的故事，展现了中国近现代历史的变迁。豆瓣评分9.4。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_product` VALUES (26, 3, 13, '9787111111112', '深入理解Java虚拟机', 79.00, 17, '本', 'B区-2排-1层', '', '周志明著《深入理解Java虚拟机》第3版，机械工业出版社。全面讲解JVM原理、内存管理、类加载、性能调优等内容。Java开发者必读。', '0', '0', 'admin', '2026-07-10 18:46:59', '', '2026-07-10 21:35:04', '');
INSERT INTO `cdc_product` VALUES (27, 3, 14, '9787111111113', '原则', 68.00, 1, '本', 'C区-1排-1层', '', '瑞·达利欧著《原则》，中信出版社。桥水基金创始人分享的生活和工作原则，帮助做决策的系统化方法。', '0', '0', 'admin', '2026-07-10 18:46:59', '', '2026-07-11 15:41:23', '');
INSERT INTO `cdc_product` VALUES (28, 3, 16, '6901234560028', '晨光中性笔', 2.50, 208, '支', 'D区-1排-1层', '', '晨光K-35按动中性笔，0.5mm黑色，书写顺滑。', '0', '0', 'admin', '2026-07-10 18:46:59', '', '2026-07-11 15:46:59', '');
INSERT INTO `cdc_product` VALUES (1000, 1, 2, '', '茶派', 5.00, 11000, '件', '', '', NULL, '0', '0', 'admin', '2026-07-13 17:50:40', '', '2026-07-13 17:51:38', '');
INSERT INTO `cdc_product` VALUES (1001, 1, 15, '', '草房子', 20.00, 100, '件', '', '', NULL, '0', '0', 'admin', '2026-07-13 18:15:06', '', NULL, '');

-- ----------------------------
-- Table structure for cdc_purchase_order
-- ----------------------------
DROP TABLE IF EXISTS `cdc_purchase_order`;
CREATE TABLE `cdc_purchase_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '采购单ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '采购单号（PO+日期+序号）',
  `supplier_id` bigint NOT NULL COMMENT '供应商ID',
  `total_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '总金额',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'draft' COMMENT '状态(draft/confirmed/received/cancelled)',
  `order_date` date NULL DEFAULT NULL COMMENT '采购日期',
  `receive_date` datetime NULL DEFAULT NULL COMMENT '收货时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_supplier`(`supplier_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 206 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采购单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_purchase_order
-- ----------------------------
INSERT INTO `cdc_purchase_order` VALUES (203, 'PO20260710001', 100, 21.00, 'received', '2026-07-10', '2026-07-10 21:11:24', 'admin', '2026-07-10 21:11:14', 'admin', '2026-07-10 21:11:23', '');
INSERT INTO `cdc_purchase_order` VALUES (204, 'PO20260711001', 100, 8.00, 'received', '2026-07-11', '2026-07-11 15:46:59', 'admin', '2026-07-11 15:46:53', 'admin', '2026-07-11 15:46:59', '');
INSERT INTO `cdc_purchase_order` VALUES (205, 'PO20260713001', 100, 33000.00, 'received', '2026-07-13', '2026-07-13 17:51:39', 'admin', '2026-07-13 17:51:31', 'admin', '2026-07-13 17:51:38', '');

-- ----------------------------
-- Table structure for cdc_purchase_order_item
-- ----------------------------
DROP TABLE IF EXISTS `cdc_purchase_order_item`;
CREATE TABLE `cdc_purchase_order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id` bigint NOT NULL COMMENT '采购单ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `product_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称（快照）',
  `price` decimal(10, 2) NOT NULL COMMENT '采购单价',
  `quantity` int NOT NULL COMMENT '数量',
  `subtotal` decimal(12, 2) NOT NULL COMMENT '小计',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 303 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采购明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_purchase_order_item
-- ----------------------------
INSERT INTO `cdc_purchase_order_item` VALUES (300, 203, 28, '晨光中性笔', 3.00, 7, 21.00);
INSERT INTO `cdc_purchase_order_item` VALUES (301, 204, 28, '晨光中性笔', 2.00, 4, 8.00);
INSERT INTO `cdc_purchase_order_item` VALUES (302, 205, 1000, '茶派', 3.00, 11000, 33000.00);

-- ----------------------------
-- Table structure for cdc_recommend
-- ----------------------------
DROP TABLE IF EXISTS `cdc_recommend`;
CREATE TABLE `cdc_recommend`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `score` int NOT NULL DEFAULT 50 COMMENT '推荐指数（0-100，越高越优先，排序依据）',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '推荐理由（如\"新品上市\"\"季节性热销\"）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0启用 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE,
  INDEX `idx_score`(`score` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '运营推荐榜表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_recommend
-- ----------------------------
INSERT INTO `cdc_recommend` VALUES (1, 1, 50, '', '0', NULL, '2026-07-14 18:21:05', '', '2026-07-14 18:21:05', NULL);
INSERT INTO `cdc_recommend` VALUES (2, 2, 100, '', '0', NULL, '2026-07-14 18:21:33', '', '2026-07-14 18:21:33', NULL);
INSERT INTO `cdc_recommend` VALUES (3, 20, 50, '', '0', NULL, '2026-07-14 21:25:33', '', '2026-07-14 21:25:33', NULL);

-- ----------------------------
-- Table structure for cdc_scene
-- ----------------------------
DROP TABLE IF EXISTS `cdc_scene`;
CREATE TABLE `cdc_scene`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '场景ID',
  `scene_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '场景名称（超市/药店/书店...）',
  `scene_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '场景编码（SC=超市, YD=药店, SD=书店...）',
  `description` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '场景描述',
  `icon` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '场景图标',
  `prompt_template` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'System Prompt模板',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0启用 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_scene_code`(`scene_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '场景表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_scene
-- ----------------------------
INSERT INTO `cdc_scene` VALUES (1, '超市', 'SC', '超市导购场景，包含食品、饮料、日用品等商品', 'supermarket', '你是超市AI导购助手。请根据商品知识库，帮助顾客查找商品位置、价格、库存等信息。回答要简洁准确，商品信息必须来自知识库，不得编造。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_scene` VALUES (2, '药店', 'YD', '药店导购场景，包含药品、保健品等商品', 'pharmacy', '你是药店AI导购助手。请根据药品知识库，帮助顾客查找药品位置、价格、功效、注意事项等信息。涉及药品安全必须谨慎，回答要专业准确。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');
INSERT INTO `cdc_scene` VALUES (3, '书店', 'SD', '书店导购场景，包含图书、文具等商品', 'bookstore', '你是书店AI导购助手。请根据图书知识库，帮助读者查找图书位置、价格、简介等信息，也可推荐相关书籍。', '0', '0', 'admin', '2026-07-10 18:46:59', '', NULL, '');

-- ----------------------------
-- Table structure for cdc_supplier
-- ----------------------------
DROP TABLE IF EXISTS `cdc_supplier`;
CREATE TABLE `cdc_supplier`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '供应商ID',
  `supplier_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '供应商名称',
  `contact_person` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '联系人',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '联系电话',
  `email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '邮箱',
  `address` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '地址',
  `bank_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '开户行',
  `bank_account` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '银行账号',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0启用 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0存在 2删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '供应商表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cdc_supplier
-- ----------------------------
INSERT INTO `cdc_supplier` VALUES (100, '朱茂林', '15519142296', '15519142296', '3231179598@qq.com', '', '', '', '0', '0', 'admin', '2026-07-10 21:07:41', '', NULL, '');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int NULL DEFAULT 1 COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-07-10 18:24:23', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-07-10 18:24:23', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-07-10 18:24:23', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2026-07-10 18:24:23', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2026-07-10 18:24:23', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2026-07-10 18:24:23', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2026-07-10 18:24:23', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-07-10 18:24:23', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (9, '用户管理-密码字符范围', 'sys.account.chrtype', '0', 'Y', 'admin', '2026-07-10 18:24:23', '', NULL, '默认任意字符范围，0任意（密码可以输入任意字符），1数字（密码只能为0-9数字），2英文字母（密码只能为a-z和A-Z字母），3字母和数字（密码必须包含字母，数字）,4字母数字和特殊字符（目前支持的特殊字符包括：~!@#$%^&*()-=_+）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-07-10 18:24:23', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-07-10 18:24:23', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-07-10 18:24:23', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-07-10 18:24:23', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-07-10 18:24:23', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-07-10 18:24:23', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-07-10 18:24:23', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-07-10 18:24:23', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-07-10 18:24:23', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-07-10 18:24:23', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2026-07-10 18:24:23', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '异常信息',
  `start_time` datetime NULL DEFAULT NULL COMMENT '执行开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '执行结束时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 137 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-10 19:48:17');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-10 19:48:22');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-11 15:21:14');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-11 15:21:19');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-11 15:28:52');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-11 15:35:04');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '1', '验证码错误', '2026-07-11 15:35:04');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-11 16:53:21');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-11 17:58:18');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-11 17:58:18');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-11 18:00:56');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-11 18:00:59');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-11 22:07:53');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-12 08:49:22');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-12 20:05:44');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-12 20:05:47');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-13 08:36:43');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-13 12:31:07');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-13 13:41:26');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-13 17:38:09');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-13 19:30:17');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-13 20:31:03');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-13 21:11:10');
INSERT INTO `sys_logininfor` VALUES (123, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-14 09:31:15');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-14 10:18:18');
INSERT INTO `sys_logininfor` VALUES (125, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-14 10:53:29');
INSERT INTO `sys_logininfor` VALUES (126, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-14 11:09:25');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-14 14:31:59');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-14 16:28:06');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-14 17:53:37');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-14 20:07:58');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-14 21:24:08');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-19 09:06:54');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-19 09:40:08');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-19 11:18:11');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-19 11:18:14');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Edge 150', 'Windows >=10', '0', '登录成功', '2026-07-19 14:40:38');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2049 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2026-07-10 18:24:23', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2026-07-10 18:24:23', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2026-07-10 18:24:23', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '1', '1', '', 'guide', 'admin', '2026-07-10 18:24:23', 'admin', '2026-07-11 15:47:47', '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2026-07-10 18:24:23', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2026-07-10 18:24:23', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2026-07-10 18:24:23', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2026-07-10 18:24:23', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2026-07-10 18:24:23', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2026-07-10 18:24:23', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2026-07-10 18:24:23', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2026-07-10 18:24:23', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2026-07-10 18:24:23', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2026-07-10 18:24:23', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2026-07-10 18:24:23', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2026-07-10 18:24:23', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2026-07-10 18:24:23', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2026-07-10 18:24:23', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2026-07-10 18:24:23', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2026-07-10 18:24:23', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2026-07-10 18:24:23', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2026-07-10 18:24:23', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2026-07-10 18:24:23', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2026-07-10 18:24:23', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '业务管理', 0, 4, 'business', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'tree', 'admin', '2026-07-10 19:51:29', '', NULL, '业务管理目录');
INSERT INTO `sys_menu` VALUES (2007, '分类管理', 2000, 2, 'category', 'business/category/index', NULL, '', 1, 0, 'C', '0', '0', 'business:category:list', 'list', 'admin', '2026-07-10 19:51:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2008, '分类新增', 2007, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:category:add', '#', 'admin', '2026-07-10 19:51:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2009, '分类修改', 2007, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:category:edit', '#', 'admin', '2026-07-10 19:51:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2010, '分类删除', 2007, 3, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:category:remove', '#', 'admin', '2026-07-10 19:51:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2011, '分类查询', 2007, 4, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:category:query', '#', 'admin', '2026-07-10 19:51:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2012, '商品管理', 2000, 3, 'product', 'business/product/index', NULL, '', 1, 0, 'C', '0', '0', 'business:product:list', 'shopping', 'admin', '2026-07-10 19:51:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2013, '商品新增', 2012, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:product:add', '#', 'admin', '2026-07-10 19:51:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2014, '商品修改', 2012, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:product:edit', '#', 'admin', '2026-07-10 19:51:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2015, '商品删除', 2012, 3, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:product:remove', '#', 'admin', '2026-07-10 19:51:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2016, '商品查询', 2012, 4, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:product:query', '#', 'admin', '2026-07-10 19:51:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2017, '商品导出', 2012, 5, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:product:export', '#', 'admin', '2026-07-10 19:51:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2018, '商品导入', 2012, 6, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:product:import', '#', 'admin', '2026-07-10 19:51:29', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2019, '供应商管理', 2035, 1, 'supplier', 'business/supplier/index', NULL, '', 1, 0, 'C', '0', '0', 'business:supplier:list', 'peoples', 'admin', '2026-07-10 21:01:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2020, '供应商新增', 2019, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:supplier:add', '#', 'admin', '2026-07-10 21:01:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2021, '供应商修改', 2019, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:supplier:edit', '#', 'admin', '2026-07-10 21:01:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2022, '供应商删除', 2019, 3, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:supplier:remove', '#', 'admin', '2026-07-10 21:01:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2023, '供应商查询', 2019, 4, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:supplier:query', '#', 'admin', '2026-07-10 21:01:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2024, '采购管理', 2035, 2, 'purchase', 'business/purchase/index', NULL, '', 1, 0, 'C', '0', '0', 'business:purchase:list', 'build', 'admin', '2026-07-10 21:01:48', 'admin', '2026-07-11 15:47:19', '');
INSERT INTO `sys_menu` VALUES (2025, '采购单新增', 2024, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:purchase:add', '#', 'admin', '2026-07-10 21:01:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2026, '采购单修改', 2024, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:purchase:edit', '#', 'admin', '2026-07-10 21:01:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2027, '采购单删除', 2024, 3, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:purchase:remove', '#', 'admin', '2026-07-10 21:01:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2028, '采购单确认', 2024, 4, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:purchase:confirm', '#', 'admin', '2026-07-10 21:01:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2029, '采购单收货', 2024, 5, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:purchase:receive', '#', 'admin', '2026-07-10 21:01:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2030, '订单管理', 2035, 3, 'order', 'business/order/index', NULL, '', 1, 0, 'C', '0', '0', 'business:order:list', 'chart', 'admin', '2026-07-10 21:01:48', 'admin', '2026-07-11 15:47:27', '');
INSERT INTO `sys_menu` VALUES (2031, '订单详情', 2030, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:order:query', '#', 'admin', '2026-07-10 21:01:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2032, '订单完成', 2030, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:order:complete', '#', 'admin', '2026-07-10 21:01:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2033, '订单取消', 2030, 3, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'business:order:cancel', '#', 'admin', '2026-07-10 21:01:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2034, '库存流水', 2035, 4, 'inventory', 'business/inventory/index', NULL, '', 1, 0, 'C', '0', '0', 'business:inventory:list', 'log', 'admin', '2026-07-10 21:01:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2035, '进销存管理', 0, 5, 'psi', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'cascader', 'admin', '2026-07-10 21:01:48', '', NULL, '进销存管理目录');
INSERT INTO `sys_menu` VALUES (2036, '库存总览', 2035, 5, 'stock', 'business/stock/index', NULL, '', 1, 0, 'C', '0', '0', 'business:stock:list', 'chart', 'admin', '2026-07-10 22:03:31', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2037, 'AI管理', 0, 9, 'ai', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'monitor', 'admin', '2026-07-13 13:44:49', '', '2026-07-13 13:44:49', '');
INSERT INTO `sys_menu` VALUES (2038, 'AI评测', 2037, 1, 'eval', 'ai/eval/index', NULL, '', 1, 0, 'C', '0', '0', 'ai:eval:list', '#', 'admin', '2026-07-13 13:44:49', '', '2026-07-13 13:44:49', '');
INSERT INTO `sys_menu` VALUES (2039, '对话日志', 2037, 2, 'chatlog', 'ai/eval/chatlog', NULL, '', 1, 0, 'C', '0', '0', 'ai:chatlog:list', '#', 'admin', '2026-07-13 14:35:49', '', '2026-07-13 14:35:49', '');
INSERT INTO `sys_menu` VALUES (2040, '知识库管理', 2037, 3, 'knowledge', 'ai/knowledge/index', NULL, '', 1, 0, 'C', '0', '0', 'ai:knowledge:list', '#', 'admin', '2026-07-13 19:27:54', '', '2026-07-13 19:27:54', '');
INSERT INTO `sys_menu` VALUES (2041, 'FAQ管理', 2037, 4, 'faq', 'ai/faq/index', NULL, '', 1, 0, 'C', '0', '0', 'business:faq:list', '#', 'admin', '2026-07-13 21:05:54', '', '2026-07-13 21:05:54', '');
INSERT INTO `sys_menu` VALUES (2048, '排行榜管理', 2000, 8, 'ranking', 'ai/ranking/index', NULL, '', 1, 0, 'C', '0', '0', 'business:ranking:list', '#', 'admin', '2026-07-14 18:14:16', '', '2026-07-14 18:14:16', '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2026-07-10 18:24:23', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2026-07-10 18:24:23', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (3, '若依开源框架介绍', '1', 0x3C703E3C7370616E207374796C653D22636F6C6F723A20726762283233302C20302C2030293B223EE9A1B9E79BAEE4BB8BE7BB8D3C2F7370616E3E3C2F703E3C703E3C666F6E7420636F6C6F723D2223333333333333223E52756F5969E5BC80E6BA90E9A1B9E79BAEE698AFE4B8BAE4BC81E4B89AE794A8E688B7E5AE9AE588B6E79A84E5908EE58FB0E8849AE6898BE69EB6E6A186E69EB6EFBC8CE4B8BAE4BC81E4B89AE68993E980A0E79A84E4B880E7AB99E5BC8FE8A7A3E586B3E696B9E6A188EFBC8CE9998DE4BD8EE4BC81E4B89AE5BC80E58F91E68890E69CACEFBC8CE68F90E58D87E5BC80E58F91E69588E78E87E38082E4B8BBE8A681E58C85E68BACE794A8E688B7E7AEA1E79086E38081E8A792E889B2E7AEA1E79086E38081E983A8E997A8E7AEA1E79086E38081E88F9CE58D95E7AEA1E79086E38081E58F82E695B0E7AEA1E79086E38081E5AD97E585B8E7AEA1E79086E380813C2F666F6E743E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE5B297E4BD8DE7AEA1E790863C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE38081E5AE9AE697B6E4BBBBE58AA13C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE380813C2F7370616E3E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE69C8DE58AA1E79B91E68EA7E38081E799BBE5BD95E697A5E5BF97E38081E6938DE4BD9CE697A5E5BF97E38081E4BBA3E7A081E7949FE68890E7AD89E58A9FE883BDE38082E585B6E4B8ADEFBC8CE8BF98E694AFE68C81E5A49AE695B0E68DAEE6BA90E38081E695B0E68DAEE69D83E99990E38081E59BBDE99985E58C96E380815265646973E7BC93E5AD98E38081446F636B6572E983A8E7BDB2E38081E6BB91E58AA8E9AA8CE8AF81E7A081E38081E7ACACE4B889E696B9E8AEA4E8AF81E799BBE5BD95E38081E58886E5B883E5BC8FE4BA8BE58AA1E380813C2F7370616E3E3C666F6E7420636F6C6F723D2223333333333333223EE58886E5B883E5BC8FE69687E4BBB6E5AD98E582A83C2F666F6E743E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE38081E58886E5BA93E58886E8A1A8E5A484E79086E7AD89E68A80E69CAFE789B9E782B9E380823C2F7370616E3E3C2F703E3C703E3C696D67207372633D2268747470733A2F2F666F727564612E67697465652E636F6D2F696D616765732F313737333933313834383334323433393033322F61346432323331335F313831353039352E706E6722207374796C653D2277696474683A20363470783B223E3C62723E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A20726762283233302C20302C2030293B223EE5AE98E7BD91E58F8AE6BC94E7A4BA3C2F7370616E3E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE88BA5E4BE9DE5AE98E7BD91E59CB0E59D80EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F72756F79692E7669703C2F613E3C6120687265663D22687474703A2F2F72756F79692E76697022207461726765743D225F626C616E6B223E3C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE88BA5E4BE9DE69687E6A1A3E59CB0E59D80EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F646F632E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F646F632E72756F79692E7669703C2F613E3C62723E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E4B88DE58886E7A6BBE78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F64656D6F2E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F64656D6F2E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E58886E7A6BBE78988E69CACE38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F7675652E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F7675652E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E5BEAEE69C8DE58AA1E78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F636C6F75642E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F636C6F75642E72756F79692E7669703C2F613E3C2F703E3C703E3C7370616E207374796C653D22636F6C6F723A207267622835312C2035312C203531293B223EE6BC94E7A4BAE59CB0E59D80E38090E7A7BBE58AA8E7ABAFE78988E38091EFBC9A266E6273703B3C2F7370616E3E3C6120687265663D22687474703A2F2F68352E72756F79692E76697022207461726765743D225F626C616E6B223E687474703A2F2F68352E72756F79692E7669703C2F613E3C2F703E3C703E3C6272207374796C653D22636F6C6F723A207267622834382C2034392C203531293B20666F6E742D66616D696C793A202671756F743B48656C766574696361204E6575652671756F743B2C2048656C7665746963612C20417269616C2C2073616E732D73657269663B20666F6E742D73697A653A20313270783B223E3C2F703E, '0', 'admin', '2026-07-10 18:24:23', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_notice_read
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice_read`;
CREATE TABLE `sys_notice_read`  (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`) USING BTREE,
  UNIQUE INDEX `uk_user_notice`(`user_id` ASC, `notice_id` ASC) USING BTREE COMMENT '同一用户同一公告只记录一次'
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告已读记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice_read
-- ----------------------------
INSERT INTO `sys_notice_read` VALUES (1, 3, 1, '2026-07-14 18:01:29');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 141 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '供应商管理', 1, 'com.ruoyi.web.controller.business.SupplierController.add()', 'POST', 1, 'admin', '研发部门', '/business/supplier', '127.0.0.1', '内网IP', '{\"contactPerson\":\"15519142296\",\"createBy\":\"admin\",\"email\":\"3231179598@qq.com\",\"params\":{},\"phone\":\"15519142296\",\"status\":\"0\",\"supplierName\":\"朱茂林\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-10 21:07:41', 538);
INSERT INTO `sys_oper_log` VALUES (101, '采购订单', 1, 'com.ruoyi.web.controller.business.PurchaseOrderController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"supplierId\":100} ', NULL, 1, 'Cannot invoke \"java.util.List.iterator()\" because \"items\" is null', '2026-07-10 21:07:57', 93);
INSERT INTO `sys_oper_log` VALUES (102, '采购订单', 1, 'com.ruoyi.web.controller.business.PurchaseOrderController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"purchaseItems\":[{\"orderId\":200,\"productId\":28,\"productName\":\"晨光中性笔\",\"quantity\":6}],\"supplierId\":100} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'price\' cannot be null\r\n### The error may exist in file [D:\\ij\\xmwjj\\cdc-aics\\cdc-aics-server\\cdc-aics-business\\target\\classes\\mapper\\business\\PurchaseOrderItemMapper.xml]\r\n### The error may involve com.ruoyi.business.mapper.PurchaseOrderItemMapper.batchInsert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cdc_purchase_order_item (order_id, product_id, product_name, price, quantity, subtotal)         values                        (?, ?, ?, ?, ?, ?)\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'price\' cannot be null\n; Column \'price\' cannot be null', '2026-07-10 21:10:07', 1828);
INSERT INTO `sys_oper_log` VALUES (103, '采购订单', 1, 'com.ruoyi.web.controller.business.PurchaseOrderController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"purchaseItems\":[{\"orderId\":201,\"productId\":28,\"productName\":\"晨光中性笔\",\"quantity\":6}],\"supplierId\":100} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'price\' cannot be null\r\n### The error may exist in file [D:\\ij\\xmwjj\\cdc-aics\\cdc-aics-server\\cdc-aics-business\\target\\classes\\mapper\\business\\PurchaseOrderItemMapper.xml]\r\n### The error may involve com.ruoyi.business.mapper.PurchaseOrderItemMapper.batchInsert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cdc_purchase_order_item (order_id, product_id, product_name, price, quantity, subtotal)         values                        (?, ?, ?, ?, ?, ?)\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'price\' cannot be null\n; Column \'price\' cannot be null', '2026-07-10 21:10:07', 780);
INSERT INTO `sys_oper_log` VALUES (104, '采购订单', 1, 'com.ruoyi.web.controller.business.PurchaseOrderController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"purchaseItems\":[{\"orderId\":202,\"productId\":28,\"productName\":\"晨光中性笔\",\"quantity\":10}],\"supplierId\":100} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'price\' cannot be null\r\n### The error may exist in file [D:\\ij\\xmwjj\\cdc-aics\\cdc-aics-server\\cdc-aics-business\\target\\classes\\mapper\\business\\PurchaseOrderItemMapper.xml]\r\n### The error may involve com.ruoyi.business.mapper.PurchaseOrderItemMapper.batchInsert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cdc_purchase_order_item (order_id, product_id, product_name, price, quantity, subtotal)         values                        (?, ?, ?, ?, ?, ?)\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'price\' cannot be null\n; Column \'price\' cannot be null', '2026-07-10 21:10:18', 67);
INSERT INTO `sys_oper_log` VALUES (105, '采购订单', 1, 'com.ruoyi.web.controller.business.PurchaseOrderController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"purchaseItems\":[{\"orderId\":203,\"price\":3,\"productId\":28,\"productName\":\"晨光中性笔\",\"quantity\":7,\"subtotal\":21}],\"supplierId\":100} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-10 21:11:14', 34);
INSERT INTO `sys_oper_log` VALUES (106, '采购订单', 2, 'com.ruoyi.web.controller.business.PurchaseOrderController.confirm()', 'PUT', 1, 'admin', '研发部门', '/business/purchase/203/confirm', '127.0.0.1', '内网IP', '203 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-10 21:11:18', 43);
INSERT INTO `sys_oper_log` VALUES (107, '采购订单', 2, 'com.ruoyi.web.controller.business.PurchaseOrderController.receive()', 'PUT', 1, 'admin', '研发部门', '/business/purchase/203/receive', '127.0.0.1', '内网IP', '203 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-10 21:11:23', 67);
INSERT INTO `sys_oper_log` VALUES (108, 'C端订单', 2, 'com.ruoyi.web.controller.business.PortalOrderManageController.complete()', 'PUT', 1, 'admin', '研发部门', '/business/order/400/complete', '127.0.0.1', '内网IP', '400 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-10 21:35:16', 107);
INSERT INTO `sys_oper_log` VALUES (109, '采购管理', 1, 'com.ruoyi.web.controller.business.PurchaseController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"params\":{},\"supplierId\":100,\"totalAmount\":50} ', NULL, 1, '采购商品明细不能为空', '2026-07-11 15:41:56', 67);
INSERT INTO `sys_oper_log` VALUES (110, '采购管理', 1, 'com.ruoyi.web.controller.business.PurchaseController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"orderDate\":\"2026-07-11\",\"params\":{},\"supplierId\":100,\"totalAmount\":50} ', NULL, 1, '采购商品明细不能为空', '2026-07-11 15:42:03', 9);
INSERT INTO `sys_oper_log` VALUES (111, '采购管理', 1, 'com.ruoyi.web.controller.business.PurchaseController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"orderDate\":\"2026-07-11\",\"params\":{},\"supplierId\":100,\"totalAmount\":80} ', NULL, 1, '采购商品明细不能为空', '2026-07-11 15:42:06', 5);
INSERT INTO `sys_oper_log` VALUES (112, '采购管理', 1, 'com.ruoyi.web.controller.business.PurchaseController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"orderDate\":\"2026-07-11\",\"params\":{},\"supplierId\":100,\"totalAmount\":108} ', NULL, 1, '采购商品明细不能为空', '2026-07-11 15:42:17', 4);
INSERT INTO `sys_oper_log` VALUES (113, '订单管理', 2, 'com.ruoyi.web.controller.business.BusinessOrderController.complete()', 'PUT', 1, 'admin', '研发部门', '/business/order/401/complete', '127.0.0.1', '内网IP', '401 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 15:42:26', 65);
INSERT INTO `sys_oper_log` VALUES (114, '采购管理', 1, 'com.ruoyi.web.controller.business.PurchaseController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"orderDate\":\"2026-07-11\",\"params\":{},\"supplierId\":100,\"totalAmount\":10} ', NULL, 1, '采购商品明细不能为空', '2026-07-11 15:42:42', 4);
INSERT INTO `sys_oper_log` VALUES (115, '采购管理', 1, 'com.ruoyi.web.controller.business.PurchaseController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"params\":{},\"supplierId\":100,\"totalAmount\":40} ', NULL, 1, '采购商品明细不能为空', '2026-07-11 15:43:17', 5);
INSERT INTO `sys_oper_log` VALUES (116, '采购管理', 1, 'com.ruoyi.web.controller.business.PurchaseController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"orderDate\":\"2026-07-10\",\"params\":{},\"supplierId\":100,\"totalAmount\":40} ', NULL, 1, '采购商品明细不能为空', '2026-07-11 15:43:22', 4);
INSERT INTO `sys_oper_log` VALUES (117, '采购管理', 1, 'com.ruoyi.web.controller.business.PurchaseController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"params\":{},\"supplierId\":100,\"totalAmount\":40} ', NULL, 1, '采购商品明细不能为空', '2026-07-11 15:44:36', 4);
INSERT INTO `sys_oper_log` VALUES (118, '采购管理', 1, 'com.ruoyi.web.controller.business.PurchaseController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"orderDate\":\"2026-07-10\",\"params\":{},\"supplierId\":100,\"totalAmount\":40} ', NULL, 1, '采购商品明细不能为空', '2026-07-11 15:44:41', 4);
INSERT INTO `sys_oper_log` VALUES (119, '采购管理', 1, 'com.ruoyi.web.controller.business.PurchaseController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"params\":{},\"supplierId\":100,\"totalAmount\":40} ', NULL, 1, '采购商品明细不能为空', '2026-07-11 15:45:33', 80);
INSERT INTO `sys_oper_log` VALUES (120, '采购管理', 1, 'com.ruoyi.web.controller.business.PurchaseController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"orderDate\":\"2026-07-11\",\"params\":{},\"supplierId\":100,\"totalAmount\":40} ', NULL, 1, '采购商品明细不能为空', '2026-07-11 15:45:36', 8);
INSERT INTO `sys_oper_log` VALUES (121, '采购管理', 1, 'com.ruoyi.web.controller.business.PurchaseController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"id\":204,\"orderDate\":\"2026-07-11\",\"orderNo\":\"PO20260711001\",\"params\":{},\"purchaseItems\":[{\"orderId\":204,\"price\":2,\"productId\":28,\"productName\":\"晨光中性笔\",\"quantity\":4,\"subtotal\":8}],\"status\":\"draft\",\"supplierId\":100,\"totalAmount\":8} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 15:46:53', 821);
INSERT INTO `sys_oper_log` VALUES (122, '采购管理', 2, 'com.ruoyi.web.controller.business.PurchaseController.confirm()', 'PUT', 1, 'admin', '研发部门', '/business/purchase/204/confirm', '127.0.0.1', '内网IP', '204 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 15:46:56', 37);
INSERT INTO `sys_oper_log` VALUES (123, '采购管理', 2, 'com.ruoyi.web.controller.business.PurchaseController.receive()', 'PUT', 1, 'admin', '研发部门', '/business/purchase/204/receive', '127.0.0.1', '内网IP', '204 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 15:46:59', 70);
INSERT INTO `sys_oper_log` VALUES (124, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"business/purchase/index\",\"createTime\":\"2026-07-10 21:01:48\",\"icon\":\"build\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2024,\"menuName\":\"采购管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2035,\"path\":\"purchase\",\"perms\":\"business:purchase:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 15:47:19', 43);
INSERT INTO `sys_oper_log` VALUES (125, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"business/order/index\",\"createTime\":\"2026-07-10 21:01:48\",\"icon\":\"chart\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2030,\"menuName\":\"订单管理\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":2035,\"path\":\"order\",\"perms\":\"business:order:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 15:47:27', 66);
INSERT INTO `sys_oper_log` VALUES (126, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-07-10 18:24:23\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-11 15:47:47', 21);
INSERT INTO `sys_oper_log` VALUES (127, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/4', '127.0.0.1', '内网IP', '4 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-07-11 15:47:51', 17);
INSERT INTO `sys_oper_log` VALUES (128, '商品管理', 1, 'com.ruoyi.web.controller.business.ProductController.add()', 'POST', 1, 'admin', '研发部门', '/business/product', '127.0.0.1', '内网IP', '{\"categoryId\":6,\"createBy\":\"admin\",\"params\":{},\"price\":1000,\"productName\":\"茅台\",\"status\":\"0\",\"stock\":0,\"unit\":\"件\"} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'scene_id\' doesn\'t have a default value\r\n### The error may exist in file [D:\\ij\\xmwjj\\cdc-aics\\cdc-aics-server\\cdc-aics-business\\target\\classes\\mapper\\business\\ProductMapper.xml]\r\n### The error may involve com.ruoyi.business.mapper.ProductMapper.insertProduct-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cdc_product (              category_id,                             product_name,               price,               stock,               unit,                                                         status,               create_by,                            create_time         )values(              ?,                             ?,               ?,               ?,               ?,                                                         ?,               ?,                            sysdate()         )\r\n### Cause: java.sql.SQLException: Field \'scene_id\' doesn\'t have a default value\n; Field \'scene_id\' doesn\'t have a default value', '2026-07-13 17:45:33', 680);
INSERT INTO `sys_oper_log` VALUES (129, '商品管理', 1, 'com.ruoyi.web.controller.business.ProductController.add()', 'POST', 1, 'admin', '研发部门', '/business/product', '127.0.0.1', '内网IP', '{\"categoryId\":6,\"createBy\":\"admin\",\"params\":{},\"price\":1000,\"productName\":\"茅台\",\"status\":\"0\",\"stock\":0,\"unit\":\"件\"} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'scene_id\' doesn\'t have a default value\r\n### The error may exist in file [D:\\ij\\xmwjj\\cdc-aics\\cdc-aics-server\\cdc-aics-business\\target\\classes\\mapper\\business\\ProductMapper.xml]\r\n### The error may involve com.ruoyi.business.mapper.ProductMapper.insertProduct-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into cdc_product (              category_id,                             product_name,               price,               stock,               unit,                                                         status,               create_by,                            create_time         )values(              ?,                             ?,               ?,               ?,               ?,                                                         ?,               ?,                            sysdate()         )\r\n### Cause: java.sql.SQLException: Field \'scene_id\' doesn\'t have a default value\n; Field \'scene_id\' doesn\'t have a default value', '2026-07-13 17:45:39', 10);
INSERT INTO `sys_oper_log` VALUES (130, '商品管理', 1, 'com.ruoyi.web.controller.business.ProductController.add()', 'POST', 1, 'admin', '研发部门', '/business/product', '127.0.0.1', '内网IP', '{\"categoryId\":2,\"createBy\":\"admin\",\"params\":{},\"price\":5,\"productName\":\"茶派\",\"status\":\"0\",\"stock\":0,\"unit\":\"件\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-13 17:50:40', 61);
INSERT INTO `sys_oper_log` VALUES (131, '采购管理', 1, 'com.ruoyi.web.controller.business.PurchaseController.add()', 'POST', 1, 'admin', '研发部门', '/business/purchase', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"id\":205,\"orderDate\":\"2026-07-13\",\"orderNo\":\"PO20260713001\",\"params\":{},\"purchaseItems\":[{\"orderId\":205,\"price\":3,\"productId\":1000,\"productName\":\"茶派\",\"quantity\":11000,\"subtotal\":33000}],\"status\":\"draft\",\"supplierId\":100,\"totalAmount\":33000} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-13 17:51:31', 101);
INSERT INTO `sys_oper_log` VALUES (132, '采购管理', 2, 'com.ruoyi.web.controller.business.PurchaseController.confirm()', 'PUT', 1, 'admin', '研发部门', '/business/purchase/205/confirm', '127.0.0.1', '内网IP', '205 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-13 17:51:36', 28);
INSERT INTO `sys_oper_log` VALUES (133, '采购管理', 2, 'com.ruoyi.web.controller.business.PurchaseController.receive()', 'PUT', 1, 'admin', '研发部门', '/business/purchase/205/receive', '127.0.0.1', '内网IP', '205 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-13 17:51:38', 93);
INSERT INTO `sys_oper_log` VALUES (134, '商品管理', 1, 'com.ruoyi.web.controller.business.ProductController.add()', 'POST', 1, 'admin', '研发部门', '/business/product', '127.0.0.1', '内网IP', '{\"categoryId\":15,\"createBy\":\"admin\",\"params\":{},\"price\":20,\"productName\":\"草房子\",\"status\":\"0\",\"stock\":100,\"unit\":\"件\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-13 18:15:06', 734);
INSERT INTO `sys_oper_log` VALUES (135, 'FAQ管理', 1, 'com.ruoyi.web.controller.business.KnowledgeFaqController.add()', 'POST', 1, 'admin', '研发部门', '/business/faq', '127.0.0.1', '内网IP', '{\"answer\":\"当然可以，我们有现金支付和微信支付以及支付宝支付和各种银行卡支付\",\"category\":\"售后服务\",\"createBy\":\"admin\",\"enabled\":\"1\",\"id\":1,\"orderNum\":0,\"params\":{},\"question\":\"能使用现金支付吗\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-13 21:13:45', 475);
INSERT INTO `sys_oper_log` VALUES (136, 'FAQ管理', 1, 'com.ruoyi.web.controller.business.KnowledgeFaqController.add()', 'POST', 1, 'admin', '研发部门', '/business/faq', '127.0.0.1', '内网IP', '{\"answer\":\"可以，你这边是出现了什么问题吗？可以随时给我讲\",\"category\":\"售后服务\",\"createBy\":\"admin\",\"enabled\":\"1\",\"id\":2,\"orderNum\":1,\"params\":{},\"question\":\"能退货吗\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-13 21:14:41', 367);
INSERT INTO `sys_oper_log` VALUES (137, 'FAQ管理', 3, 'com.ruoyi.web.controller.business.KnowledgeFaqController.remove()', 'DELETE', 1, 'admin', '研发部门', '/business/faq/1', '127.0.0.1', '内网IP', '1 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-13 21:23:04', 815);
INSERT INTO `sys_oper_log` VALUES (138, 'FAQ管理', 3, 'com.ruoyi.web.controller.business.KnowledgeFaqController.remove()', 'DELETE', 1, 'admin', '研发部门', '/business/faq/2', '127.0.0.1', '内网IP', '2 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-13 21:23:05', 474);
INSERT INTO `sys_oper_log` VALUES (139, 'FAQ管理', 6, 'com.ruoyi.web.controller.business.KnowledgeFaqController.importData()', 'POST', 1, 'admin', '研发部门', '/business/faq/importData', '127.0.0.1', '内网IP', '', '{\"msg\":\"导入完成：成功 12 条，失败 0 条\",\"code\":200}', 0, NULL, '2026-07-13 21:24:23', 5889);
INSERT INTO `sys_oper_log` VALUES (140, 'FAQ管理', 2, 'com.ruoyi.web.controller.business.KnowledgeFaqController.edit()', 'PUT', 1, 'admin', '研发部门', '/business/faq', '127.0.0.1', '内网IP', '{\"answer\":\"!目前有三大优惠活动：1. 新用户首单满50减10元；2. 每周五六日粮油8.8折；3. 会员积分可兑换优惠券，100积分=5元。具体活动以页面展示为准。\",\"category\":\"促销活动\",\"createBy\":\"admin\",\"createTime\":\"2026-07-13 21:24:21\",\"enabled\":\"1\",\"id\":5,\"params\":{},\"question\":\"有没有优惠活动\",\"updateBy\":\"admin\",\"updateTime\":\"2026-07-13 21:24:21\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-07-13 21:28:57', 1085);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2026-07-10 18:24:23', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2026-07-10 18:24:23', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2026-07-10 18:24:23', '', NULL, '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-07-19 14:40:30', '2026-07-10 18:24:23', 'admin', '2026-07-10 18:24:23', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);

SET FOREIGN_KEY_CHECKS = 1;
