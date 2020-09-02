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
年轻代：复制算法
老年代：
1. 标记-清除
2. 标记-整理
分代算法：年轻代使用复制算法，老年代使用标记清除/标记整理

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

CMS垃圾回收三色标记法：
### 混合收集器
|收集器|描述|算法|过程|优点|缺点|参数|
|:-|:-:|:-:|:-:|:-:|:-:|:-:|
|+UseG1GC| | | | |  | |
|+UseZGC| | | | | | |

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
### 内存参数
-Xms：初始堆。默认为物理内存的1/64。
-Xmx：最大堆。默认为物理内存的1/4。
-Xmn：新生代/年轻代大小。增大年轻代后，老年代会减小，官方建议为整个堆的3/8.
```
年轻代大小 = eden + survivor
整个堆大小 = 年轻代大小 + 老年代大小 + 永久代大小(1.8之后弃用)
```
-XX:NewRatio: 年轻代与老年代的比值。
-XX:SurvivorRatio: Eden区与Survicor区的比值。
-XX:PermSize：永久代初始大小。默认为物理内存的1/64。
-XX:MaxPermSize：永久代最大值。默认为物理内存的1/4。

### 编译参数
-XX:LargePageSizeInBytes: 内存页的大小，默认为，可能会影响Perm。
-XX:+UseFastAccessorMethods：
-XX:+UseBiasedLocking	
-XX:PretenureSizeThreshold	
-XX:TLABWasteTargetPercent：TLAB占Eden区的百分比，默认1%。
-XX:SoftRefLRUPolicyMSPerMB	
-XX:+UseCompressedClassPointers 
-XX:+UseCompressedOops -XX:-UseLargePagesIndividualAllocation

-XX:G1ConcRefinementThreads=4 -XX:GCDrainStackTargetSize=64 -XX:InitialHeapSize=130694848 
-XX:MaxHeapSize=2091117568
-XX:MinHeapSize=6815736 
-XX:+PrintCommandLineFlags -XX:ReservedCodeCacheSize=251658240 
-XX:+SegmentedCodeCache 

### 日志参数
-XX:+PrintHeapAtGC：打印GC前后的堆栈信息
-XX:+PrintTLAB： 查看TLAB空间的使用情况
-Xloggc 日志文件存放位置
-XX:+PrintGCDateStamps 打印每个年代对象分布情况
-XX:+PrintGCDateStamps / -XX:+PrintGCTimeStamps
-XX:+PrintGCApplicationStoppedTime： 
-XX:+PrintGCApplicationConcurrentTime：打印除了GC之外引起JVM STW的时间
-XX:+PrintSafepointStatistics：
-XX:PrintSafepointStatisticsCount=1：

## GC调优
GC性能调优大致有两个指标：
1. 吞吐量：工作线程运行时间/总的运行时间
2. 停顿时间：STW时间

### 调优方向
1. Heap大小
Xms、Xmx设置为相同值，避免申请内存带来的压力。

2. 年轻代大小
年轻代太小，就会导致频繁的Minor GC；太大则占用老年代空间，导致频繁的Full GC；
响应时间优先：
吞吐量优先：

3. 老年代大小
响应时间优先：
吞吐量优先：

4. CMS收集器
使用CMS的好处是用尽量少的年轻代，经验值是128M－256M， 然后老年代可以大一些，由于老年代并发收集， 这样能保证系统低延迟的吞吐效率。 
实际上cms的收集停顿时间非常的短，2G的内存， 大约20－80ms的应用程序停顿时间。
并发模式失败：GC线程在并发标记/并发清理阶段，用户工作线程仍然并发运行，导致浮动垃圾，如果老年代剩余空间不足，则会导致'并发模式失败'。
晋升失败：`Eden + From Survivor`区对象经过Minor GC进入`To Survivor`，To Survivor空间不足，再次进入`Old gen`老年代，老年代空间也不足，则会执行`Full GC`，同时抛出晋升失败`Promotion faild`。关于晋升失败，前辈大概总结出来一个公式：
```
CMSInitiatingOccupancyFraction <= ((Xmx-Xmn)-(Xmn-Xmn/(SurvivorRatior+2)))/(Xmx-Xmn)*100
```