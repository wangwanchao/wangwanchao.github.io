---
title: SpringSecurity--整合jwt(六)
date: 2019-06-21 11:11:21
tags:
categpries: SpringSecurity
---
jwt模式，web请求模式中分：有状态模无状态模式。一般基于session的就是有状态模式，基于token的是无状态模式。而jwt的token可以存储用户信息，个人认为也算是一种有状态模式。

<!-- more -->
## 实战


## 原理
Securtiy默认是基于session会话的模式，jwt既然基于token的模式，就要关闭session。
### 宏观上来看执行流程：



#### 源码分析
Security对SecurityContext的存储也是分session状态：
(1) 完全无session状态，可以看到SecurityContext使用`NullSecurityContextRepository`存储，每次请求创建新的上下文context。
![1](https://impwang.oss-cn-beijing.aliyuncs.com/security/SecurityContextPersistenceFilter00.png)

![2](https://impwang.oss-cn-beijing.aliyuncs.com/security/SecurityContextPersistenceFilter01.png)

![3](https://impwang.oss-cn-beijing.aliyuncs.com/security/SecurityContextPersistenceFilter03.png)

(2) session禁用状态，使用`HttpSessionSecurityContextRepository`存储，每次请求根据session会话获取上下文context。这样如果请求request中携带JSESSIONID就会存储相应的用户信息
![](https://impwang.oss-cn-beijing.aliyuncs.com/security/SecurityContextPersistenceFilter04.png)

![](https://impwang.oss-cn-beijing.aliyuncs.com/security/SecurityContextPersistenceFilter05.png)

`SecurityContextRepository`类从名字也可看出就是一个存储仓库，对比两个不同的实现。
![](https://impwang.oss-cn-beijing.aliyuncs.com/security/SecurityContextPersistenceFilter02.png)

而且，注意tomcat本身也有session，如果请求中带有session会话，也会导致tomcat存储信息
