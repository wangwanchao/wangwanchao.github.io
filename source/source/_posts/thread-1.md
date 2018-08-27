---
title: Java并发编程
date: 2018-07-27 23:12:48
tags:
---
synchronized

public static void synchronized 


## volatile

当且仅当满足以下所有条件时，才应该使用volatile变量：

对变量的写入操作不依赖变量的当前值，或者你能确保只有单个线程更新变量的值；

该变量不会与其它状态变量一起纳入不变性条件中；

在访问变量时不需要加锁。


发布：

逸出：

构造过程导致this引用逸出的常见错误：

1、在构造函数中启动一个线程。在构造函数中创建线程并没有错误，但最好不要立即启动它，而是通过一个sart/initialize方法启动它。

2、在构造函数中调用一个可改写的实例方法时(既不是私有方法，也不是终结方法)

如果在构造函数中注册一个事件监听器或者启动线程，那么可以使用一个私有的构造函数和一个公共的工厂方法。


线程封闭：如果仅在单线程内访问数据，就不需要同步，这种技术被称为线程封闭

应用场景：

> 在Swing中大量使用
> 
> JDBC的Connection对象


1、Ad-hoc线程封闭：维护线程封闭性的职责完全由程序来承担

Demo:


2、栈封闭：将对象封闭在栈内，只能通过局部变量才能访问

Demo:


3、TreadLocal类:

场景：

> 通常用于防止对可变的单实例变量、全局变量进行共享
> 

Demo:

    private static ThreadLocal<Connection> connection = new ThreadLocal<Connection>(){};

## 同步工具类

闭锁(CountdownLatch)：

FutureTask

信号量(Semphore):

栅栏(CyclicBarrier):


### 基本的任务排队方法 ###
1、无界队列

2、有界队列

3、同步移交

SynchronousQueue

ArrayBlockingQueue

LinkedBlockingQueue

PriorityBlockingQueue

### 饱和策略 ###

AbortPolicy

CallerRunsPolicy

DiscardPolicy

DiscardOldestPolicy


## ##

Synchronized和ReentrantLock


独占锁和读写锁(ReentrantReadWriteLock/ReadWriteLock)

ConcurrentHashMap(ConcurrentMap)


## AQS ##

基于AQS实现的类：

CountDownLatch

Semaphore

FutureTask

SynchronousQueue

ReentrantLock

ReentrantReadWriteLock


## 原子变量与非阻塞同步机制 ##


## Java内存模型 ##

Happens-Before原则：

