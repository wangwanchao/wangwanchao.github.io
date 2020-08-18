---
title: RocketMQ环境
date: 2020-07-20 18:19:49
tags:
categpries: RocketMQ
---
消息队列

<!-- more -->
## 单节点模式
### 启动服务
需要启动namesrv、broker服务
#### 配置

#### 后台启动

```
nohup sh bin/mqnamesrv &

nohup sh bin/mqbroker -n localhost:9876 &
```

#### 终止服务
```
sh bin/mqshutdown  namesrv

sh bin/mqshutdown broker
```

### 界面化
实际上就是一个Spring Boot项目
#### 命令行启动
```
java -jar rocketmq-console-ng-1.0.1.jar --server.port=12581 --rocketmq.config.namesrvAddr=192.168.117.138:9876
```
参数：
rocketmq.config.namesrvAddr: 指定server地址
server.port: 指定启动端口，默认启动在8083端口

**注意**原来在Edge浏览器上无法访问，以为哪里出问题了，后来在Chrome上访问正常，贼恶心。

现在就可以访问了：192.168.117.138:8083