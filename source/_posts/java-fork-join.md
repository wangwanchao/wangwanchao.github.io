---
title: java中Fork/Join
tags: forkjoin
categories: Java
date: 2020-08-18 00:45:23
---
工作中，一个处理数据远程数据逻辑耗时很长，尝试使用fork/join来改进，远程基本可以从60min+优化到20min+。干！

<!-- more -->
Fork/Join采用了分而治之的思想，具体实现使用工作窃取算法

## 设计思路
fork/join主要分为2个步骤：
1. 分割任务
2. 执行任务并合并结果
### 分割任务
使用fork类将大任务分割为子任务，子任务可以继续分割

### 执行任务并合并结果
分割的任务放到双端队列，然后启动线程，这些线程分别从队列的两端获取任务，执行的结果放到另一个队列中，最后由一个线程合并执行的结果

## Fork/Join实现原理
fork/join实现了
1. ForkJoinTask提供了fork()、join()，fork()方法将分割的任务添加到任务队列，join()合并任务执行结果。有两个子类
RecursiveAction: 用于返回没有结果的任务
RecursiveTask：用于返回有结果的任务 
2. ForkJoinPool ForkJoinTask需要通过ForkJoinPool来执行。分割的子任务会被添加到当前工作线程所维护的双端队列中，当一个工作线程的队列中暂时没有任务时，会从其他工作线程的队列尾部窃取任务来执行。这就是'工作窃取算法'

### 异常处理
取消异常
运行异常