---
title: java中特殊类Object
date: 2019-06-10 23:21:14
tags: java
categpries: Java
---
Object是所有类的父类。

<!-- more -->
Object类方法结构：

<image src="https://impwang.oss-cn-beijing.aliyuncs.com/java/object.png"/>

## equals、hashCode


## wait、notify、notifyAll
原理：
obj.wait(), obj.notify()必须在synchronized(obj)语句块内，wait释放对象锁，线程休眠。notify唤醒线程，但不会马上释放对象锁。synchronized执行结束，自动释放锁后，jvm层在持有wait对象锁的线程中随机选取一线程，赋予对象锁，唤醒线程。

虚假唤醒：

**注意：lost wake up问题** 
> 
1. wait/notify/notify必须在锁对象的synchronized同步块内。 因为这三个方法都是释放锁的，如果没有synchronized先获取锁就调用释放锁会引起异常.
2. java.util.concurrent.locks.Condition类中的await/signal也必须在同步块内


案例：

```

```

### wait/notify的缺点：
1. 线程B通知线程A时，线程A必须在wait调用上等待，否则线程A永远不会被唤醒
2. notify只能唤醒一个线程，而notifyAll则唤醒全部线程

### 改进方案LockSupport:

<image src="https://impwang.oss-cn-beijing.aliyuncs.com/java/LockSupport.png"/>

原理：
LockSupport使用：
park：等待许可，类似于wait
unpark：提供许可，类似于notify
park和unpark之间没有时序问题，最底层通过Posix的mutex、condition实现。

```

```

### 对比
相同点：
1. wait/park都会阻塞线程，释放锁
2. 上层表现机制不一样，系统层面都是通过**中断**实现

不同点：
1. wait/notify/notifyAll针对的是对象，而且notify不能唤醒某个具体线程；LockSupport可以具体到某一个线程
2. 实现原理不同，wait/notify基于；LockSupport底层基于Unsafe.park实现
3. wait完成同步，需要依赖监视器锁；LockSupport可以使用getBlocker监视锁的持有情况


