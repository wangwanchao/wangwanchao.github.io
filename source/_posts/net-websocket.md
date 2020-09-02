---
title: WebSocket协议
date: 2020-08-18 21:31:25
tags:
categpries: NetWork
---
之前接触过WebSocket，当时只是当做一个工具去使用，应用场景：

1. 浏览器中实现二维码登录，server主动向client发起通信
2. 小程序中实现IM聊天系统

<!-- more -->
来点刺激的，[官方文档](https://tools.ietf.org/html/rfc6455#section-1.9 
阅读加理解需要耗费大量的精力
## 历史背景
历史上，client和server的双向通信导致对HTTP协议的滥用，为了应对不同的HTTP调用，需要不断地轮询server。这就导致一些问题：
1. 每个client在server端都需要建立许多不同的TCP连接。一个TCP用于发送消息到client，另一个新的TCP用于接收信息
2. 无线协议时，每个client到server的信息都需要携带header，开销很大
3. client需要维护两个TCP连接的映射关系

简单的解决方案就是使用一个TCP连接实现双向通信，这就是`WebSocket`的由来。WebSocket API提供了一种选择：可以切换到HTTP轮询模式实现双向通信

`WebSocket`技术被设计的目的就是取代基于HTTP协议实现的双向通信技术。因为HTTP刚开始的设计就不是为了解决双向通信问题，而是在性能和可靠性之间的一种取舍。
WebSocket虽然工作在HTTP的80/443端口，同时支持HTTP代理、中间人，但并不意味着局限于HTTP，为了会使用专用的端口而不需要重新设计整个协议

### 应用场景：
1. 游戏
2. 股票
3. 多用户同步协作(现在流行的协作工具)
4. 实时暴露server端服务()

## 请求流程

协议分为两个阶段：
1. 握手
2. 数据传输

## 