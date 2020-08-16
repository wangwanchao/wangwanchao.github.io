---
title: java序列化Serializable
date: 2018-12-25 11:16:12
tags: Java
categpries: Java
---
类要实例化必须实现Serializable接口，类的序列化/反序列化通过serialVersionUID唯一确认，当没有显式设置时，系统会默认生成一个，同一个类每次实例生成不同的serialVersionUID。

<!-- more -->

## Serializable和Externalizable

序列化类型是String、Array、Enum、Serializable时，则序列化，否则抛出不允许序列化的异常'NotSerializableException'。

```
public interface Externalizable extends java.io.Serializable {

    void writeExternal(ObjectOutput out) throws IOException;

    void readExternal(ObjectInput in) throws IOException, ClassNotFoundException;
}
```

**使用Externalizable接口来进行序列化与反序列化的时候需要开发人员重写 writeExternal()与readExternal()方法。否则所有变量的值都会变成默认值。**

## transient
transient 关键字的作用是控制变量的序列化，在变量声明前加上该关键字，可以阻止该变量被序列化到文件中，在被反序列化后， transient 变量的值被设为初始值，如 int 型的是 0，对象型的是 null。

## 自定义序列化策略

在序列化过程中，如果被序列化的类中定义了writeObject 和 readObject 方法，虚拟机会试图调用对象类里的 writeObject 和 readObject 方法，进行用户自定义的序列化和反序列化。

如果没有这样的方法，则默认调用是 ObjectOutputStream 的 defaultWriteObject 方法以及 ObjectInputStream 的 defaultReadObject 方法。

## serialVersionUID

**注意** 在做兼容性升级时，不要修改serialVersionUID的值。








