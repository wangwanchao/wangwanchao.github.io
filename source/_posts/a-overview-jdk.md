---
title: jdk版本特性概览(一)
date: 2018-10-17 00:21:01
tags: java,jdk
categories: Java
---
目前jdk已经升级到jdk12，大多还停留在jdk6/7/8上，jdk的快速迭代，让人非常兴奋，下面大致罗列一下jdk的新特性：

<!-- more -->
## jdk8 ##
[OpenJDK1.8下载](https://jdk.java.net/java-se-ri/8)
<!--[OracleJDK8文档]()
-->

特性表详细的list没有找到，自己手动整理了一下
### Lambda表达式和Functional接口

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

### 编译器新特性

	通过'-parameters'参数可以将方法参数名添加到字节码

### 类库的新特性
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
	HashMap：链表 + 红黑树
	ConcurrentHashMap：采用了CAS算法

### Java工具
1. Norshorn引擎 jjs
2. 类依赖分析器 jdeps：可以用来分析'.class'、目录、jar

### JVM新特性
1. PermGen空间被Metaspace取代，
		
		-XX:PermSize      -XX:MetaSpaceSize
		-XX:MaxPermSize   -XX:MaxMetaspaceSize
		
### 安全性

### IO/NIO改进
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
**注意：**官网明确表明，jdk9已经不被支持，用户可以切到jdk10

### 新特性
> 102: Process API Updates
> 110: HTTP 2 Client: HTTP/2 用于替换'HttpURLConnection'
> 143: Improve Contended Locking: 锁争用机制
> 158: Unified JVM Logging
> 165: Compiler Control: 编译控制
> 193: Variable Handles: 操作变量
> 197: Segmented Code Cache: 代码分段缓存
> 199: Smart Java Compilation, Phase Two: 更智能的Java编译器
> 200: The Modular JDK
> 201: Modular Source Code
> 211: Elide Deprecation Warnings on Import Statements
> 212: Resolve Lint and Doclint Warnings
> 213: Milling Project Coin
> 214: Remove GC Combinations Deprecated in JDK 8
> 215: Tiered Attribution for javac
> 216: Process Import Statements Correctly
> 217: Annotations Pipeline 2.0: 注解2.0
> 219: Datagram Transport Layer Security (DTLS)
> 220: Modular Run-Time Images
> 221: Simplified Doclet API
> 222: 增加jshell(Read-Eval-Print Loop)REPL交互
> 223: New Version-String Scheme: 
> 224: HTML5 Javadoc
> 225: Javadoc Search
> 226: UTF-8 Property Files
> 227: Unicode 7.0
> 228: Add More Diagnostic Commands
> 229: Create PKCS12 Keystores by Default
> 231: Remove Launch-Time JRE Version Selection
> 232: Improve Secure Application Performance
> 233: Generate Run-Time Compiler Tests Automatically
> 235: Test Class-File Attributes Generated by javac
> 236: JS解析API
> 237: Linux/AArch64 Port
> 238: Multi-Release JAR Files: 多版本的jars
> 240: 移除JVM TI hprof Agent
> 241: 移除jhat工具
> 243: Java-Level JVM Compiler Interface
> 244: TLS Application-Layer Protocol Negotiation Extension
> 245: Validate JVM Command-Line Flag Arguments
> 246: Leverage CPU Instructions for GHASH and RSA
> 247: Compile for Older Platform Versions
> 248: 默认G1为垃圾收集器
> 249: OCSP Stapling for TLS
> 250: Store Interned Strings in CDS Archives
> 251: Multi-Resolution Images
> 252: Use CLDR Locale Data by Default
> 253: Prepare JavaFX UI Controls & CSS APIs for Modularization
> 254: Compact Strings: 压缩字符串
> 255: Merge Selected Xerces 2.11.0 Updates into JAXP
> 256: BeanInfo Annotations
> 257: Update JavaFX/Media to Newer Version of GStreamer
> 258: HarfBuzz Font-Layout Engine
> 259: 栈跟踪API
> 260: Encapsulate Most Internal APIs
> 261: 模块化
> 262: TIFF Image I/O
> 263: HiDPI Graphics on Windows and Linux
> 264: Platform Logging API and Service
> 265: Marlin Graphics Renderer
> 266: More Concurrency Updates
> 267: 支持Unicode 8.0
> 268: XML Catalogs
> 269: Convenience Factory Methods for Collections
> 270: Reserved Stack Areas for Critical Sections
> 271: 统一GC日志
> 272: Platform-Specific Desktop Features
> 273: DRBG-Based SecureRandom Implementations
> 274: Enhanced Method Handles
> 275: Modular Java Application Packaging
> 276: Dynamic Linking of Language-Defined Object Models
> 277: Enhanced Deprecation
> 278: Additional Tests for Humongous Objects in G1
> 279: Improve Test-Failure Troubleshooting
> 280: Indify String Concatenation
> 281: HotSpot C++ Unit-Test Framework
> 282: Java链接jlink
> 283: Enable GTK 3 on Linux
> 284: New HotSpot Build System
> 285: Spin-Wait Hints
> 287: SHA-3 Hash Algorithms
> 288: Disable SHA-1 Certificates
> 289: 废除了Applet API
> 290: Filter Incoming Serialization Data
> 291: 放弃Concurrent Mark Sweep (CMS)垃圾收集器
> 292: Implement Selected ECMAScript 6 Features in Nashorn
> 294: Linux/s390x Port
> 295: Ahead-of-Time (AOT)编译
> 297: Unified arm32/arm64 Port
> 298: 移除Demos和Samples代码
> 299: Reorganize Documentation


## jdk10 ##
[OpenJDK10文档](https://openjdk.java.net/projects/jdk/10/)

[OracleJDK下载](https://www.oracle.com/technetwork/java/javase/downloads/jdk10-downloads-4416644.html)

### 新特性 ###
> 286: Local-Variable Type Inference: 
> 296: 合并JDK到一个仓库
> 304: Garbage-Collector Interface
> 307: G1支持并行Full GC
> 310: 程序类数据共享
> 312: Thread-Local Handshakes: 握手操作是一个回调操作，当线程处于一个安全状态时被调用，目前支持x64平台，可以使用`-XX:ThreadLocalHandshakes`选项，默认为true
> 313: 移除javah生成工具
> 314: Additional Unicode Language-Tag Extensions
> 316: 堆分配在可以选择内存设备：有些系统提供non-DRAM内存，例如：NTFS DAX模式、ext4 DAX模式，这种模式提供了一种映射到物理内存的虚拟内存直接映射。可使用`-XX:AllocateHeapAt=<path>`选项配置，`-Xmx, -Xms`等其他参数正常工作，注意：1.确保该文件的权限，2.当应用终止时移除该文件
> 317: 基于Java的JIT编译器(实验阶段)
> 319: 根证书
> 322: Time-Based Release Versioning

## jdk11 ##

继jdk8后的大版本LTS

[OpenJDK11下载](https://jdk.java.net/java-se-ri/11)

[OpenJDK11文档](https://openjdk.java.net/projects/jdk/11/)

[OracleJDK下载](https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html)

[Oracle文档](https://docs.oracle.com/en/java/javase/11/)

### 新特性 ###

>181: Nest-Based Access Control
>309: Dynamic Class-File Constants: 动态的类文件常量
>315: Improve Aarch64 Intrinsics
>318: Epsilon: 一个空操作收集器
>320: 移除了JavaEE和CORBA模块
>321: HTTP Client (标准)
>323: Local-Variable Syntax for Lambda Parameters
>324: 支持Curve25519和Curve448的key协议
>327: 支持Unicode 10
>328: 飞行记录器JFR
>329: ChaCha20 and Poly1305 xx20和Poly1305加密算法
>330: Launch Single-File Source-Code Programs
>331: Low-Overhead Heap Profiling: 低开销的堆分配采样
>332: TLS升级为1.3
>333: ZGC(实验阶段): 可扩展低延时的垃圾收集器
>335: 废除了JS解析器Nashorn
>336: 弃用Pack200工具类和API

## jdk12 ##
jdk12发布了，jdk20还会远吗?

[OpenJDK下载](https://jdk.java.net/12/)

[OpenJDK12文档](https://openjdk.java.net/projects/jdk/12/)

[OracleJDK12下载](https://www.oracle.com/technetwork/java/javase/downloads/jdk12-downloads-5295953.html)

[OracleJDK12文档](https://docs.oracle.com/en/java/javase/12/)

### 新特性 ###

>189:	Shenandoah(实验阶段): 低停顿的垃圾收集器
>230:	Microbenchmark Suite
>325:	Switch语法
>334:	JVM Constants API
>340:	One AArch64 Port, Not Two
>341:	Default CDS Archives
>344:	G1实现可中止的Mixed GC：如果G1发现collection set重复尝试选择的region数量错误，就会选择一种增量的方式：把collection set分成两部分(强制的、可选择的)。G1回收强制性部分后，如果还有时间就开始以一种更细粒度回收可选择性部分，粒度3取决于时间，更多是一次一个region。当预测足够准确后，可选择部分就会越来越小，直到collection set全部变成强制性。当预测不精确后，下次会重新分成两部分
>346:	Promptly Return Unused Committed Memory from G1


## JDK13

### 新特性 ###
>350:	Dynamic CDS Archives
>351:	ZGC: Uncommit Unused Memory
>353:	重新实现了Socket API
>354:	Switch语法(预览)
>355:	文本块(预览)


## JDK14
[OpenJDK14源码](https://jdk.java.net/java-se-ri/14)

305:	Pattern Matching for instanceof (预览)
343:	Packaging Tool (孵化阶段)
345:	NUMA-Aware Memory Allocation for G1
349:	JFR Event Streaming
352:	Non-Volatile Mapped Byte Buffers
358:	更有用的NullPointerExceptions
359:	Records (Preview)
361:	Switch语法(预览)
362:	废除了对Solaris和SPARC的支持
363:	移除了Concurrent Mark Sweep (CMS)垃圾回收器
364:	ZGC在macOS平台的实现
365:	ZGC在Windows平台的实现
366:	弃用ParallelScavenge + SerialOld GC组合模式
367:	移除Pack200工具类和API
368:	Text Blocks (二次预览)
370:	Foreign-Memory Access API (孵化阶段)