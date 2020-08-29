---
title: 微服务--网关(三)
date: 2019-08-15 16:28:03
tags: 网关
categpries: SpringCloud
---
nginx、zuul、gateway、kong都是网关组件，基于不同的结构设计模式实现

<!-- more -->
## Nginx


### 限流

#### 模块
nginx使用漏桶算法

`limit_req_zone`
`limit_req_conn`

### 限流


## Zuul1 
### 过滤器Filter
按照生命周期大约有4种过滤器：

1. pre 

2. routing

3. post 

4. error


### 限流
主流的有4种限流方式：

1. 根据认证用户
2. 根据原始请求
3. 根据URL
4. 根据ServiceId

#### 插件
zuul-ratelimit

### 超时

### 重试机制
zuul默认整合了ribbon实现路由

配置属性：
```
spring:
  cloud:
    loadbalancer:
      retry:
        enabled: true  # ribbon重试默认已经开启
 
zuul:
# 重试必配，据说在Brixton.SR5版的spring cloud中该配置默认是true，结果在Dalston.SR1中看到的是false
  retryable: true
 
ribbon:
  ConnectTimeout: 250   # ribbon重试超时时间
  ReadTimeout: 1000     # 建立连接后的超时时间
  OkToRetryOnAllOperations: true  # 对所有操作请求都进行重试
  MaxAutoRetriesNextServer: 2  # 重试负载均衡其他的实例最大重试次数，不包括首次server
  MaxAutoRetries: 1  # 同一台实例最大重试次数，不包括首次调用
```

**注意**熔断器的超时时间`hystrix.command.default.execution.isolation.thread.timeoutInMilliseconds	`需要大于ribbon的超时时间，否则不会触发重试
#### 垮zone重试

## Zuul2
| 对比 | Zuul1 | Zuul2 | Gateway |
|-|:-:|:-:|:-:|
| 同步 | 阻塞 | 异步非阻塞 | 非阻塞 |
| 整合SpringCloud| 支持 | 不支持 | 支持 |
| 限流 | 支持 | 不支持| 支持 |
| 自定义filter | - | 不支持 | 支持(内置了很多filter) |

## Kong
kong可以说是nginx的升级版，基于OpenResty。
### 核心
1. upstream
2. target
3. service
4. route
