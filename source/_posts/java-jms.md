---
title: java消息服务JMS
date: 2018-10-10 21:45:16
tags: java
categories: java
---
开发中多多少少接触过一些消息队列，但是对原生的JMS(Java Message Service: Java消息服务)了解较少。


<!-- more -->

## JMS ##

JMS API是一个消息服务的标准。

### P2P模式 ###

特点:

> 每条消息只有一个消费者(即消息一旦被消费，消息就不在消息队列中)
> 
> 生产者和消费者在时间上没有依赖性()
> 
> 消费者在接收消息后需要向队列应答消费成功


### Pub/Sub模式 ###

特点:

> 每条消息可以有多个消费者
> 
> 生产者和消费者之间有时间上的依赖(即针对某个主题，必须创建一个消费者之后，才能消费消息)
> 
> 为了消费消息，订阅者必须保持运行


### JMS编程模型 ###

加入依赖包jms-api，类似于servlet-api

	<dependency>
	    <groupId>javax.jms</groupId>
	    <artifactId>javax.jms-api</artifactId>
	    <version>2.0.1</version>
	</dependency>

1. 管理对象
2. 连接对象 Connection
3. 会话 Session
4. 消息生产者 MessageProducer
5. 消息消费者 MessageConsumer
6. 消息监听者 MessageLister


### JMS协议结构 ###



## JMS的应用场景 ##

1. ActiveMQ完全支持JMS1.1和J2EE1.4规范。

	ActiveMQ特性
2. JBoss HornetQ
3. Joram
4. MantaRay
5. OpenJMS

