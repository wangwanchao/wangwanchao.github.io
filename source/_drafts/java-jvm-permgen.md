---
title: java永久代、元数据区
date: 2019-11-14 13:53:32
tags:
categpries: JVM
---
今天在维护一个jsp + tomcat的老项目中，开始使用JRE1.8运行，没有问题，切换到JRE1.7运行就报错:
	
	java.lang.OutOfMemoryError: PermGen space
添加运行时参数`-XX:MaxPermSize=512m`解决问题，这里涉及到jvm运行时内存的变化。

<!-- more -->
## 永久代 Perm Gen
PermGen存在于`jdk1.7-`版本中，主要存储内容：

> class类的名称、字段、方法
> 字节码
> 常量池
> 对象数组/类型数组的class
> JIT编译后的class信息

## 元数据区 Metaspace

