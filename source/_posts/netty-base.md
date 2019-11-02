---
title: Netty概览(一)
date: 2019-06-05 12:25:13
tags: netty
categpries: Netty
---
基于Netty4.1分支，可以看到代码已经非常复杂

<!-- more -->
netty结构图
基础部分：
<image width=200 height=300 src="https://impwang.oss-cn-beijing.aliyuncs.com/netty/netty-base1.png">

test组件：
<image width=250 height=100 src="https://impwang.oss-cn-beijing.aliyuncs.com/netty/netty-base2.png">

transport组件：
<image width=250 height=100 src="https://impwang.oss-cn-beijing.aliyuncs.com/netty/netty-base3.png">

## 事件驱动模型

## Reactor模型
示意图：

Reactor模型主要有2部分：
> Reactor：单独的线程，负责监听、分发事件，
> Handlers：

#### 1. 单Reactor、单线程

#### 2. 单Reactor、多线程

#### 3. 主从Reactor、多线程

模型：
> MainReactor：负责连接请求，把请求转交给SubReactor
> SubReactor：负责相应Channel的I/O读写请求
> 非I/O请求则直接写入队列，等待worker threads(工作线程)处理

## Netty

### 特性
传输服务，支持 BIO 和 NIO。
容器集成，支持 OSGI、JBossMC、Spring、Guice 容器。
协议支持，HTTP、Protobuf、二进制、文本、WebSocket、RTSP等，还支持通过实行编码解码逻辑来实现自定义协议。
Core 核心，可扩展事件模型、通用通信 API、支持零拷贝的 ByteBuf 缓冲对象。

### 线程模型
Netty基于主从Reactor、多线程模型。
> bossGroup：线程池，在绑定某个端口后，从线程池获取一个线程处理Accept事件(相当于MainReactor)，这样每个端口对应一个Boss线程
> workerGroup：线程池，SubReactor和Worker线程会共用该线程池

### 核心模块
Bootstrap/ServerBootstrap
Future/ChannelFuture
Channel/ChannelHandler/ChannelPipline
Selector
NioEventLoop/NioEventLoopGroup

总结：从结构上看，核心功能主要有2个：

1. I/O模型
2. 	解析协议(编码/解码)







