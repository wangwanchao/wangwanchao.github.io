---
title: MyBatis概览(一)
date: 2019-06-04 20:30:05
tags: MyBatis
categpries: MyBatis
---
终究还是要自己来分析源码了，网上有很多MyBatis的源码分析，自己决定做，一来是加深印象；二来摸索源码分析的方法论。很多时候看源码一脸懵逼，不知道该从哪里看，看完没有形成思路。

<!-- more -->
## MyBatis
mybatis结构图：

<img width=200 height=300 src="https://impwang.oss-cn-beijing.aliyuncs.com/mybatis/mybatis-arc.png" >

在我看来mybatis核心功能主要有3个：
1、xml/注解的解析(包括config配置、mapper)
2、一级缓存，二级缓存
3、事务

## MyBatis和Spring整合
mybatis和Spring整合插件结构图：

<img width=200 height=300 src="https://impwang.oss-cn-beijing.aliyuncs.com/mybatis/mybatis-spring.png" >
