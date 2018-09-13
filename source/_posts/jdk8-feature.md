---
title: jdk1.8新特性
date: 2018-08-30 20:32:42
tags: java
categories: java
---
jdk10都出来好久了，一直也没总结过jdk1.8的东西，今天回顾一下

## 一、集合 ##

HashMap

链表 + 红黑树

ConcurrentHashMap

采用了CAS算法

没有永久代，取而代之的是Meta Space空间，用的是物理内存。


## Lambda表达式 ##


## 接口的默认实现方法 ##

接口中可以添加一个非抽象方法，只需要使用default修饰符即可


## 函数式接口 ##

指仅仅包含一个抽象方法的接口。在接口上添加@FunctionalInterface即可实现函数式接口。详细可以查看jdk1.8的java.util.function包

Consumer<T>

Supplier<T>

Function<T, R>

Predicate<T>

Comparator<T>

Optional<T>: 不是函数是接口，这是个用来防止NullPointerException异常的辅助类型

Stream<T>: Stream 操作分为中间操作或者最终操作两种，最终操作返回一特定类型的计算结果，而中间操作返回Stream本身

Filter过滤

Sort排序

Map映射

Match匹配

Reduce规约





## 方法和构造器的引用 ##

方法引用

	对象::实例方法名
	类::静态方法名
	类::实例方法名

构造器引用

	类::new

数组引用

	Type[]::new


## Fork/Join并行流 ##

在必要的情况下，将一个大任务进行必要的拆分Fork成若干个小任务，再将小任务的运算结果进行Join汇总。

Fork/Join框架和传统线程池的区别：

采用“工作窃取”模式（Working-stealing），即当执行新的任务时它可以将其拆分分成更小的任务执行，并将小任务加到线程队列中，然后再从一个随机线程的队列中偷一个并把它放在自己的队列中。

parallel()




## Date API(详细在java.time包内) ##

Instant

Clock时钟

Timezones时区

LocalTime/LocalDate/LocalDateTime本地时间

**注意：**和java.text.SimpleDateFormat不同的是，DateTimeFormatter是不可变的，所以它是线程安全的。


## 支持多重注解 ##



