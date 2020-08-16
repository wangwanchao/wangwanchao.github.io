---
title: jvm垃圾收集器CMS和G1比较(四)
date: 2018-12-04 14:09:26
tags: java, jvm
categpries: JVM
---
结合GC日志对CMS、G1分析

<!-- more -->
## CMS
### 参数：
|参数|详解|
|-|:-:|
| -XX:+UseConcMarkSweepGC 				| 激活CMS收集器|				
| -XX:ConcGCThreads 					| 设置CMS线程的数量|
| -XX:+UseCMSInitiatingOccupancyOnly 	| 只根据老年代使用比例来决定是否进行CMS|
| -XX:CMSInitiatingOccupancyFraction 	| 设置触发CMS老年代回收的内存使用率占比|
| -XX:+CMSParallelRemarkEnabled 		| 并行运行最终标记阶段，加快最终标记的速度|
| -XX:+UseCMSCompactAtFullCollection 	| 每次触发CMS Full GC的时候都整理一次碎片|
| -XX:CMSFullGCsBeforeCompaction 		| 经过几次CMS Full GC的时候整理一次碎片|
| -XX:+CMSClassUnloadingEnabled 		| 让CMS可以收集永久带，默认不会收集|
| -XX:+CMSScavengeBeforeRemark 			| 最终标记之前强制进行一个Minor GC|
| -XX:+ExplicitGCInvokesConcurrent 		| 当调用System.gc()的时候，执行并行gc，只有在CMS或者G1下该参数才|

### 日志：


## G1
### 参数：
|参数|详解|
|-|:-:|
|-XX:+UseG1GC 							| 使用 G1 垃圾收集器	|						
|-XX:MaxGCPauseMillis=200 				| 设置期望达到的最大GC停顿时间指标（JVM会尽力实现，但不保证达到）|
|-XX:InitiatingHeapOccupancyPercent=45 	| 启动并发GC周期时的堆内存占用百分比. G1之类的垃圾收集器用它来触发并发GC周期,基于整个堆的使用率,而不只是某一代内存的使用比. 值为 0 则表示”一直执行GC循环”. 默认值为 45	|
|-XX:NewRatio=n 							| 新生代与老生代(new/old generation)的大小比例(Ratio). 默认值为 2	|
|-XX:SurvivorRatio=n 					| eden/survivor 空间大小的比例(Ratio). 默认值为 8.|
|-XX:MaxTenuringThreshold=n 				| 提升年老代的最大临界值(tenuring threshold). 默认值15	|
|-XX:ParallelGCThreads=n 				| 设置垃圾收集器在并行阶段使用的线程数,默认值随JVM运行的平台不同而不同.|
|-XX:ConcGCThreads=n 					| 并发垃圾收集器使用的线程数量. 默认值随JVM运行的平台不同而不同.|
|-XX:G1ReservePercent=n 					| 设置堆内存保留为假天花板的总量,以降低提升失败的可能性. 默认值是 10.|
|-XX:G1HeapRegionSize=n 					| 使用G1时Java堆会被分为大小统一的的区(region)。此参数可以指定每个heap区的大小. 默认值将根据 heap size 算出最优解. 最小值为 1Mb, 最大值为 32Mb.|

### 日志：