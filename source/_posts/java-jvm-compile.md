---
title: java编译器(五)
date: 2018-09-02 10:31:41
tags: java,jvm
categories: JVM
---
编译器是一门很深入的模块，完全理解需要很深厚的功底，就是所谓的"内功"，例如《编译原理》，回头接着好好撸

<!-- more -->
编译器在Java中根据不同大致分为3部分：

1. 前端编译器：Javac、增量编译器ECJ
2. JIT编译器：HotSpot中的C1(Client Compiler)、C2(Server Compiler)编译器
3. AOT编译器：GNU Compiler for the Java(GCJ)、Excelsior JET

## 静态提前编译 AOT ##

直接把.java文件编译成机器码的过程。例如：GCJ, JET

编译过程：

1. 解析与填充符号表

	> 词法、语法分析
	> 
	> 填充符号表
 
2. 注解处理
 
3. 语义分析与字节码生成

	> 标注检查: 实现方法JavaCompiler.attribute()--sun.tools.javac.comp.Attr/Check类
	> 
	> 数据及控制流分析: JavaCompiler.flow()
	> 解语法糖: 泛型、变长参数、自动装箱/拆箱。实现类com.sun.tools.javac.comp.TransTypes/Lower类
	> 字节码生成: 把以上生成的语法树、符号表转为字节码写到磁盘，同时添加少量代码。实现类com.sun.tools.javac.jvm.Gen/ClassWriter类


## 后端运行时编译 JIT ##

把字节码编译成机器码的过程。例如：C1, C2

HotSpot内置了两个即时编译器： Client Compiler(C1编译器) + Server Compiler(C2编译器)，默认jvm会根据自身版本和系统硬件环境自动选择模式。
默认使用解释器 + 编译器混合模式。

-client: 强制Client模式

-server: 强制Server模式

-Xint: 强制使用解释模式

-Xcomp: 强制使用编译模式


分层编译：

1. 第0层
2. 第1层
3. 第2层

JDK1.7 Server模式下默认开启分层编译。

热点代码：

栈上替换(OSR编译)

热点探测：判断一段代码是不是热点代码，是不是需要即时编译的行为。

> 基于采样的热点探测：周期性的检查各个线程的栈顶
> 
> 基于计数器的热点探测：建立计数器，统计方法的执行次数。

HotSpot采用基于计数器探测，为每个方法准备了:方法调用计数器; 回边计数器

1. 方法调用计数器：统计方法被调用次数

	-XX: CompileThreshold 设置方法被调用次数的阈值	

	-XX: -UseCounterDecay  设置关闭热度衰减

	-XX: CounterHalfLifeTime 设置版帅周期的时间

2. 回边计数器：统计一个方法中循环体代码执行次数

	-XX: BackEdgeThreshold 类似于CompileThreshold

	-XX: OnStackReplacePercentage OSR比率，Client模式和Server下 默认值不同


编译优化：

1. 公共子表达式消除
2. 数组范围检查
3. 方法内联
4. 逃逸分析

### Java编译器和C/C++编译器的对比：

优点：
> 调用频率预测
> 分支频率预测
> 裁剪未被选择的分支












