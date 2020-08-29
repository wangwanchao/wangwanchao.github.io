---
title: JVM虚拟机命令详解(三)
date: 2018-08-07 22:14:15
tags: java, jvm
categories: JVM
---
其实去年就一直在做这些东西，只是没有整理出来，这一段时间面试还是遇到很多问jvm的东西，特别整理以下

<!-- more -->
## jvm的默认参数 ##

安装完jdk后，先来看一看一些默认参数，以下统一以jdk1.8为例。

	java -XX:+PrintFlagsFinal -version | grep :

"=":表示jvm参数的默认值，

":=":表示被用户或者jvm赋值的参数

     intx CICompilerCount                          := 2                                   {product}
    uintx InitialHeapSize                          := 48234496                            {product}
    uintx MaxHeapSize                              := 742391808                           {product}
    uintx MaxNewSize                               := 247463936                           {product}
    uintx MinHeapDeltaBytes                        := 524288                              {product}
    uintx NewSize                                  := 15728640                            {product}
    uintx OldSize                                  := 32505856                            {product}
     bool PrintFlagsFinal                          := true                                {product}
     bool UseCompressedClassPointers               := true                                {lp64_product}
     bool UseCompressedOops                        := true                                {lp64_product}
     bool UseParallelGC                            := true                                {product}


查看参数配置：

	java -XX:+PrintCommandLineFlags -version

	-XX:InitialHeapSize=46359872 
	-XX:MaxHeapSize=741757952 
	-XX:+PrintCommandLineFlags 
	-XX:+UseCompressedClassPointers 
	-XX:+UseCompressedOops 
	-XX:+UseParallelGC 
	java version "1.8.0_161"
	Java(TM) SE Runtime Environment (build 1.8.0_161-b12)
	Java HotSpot(TM) 64-Bit Server VM (build 25.161-b12, mixed mode)

### 参数分析 ###

-XX:+UseParallelGC参数可知，使用的收集器为Parallel Scavenge + Serial Old(PS MarkSweep)组合。

## jstat: 统计信息监控 ##

jstat option vmid [interval] [count]

#### 参数解释：####

Options — 选项，我们一般使用 -gcutil 查看gc 情况

vmid — VM 的进程号，即当前运行的java 进程号

interval– 间隔时间，单位为秒或者毫秒

count — 打印次数，如果缺省则打印无数次

#### 具体参数如下： ####

-class：统计class loader行为信息

-compile：统计编译行为信息

-gc：统计jdk gc时heap信息

-gccapacity：统计不同的generations（不知道怎么翻译好，包括新生区，老年区，permanent区）相应的heap容量情况

-gccause：统计gc的情况，（同-gcutil）和引起gc的事件

-gcnew：统计gc时，新生代的情况

-gcnewcapacity：统计gc时，新生代heap容量

-gcold：统计gc时，老年区的情况

-gcoldcapacity：统计gc时，老年区heap容量

-gcpermcapacity：统计gc时，permanent区heap容量

-gcutil：统计gc时，heap情况

-printcompilation：不知道干什么的，一直没用过。

#### 案例分析： ####

S0 — Heap 上的 Survivor space 0 区已使用空间的百分比

S1 — Heap 上的 Survivor space 1 区已使用空间的百分比

E — Heap 上的 Eden space 区已使用空间的百分比

O — Heap 上的 Old space 区已使用空间的百分比

P — Perm space 区已使用空间的百分比

YGC — 从应用程序启动到采样时发生 Young GC 的次数

YGCT– 从应用程序启动到采样时 Young GC 所用的时间( 单位秒 )

FGC — 从应用程序启动到采样时发生 Full GC 的次数

FGCT– 从应用程序启动到采样时 Full GC 所用的时间( 单位秒 )

GCT — 从应用程序启动到采样时用于垃圾回收的总时间( 单位秒)

jstat -gc 1909

	S0C    S1C    S0U    S1U      EC       EU        OC         OU       MC     MU      CCSC   CCSU     YGC     YGCT    FGC    FGCT     GCT   
	
	3456.0 3456.0 3456.0  0.0   28224.0  23968.9   70124.0    66785.0   43264.0 42270.5 4864.0  4588.8    128    1.487    8    0.779    2.266

jstat -gccapacity 1909

	NGCMN    NGCMX     NGC     S0C   S1C       EC      OGCMN      OGCMX       OGC         OC       MCMN     MCMX      MC     CCSMN    CCSMX     CCSC    YGC    FGC 
	
	5440.0  83968.0  35136.0 3456.0 3456.0  28224.0    10944.0   167936.0    70124.0    70124.0      0.0 1087488.0  43264.0   0.0    1048576.0   4864.0  128     8

jstat -gcutil 1909

jstat -gcutil 1909 1000 100      #每1000ms打印一次，总共打印100次

	S0     S1     E      O      M     CCS    YGC     YGCT    FGC    FGCT     GCT   
	
	0.00   0.00   3.41  60.00  97.54  94.07    129    1.534     9    1.148    2.682

jstat -gcnew 1909

	S0C    S1C    S0U    S1U   TT MTT  DSS      EC       EU     YGC     YGCT  
	
	3584.0 3584.0    0.0    0.0  1  15 1728.0  29248.0   2123.2    129    1.534

