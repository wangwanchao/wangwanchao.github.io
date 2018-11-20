---
title: jdk版本特性概览
date: 2018-10-17 00:21:01
tags: Java
categories: Java
---
目前jdk已经升级到jdk11，大多还停留在jdk6/7/8上，jdk的快速迭代，让人非常兴奋，下面大致罗列一下jdk的新特性：

<!-- more -->

## jdk8 ##

### 1. Lambda表达式和Functional接口

1. 接口的默认与静态方法

2. 方法引用：
		
	方法引用

		对象::实例方法名
		类::静态方法名
		类::实例方法名
	
	构造器引用
	
		类::new

	数组引用
	
		Type[]::new
	
3. 重复注解

4. 更好的类型推测机制

5. 扩展注解： ElementType.TYPE_USE、 ElementType.TYPE_PARAMETER；可以为任何代码添加注解(接口、异常)

### 2. 编译器新特性

	通过'-parameters'参数可以将方法参数名添加到字节码

### 3. 类库的新特性

1. Optional：解决空指针异常

```
	Consumer<T>

	Supplier<T>
	
	Function<T, R>
	
	Predicate<T>
	
	Comparator<T>
```

2. Stream：

	filter过滤

	sort排序
	
	map映射
	
	match匹配
	
	reduce规约


3. Date/Time API

	Instant
	
	Clock时钟
	
	Timezones时区
	
	LocalTime/LocalDate/LocalDateTime本地时间
	
	**注意：**和java.text.SimpleDateFormat不同的是，DateTimeFormatter是不可变的，所以它是线程安全的。

4. Base64：Base64编码成为类库标准

5. 并行：parallelSort()、

6. 并发：java.util.concurrent包
	
	> ConcurrentHashMap增加新方法支持聚集
	> ForkJoinPool增加新方法支持共有资源池
	> locks.StampedLock，用来替换locks.ReadWriteLock
	> atomic包下增加DoubleAccumulator、DoubleAdder、LongAccumulator、LongAdder
	
7. 集合

	HashMap

	链表 + 红黑树
	
	ConcurrentHashMap
	
	采用了CAS算法


### 4. Java工具

1. Norshorn引擎 jjs

2. 类依赖分析器 jdeps：可以用来分析'.class'、目录、jar

### 5. JVM新特性

1. PermGen空间被Metaspace取代，
		
		-XX:PermSize      -XX:MetaSpaceSize
		-XX:MaxPermSize   -XX:MaxMetaspaceSize
		
### 6. 安全性

	

### 7. IO/NIO改进

1. 改进java.nio.charset.Charset的实现，精简了 jre/lib/charsets.jar 包；优化了 String(byte[],*) 构造方法和 String.getBytes() 方法的性能
2. 新增API

		BufferedReader.line(): 返回文本行的流 Stream<String>
	
		File.lines(Path, Charset):返回文本行的流 Stream<String>
		
		File.list(Path): 遍历当前目录下的文件和目录
		
		File.walk(Path, int, FileVisitOption): 遍历某一个目录下的所有文件和指定深度的子目录
		
		File.find(Path, int, BiPredicate, FileVisitOption... ): 查找相应的文件

## jdk9 ##

[OpenJDK9](https://openjdk.java.net/projects/jdk9/)

"Java SE 9 has reached end of support. Users of Java SE 9 should switch to Java SE 10."

官网明确表明，jdk9已经不被支持，用户可以切到jdk10

1. 模块化
2. Linking
3. JShell
4. JSON API
5. 金钱和货币API
6. 锁争用机制
7. 代码分段缓存
8. 编译工具 sjavac
9. 接口私有方法
10. HTTP/2 用于替换'HttpURLConnection'
11. 多版本兼容jar
12. Stream API 增加4个新的方法: dropWhile、takeWhile、ofNullable、iterate

## jdk10 ##

[OpenJDK10](https://openjdk.java.net/projects/jdk/10/)

[下载](https://www.oracle.com/technetwork/java/javase/downloads/jdk10-downloads-4416644.html)

### 主要新特性 ###

> 286: Local-Variable Type Inference
> 
> 296: Consolidate the JDK Forest into a Single Repository
> 
> 304: Garbage-Collector Interface
> 
> 307: Parallel Full GC for G1
> 
> 310: Application Class-Data Sharing
> 
> 312: Thread-Local Handshakes
> 
> 313: Remove the Native-Header Generation Tool (javah)
> 
> 314: Additional Unicode Language-Tag Extensions
> 
> 316: Heap Allocation on Alternative Memory Devices
> 
> 317: Experimental Java-Based JIT Compiler
> 
> 319: Root Certificates
> 
> 322: Time-Based Release Versioning

### 1. 类库API 73项 ###

### 2. JVM规范改动 ###


### 3. Java语言规范 ###


### 4. 乱七八糟 ###


## jdk11 ##

继jdk8后的大版本LTS

[Oracle JDK下载](https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html)

[OpenJDk11](https://openjdk.java.net/projects/jdk/11/)

[文档](https://docs.oracle.com/en/java/javase/11/)

既然都到了JDK11，那就跟着英文文档来一波吧！

### 主要新特性 ###

>181: Nest-Based Access Control
>
>309: Dynamic Class-File Constants
>
>315: Improve Aarch64 Intrinsics
>
>318: Epsilon: A No-Op Garbage Collector
>
>320: Remove the Java EE and CORBA Modules
>
>321: HTTP Client (Standard)
>
>323: Local-Variable Syntax for Lambda Parameters
>
>324: Key Agreement with Curve25519 and Curve448
>
>327: Unicode 10
>
>328: Flight Recorder
>
>329: ChaCha20 and Poly1305 Cryptographic Algorithms
>
>330: Launch Single-File Source-Code Programs
>
>331: Low-Overhead Heap Profiling
>
>332: Transport Layer Security (TLS) 1.3
>
>333: ZGC: A Scalable Low-Latency Garbage Collector
> (Experimental)
>
>335: Deprecate the Nashorn JavaScript Engine
>
>336: Deprecate the Pack200 Tools and API