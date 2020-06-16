---
title: SpringSecurity--整合oauth2(五)
date: 2019-06-21 11:11:03
tags:
categpries: SpringSecurity
---
oauth2.0有4种认证模型

<!-- more -->
## 原理

在客户端和服务端中间，设置了一个授权层，客户端不能登陆服务端，只能登录中间授权层。

第一阶段使用account + secret登录中间层，获得token

第二阶段开始使用token进行权限验证

