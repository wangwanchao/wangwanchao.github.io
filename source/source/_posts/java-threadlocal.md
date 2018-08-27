---
title: Threadlocal原理分析
date: 2018-08-11 10:16:46
tags: java, threadlocal
categories: java
---
## ThreadLocal的底层实现 ##

### 主要方法： ###

#### set ####

	public void set(T value) {
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null)
            map.set(this, value);
        else
            createMap(t, value);
    }

<!-- more -->

#### get ####

	public T get() {
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null) {
            ThreadLocalMap.Entry e = map.getEntry(this);
            if (e != null)
                return (T)e.value;
        }
        return setInitialValue();
    }
可以看到先获取当前线程t,然后根据t得到ThreadLocalMap对象，如果map为null则设置初始值。

#### getMap(t) ####

	ThreadLocalMap getMap(Thread t) {
        return t.threadLocals;
    }
从getMap可以看到返回的是当前线程的threadLocals属性。

#### ThreadLocalMap类 ####

	static class ThreadLocalMap {

        static class Entry extends WeakReference<ThreadLocal> {
            /** The value associated with this ThreadLocal. */
            Object value;

            Entry(ThreadLocal k, Object v) {
                super(k);
                value = v;
            }
        }

        private static final int INITIAL_CAPACITY = 16;

        private Entry[] table;
		
		...

        private Entry getEntry(ThreadLocal key) {
            int i = key.threadLocalHashCode & (table.length - 1);
            Entry e = table[i];
            if (e != null && e.get() == key)
                return e;
            else
                return getEntryAfterMiss(key, i, e);
        }

可以看到其实ThreadLocalMap就是HashMap的一个变形。

#### setInitialValue ####

	private T setInitialValue() {
        T value = initialValue();
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null)
            map.set(this, value);
        else
            createMap(t, value);
        return value;
    }

	protected T initialValue() {
        return null;
    }

	void createMap(Thread t, T firstValue) {
        t.threadLocals = new ThreadLocalMap(this, firstValue);
    }
可以看到初始化时，为当前线程t设置了一个key为当前ThreadLocal对象，value为null的threadLocals属性。


## ThreadLocal初始化在堆上还是栈上 ##

## ThreadLocal会导致内存泄漏吗? ##

看到一篇博客讲不会发生内存泄漏，原因是Entry是一个弱引用，如果entry.get()=null，entry会被擦除

	static class ThreadLocalMap {

        /**
         * The entries in this hash map extend WeakReference, using
         * its main ref field as the key (which is always a
         * ThreadLocal object).  Note that null keys (i.e. entry.get()
         * == null) mean that the key is no longer referenced, so the
         * entry can be expunged from table.  Such entries are referred to
         * as "stale entries" in the code that follows.
         */
        static class Entry extends WeakReference<ThreadLocal> {
            /** The value associated with this ThreadLocal. */
            Object value;

            Entry(ThreadLocal k, Object v) {
                super(k);
                value = v;
            }
        }

[技术小黑屋](https://droidyue.com/blog/2016/03/13/learning-threadlocal-in-java/ "技术小黑屋")



## ThreadLocal和InheritableThreadLocal的区别 ##

InheritableThreadLocal会自动将值传递给子线程，也就是说在子线程可以看到父线程的值。

**注意：**为了保护线程安全，应该只对不可变的对象使用InheritableThreadLocal。但不能是有状态的对象，例如JDBC Connection

ThreadLocal

    static final ThreadLocal<Integer> threadLocal = new ThreadLocal();

    public static void main(String[] args){

        threadLocal.set(123);
        System.out.println("父线程获取threadLocal:" + threadLocal.get());

        Thread t = new Thread(){
            @Override
            public void run() {
                super.run();
                System.out.println("设值前：子线程获取threadLocal:" + threadLocal.get());

                threadLocal.set(234);
                System.out.println("设值后：子线程获取threadLocal:" + threadLocal.get());
            }
        };

        t.start();

    }

返回值

	父线程获取threadLocal:123
	设值前：子线程获取threadLocal:null
	设值后：子线程获取threadLocal:234

InheritableThreadLocal

	static final ThreadLocal threadLocal = new InheritableThreadLocal();

    public static void main(String[] args){

        threadLocal.set(123);
        System.out.println("父线程获取threadLocal:" + threadLocal.get());

        Thread t = new Thread(){
            @Override
            public void run() {
                super.run();
                System.out.println("设值前：子线程获取threadLocal:" + threadLocal.get());

                threadLocal.set(234);
                System.out.println("设值后：子线程获取threadLocal:" + threadLocal.get());
            }
        };

        t.start();

    }

返回值

	父线程获取threadLocal:123
	设值前：子线程获取threadLocal:123
	设值后：子线程获取threadLocal:234

### ThreadLocal的应用场景 ###

1.实现单个线程单例以及单个线程上下文信息存储，比如交易id等

2.实现对象线程安全，例如：数据库连接

3.承载一些线程相关的数据，避免在方法中来回传递参数。例如：Session管理

### InheritableThreadLocal的应用场景 ###

1、用户标识

2、事务标识
