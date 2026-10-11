# 心理健康AI助手

一个基于 Spring Boot 3 + Vue 3 的 AI 心理健康助手，提供 AI 心理咨询、情绪日记、心理健康知识库等功能。

## 功能

### 用户端
- **AI 心理咨询**：与 AI 助手实时流式对话，情绪花园面板根据对话内容实时分析情绪状态并给出建议
- **情绪日记**：记录每日情绪评分、主要情绪、触发因素与今日感想
- **知识库**：浏览心理健康知识文章，支持推荐阅读、文章详情

### 管理后台
- **数据分析**：用户数、咨询会话、情绪趋势等可视化图表
- **知识文章管理**：文章的增删改查、发布/下线
- **咨询记录**：查看全站用户的咨询会话
- **情绪日志**：查看全站用户的情绪日记

## 技术栈

**后端**：Spring Boot 3.5、Spring AI（硅基流动 DeepSeek-V3）、Spring Security + JWT、MyBatis-Plus、MySQL

**前端**：Vue 3、Vite、Element Plus、Pinia、Vue Router、ECharts、SSE 流式渲染

## 目录结构

```
├── code
│   ├── ai-spingboot   # 后端（Spring Boot）
│   └── ai-vue         # 前端（Vue 3）
└── 功能截图            # 各功能页面截图
```

## 运行方式

1. 配置 MySQL（数据库名 `mental_health_assistant`），在后端 `application.yml` 中填入数据库账号与 [硅基流动](https://siliconflow.cn) 的 API Key
2. 后端：JDK 17，在 `code/ai-spingboot` 下执行 `./mvnw spring-boot:run`（端口 1236）
3. 前端：在 `code/ai-vue` 下执行 `npm install && npm run dev`
4. 浏览器访问前端开发服务器地址即可

## 截图

见 [功能截图](./功能截图) 文件夹。
