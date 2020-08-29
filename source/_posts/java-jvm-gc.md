---
title: jvm垃圾回收
date: 2020-08-29 14:41:46
tags: jvm
categpries: JVM
---
垃圾回收器应该是架构师必备的核心技能，从回收算法、回收器、GC Roots、安全点/安全区域、分配策略、回收策略，整个过程都需要清晰。最后通过配置参数进行调优
<!-- more -->

## 安全点/安全区域


## 回收算法
年轻代：
老年代：
1. 标记-清除
2. 标记-整理
分代算法：

## 回收器
### 年轻代收集器
|收集器|描述|算法|过程|优点|缺点|参数|
|:-|:-:|:-:|:-:|:-:|:-:|:-:|
|Serial|单线程，使用一个CPU/一个线程完成垃圾收集工作，收集过程必须STW，直到收集结束|复制算法|-|简单高效|-|-|
|ParNew|多线程，基于Serial的多线程版本，默认GC线程数等于CPU数量。除了Serial，只有ParNew可以和老年代的CMS收集器搭配|复制算法|-|-|在单CPU下性能不如Serial|ParallelGCThreads:GC线程数|
|Parallel Scavenge|并行，多线程，目标是达到可控制的吞吐量|复制算法|-|-|-|MaxGCPauseMillis:GC停顿时间;GCTimeRatio:GC停顿时间比例;UseAdaptiveSizePolicy:自适应调整参数|

### 老年代收集器
|收集器|描述|算法|过程|优点|缺点|参数|
|:-|:-:|:-:|:-:|:-:|:-:|:-:|
|Serial Old|单线程|标记-整理|-|-|-|-|
|Parallel Old|多线程|标记-整理|-|在吞吐量、CPU资源敏感的场景，优先考虑Parallel Scavenge + Parallel Old|-|
|CMS|并发，最短停顿时间|标记-清除|初始标记(STW)；并发标记；重新标记(STW)；并发清除|-|并发对CPU资源敏感；无法处理浮动垃圾导致并发模式失败；空间碎片导致无法分配大对象|CMSInitiatingOccupancyFraction:设置老年代占用率达到该阈值后，执行一次FullGC;+UseCMSCompactAtFullCollection:空间不足执行FullGC时同时执行碎片整理;CMSFullGCsBeforeCompaction:执行多少次不压缩的FullGC后执行一次碎片整理;|

三色标记：
### 混合收集器
|收集器|描述|算法|过程|优点|缺点|参数|
|:-|:-:|:-:|:-:|:-:|:-:|:-:|

### 回收器组合
|收集器组合|收集器|描述|
|:-|:-:|:-:|
|+UseSerialGC|Serial + Serial Old |jdk运行在client模式下默认组合|
|+UseParNewGC|ParNew + Serial Old|-|
|+UseConcMarkSweepGC|ParNew + CMS/Serial Old|老年代在并发模式失败后开启Serial Old|
|+UseParrallelGC|Parallel Scavenge + Serial Old(PS MarkSweep)|jdk运行在server模式下默认开启|
|+UseParallelGC|Parallel Scavenge + Parallel Old||
|+UseG1GC|G1|-|

## 参数
-Xms：最小堆
-Xmx：最大堆
-Xmn：新生代/年轻代大小

### -XX:+PrintGC / -XX:+PrintGCDetails

-XX:+PrintHeapAtGC
-Xloggc 日志文件存放位置
-XX:+PrintGCDateStamps 打印每个年代对象分布情况
-XX:+PrintGCDateStamps / -XX:+PrintGCTimeStamps
-XX:+PrintGCApplicationStoppedTime 
-XX:+PrintGCApplicationConcurrentTime 打印除了GC之外引起JVM STW的时间
-XX:+PrintSafepointStatistics 
-XX:PrintSafepointStatisticsCount=1
