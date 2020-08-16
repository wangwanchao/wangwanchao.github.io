---
title: java中特殊类Object
date: 2019-06-10 23:21:14
tags: java
categpries: Java
---
Object是所有类的父类。这样的设计便于扩展，类中所有的方法分为final方法、非final方法。非final方法都有明确的“通用约束”，在重写时，需要遵守。

<!-- more -->
Object类方法结构：

<image src="https://impwang.oss-cn-beijing.aliyuncs.com/java/object.png"/>

## equals()、hashCode()
### equals()
约束：
1. 自反性
2. 对称性
3. 传递性
4. 一致性
5. 非空性

不需要重写的场景：

需要重写的场景：

### hashCode()
约束：
> 每个覆盖了equals()方法的类，必须覆盖hashCode()方法
> equals() 相等的对象hashCode()必须相等，但hashCode()相等的对象不一定相等
> 一个好的散列函数为不相等的对象生成不相等的散列码

hashCode的实现原理：
1. 计算单个属性hashCode 
    boolean/Boolean: 
    byte/short/char/int: (int)f
    long：
    float
    double
    对象：递归计算
    数组：遍历数组计算
2. 计算对象hashCode 取一个素数s，一个初始hashCode，计算整个对象所有域的和
hashCode = 素数 * hashCode + hashCode(field)

优化：
1. 如果一个类是不可变的，计算hashCode开销比较大，则可以将hashCode散列在对象内部
2. 如果某种Class类型大多数对象会被用作散列键，在创建实例的时候计算hashCode；否则可以选择“延迟初始化”，知道第一次被调用时初始化

## clone
约定：


1. 使用clone()方法拷贝时，需要实现Cloneable接口，否则抛出`CloneNotSupportedException`异常。改变了Object类中clone方法的protected属性

拷贝构造器：

拷贝工厂：

## finalize
垃圾回收中的应用：

注意事项：
Java语言规范并不保证finalize会被执行。
`System.gc`和`System.runFinalization`方法也无法保证finalize被执行。
使用finalize存在严重的性能损耗。

## wait、notify、notifyAll
原理：
obj.wait(), obj.notify()必须在synchronized(obj)语句块内，wait释放对象锁，线程休眠。notify唤醒线程，但不会马上释放对象锁。synchronized执行结束，自动释放锁后，jvm层在持有wait对象锁的线程中随机选取一线程，赋予对象锁，唤醒线程。

虚假唤醒：

**注意：lost wake up问题** 
> 
1. wait/notify/notify必须在锁对象的synchronized同步块内。 因为这三个方法都是释放锁的，如果没有synchronized先获取锁就调用释放锁会引起异常.
2. java.util.concurrent.locks.Condition类中的await/signal也必须在同步块内


案例：

```

```

### wait/notify的缺点：
1. 线程B通知线程A时，线程A必须在wait调用上等待，否则线程A永远不会被唤醒
2. notify只能唤醒一个线程，而notifyAll则唤醒全部线程

### 改进方案LockSupport:

<image src="https://impwang.oss-cn-beijing.aliyuncs.com/java/LockSupport.png"/>

原理：
LockSupport使用：
park：等待许可，类似于wait
unpark：提供许可，类似于notify
park和unpark之间没有时序问题，最底层通过Posix的mutex、condition实现。

```

```

### 对比
相同点：
1. wait/park都会阻塞线程，释放锁
2. 上层表现机制不一样，系统层面都是通过**中断**实现

不同点：
1. wait/notify/notifyAll针对的是对象，而且notify不能唤醒某个具体线程；LockSupport可以具体到某一个线程
2. 实现原理不同，wait/notify基于；LockSupport底层基于Unsafe.park实现
3. wait完成同步，需要依赖监视器锁；LockSupport可以使用getBlocker监视锁的持有情况


