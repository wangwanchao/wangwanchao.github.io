---
title: Java中的类加载器
date: 2018-08-07 01:04:31
tags: java
categories: java
---

## 类加载器 ##

1. 启动类加载器
2. 扩展类加载器
3. 应用程序类加载器


## 双亲委派机制 ##

	protected Class<?> loadClass(String name, boolean resolve)
        throws ClassNotFoundException
    {
        synchronized (getClassLoadingLock(name)) {
            // First, check if the class has already been loaded
            Class c = findLoadedClass(name);
            if (c == null) {
                long t0 = System.nanoTime();
                try {
                    if (parent != null) {
                        c = parent.loadClass(name, false);
                    } else {
                        c = findBootstrapClassOrNull(name);
                    }
                } catch (ClassNotFoundException e) {
                    // ClassNotFoundException thrown if class not found
                    // from the non-null parent class loader
                }

                if (c == null) {
                    // If still not found, then invoke findClass in order
                    // to find the class.
                    long t1 = System.nanoTime();
                    c = findClass(name);

                    // this is the defining class loader; record the stats
                    sun.misc.PerfCounter.getParentDelegationTime().addTime(t1 - t0);
                    sun.misc.PerfCounter.getFindClassTime().addElapsedTimeFrom(t1);
                    sun.misc.PerfCounter.getFindClasses().increment();
                }
            }
            if (resolve) {
                resolveClass(c);
            }
            return c;
        }
    }

为什么使用双亲委派机制？


## 3次破坏双亲委派机制 ##

1. 双亲委派机制在JDK1.2的时候才引入，为了向前兼容，java.lang.ClassLoader添加了一个protected方法findClass()
2. 机制设计缺陷。JDK1.3增加了JNDI服务，需要类加载器去读取Class Path下的接口代码，由于启动类加载器无法实现，增加了"线程上下文类加载器"
3. 追求代码的灵活性导致的问题，例如：代码热替换(HotSwap)、模块热部署(OSGi、JDK1.9的模块化)

