---
title: 微服务--网关(三)
date: 2019-08-15 16:28:03
tags:
categpries: SpringCloud
---
nginx、zuul、gateway、kong都是网关组件。

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
