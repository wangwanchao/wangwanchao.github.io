---
title: synchronized和ReentrantLock
date: 2018-08-07 00:02:44
tags: java, 多线程
categories: java
---
## synchronized ##

### sychronized的几种不同用法： ###

1、修饰类

锁的对象是该类的所有实例

2、修饰静态方法

锁的对象是该类的所有实例对象



3、修饰方法

锁的对象是调用该方法的实例对象

4、修饰代码块

和修饰方法类似，锁对象都是调用该方法的实例对象


## ReentrantLock ##


## synchronize和ReentrantLock的比较 ##



ReentranLock使用场景：

> 需要时间锁、可中断锁、无块结构锁、轮询锁、多个条件变量时使用
>
> 需要可伸缩性、高度竞争的情况下使用