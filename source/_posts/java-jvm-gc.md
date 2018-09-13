---
title: jvm垃圾回收器
date: 2018-08-07 22:09:54
tags: java, jvm
categories: java
---

## gc算法 ##

1.标记-清除算法(Mark-Sweep):


缺点：

> 效率不高
> 
> 产生大量不连续的内存碎片

<!-- more -->

2.复制算法

优点：

> 实现简单，运行高效

缺点：

> 内存浪费

商业用例：

	Eden:Survivor = 8:1


3.标记-整理算法/标记-压缩算法

4.分代收集算法

> 新生代：复制算法
> 
> 老年代：标记-清除/标记-整理


### 案例分析：HotSpot的实现 ###

1.枚举根节点

2.安全点

3.安全区域



## gc回收器 ##

常用的参数

|参数  |描述 |
|-  |:----:|
|UseSerialGC      | client模式下的默认值，Serial + Serial Old收集器                 |
|UseParallelGC    | Server模式下的默认值，Parallel Scavenge + Serial Old收集器      |

1.Serial

2.ParNew


3.Parallel Scavenge

4.Serial Old

5.Parallel Old

6.CMS(并发低停顿收集器), 基于标记-清除算法

目标：以获取最短回收停顿时间

原理：

>初始标记
>
>并发标记
>
>重新标记
>
>并发清除

优点：

缺点：

> 对CPU资源非常敏感
> 
> 无法处理浮动垃圾
> 
> 产生大量空间碎片


7.G1

目标：

原理：

> 概念：
> 优先列表
> 
> Region
> 
> Remembered Set
> 
> Write Barrier
> 
> CarTable


> 初始标记
> 
> 并发标记
> 
> 最终标记
> 
> 筛选回收


优点：

> 并行与并发
> 
> 分代收集
> 
> 空间整合：与CMS的标记-清除算法不同，G1整理看是标记-整理算法，局部(Region)看则是复制算法，不会产生内存碎片。
> 
> 可预测的停顿：这是G1相比CMS的一大优势，降低停顿时间时G1和CMS共同的关注点，但G1除了追求低停顿，还能建立可预测的停顿时间模型

缺点：



## 内存分配、回收策略 ##

Minor GC: 指发生在新生代的垃圾回收动作

Full GC/Major GC: 指发生在老年代的GC，出现Full GC，经常会伴随至少一次Minor GC;

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

Minor GC触发条件：

> Eden区没有足够空间分配时，触发

Full GC触发条件：

>显式调用System.gc()时
>
>方法区空间不足
>
>老年代空间不足
>
>Eden区对象执行Minor GC后，进入老年代的所有对象和大于老年代可用内存时，触发Full GC
>
>Eden + From执行Minor GC时，如果存活对象大于To内存区，则直接进入老年代，如果老年代的可用内存小于该对象，则触发Full GC

**注意:**jdk1.6_24之后，只要老年代的连续空间大于新生代对象总大小或者历次晋升的平均大小，就会执行Minor GC,否则进行Full GC