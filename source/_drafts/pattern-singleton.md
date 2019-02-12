---
title: 单例模式
tags: Pattern
categories: Pattern
---

##单例的不同实现模式
1、饿汉式

```
public class Singleton {   
    private static Singleton = new Singleton();
    private Singleton() {}
    public static getSignleton(){
        return singleton;
    }
}
```
2、单线程

```
public class Singleton {
    private static Singleton singleton = null;
    private Singleton(){}
    public static Singleton getSingleton() {
        if(singleton == null) singleton = new Singleton();
        return singleton;
    }
}
```

3、线程安全

```
public class Singleton {
    private static volatile Singleton singleton = null;
 
    private Singleton(){}
 
    public static Singleton getSingleton(){
        synchronized (Singleton.class){
            if(singleton == null){
                singleton = new Singleton();
            }
        }
        return singleton;
    }    
}
```

4、线程安全 + 效率 增加双重检查

```
public class Singleton {
    private static volatile Singleton singleton = null;
 
    private Singleton(){}
 
    public static Singleton getSingleton(){
        if(singleton == null){
            synchronized (Singleton.class){
                if(singleton == null){
                    singleton = new Singleton();
                }
            }
        }
        return singleton;
    }    
}
```

5、静态内部类

```
public class Singleton {
    private static class Holder {
        private static Singleton singleton = new Singleton();
    }
 
    private Singleton(){}
 
    public static Singleton getSingleton(){
        return Holder.singleton;
    }
}

```

6、枚举实现

```
public enum Singleton {
    INSTANCE;
    private String name;
    public String getName(){
        return name;
    }
    public void setName(String name){
        this.name = name;
    }
}
```

## 设计模式被破坏的情景

1. 通过反射
2. 通过序列化/反序列化
