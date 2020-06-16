---
title: Tomcat--类加载模型(五)
date: 2019-06-16 12:15:30
tags: tomcat
categpries: Servlet
---
tomcat类加载器破坏了jvm的双亲委派机制

<!-- more -->
## 原理

```
package org.apache.catalina.startup;

/**
 * Daemon reference.
 */
private Object catalinaDaemon = null;

ClassLoader commonLoader = null;
ClassLoader catalinaLoader = null;
ClassLoader sharedLoader = null;

private void initClassLoaders() {
    try {
        commonLoader = createClassLoader("common", null);
        if (commonLoader == null) {
            // no config file, default to this loader - we might be in a 'single' env.
            commonLoader = this.getClass().getClassLoader();
        }
        catalinaLoader = createClassLoader("server", commonLoader);
        sharedLoader = createClassLoader("shared", commonLoader);
    } catch (Throwable t) {
        handleThrowable(t);
        log.error("Class loader creation threw exception", t);
        System.exit(1);
    }
}
```
|类加载器|tomcat可见性|webapp可见性|
|-|:-:|:-:|
|commonLoader		|可见|可见|
|catalinaLoader	|可见|不可见|
|sharedLoader		|不可见|可见|
|WebappClassLoader|不可见|只对当前web可见|

## 原因
1. jar类库隔离：tomcat可以部署多个应用，如果引用多个不同版本的jar，类实现不同，所以需要加载不同的jar包
2. jar类库共享：如果jar版本相同，则只加载一份
3. 安全隔离：tomcat自身的类加载器和web应用的类加载器隔离
4. 热加载：jsp修改后不需要重启也可以刷新，这样就需要动态加载jsp文件

