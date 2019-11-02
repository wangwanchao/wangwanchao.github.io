---
title: Maven依赖冲突问题
date: 2019-06-03 10:45:33
tags: Maven
categpries: Maven
---
maven依赖冲突

<!-- more -->
### 冲突分类：
第一类Jar包问题：依赖的同一个Jar出现不同的版本。
第二类Jar包问题：同样的类Class出现在多个不同的Jar包中。

### 冲突原因：

maven的依赖机制：
优先按照依赖管理<dependencyManagement>元素中指定的版本声明进行仲裁，此时下面的两个原则都无效了
若无版本声明，则按照“短路径优先”的原则（Maven2.0）进行仲裁，即选择依赖树中路径最短的版本
若路径长度一致，则按照“第一声明优先”的原则进行仲裁，即选择POM中最先声明的版本

### 冲突解决
#### 1、依赖管理
针对第一类冲突
方法1）通过<excludes>排除传递依赖
方法2）使用<dependencyManagement>对依赖包统一版本管理

### 2、冲突检测插件
针对第二类冲突
maven-enforcer-plugin插件 + extra-enforcer-rules工具，注意：应用在子模块上，
