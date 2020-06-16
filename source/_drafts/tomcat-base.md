---
title: Tomcat--概览(一)
date: 2019-01-03 23:50:51
tags: tomcat
categpries: Servlet
---
Tomcat作为常见的Servlet容器，我接触的从最初的SSH/SSM架构，Tomcat需要单独维护，到SpringBoot的嵌入式容器。

<!-- more -->

## 整体架构
![架构示意图：](https://impwang.oss-cn-beijing.aliyuncs.com/tomcat/tomcat-base.png)

### Server
Server包含一个或多个Service

### Service
Service是多个Connector和一个Container的集合，因为有不同的协议，需要用相应的Connector接收请求，转发给Container

### Connector 
Connector安装不同的协议分为：

1. HTTP Connector
2. AJP Connector

### Container

#### Engine
负责处理Service的请求，Connector作为中间媒介

#### Host
表示一个虚拟主机，每个虚拟主机和一个网络域名对应

#### Context
每个Context对应一个Web应用

Wrapper：代表一个Servlet，使用门面设计模式

Connector有两种：可以在server.xml中看到配置
1) 监听8080端口
2) 监听8009端口

#### Wrapper

### 其它组件
#### manager
主要用来管理会话

#### loader
启动Context，管理context的ClassLoader。

#### pipline
Enging/Host/Context都有一个管道，在每个管道中设置了不同的valve，由valve做一些处理

#### valve
用来做一些拦截处理，

#### logger


### 优化
1、


3、并行类加载


## 常见问题
### 独立容器
1、日志乱码问题



### SpringBoot
1、URL路径转义问题




