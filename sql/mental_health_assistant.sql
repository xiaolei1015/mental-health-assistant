-- ============================================================
-- 心理健康AI助手 数据库初始化脚本
-- 适用：MySQL 5.7+（字符集 utf8mb4）
-- 内容：全部表结构 + 演示数据（演示账号 / 知识分类与文章）
-- 注意：不含真实用户数据；演示账号密码均为 123456
-- ============================================================

-- MySQL dump 10.13  Distrib 5.7.44, for Win64 (x86_64)
--
-- Host: localhost    Database: mental_health_assistant
-- ------------------------------------------------------
-- Server version	5.7.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ai_analysis_task`
--

DROP TABLE IF EXISTS `ai_analysis_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ai_analysis_task` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `diary_id` bigint(20) NOT NULL COMMENT '日记ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务状态：PENDING-待处理，PROCESSING-处理中，COMPLETED-已完成，FAILED-失败',
  `task_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务类型：AUTO-自动触发，MANUAL-手动触发，ADMIN-管理员触发，BATCH-批量触发',
  `priority` int(11) NOT NULL DEFAULT '2' COMMENT '优先级：1-低，2-正常，3-高，4-紧急',
  `retry_count` int(11) NOT NULL DEFAULT '0' COMMENT '重试次数',
  `max_retry_count` int(11) NOT NULL DEFAULT '3' COMMENT '最大重试次数',
  `error_message` text COLLATE utf8mb4_unicode_ci COMMENT '错误信息',
  `started_at` datetime DEFAULT NULL COMMENT '处理开始时间',
  `completed_at` datetime DEFAULT NULL COMMENT '处理完成时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_diary_id` (`diary_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_task_type` (`task_type`) USING BTREE,
  KEY `idx_priority` (`priority`) USING BTREE,
  KEY `idx_created_at` (`created_at`) USING BTREE,
  KEY `idx_status_priority` (`status`,`priority`) USING BTREE,
  KEY `idx_status_created_at` (`status`,`created_at`) USING BTREE,
  KEY `idx_task_type_created_at` (`task_type`,`created_at`) USING BTREE,
  KEY `idx_retry_status` (`status`,`retry_count`,`max_retry_count`) USING BTREE,
  CONSTRAINT `fk_ai_task_diary` FOREIGN KEY (`diary_id`) REFERENCES `emotion_diary` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ai_task_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='AI分析任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `consultation_message`
--

DROP TABLE IF EXISTS `consultation_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consultation_message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `session_id` bigint(20) NOT NULL COMMENT '会话ID',
  `sender_type` tinyint(4) NOT NULL COMMENT '发送者类型 1:用户 2:AI助手',
  `message_type` tinyint(4) DEFAULT '1' COMMENT '消息类型 1:文本',
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '消息内容',
  `emotion_tag` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '情绪标签',
  `ai_model` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '使用的AI模型',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_session_message` (`session_id`,`created_at`) USING BTREE,
  CONSTRAINT `consultation_message_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `consultation_session` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='咨询消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `consultation_session`
--

DROP TABLE IF EXISTS `consultation_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `consultation_session` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '会话ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `session_title` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '会话标题',
  `started_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_emotion_analysis` json DEFAULT NULL COMMENT '最后一次情绪分析结果(JSON格式)',
  `last_emotion_updated_at` datetime DEFAULT NULL COMMENT '最后一次情绪分析更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_session` (`user_id`,`started_at`) USING BTREE,
  KEY `idx_last_emotion_updated_at` (`last_emotion_updated_at`) USING BTREE,
  CONSTRAINT `consultation_session_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='咨询会话表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `emotion_diary`
--

DROP TABLE IF EXISTS `emotion_diary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emotion_diary` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日记ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `diary_date` date NOT NULL COMMENT '日记日期',
  `mood_score` tinyint(4) NOT NULL COMMENT '情绪评分(1-10)',
  `dominant_emotion` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '主要情绪',
  `emotion_triggers` text COLLATE utf8mb4_unicode_ci COMMENT '情绪触发因素',
  `diary_content` text COLLATE utf8mb4_unicode_ci COMMENT '日记内容',
  `sleep_quality` tinyint(4) DEFAULT NULL COMMENT '睡眠质量(1-5)',
  `stress_level` tinyint(4) DEFAULT NULL COMMENT '压力水平(1-5)',
  `ai_emotion_analysis` text COLLATE utf8mb4_unicode_ci COMMENT 'AI情绪分析结果(JSON格式)',
  `ai_analysis_updated_at` datetime DEFAULT NULL COMMENT 'AI分析更新时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `user_date_unique` (`user_id`,`diary_date`) USING BTREE,
  KEY `idx_user_diary` (`user_id`,`diary_date`) USING BTREE,
  KEY `idx_ai_analysis_time` (`ai_analysis_updated_at`) USING BTREE,
  CONSTRAINT `emotion_diary_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='情绪日记表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `knowledge_article`
