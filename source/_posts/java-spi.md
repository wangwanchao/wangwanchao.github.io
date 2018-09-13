---
title: java中spi机制
date: 2018-09-07 23:35:22
tags: java
categories: java
---
今天阅读dubbo源码的时候，看到SPI机制，咦？Java还有这种机制...瞬间觉得自己太弱鸡了...现在补课中

## SPI机制 ##

定义一个通用的接口，不同的场景可以针对该接口做出不同的实现。同时需要在classpath下的META-INF/services目录下创建接口全路径对应的文件，文件的内容就是接口的实现类。

<!-- more -->

## SPI的实现原理 ##

SPI机制的实现主要是通过java.util.ServiceLoader实现的，在遍历的时候
	
	public final class ServiceLoader<S>
    implements Iterable<S>{

    private static final String PREFIX = "META-INF/services/";

    // The class or interface representing the service being loaded
    private Class<S> service;

    // The class loader used to locate, load, and instantiate providers
    private ClassLoader loader;

    // Cached providers, in instantiation order
    private LinkedHashMap<String,S> providers = new LinkedHashMap<>();

    // The current lazy-lookup iterator
    private LazyIterator lookupIterator;
	
	......

	private class LazyIterator
        implements Iterator<S>
    {

        Class<S> service;
        ClassLoader loader;
        Enumeration<URL> configs = null;
        Iterator<String> pending = null;
        String nextName = null;

        private LazyIterator(Class<S> service, ClassLoader loader) {
            this.service = service;
            this.loader = loader;
        }

        public boolean hasNext() {
            if (nextName != null) {
                return true;
            }
            if (configs == null) {
                try {
                    String fullName = PREFIX + service.getName();
                    if (loader == null)
                        configs = ClassLoader.getSystemResources(fullName);
                    else
                        configs = loader.getResources(fullName);
                } catch (IOException x) {
                    fail(service, "Error locating configuration files", x);
                }
            }
            while ((pending == null) || !pending.hasNext()) {
                if (!configs.hasMoreElements()) {
                    return false;
                }
                pending = parse(service, configs.nextElement());
            }
            nextName = pending.next();
            return true;
        }

        public S next() {
            if (!hasNext()) {
                throw new NoSuchElementException();
            }
            String cn = nextName;
            nextName = null;
            Class<?> c = null;
            try {
                c = Class.forName(cn, false, loader);
            } catch (ClassNotFoundException x) {
                fail(service,
                     "Provider " + cn + " not found");
            }
            if (!service.isAssignableFrom(c)) {
                fail(service,
                     "Provider " + cn  + " not a subtype");
            }
            try {
                S p = service.cast(c.newInstance());
                providers.put(cn, p);
                return p;
            } catch (Throwable x) {
                fail(service,
                     "Provider " + cn + " could not be instantiated",
                     x);
            }
            throw new Error();          // This cannot happen
        }

        public void remove() {
            throw new UnsupportedOperationException();
        }

    }


## SPI机制的应用 ##

1、典型的JDBC应用

jdk定义了java.sql.Driver接口，java.sql.DriverManager通过调用ServiceLoader实例化所有的Driver接口的实现类。

2、Dubbo框架

dubbo框架META-INF/dubbo.internal文件夹下有很多的文件，例如：com.alibaba.dubbo.rpc.Protocol，打开文件

	filter=com.alibaba.dubbo.rpc.protocol.ProtocolFilterWrapper
	listener=com.alibaba.dubbo.rpc.protocol.ProtocolListenerWrapper
	mock=com.alibaba.dubbo.rpc.support.MockProtocol
	dubbo=com.alibaba.dubbo.rpc.protocol.dubbo.DubboProtocol
	injvm=com.alibaba.dubbo.rpc.protocol.injvm.InjvmProtocol
	rmi=com.alibaba.dubbo.rpc.protocol.rmi.RmiProtocol
	hessian=com.alibaba.dubbo.rpc.protocol.hessian.HessianProtocol
	com.alibaba.dubbo.rpc.protocol.http.HttpProtocol
	com.alibaba.dubbo.rpc.protocol.webservice.WebServiceProtocol
	thrift=com.alibaba.dubbo.rpc.protocol.thrift.ThriftProtocol
	memcached=com.alibaba.dubbo.rpc.protocol.memcached.MemcachedProtocol
	redis=com.alibaba.dubbo.rpc.protocol.redis.RedisProtocol
	rest=com.alibaba.dubbo.rpc.protocol.rest.RestProtocol
	registry=com.alibaba.dubbo.registry.integration.RegistryProtocol
	qos=com.alibaba.dubbo.qos.protocol.QosProtocolWrapper

可以看到是对协议的不同实现