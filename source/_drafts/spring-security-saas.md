---
title: SpringSecurity--SAAS平台设计思路(七)
date: 2019-06-21 11:49:55
tags:
categpries: SpringSecurity
---
最近要做一个saas平台，20171年的时候选用的是Shiro实现，考虑到SpringSecurity可以完美的整合Oauth2.0/OpenID

<!-- more -->
RBAC模型

### 安全原则
1. 最小权限原则
2. 责任分离原则
3. 数据抽象原则

页面权限
功能权限
数据权限

## 数据模型
用户

角色：可以按照部门、岗位、

