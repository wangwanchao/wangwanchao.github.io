---
title: gRPC协议
date: 2020-08-15 11:21:25
tags: gRPC
categpries: gRPC
---
gRPC是一个可以应用在任何场景的开源框架，提供跨数据中心之间的高效通信。可以说解决了分布式计算的“最后一公里”问题。可插拔特性支持负载均衡、可跟踪、健康检查、认证

<!-- more -->
## 应用场景
主要应用场景
1. 跨语言微服务系统之间的高效连接
2. 手机端、浏览器到服务端的通信
3. 生成高效的skd lib

## 核心特性
1. sdk lib支持10种语言
2. 无线环境更高效，服务开发简单
3. 基于http/2支持双向通信
4. 可插拔特性

## 架构
![通信模型](https://impwang.oss-cn-beijing.aliyuncs.com/gRPC-1.svg)
server端：实现接口，处理客户端请求
client端：stub提供和server相同的方法
### 通信类型、生命周期
#### 单向通信(unary rpc)
client发起请求，server返回结果
1. client调用stub方法，sever收到通知(metadata、方法名、指定的deadline)--client发起调用
2. server要么直接返回自身初始化的metadata(需要在所有response之前返回)；或者等待client请求信息
3. server收到client request信息后，创建response并填充属性，返回response、状态信息、trailing metadata(可选的)
4. rpc完成
#### Server流RPC
client一次请求，sever返回流消息，client进行解析直到结束，在一次rpc请求中，gRPC保证流消息的顺序性
#### Server流RPC
client写入流消息请求，sever解析流消息返回消息，client结束，同样在一次rpc请求中，gRPC保证流消息的顺序性
#### 双向流消息通信

#### Deadlines/Timeouts 
client: 可以指定RPC超时时间，如果超时后未收到响应，则被终止，同时抛出`DEADLINE_EXCEEDED`错误
server: 可以查询某个特定的RPC请求是否已经超时、完成某个RPC请求还需要多长时间

**注意** 
1. client和server端是相互独立的，可能client端成功了，但是server仍然失败。
2. client/server都可以取消RPC，取消会快速终止RPC请求，但是终止之前的任何动作不会回滚

#### Metadata
Metadata是一个RPC请求的所有信息，是一些key(String)-value(String/二进制数据)的键值对

#### Channels
channel在创建client hub的时候被创建，以指定的ip:port提供到server的连接。client可以修改channel参数，例如是否开启对传输数据的压缩。一个channel包括两种状态：connected和idle

**注意** gRPC支持同步阻塞、异步非阻塞模式通信

### gRPC和protocol buffers的关系
默认情况下，gRPC使用protocol buffers作为接口定义语言(IDL)、底层通信数据格式。protocol buffers已经是一种成熟的序列化机制。
工作机制：
1. 首先在`proto`中定义序列化对象的结构
    ```
    hello.proto
    service HelloService {
        rpc SayHello (HelloRequest) returns (HelloResponse);
    }

    message HelloRequest {
        string greeting = 1;
    }

    message HelloResponse {
        string reply = 1;
    }
    ```
2. 使用编译器`protoc`指定语言编译`.proto`文件生成class文件，该class类被用在应用程序中

[protocol buffers的详细介绍](https://developers.google.com/protocol-buffers/docs/overview)

## java实现的Demo


## Nginx对gRPC的支持