--

DROP TABLE IF EXISTS `knowledge_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knowledge_article` (
  `id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文章ID(UUID)',
  `category_id` bigint(20) NOT NULL COMMENT '分类ID',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文章标题',
  `summary` text COLLATE utf8mb4_unicode_ci COMMENT '文章摘要',
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文章内容',
  `cover_image` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封面图片',
  `tags` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '标签',
  `author_id` bigint(20) DEFAULT NULL COMMENT '作者ID',
  `read_count` int(11) DEFAULT '0' COMMENT '阅读次数',
  `status` tinyint(4) DEFAULT '1' COMMENT '状态 1:已发布',
  `published_at` datetime DEFAULT NULL COMMENT '发布时间',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `author_id` (`author_id`) USING BTREE,
  KEY `idx_category_article` (`category_id`,`published_at`) USING BTREE,
  KEY `idx_title` (`title`) USING BTREE,
  CONSTRAINT `knowledge_article_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `knowledge_category` (`id`),
  CONSTRAINT `knowledge_article_ibfk_2` FOREIGN KEY (`author_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='知识文章表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `knowledge_category`
--

DROP TABLE IF EXISTS `knowledge_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knowledge_category` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `parent_id` bigint(20) DEFAULT '0' COMMENT '父分类ID',
  `category_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `category_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '分类代码',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '分类描述',
  `sort_order` int(11) DEFAULT '0' COMMENT '排序',
  `status` tinyint(4) DEFAULT '1' COMMENT '状态 0:禁用 1:启用',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `category_code` (`category_code`) USING BTREE,
  KEY `idx_parent_id` (`parent_id`) USING BTREE,
  KEY `idx_sort_order` (`sort_order`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='知识文章分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_file_info`
--

DROP TABLE IF EXISTS `sys_file_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_file_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '文件ID，主键自增',
  `original_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '原始文件名（用户上传时的文件名）',
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件访问路径（服务器存储路径）',
  `file_size` bigint(20) NOT NULL DEFAULT '0' COMMENT '文件大小，单位：字节',
  `file_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件类型（IMG/PDF/TXT/DOC/XLS等）',
  `business_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务类型（用于区分文件用途，如：avatar/document/attachment）',
  `business_id` char(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务对象ID（关联的业务数据主键）',
  `business_field` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务字段名（对应业务表中的字段名）',
  `upload_user_id` bigint(20) DEFAULT NULL COMMENT '上传用户ID（记录谁上传的文件）',
  `is_temp` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否临时文件（0:否 1:是）',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态（0:删除 1:正常）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间（仅对临时文件有效）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_business` (`business_type`,`business_id`) USING BTREE,
  KEY `idx_upload_user` (`upload_user_id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_temp_expire` (`is_temp`,`expire_time`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='系统文件信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `nickname` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像URL',
  `gender` tinyint(4) DEFAULT NULL COMMENT '性别 0:未知 1:男 2:女',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `user_type` tinyint(4) DEFAULT '1' COMMENT '用户类型 1:普通用户 2:管理员',
  `status` tinyint(4) DEFAULT '1' COMMENT '状态 0:禁用 1:正常',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE,
  UNIQUE KEY `email` (`email`) USING BTREE,
  UNIQUE KEY `phone` (`phone`) USING BTREE,
  KEY `idx_username` (`username`) USING BTREE,
  KEY `idx_user_type` (`user_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_favorite`
--

DROP TABLE IF EXISTS `user_favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_favorite` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `article_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文章ID',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `user_article_unique` (`user_id`,`article_id`) USING BTREE,
  KEY `article_id` (`article_id`) USING BTREE,
  CONSTRAINT `user_favorite_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_favorite_ibfk_2` FOREIGN KEY (`article_id`) REFERENCES `knowledge_article` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='用户收藏表';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-11 21:50:38

-- ============================================================
-- 演示数据
-- ============================================================

-- MySQL dump 10.13  Distrib 5.7.44, for Win64 (x86_64)
--
-- Host: localhost    Database: mental_health_assistant
-- ------------------------------------------------------
-- Server version	5.7.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `user`
--
-- WHERE:  id<=2

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','admin@example.com','13123456789','$2a$10$qUjCfQLqf9qVt1w1LDoaj.f5TUzBYcXh3FNNA0BhoQ54Vv2cSUt7K','系统管理员','/files/bussiness/user_avatar/1757687320361.jpg',1,'2019-09-02',2,1,'2025-08-30 12:00:01','2025-09-12 22:28:42'),(2,'test','15165@qq.com','13132584165','$2a$10$qUjCfQLqf9qVt1w1LDoaj.f5TUzBYcXh3FNNA0BhoQ54Vv2cSUt7K','tyest','/files/bussiness/user_avatar/1757816752928.jpg',1,'2002-08-01',1,1,'2025-08-30 17:22:24','2025-09-14 10:25:54');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-11 21:50:38
-- MySQL dump 10.13  Distrib 5.7.44, for Win64 (x86_64)
--
-- Host: localhost    Database: mental_health_assistant
-- ------------------------------------------------------
-- Server version	5.7.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `knowledge_category`
--

LOCK TABLES `knowledge_category` WRITE;
/*!40000 ALTER TABLE `knowledge_category` DISABLE KEYS */;
INSERT INTO `knowledge_category` VALUES (1,0,'心理健康基础',NULL,'心理健康基础知识和概念.',30,1,'2025-09-04 12:50:03','2025-09-13 11:48:16'),(2,0,'情绪管理',NULL,'情绪识别、调节和管理技巧',40,1,'2025-09-04 12:50:03','2025-09-13 11:48:16'),(3,0,'压力缓解',NULL,'压力来源分析和缓解方法',20,1,'2025-09-04 12:50:03','2025-09-13 11:48:16'),(4,0,'人际关系',NULL,'人际交往和关系处理',10,1,'2025-09-04 12:50:03','2025-09-13 11:48:16');
/*!40000 ALTER TABLE `knowledge_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `knowledge_article`
--

LOCK TABLES `knowledge_article` WRITE;
/*!40000 ALTER TABLE `knowledge_article` DISABLE KEYS */;
INSERT INTO `knowledge_article` VALUES ('550e8400-e29b-41d4-a716-446655440001',1,'如何识别和管理焦虑情绪','焦虑是现代生活中常见的情绪反应，学会识别和管理焦虑对心理健康至关重要。','<p>焦虑是一种正常的情绪反应，但过度的焦虑可能会影响我们的日常生活。本文将介绍如何识别焦虑的症状，以及一些有效的管理方法。</p><h3>识别焦虑的症状</h3><ul><li>心跳加速、出汗</li><li>呼吸急促</li><li>思维混乱</li><li>难以集中注意力</li></ul><h3>管理焦虑的方法</h3><ol><li>深呼吸练习</li><li>正念冥想</li><li>适度运动</li><li>寻求专业帮助</li></ol>','','焦虑,情绪管理,心理健康',1,15,1,'2025-09-01 10:00:00','2025-09-01 10:00:00','2025-09-01 10:00:00'),('550e8400-e29b-41d4-a716-446655440002',2,'情绪调节的五个有效策略','掌握情绪调节技巧，让生活更加平衡和谐。','<p>情绪调节是心理健康的重要组成部分。以下是五个经过科学验证的情绪调节策略：</p><h3>1. 认知重构</h3><p>学会从不同角度看待问题，挑战负面思维模式。</p><h3>2. 情绪标记</h3><p>准确识别和命名自己的情绪状态。</p><h3>3. 渐进式肌肉放松</h3><p>通过身体放松来缓解情绪紧张。</p><h3>4. 表达性写作</h3><p>通过写作来处理复杂的情绪体验。</p><h3>5. 社交支持</h3><p>寻求朋友和家人的理解与支持。</p>','','情绪调节,心理技巧,自我管理',1,23,1,'2025-09-02 14:30:00','2025-09-02 14:30:00','2025-09-02 14:30:00'),('550e8400-e29b-41d4-a716-446655440003',3,'职场压力管理指南','在快节奏的工作环境中，学会有效管理压力是职业成功的关键。','<p>职场压力是现代工作生活中不可避免的挑战。本指南将帮助您建立有效的压力管理体系。</p><h3>识别压力源</h3><ul><li>工作量过大</li><li>人际关系紧张</li><li>职业发展焦虑</li><li>工作与生活平衡困难</li></ul><h3>压力管理策略</h3><ol><li>时间管理技巧</li><li>设定合理目标</li><li>建立支持网络</li><li>培养兴趣爱好</li><li>定期休息和放松</li></ol><h3>长期压力预防</h3><p>建立健康的工作习惯和生活方式，预防压力累积。</p>','','职场压力,时间管理,工作生活平衡',1,31,1,'2025-09-03 09:15:00','2025-09-03 09:15:00','2025-09-03 09:15:00'),('550e8400-e29b-41d4-a716-446655440004',4,'建立健康的人际关系','良好的人际关系是心理健康和生活幸福的基石。','<p>人际关系质量直接影响我们的心理健康和生活满意度。本文将探讨如何建立和维护健康的人际关系。</p><h3>健康关系的特征</h3><ul><li>相互尊重和信任</li><li>有效沟通</li><li>情感支持</li><li>个人边界清晰</li></ul><h3>沟通技巧</h3><ol><li>积极倾听</li><li>表达真实感受</li><li>非暴力沟通</li><li>冲突解决</li></ol><h3>维护关系的方法</h3><p>定期联系、表达感激、共同成长、处理分歧。</p>','','人际关系,沟通技巧,社交能力',1,18,1,'2025-09-04 16:20:00','2025-09-04 16:20:00','2025-09-04 16:20:00'),('550e8400-e29b-41d4-a716-446655440005',1,'睡眠质量与心理健康','优质睡眠是维护心理健康的重要基础。','<p>睡眠质量与心理健康密切相关。充足的睡眠不仅能恢复身体机能，还对情绪调节和认知功能有重要影响。</p><h3>睡眠对心理健康的影响</h3><ul><li>情绪稳定性</li><li>压力应对能力</li><li>记忆和学习能力</li><li>注意力集中</li></ul><h3>改善睡眠质量的方法</h3><ol><li>建立规律作息</li><li>创造良好睡眠环境</li><li>睡前放松活动</li><li>避免刺激性物质</li><li>适度运动</li></ol>','','睡眠健康,心理健康,生活习惯',1,27,1,'2025-09-05 11:45:00','2025-09-05 11:45:00','2025-09-05 11:45:00'),('550e8400-e29b-41d4-a716-446655440006',2,'正念练习入门指南','正念练习是现代心理学推荐的有效减压和情绪调节方法。','<p>正念是一种专注于当下体验的练习方法，能够帮助我们更好地管理情绪和压力。</p><h3>什么是正念</h3><p>正念是有意识地、不带评判地关注当下时刻的能力。</p><h3>正念的益处</h3><ul><li>减少焦虑和抑郁</li><li>提高专注力</li><li>改善情绪调节</li><li>增强自我觉察</li></ul><h3>基础正念练习</h3><ol><li>呼吸观察</li><li>身体扫描</li><li>行走冥想</li><li>日常正念</li></ol><h3>练习建议</h3><p>从每天5-10分钟开始，逐渐增加练习时间。</p>','','正念,冥想,减压,专注力',1,42,1,'2025-09-06 13:10:00','2025-09-06 13:10:00','2025-09-06 13:10:00'),('550e8400-e29b-41d4-a716-446655440007',3,'学生心理压力应对策略','帮助学生识别和应对学习生活中的各种心理压力。','<p>学生时期面临着学业、人际、未来规划等多重压力。掌握有效的应对策略对学生心理健康至关重要。</p><h3>常见压力源</h3><ul><li>学业成绩压力</li><li>同伴关系</li><li>家庭期望</li><li>未来规划焦虑</li></ul><h3>应对策略</h3><ol><li>合理规划学习时间</li><li>培养兴趣爱好</li><li>建立支持网络</li><li>学会放松技巧</li><li>寻求专业帮助</li></ol><h3>预防措施</h3><p>建立健康的学习习惯和生活方式。</p>','','学生心理,学业压力,青少年心理',1,35,1,'2025-09-07 08:30:00','2025-09-07 08:30:00','2025-11-10 19:07:53');
/*!40000 ALTER TABLE `knowledge_article` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-11 21:50:38
