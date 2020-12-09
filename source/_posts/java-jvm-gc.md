---
title: jvm垃圾回收
date: 2020-12-09 14:41:46
tags: jvm
categpries: JVM
---
垃圾回收器应该是架构师必备的核心技能，从回收算法、回收器、GC Roots、安全点/安全区域、分配策略、回收策略，整个过程都需要清晰。最后通过配置参数进行调优。
这是一篇持续更新的博客，随着认知的变化、GC的更新不断更新

<!-- more -->
## GC算法 ##

### 1. 标记-清除算法(Mark-Sweep):

缺点：
> 效率不高
> 
> 产生大量不连续的内存碎片

### 2. 复制算法

优点：
> 实现简单，运行高效

缺点：
> 内存浪费

商业用例：
```
Eden:Survivor = 8:1
```

### 3. 标记-整理算法/标记-压缩算法

### 4. 分代收集算法
> 新生代：复制算法
> 老年代：标记-清除/标记-整理

## 安全点/安全区域 ##

1.枚举根节点

2.安全点

3.安全区域

## 回收算法
年轻代：复制算法
老年代：
1. 标记-清除
2. 标记-整理
分代算法：年轻代使用复制算法，老年代使用标记清除/标记整理

## 回收器 ##
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

CMS、G1垃圾回收都采用**三色标记法**，但是具体实现不同：
思想：将对象标记为黑、灰、白三种颜色
> 从`GC Root`对象向下查找，根据三色标记法标记出所有连接的对象
> 第一次并发标记后，会产生浮动垃圾，即灰色对象，这时候进行一次STW的短暂停顿对灰色对象进行扫描标记
> GC线程扫描所有内存，找出被标记为白色的对象。

**规则**
黑色：该对象已经被标记过了，且该对象下的属性也全部都被标记过了。(存活对象)
灰色：该对象已经被标记过了，但该对象下的属性没有全被标记完。(存活对象下存在垃圾)
白色：该对象没有被标记过。(垃圾对象)

### CMS
(并发低停顿收集器), 基于标记-清除算法
目标：主要针对老年代，以获取最短回收停顿时间

#### 原理：

#### 垃圾回收
>初始标记：stop-the-world，仅仅标记GC Roots能关联到的对象 
>并发标记：进行GC Roots Tracing的过程
>重新标记：stop-the-world，修正并发标记期间程序运行变化的对象
>并发清除：用户程序同时运行

#### 优点：

#### 缺点：
1. 对CPU资源非常敏感：

	> 并发处理对CPU要求就比较高，占用一部分线程，会导致吞吐量降低。
	> **默认**垃圾回收线程数量(NUM(cpu) + 3)/4；
	> CPU不足4个时，对应用的影响就会比较大
2. 无法处理浮动垃圾：concurrent mode failure(并发模式失败)
	> 浮动垃圾：并发清理和用户程序同时运行，这样在清理期间就会产生对象垃圾，这部分垃圾需要留到下一次GC去处理，就会产生浮动垃圾。
	> 由于用户程序需要同时运行，所以老年代需要为用户程序预留一部分空间，预留空间无法满足用户程序，就会导致`Concurrent Mode Failure`，接着产生Full GC
	> jdk1.5增加参数`-XX:CMSInitiatingOccupancyFraction`，老年代使用超过该阈值，触发CMS垃圾回收，如果老年代不是增长太快，可以适当调高该值
	> jdk1.6
	> 参数`-XX:ConGCThreads=N`，可以设置垃圾收集线程数量
3. 产生大量空间碎片：promoration failure(晋升失败)
	> 标记-清除算法会导致空间碎片，碎片过多在大对象分配的时候，虽然有足够的时间，无法找到连续空间，不得不触发一次Full GC
	> 参数`-XX:+UseCMSCompactAtFullCollection`，默认开启，在执行Full GC的时候，开启内存碎片的整理
	> 参数`-XX:CMSFullGCsBeforeCompaction`，默认值为0，用于控制执行多少次不压缩的Full GC后执行一次带压缩的Full GC。

#### 参数：
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

### G1

目标：

#### 原理：
概念：
优先列表

##### Region：
> 默认堆内存分为1024个region分区。每个region大小相等
> region分为：Eden Survivor Old Humongous(巨型对象)，垃圾收集时，一个对象可以跨region
> 参数`-XX:G1HeapRegionSize`可以设置region大小，最小1Mb，最大32Mb

##### CSet(Collection Set)
一组可被回收的Region分区的集合。

##### RSet(Remembered Set)：
每个Region都有一个RSet，RSet其实是Card的集合，这个RSet用来记录其它Region引用自身Region内部对象的信息，对象可以跨代引用，`old->young`或者`young->old`，这样垃圾回收时只需要扫描RSet

