---
title: java分布式事务
date: 2018-09-09 08:47:52
<<<<<<< HEAD
tags: Java
categories: Java
=======
tags: java
categories: 分布式
>>>>>>> 811e6bd830e98ed64c74fa5e0917ff8568625b5f
---
[数据一致性](https://www.infoq.cn/article/solution-of-distributed-system-transaction-consistency)

<<<<<<< HEAD
本地事务:
=======
1. 本地事务:

2. JDBC事务:

3. XA事务: 分布式事务规范，定义了(全局)事务管理器TM(Transaction Manager)和(局部)资源管理器RM(Resource Manager)之间的接口。
>>>>>>> 811e6bd830e98ed64c74fa5e0917ff8568625b5f

4. JTA(Java Transaction API)事务: 符合X/Open DTP模型。在JTA中，事务管理器抽象为javax.transaction.TransactionManager接口，通过底层事务服务(JTS Java Transaction Service)实现。一般由容器进行管理。WebLogic、Websphere提供了JTA的实现和支持，Tomcat需要借助第三方框架Jotm、Automikos实现

<<<<<<< HEAD
XA事务(传统事务):分布式事务规范，定义了(全局)事务管理器(Transaction Manager)和(局部)资源管理器(Resource Manager)之间的接口。

JTA(Java Transaction API)事务:在JTA中，事务管理器抽象为javax.transaction.TransactionManager接口，通过底层事务服务(JTS Java Transaction Service)实现。一般由容器进行管理。

幂等性:
=======
5. 幂等性: 针对一个操作，无论执行多少次，产生的结果和返回的结果都是一致的。常用于表单的重复提交、支付接口的调用。
	> 状态机幂等：有限状态机，例如：订单等单据类业务，存在很长的状态流转。
	>
	> 对外提供的接口保证幂等：请求接口需要携带source+seq字段，存储在数据库作唯一索引，防止多次提交。当请求过来时，先到数据库查一下，再做处理
	
>>>>>>> 811e6bd830e98ed64c74fa5e0917ff8568625b5f

<!-- more -->

## 解决方案：

## 1. 事务补偿机制(TCC) ##

业务S，对外提供服务，服务消费者M决定服务cancel还是commit

TRYING阶段：主要对业务进行检测及资源预留。

CONFIRMING阶段：业务提交，默认如果TRYING阶段执行成功，CONFIRMING阶段就一定能成功。

CANCELING阶段：业务回滚

### 应用场景： ###

基于web service/rpc/jms等构建的高度自治的分布式系统接口

### 传统事务和TCC事务的区别 ###

传统事务机制 = TCC事务机制Try + TCC事务机制Confirm

传统事务： 业务逻辑部分访问资源实现数据存储，由业务系统负责；事务处理部分通过协调资源管理器以实现事务管理，由事务管理器负责

TCC事务：业务逻辑和事务管理关系复杂。

[基于TCC的ByteTCC](https://github.com/liuyangming/ByteTCC/)

[基于XA两阶段的ByteJTA](https://github.com/liuyangming/ByteJTA/)

## 2. 两阶段提交(2PC) ##

	第一阶段：准备阶段

	第二阶段：提交阶段


## 3. 一阶段提交(1PC) ##

	应用场景：基于数据库分片(sharding)
## 4. 三阶段提交(3PC) ##


## 5. 消息队列实现(异步确保型事务) ##

	通过MQ消息队列实现，需要保证消息的成功发送和消费。

## 6. eBay方案(BASE) ##

	核心：保证服务接口的幂等性。

	#### Base ####

	一种ACID的替代方案，可用性通过支持局部故障而不是全局故障来实现。

	1)、将多表操作放在本地事务中来完成

	2)、通过增加update_applied表避免重复消费用户表消息

	3)、读取消息队列，但不删除消息，判断updates_applied表检测相关记录是否被执行，未执行的记录会修改user表 ，然后增加操作记录到updates_applied，事务执行完成后删除队列。

7. 最大努力通知型

	应用场景：调用第三方系统通信，例如微信支付、支付宝支付

	
**建议：**

1. 子系统较少、负载长期稳定、无伸缩要求、考虑开发复杂度和工作量的情况下，使用分布式事务(2PC)
2. 开发时间充裕、性能要求高的情况下，尽量采用1PC、事务补偿机制
3. 系统使用sharding模式的情况下，不要使用分布式事务
4. 不要在JTA事务中嵌套JDBC事务
5. 事务要尽可能在短时间内完成，事务的嵌套要求更良好的设计


参考：

[详细](https://blog.csdn.net/bluishglc/article/details/7612811)

[详细2](http://javaeye-mao.iteye.com/blog/1501726)