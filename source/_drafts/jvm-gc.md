---
title: jvm垃圾回收器(二)
date: 2018-08-07 22:09:54
tags: java, jvm
categories: JVM
---
JVM中的一些垃圾回收算法、垃圾收集器

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

	Eden:Survivor = 8:1
	
### 3. 标记-整理算法/标记-压缩算法

### 4. 分代收集算法
> 新生代：复制算法
> 老年代：标记-清除/标记-整理


### 案例分析：HotSpot的实现 ###

1.枚举根节点

2.安全点

3.安全区域


## gc回收器 ##

常用的参数：

|参数|描述 |
|-  |:----:|
|UseSerialGC      | client模式下的默认值，Serial + Serial Old收集器                 |
|UseParallelGC    | Server模式下的默认值，Parallel Scavenge + Serial Old收集器      |

### 1. Serial ###

### 2. ParNew ###

### 3. Parallel Scavenge ###

### 4. Serial Old ###

### 5. Parallel Old ###

### 6. CMS ###
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


### 7. G1 ###
目标：

#### 原理：
概念：
优先列表

##### Region：
> 默认堆内存分为1024个region分区。每个region大小相等
> region分为：Eden Survivor Old Humongous(巨型对象)，垃圾收集时，一个对象可以跨region
> 参数`-XX:G1HeapRegionSize`可以设置region大小，最小1Mb，最大32Mb
> 

##### SATB(Snapchat-At-The-Beginning)：
> 并发GC时用户程序同时运行，可能会生成新对象，所以在GC前，会先执行SATB，生成快照记录存活的对象
> 每个region记录两个TAMS(top-at-mark-start)指针，GC过程中生成的新对象，在TAMS上的对象就是新分配的对象
> Write Barrier

##### RSet(Remembered Set)：
> G1收集器中还有一个CSet(Collection Set)，用来记录要收集的Region的集合，
> RSet用来记录其它region引用本地region对象的关系，对象可以跨代引用，old->young/young->old

##### CarTable


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

### 8. ZGC ###

目标：

> GC停顿时间不超过10ms
> 处理堆从MB到TB
> 相比G1减少了15%的吞吐量
> 

### 9. Shenandoah GC ###


#### 对比：

Zing/Azul有一个低停顿的收集器，但是没有贡献到OpenJDK。

ZGC是基于colored pointers的收集器。Shenandoah GC是基于brook pointer的收集器。

G1可以并行、并发的工作，但是不能并发的evacuation。

CMS并发标记，在停顿期间复制年轻代，但是不压缩老年代。结果导致更多的时间管理剩余空间和碎片空间。

## 内存分配、回收策略 ##

Minor GC: 指发生在新生代的垃圾回收动作

Full GC/Major GC: 指发生在老年代的GC，出现Full GC，经常会伴随至少一次Minor GC;

**如果更细粒度，Major GC可以认为只对老年的GC，而Full GC是对整个堆来说的。**

1、对象优先在新生代Eden区分配，当Eden区没有足够空间进行分配时，虚拟机将发起一次Minor GC

2、大对象直接进入老年代。大对象典型的就是那些很长的字符串、数组

参数-XX:PretenureSizeThreshold可以设定大对象的标准

3、长期存活的对象将进入老年代(默认是15岁)

Eden区对象经过Minor GC后，年龄增1，然后在Survivor每经历一次Minor GC，年龄增长1，达到指定年龄，进入老年代

参数-XX:MaxTenuringThreshold

4、动态年龄判定

如果在Survivor区，相同年龄的所有对象大小总和大于Survivor空间的一半，年龄大于等于该年龄的对象可以直接进入老年代。【可以破坏规则3】

5、空间分配担保

### GC触发 ###

[参考](https://blog.csdn.net/chenleixing/article/details/46706039)

Minor GC触发条件：

> Eden区没有足够空间分配时，触发

Full GC触发条件：

>1. 显式调用System.gc()。可以通过-XX:+ DisableExplicitGC禁止显式调用
>
>2. 方法区(永生代)空间不足。方法区在HotSpot中又被称为永生代/永生区。如果被占满，在未配置为CMS GC的情况下，会执行一次Full GC，如果空间还是不足，则抛出异常java.lang.OutOfMemoryError: PermGen space 
>
>3. 老年代空间不足。出现的原因：新生代对象转入；分配大对象、大数组。如果Full GC后空间仍然不够，则抛出java.lang.OutOfMemoryError: Java heap space 
>
>4. Eden区对象执行Minor GC后，进入老年代的所有对象和大于老年代可用内存时，触发Full GC
>
>5. (promotion failed)Eden + From执行Minor GC时，如果存活对象大于To内存区，则直接进入老年代，如果老年代的可用内存小于该对象，则触发Full GC
> 
>6. (concurrent mode failure)执行CMS GC的过程中同时有对象要放入老年代，而此时老年代空间不足，则执行一次Full GC 

**注意:**jdk1.6_24之后，只要老年代的连续空间大于新生代对象总大小或者历次晋升的平均大小，就会执行Minor GC，否则进行Full GC