##### CarTable
> CardTable是一种特殊类型的RSet，JVM使用一个字节数组作为CardTable，每一个字节都指向一个Card(512字节)，
> 老年代分为多个Card，如果Card中有指向年轻代的对象，则标记为`Dirty Card`，执行`Young GC`只需要扫描`Dirty Card`即可
> 底层使用`Bit Map`结构存储

##### SATB(Snapchat-At-The-Beginning)：
> 并发GC时用户程序同时运行，可能会生成新对象，所以在GC前，会先执行SATB，生成快照记录存活的对象
> 每个Region记录两个TAMS(top-at-mark-start)指针，GC过程中生成的新对象，在TAMS上的对象就是新分配的对象
> Write Barrier

#### 垃圾回收
#####  全局并发标记阶段
> 初始标记：stop-the-world，仅仅标记GC Roots能关联到的对象
> 并发标记： 
> 最终标记：stop-the-world，会处理在并发标记阶段write barrier记录下来的对象；与CMS最大的差别就是，CMS会扫描整个GC Roots，包括Eden区
> 筛选回收：stop-the-world，这一阶段并不会收集垃圾，而是根据停顿预测模型预测出CSet，等待下一个Evacuation阶段回收

##### 拷贝存活对象阶段 Evacuation
> stop-the-world，将一部分region中的存活对象拷贝到另一部分region，只剩下垃圾对象的region被记录在CSet，
> evacuation failure：堆空间垃圾太多，导致无法完成region之间的拷贝，导致执行一次Full GC。类似于CMS的`promoration failure`。

##### 收集模式
Young GC：
Mix GC：

#### 优点：
1. 并行与并发
2. 分代收集
3. 空间整合：

	> 与CMS的标记-清除算法不同，G1整体看是标记-整理算法，局部(Region)看则是复制算法，不会产生内存碎片。
4. 可预测的停顿：

	> 这是G1相比CMS的一大优势，降低停顿时间时G1和CMS共同的关注点，但G1除了追求低停顿，还能建立可预测的停顿时间模型
	> 参数`-XX:MaxGCPauseMillis`，可以设置停顿时间

#### 缺点：

#### 最佳实践
1. 不断调优停顿时间
2. 不设置新生代/老年代大小，由JVM自动调整，设置大小后会导致停顿时间设置失效
3. 关注Evacuation Failure问题

#### 参数：
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

### ZGC ###
#### 目标
> GC停顿时间不超过10ms
> 处理堆从MB到TB
> 相比G1减少了15%的吞吐量

#### 原理

#### 参数

### Shenandoah GC ###
目标：低停顿时间

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

## 内存分配、回收策略 ##

Minor GC: 指发生在新生代的垃圾回收动作

Full GC/Major GC: 指发生在老年代的GC，出现Full GC，经常会伴随至少一次Minor GC;

**如果更细粒度，Major GC可以认为只对老年的GC，而Full GC是对整个堆来说的。**

> 1、对象优先在新生代Eden区分配，当Eden区没有足够空间进行分配时，虚拟机将发起一次Minor GC
> 2、大对象直接进入老年代。大对象典型的就是那些很长的字符串、数组 参数-XX:PretenureSizeThreshold可以设定大对象的标准
> 3、长期存活的对象将进入老年代(默认是15岁)
Eden区对象经过Minor GC后，年龄增1，然后在Survivor每经历一次Minor GC，年龄增长1，达到指定年龄，进入老年代
参数-XX:MaxTenuringThreshold
> 4、动态年龄判定
如果在Survivor区，相同年龄的所有对象大小总和大于Survivor空间的一半，年龄大于等于该年龄的对象可以直接进入老年代。【可以破坏规则3】
> 5、空间分配担保

### GC触发 ###

Minor GC触发条件：
> Eden区没有足够空间分配时，触发

Full GC触发条件：

>1. 显式调用System.gc()。可以通过-XX:+ DisableExplicitGC禁止显式调用
>2. 方法区(永生代)空间不足。方法区在HotSpot中又被称为永生代/永生区。如果被占满，在未配置为CMS GC的情况下，会执行一次Full GC，如果空间还是不足，则抛出异常java.lang.OutOfMemoryError: PermGen space 
>3. 老年代空间不足。出现的原因：新生代对象转入；分配大对象、大数组。如果Full GC后空间仍然不够，则抛出java.lang.OutOfMemoryError: Java heap space 
>4. Eden区对象执行Minor GC后，进入老年代的所有对象和大于老年代可用内存时，触发Full GC
>5. (promotion failed)Eden + From执行Minor GC时，如果存活对象大于To内存区，则直接进入老年代，如果老年代的可用内存小于该对象，则触发Full G
>6. (concurrent mode failure)执行CMS GC的过程中同时有对象要放入老年代，而此时老年代空间不足，则执行一次Full GC 

**注意:**jdk1.6_24之后，只要老年代的连续空间大于新生代对象总大小或者历次晋升的平均大小，就会执行Minor GC，否则进行Full GC

## JVM参数

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