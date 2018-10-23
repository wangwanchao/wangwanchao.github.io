---
title: jdk1.8新特性
date: 2018-08-30 20:32:42
tags: java
categories: java
---
jdk10都出来好久了，一直也没总结过jdk1.8的东西，今天回顾一下

## 一、集合 ##


## Lambda表达式 ##


## 接口的默认实现方法 ##

接口中可以添加一个非抽象方法，只需要使用default修饰符即可


## 函数式接口 ##

指仅仅包含一个抽象方法的接口。在接口上添加@FunctionalInterface即可实现函数式接口。详细可以查看jdk1.8的java.util.function包


## Fork/Join并行流 ##

在必要的情况下，将一个大任务进行必要的拆分Fork成若干个小任务，再将小任务的运算结果进行Join汇总。

Fork/Join框架和传统线程池的区别：

采用“工作窃取”模式（Working-stealing），即当执行新的任务时它可以将其拆分分成更小的任务执行，并将小任务加到线程队列中，然后再从一个随机线程的队列中偷一个并把它放在自己的队列中。

parallel()




## Date API(详细在java.time包内) ##






