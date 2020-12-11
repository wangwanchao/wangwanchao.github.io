---
title: paper-g1
date: 2020-12-10 13:54:55
tags:
categpries:
---

<!-- more -->

## 数据结构

### 堆布局
G1堆被划分成大小相同的Region，每个Region都是一段连续的虚拟内存。我们主要关心的是多处理器、增量线程。增量线程只分配`thread-local allocation buffers`和`TLABs`，然后将对象分配在这些buffers中，来减少资源竞争。当前Region填满以后，会选择一个新的Region，所有都Regions组成一个链表使所有的分配时间是线性的。
更大的对象可能直接分配在Region，不考虑`TLABs`，超过Region大小3/4的对象称为大对象(humongous)。大对象直接分配在连续的regions中，这些regions只存储大对象。


### RSets

通知使用了一种`card table`机制，堆中每512字节的card映射到`card table`中1字节的对象。每个线程都有一个关联的`remembered set log`、一个buffer、一些连续的修改过的cards。也就是说，有一个全局的`filled RS buffers`集合
RSets实际上是cards的集合，使用`hash tables`存储。由于并行机制，每个Region都有一个`hash tables`组成的数组、一个GC线程，GC线程允许这些线程更新RSets而不相互干扰。
RSets在指针改写后会执行`write barrier`，
例如：x、y分别放在寄存器`rX`和`rY`中，执行代码`x.f = y`，执行屏障的伪代码如下
```
1| rTmp := rX XOR rY
2| rTmp := rTmp >> LogOfHeapRegionSize
3| // Below is a conditional move instr
4| rTmp := (rY == NULL) then 0 else rTmp
5| if (rTmp == 0) goto filtered
6| call rs_enqueue(rX)
7| filtered:
```
屏障使用了一种filter的技术，如果写操作在同一个Region中创建了一个对象到另一个对象的指针操作，则不需要记录在RSets中。代码中如果x、y在同一个Region中，
行1、2异或、右移操作后rTmp为0。
行4对空指针进行过滤，如果执行了过滤检查，则创建一个跨Region的指针。
`rs_enqueue`读取rX的`card table entry`。如果该entry已经脏了，则什么也不做，这就减少了对同一个card写操作的工作，典型的像初始化操作；如果该entry还没有脏，则先修改为`dirty card`，同时指向该card的指针被记录到这个线程的`remembered set log`。如果该线程的`log buffer`已经满了，则该buffer被添加到全局`filled RS buffers`集合，接着分配一个新的buffer。`log buffer`默认可以存储256个元素。
并发的RSet线程会先初始化`filled RS buffers`数量，默认是5个。每个buffer需要处理每个`card table`的entry，一些cards被频繁写入，为了避免重复处理过热的cards，尽量识别出最热的cards，直到下一个阶段(evacuation pause)去处理。这种机制通过一个`二级 card table`实现，这个table记录了从上一次evacuation pause到现在该card被dirty的总次数，每次处理card就加1。如果这个数值超过阈值(默认4)，则该card被添加到一个称为`hot queue`的`circular buffer`，该queue默认为1k。处理结束后queue为空，如果`circular buffer`满了，则从尾端取出一个card进行处理。
并发RSet线程会处理card，首先，重置entry为clean值，以便并发线程可以重新dirty、enqueue。然后，检查所有对象的指针字段

### 垃圾回收阶段 evacuation pause
在合适的时间点，停止所有的增量线程，执行一次垃圾回收。选中regions的CSet，复制regions内的存货对象到其它的位置，然后释放这些regions。该阶段允许压缩，所有对象的移动必须是原子性的，这在并发系统中是非常浪费的，所以把对象迁移放到STW阶段执行。
如果多线程程序运行在多处理器服务器上，使用单线程垃圾回收器会导致性能瓶颈。
首先，单线程顺序选择CSet
其次，并行阶段，GC线程请求执行任务，扫描`log buffers`更细RSets、扫描RSets和其它`root groups`查找存活对象、回收存活对象。
为了实现快速的并行回收，使用一种`GCLABs`技术，

### G1
新分配的对象通常更可能成为垃圾，当Region被选择作为`mutator allocation region`时，我们可以尝试指定它为young。这个Region进入下一次的CSet，这种尝试虽然有损失，但却可以获得很大的收益：
一个CSet可以包括`young regions`和`non-young regions`，
G1可以运行在2种模式下：普通模式、`pure garbage-first`模式。默认是普通模式。普通模式包括2种子模式：`evacuation pauses`可以是`fully young`和`partially young`，全量模式会把所有已分配的`young regions`添加到CSet，增量模式除了添加所有`young regions`之外，如果停顿时间允许，还会添加一部分`non-young regions`。

### 并发标记
使用一种SATB(snapshot-at-the-beginning)并发标记技术，标记用来识别开始就存在的垃圾对象。在标记中间分配的对象必须判断是否存活。但是已经被标记的对象不需要再重新标记、跟踪。这种方法大大的较少了标记耗时。

#### 标记数据结构
G1维护了2种类型的`marking bitmaps`，
previous: 已经标记完成的bitmap
next: 可能正在构建的bitmap
这2种bitmap在标记完成后交换角色，每个bitmap都包含1个bit，默认都是8字节对齐，意味着1个bitmap bit需要64bit。

#### 初始标记/并发标记
首先，清空`next bitmap`，
其次，初始化标记会停止所有的增量线程，同时标记所有可到达的对象。每个Region包括2个TAMS(top at mark start)变量，分别为previous、next使用，这些变量用来识别在标记期间分配的对象。
初始化阶段会遍历所有的regions，复制region的top属性值到`next TAMS`

#### 并发标记写屏障


例如：
```
1| rTmp := load(rThread + MarkingInProgressOffset)
2| if (!rTmp) goto filtered
3| rTmp := load(rX + FieldOffset)
4| if (rTmp == null) goto filtered
5| call satb_enqueue(rTmp)
6| filtered:
```
行1、行2: 如果不执行标记，则跳过以下代码。对于很多程序来说，这个会过滤掉很多动态屏障
行3、行4: 加载对象属性的值，检查是否为null，只需要记录非空的值。
行5: 添加指针到线程的`marking buffer`，如果buffer被填满，则添加到全局的`marking buffers`集合中，

#### 最终标记


#### 统计存活对象并清理
