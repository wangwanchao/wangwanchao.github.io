---
title: Gradle
date: 2020-08-15 17:37:03
tags:
categpries: Gradle
---
从maven到gradle，我变强了，也变秃了

<!-- more -->
## 安装

### 仓库镜像

## 原理

### Project
在gradle中，任何组件都基于两个概念`Project`和`Task`。每一个build都是由一个或者多个project组成。一个project是什么，取决于你用它来做什么，典型的project可以表示一个JAR包或者Web应用。一个project不一定要用来构建什么，只代表用来做什么。每一个project由一个或者几个task组成。
`gradle build`命令会在当前目录下寻找`build.gradle`文件，gradle的task和Ant工具的target类似，但是更强大，在task中可以使用Groovy和Kotlin。Groovy、Kotlin的好处不仅可以用来定义task，还可以动态添加任务。

### Task
`Ant task`在gradle中是一类公民。gradle通过简单的依赖Groovy实现对Ant task的整合。在gradle中使用Ant task比在build.xml中更方便、更强大。
多项目中，gradle父目录下build.gradle脚本buildscript()方法声明的dependencies依赖在所有的子项目中都可以使用。每个project都有一个默认的`buildEnvironment`任务。
gradle提供了`enhanced tasks`，这些任务要么是自定义的，要么是内置的。

### Plugins
二进制插件、DSL插件
#### 插件使用限制

#### 插件版本管理

#### 插件解析规则

#### 结合buildScript

#### 脚本插件

#### 自定义插件

### 生命周期


### 语法


## 依赖