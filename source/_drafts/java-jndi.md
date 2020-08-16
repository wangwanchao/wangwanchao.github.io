---
title: java-jndi
date: 2018-10-11 22:45:03
tags: java
categories: java
---
业务代码写多了，偶尔看看源码还是蛮有意思的，尤其是源码背后的设计思想，真的是让人佩服啊。

<!-- more -->

## JNDI ##

JNDI API是用于访问不同命名和目录服务的接口。

### JNDI编程模型 ###

可以在rt.jar中javax.naming目录下查看所有源码

1. 上下文 Context/DirContext

#### 架构： ####

第一层： 访问JNDI的代码

第二层： JNDI API，统一的命名和目录服务接口

第三层： JNDI管理器 NamingManager

第四层： JNDI SPI，用于构建JNDI实现的框架，动态插入命名和目录服务提供商的产品

第五层： 命名和目录服务商提供的产品。例如： DNS、LDAP、NIS、NDS

LDAP(Lightweight Directory Access Protocol): 轻量目录访问协议，也可以说是一种特殊的数据库(hierarchal数据库)

NIS(Network Information Service): 网络信息服务

#### 原理： ####



## JNDI的应用 ##

1. EJB项目中，用于查找其它程序组件
2. 数据库连接池中，用于连接数据库