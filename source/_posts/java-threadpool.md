---
title: 线程池
tags: 线程池
categories: Java
date: 2018-08-07 00:00:57
categpries:
---
目前的经验，实际中一般应用在发送邮件、发送短信的场景

<!-- more -->

## Executors中的静态工厂方法 ##

1. newFixedThreadPool:创建一个固定长度的线程池，(无界的阻塞队列LinkedBlockingQueue)

2. newSingleThreadExecutor:创建单个工作者线程来执行任务，如果这个线程异常结束，会创建另一个线程代替(无界的阻塞队列LinkedBlockingQueue)

	**注意：** 因为以上两个都是使用的无界队列，允许请求队列长度为Integer.MAX_VALUE，所以可能堆积大量的请求，导致OOM

3. newCachedThreadPool:创建一个可缓存的线程池，(队列SynchronizedQueue)

4. newScheduledThreadPool:创建一个固定长度的线程池，而且以延迟或者定时的方式来执行任务,类似于Timer

**注意：**以上两个允许创建线程数为Integer.MAX_VALUE,可能创建大量线程，导致OOM

## ThreadPoolExecutor ##

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

### 队列 ###

基本的任务队列有3种：

1. 无界队列：

	> ArrayBlockingQueue：先进先出队列，任务的执行顺序和到达顺序一致

2. 有界队列：

	> LinkedBlockingQueue：用链表实现的队列，可以是有界的，也可以是无界的
	>
	> PriorityBlockingQueue：根据任务优先级安排任务，可以进一步控制任务的执行顺序

	有界队列可以避免资源耗尽，同时带来问题，当队列已满的时候，新任务需要配合饱和策略执行。
	
3. 同步移交
	
	> SynchronouseQueue：对于非常大或者无界的线程池，可以通过使用该队列避免任务排队。原理：如果有线程等待，直接移交给线程；如果没有线程，且当前线程数量corePoolSize，则创建一个新线程移交；否则根据饱和策略处理。所以使用SynchronouseQueue时，maximumPoolSize是不起作用的。

### 饱和策略 ###

当线程池已满，同时队列也满了以后，根据饱和策略处理请求线程

JDK提供了4种饱和策略：

> AbortPolicy:默认的饱和策略，当队列满时，将抛出未检查的RejectedExecutionException
>
> CallerRunsPolicy:该策略不会抛弃任务，也不会抛出异常，而是将任务交给提交任务的线程执行，从而降低新任务的流量
>
> DiscardPolicy:当新提交的任务无法保存到队列时，该策略将抛弃该任务
>
> DiscardOldestPolicy:该策略将抛弃下一个被执行的任务(即最早排队而尚未执行的任务)，然后重新提交新任务

### 线程工厂 ###

默认的线程工厂方法将创建一个新的、非守护的线程，并且不包含特殊的配置信息

	public ThreadPoolExecutor(int corePoolSize,
                              int maximumPoolSize,
                              long keepAliveTime,
                              TimeUnit unit,
                              BlockingQueue<Runnable> workQueue) {
        this(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue,
             Executors.defaultThreadFactory(), defaultHandler);
    }
可以看到默认情况下，使用DefaultThreadFactory线程工厂，AbortPolicy策略

## Thread Pool使用不当导致的死锁 ##
