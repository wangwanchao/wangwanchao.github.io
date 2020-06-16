---
title: Linux--零拷贝
date: 2019-06-17 10:13:56
tags: linux
categpries: Linux
---
linux中的零拷贝技术

<!-- more -->
## I/O原理
普通I/O：应用程序或者运行在用户模式下的库函数访问硬件设备时，I/O操作需要

1. 硬件和系统之间的零拷贝
2. 软件和系统之间的零拷贝

## mmap

### 局限性
#### SIGBUS中断
其他进程同时对文件的操作导致write系统调用中断

解决方法：

方案1. 增加SIGBUS错误信号处理
方案2. 对文件加锁，当有其它的进程对文件进行操作时，触发SIGBUS中断

## sendfile


### 局限性

#### 数据污染
叶缓存可能被污染

## 改进版sendfile
文件描述符拷贝

## splice



## 应用
FileChannel类

MappedByteBuffer类