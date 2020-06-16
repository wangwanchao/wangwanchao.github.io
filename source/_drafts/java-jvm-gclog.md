---
title: jvm日志分析
date: 2019-11-14 14:41:46
tags:
categpries: JVM
---

<!-- more -->
## 通用参数
### -Xmx
### -Xms
### -Xmn 

### -XX:+PrintGC / -XX:+PrintGCDetails

-XX:+PrintHeapAtGC
-Xloggc 日志文件存放位置
-XX:+PrintGCDateStamps 打印每个年代对象分布情况
-XX:+PrintGCDateStamps / -XX:+PrintGCTimeStamps
-XX:+PrintGCApplicationStoppedTime 
-XX:+PrintGCApplicationConcurrentTime 打印除了GC之外引起JVM STW的时间
-XX:+PrintSafepointStatistics 
-XX:PrintSafepointStatisticsCount=1


## 收集器特殊参数