jstat -gcnewcapacity 1909

	NGCMN      NGCMX       NGC      S0CMX     S0C     S1CMX     S1C       ECMX        EC      YGC   FGC 
	
	5440.0    83968.0    36416.0   8384.0   3584.0   8384.0   3584.0    67200.0    29248.0   129     9

jstat -gcold pid

jstat -gcoldcapacity pid

jstat -gcpermcapacity pid

jstat -class 1909

	Loaded  Bytes  Unloaded  Bytes     Time   
	
	6688 13143.8       24    31.1      52.45

jstat -compiler 1909

	Compiled Failed Invalid   Time   FailedType FailedMethod
	
	7578      3       0    38.61          1 com/mysql/jdbc/AbandonedConnectionCleanupThread run


## jmap ##

jmap option vmid

#### 具体参数如下： ####

-dump

-heap

-histo

-finalizeerinfo

-permstat

-F

#### 案例分析： ####

使用hprof二进制形式,输出jvm的heap内容到文件，.live子选项是可选的，假如指定live选项,那么只输出活的对象到文件. 【执行过程会暂停应用】

记录堆内存快照文件，然后利用第三方工具mat分析整个Heap的对象关联情况 【如果添加参数:live，JVM会先触发gc，然后再统计信息。】

	jmap -dump:format=b,file=[filename][pid]
	
	jmap -dump:live,format=b,file=20170509.hprof 1909

打印heap的概要信息，GC使用的算法，heap的配置及wise heap的使用情况.

	jmap -heap 1909

打印每个class的实例数目,内存占用,类全名信息。VM的内部类名字开头会加上前缀”*”. 如果live子参数加上后,只统计活的对象数量. 【如果添加参数:live，JVM会先触发gc，然后再统计信息。】

	jmap -histo:live 1909 | head -n 100 > jmaphisto.log

打印正等候回收的对象的信息

	jmap -finalizerinfo 1283


打印classload和jvm heap永久层的信息. 【执行过程会暂停应用】

包含每个classloader的名字,活泼性,地址,父classloader和加载的class数量. 另外,内部String的数量和占用内存数也会打印出来.
 
	jmap -permstat 1909

结合MAT分析。

#### 补充：保留现场，使用更快的gcore分析 ####

1. Linux内核里面生成的core file文件相关的代码
2. core dump file 相关的设置
3. 如何在程序中调用代码生成 core dump file，程序又不用退出。
4. 使用gdb分析 core dump file 文件
5. 用gdb 生成core文件

## jstack ##

#### 具体参数如下： ####


#### 案例分析： ####

生成虚拟机当前时刻线程快照:
```
	jstack -l 1909
	jstack 1909 > jstack.log
```
## jps ##


## jinfo ##


## jcmd: 新版jdk的命令，用于取代旧版本命令##

#### 具体参数如下： ####



#### 案例分析： ####

查看jvm的pid,类似于jps命令

	jcmd -l
	1283 org.apache.catalina.startup.Bootstrap start
	2293 sun.tools.jcmd.JCmd -l
	27449 org.apache.activemq.apollo.boot.Apollo /usr/local/tbroker/lib\;/usr/local/apollo-1.7.1/lib org.apache.activemq.apollo.cli.Apollo run

	jps
	1283 Bootstrap
	27449 Apollo
	2315 Jps

查看 JVM 的启动时长：

	jcmd PID VM.uptime

查看 JVM 的类信息：这个可以查看每个类的实例数量和占用空间大小。

	jcmd PID GC.class_histogram

查看 JVM 的线程快照：

	jcmd PID Thread.print

查看 JVM 的Heap Dump：

	jcmd PID GC.heap_dump FILE_NAME

**注意**，如果只指定文件名，默认会生成在启动 JVM 的目录里。

查看 JVM 的属性信息：

	jcmd 1283 VM.system_properties
	1283:
	java.lang.OutOfMemoryError: Java heap space

查看 JVM 的启动参数：注意，可以看到 -X 和 -XX 的参数信息，比较有用。

	jcmd 1283 VM.flags
	1283:
	-XX:CICompilerCount=2 -XX:InitialHeapSize=16777216 -XX:MaxHeapSize=262144000 -XX:MaxNewSize=87359488 -XX:MinHeapDeltaBytes=196608 -XX:NewSize=5570560 -XX:OldSize=11206656 -XX:+UseCompressedClassPointers -XX:+UseCompressedOops 

查看 JVM 的启动命令行：

	jcmd 1283 VM.command_line

对JVM执行 java.lang.System.runFinalization()：

	jcmd 1283 GC.run_finalization

对JVM执行 java.lang.System.gc()：

	jcmd 1283 GC.run

**注意：**告诉垃圾收集器打算进行垃圾收集，而垃圾收集器进不进行收集是不确定的。

查看 JVM 的性能：

jcmd PID PerfCounter.print

**补充** 

常用命令

	top
	top -p 1909 -H
	free 
	free -m

高内存占用分析

	ps -mp 1909 -o THREAD,tid,time,rss,size,%mem

查看进程内存

	pmap -x 5454
	pmap -q 5454
	pmap -d -q 5454
