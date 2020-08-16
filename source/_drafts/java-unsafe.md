---
title: java特殊类Unsafe
date: 2019-03-23 18:36:58
tags: java
categpries: Java
---
Unsafe类，可以用来直接访问系统内存资源、自主管理内存资源

<!-- more -->
## 原理
### 特性

1. 虚拟机“集约化”（VM intrinsification）：如用于无锁Hash表中的CAS（比较和交换）。再比如compareAndSwapInt这个方法用JNI调用，包含了对CAS有特殊引导的本地代码。在这里你能读到更多关于CAS的信息：http://en.wikipedia.org/wiki/Compare-and-swap。
2. 主机虚拟机（译注：主机虚拟机主要用来管理其他虚拟机。而虚拟平台我们看到只有guest VM）的sun.misc.Unsafe功能能够被用于未初始化的对象分配内存（用allocateInstance方法），然后将构造器调用解释为其他方法的调用。
3. 你可以从本地内存地址中追踪到这些数据。使用java.lang.Unsafe类获取内存地址是可能的。而且可以通过unsafe方法直接操作这些变量！
4. 使用allocateMemory方法，内存可以被分配到堆外。例如当allocateDirect方法被调用时DirectByteBuffer构造器内部会使用allocateMemory。
5. arrayBaseOffset和arrayIndexScale方法可以被用于开发arraylets，一种用来将大数组分解为小对象、限制扫描的实时消耗或者在大对象上做更新和移动。

### API
1. 内存操作
	> 例如：堆外内存操作`DirectByteBuffer`
2. CAS操作
	> 例如：atomic原子类；AQS类；ConcurrentHashMap类
3. Class类：
4. 对象操作：对象成员属性操作；非常规的对象实例化方式
5. 线程调度：挂起、唤醒
	> 例如：LockSupport.park()/unpark()
6. 系统信息获取：系统指针大小；内存页大小
	> 例如：java.nio.Bits使用pageSize计算内存页
7. 内存屏障：jdk1.8引入，用来避免重排序
	> 例如：java.util.concurrent.locks.StampedLock改进版读写锁实现
8. 数组操作：
	> AtomicINtegerArray类使用`arrayBaseOffset和arrayIndexScale`来定位元素

## 使用
Unsafe类通过Bootstrap ClassLoader加载，有诸多限制。使用有两种方法。

### 使用命令行实现
调用Unsafe类使用Application ClassLoader加载，要想使用Unsafe类，需要使用Boostrap类加载器加载。

**注意：**(分隔符与classpath参数类似，unix使用:号,windows使用;号，这里以unix为例)

``` 
 java -Xbootclasspath/a:/usrhome/thirdlib.jar: -jar yourJarExe.jar
```















