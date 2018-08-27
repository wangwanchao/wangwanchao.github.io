---
title: 线程池
date: 2018-08-07 00:00:57
tags: java, 多线程
categories: java
---
## 线程池 ##

1、Executors中的静态工厂方法：

newFixedThreadPool:创建一个固定长度的线程池，(无界的阻塞队列LinkedBlockingQueue)

newSingleThreadExecutor:创建单个工作者线程来执行任务，如果这个线程异常结束，会创建另一个线程代替(无界的阻塞队列LinkedBlockingQueue)

**注意：** 以上两个允许请求队列长度为Integer.MAX_VALUE,可能堆积大量的请求，导致OOM

newCachedThreadPool:创建一个可缓存的线程池，(队列SynchronizedQueue)

newScheduledThreadPool:创建一个固定长度的线程池，而且以延迟或者定时的方式来执行任务,类似于Timer

**注意：**以上两个允许创建线程数为Integer.MAX_VALUE,可能创建大量线程，导致OOM

2、ThreadPoolExecutor

### 创建与销毁 ###

	public ThreadPoolExecutor(int corePoolSize,
                          int maximumPoolSize,
                          long keepAliveTime,
                          TimeUnit unit,
                          BlockingQueue<Runnable> workQueue,
                          ThreadFactory threadFactory,
                          RejectedExecutionHandler handler) {

	}

corePoolSize:没有任务执行时线程池的大小，当工作队列满了的时候，才会创建超出该数量的线程

maximumPoolSize:表示可同时活动的线程数量的上限

keepAliveTime:空闲线程存活时间，如果某个线程的空闲时间超过了keepAliveTIme，则被标记为可回收，并且当线程池当前大小超出corePoolSize时，这个线程将被终止。

### 管理队列任务 ###

基本的任务队列有3种：

>无界队列
>
>有界队列
>
>同步移交

ArrayBlockingQueue

LinkedBlockingQueue

PriorityBlockingQueue

SynchronouseQueue

### 饱和策略 ###

当队列满了以后，饱和策略发挥作用

JDK提供了4种饱和策略：

> AbortPolicy:默认的饱和策略，当队列满时，将抛出未检查的RejectedExecutionException
>
> CallerRunsPolicy:该策略不会抛弃任务，也不会抛出异常，而是将某些任务回退到调用者，从而降低新任务的流量
>
> DiscardPolicy:当新提交的任务无法保存到队列时，该策略将抛弃该任务
>
> DiscardOldestPolicy:该策略将抛弃下一个被执行的任务，然后重新提交新任务



### 线程工厂 ###

默认的线程工厂方法将创建一个新的、非守护的线程，并且不包含特殊的配置信息
