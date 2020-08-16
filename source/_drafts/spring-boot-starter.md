---
title: SpringBoot--启动流程(一)
date: 2018-12-31 12:31:01
tags:
categpries: SpringBoot
---
SpringBoot集成了Spring、Servlet容器

<!-- more -->
## 主流程
1. 读取配置文件：spring.factories
2. 启动监听器：SpringApplicationRunListeners
3. 配置环境变量：ConfigurableEnvironment，判断是否是web环境。实质就是启动Servlet容器
4. 创建上下文：ApplicationContext，核心方法主要'createContext' 'refreshContext' 'afterRefresh'。本质上是启动Spring IoC。