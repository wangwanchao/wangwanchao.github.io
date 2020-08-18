---
title: java中Fork/Join
tags: Java
categories: Java
date: 2020-08-18 00:45:23
---
工作中，一个处理数据远程数据逻辑耗时很长，尝试使用fork/join来改进，远程基本可以从60min+优化到20min+。干！

<!-- more -->
工作窃取算法

1、分割任务

2、执行任务并合并结果


ForkJoinTask

RecursiveAction: 用于返回没有结果的任务

RecursiveTask：用于返回有结果的任务 



Fork/Join实现原理

