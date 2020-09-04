---
title: Protobuf Buffers
date: 2020-09-02 22:33:41
tags:
categpries: Protocol Buffers
---
17年在异构系统通信中尝试使用pb作为序列化中间价，最后因为嵌入式系统问题，最后采用了jsonrpc。
首先来一波：
1. pb是什么？what
2. pb用来做什么？for
3. pb解决了什么问题？solve
4. pb的设计原理是什么？design
5. 你自己如何实现pb？practice

1) pb是一个灵活的、高效的、自动化的序列化框架。更小、更快、更简单。(蜜汁自信？可能我还没体会到)

2) 基本上可以说解决了异构的序列化问题

3) 序列化/反序列化文件有几种方式：
1. 使用jdk自带框架序列化。但是它有太多的问题，《Effective Java》中第213条明确指出。而且无法在异构系统之间实现共享数据，例如和C++或Python
2. 你也可以自定义一种方式对数据进行编码成一个字符串，这种方式可能在运行时有一定的性能损耗，但比较适合简单的数据序列化。
3. 序列化为XML。由于XML的可读性，这种方式也很多，在大多数语言中都有相应的开源库，但是XML占用空间，编码/解码需要耗费极大的性能。除此之外，遍历XML DOM树比遍历简单的类属性更复杂。

4) 

5) 
<!-- more -->
Protocol buffers需要安装protoc编译器，重要的是pb支持扩展，即便格式被改变后，仍然可以反序列化旧的格式。
## 简介
流程：
1. 定义`.proto`文件，文件按照proto的语法编写
2. 使用protoc编译器编译`.proto`文件，生成包含setters/getters的文件
3. Java调用pb框架API

### 安装protoc编译器
```
brew install protobuf
```

### 编译文件
```
protoc -I=$SRC_DIR --java_out=$DST_DIR $SRC_DIR/addressbook.proto
```
java_out：指定生成文件路径


## proto语法
proto2和proto3语法不一致，但是在不同的语言中语法一致，例如C++和Java中，最后通过protoc编译器编译为相应的类。

**注意：** pb不支持继承
```
syntax = "proto2";    // 指定语法版本

package tutorial;     // 指定包路径，防止命名冲突，

option java_package = "com.example.tutorial";   // 指定生成Java类路径，如果为定义，则使用package值作为生成路径
option java_outer_classname = "AddressBookProtos";    // 指定包含以下所有类定义的文件，在这里生成的AddressBookProtos会包含以下Person、AddressBook内部类。如果未指定，则使用该文件名的驼峰命名法取代。

message Person {    // 等于一个类，最后会生成Class类
  required string name = 1;     // required表明该字段必须有值，否则认为实例未初始化，创建未实例化的对象会抛出RuntimeException。反序列化一个未初始化对象则抛出IOException
  required int32 id = 2;
  optional string email = 3;    // 该字段可以不设值，如果不设值，则使用默认值。number-0, strings-"", bool-false, 嵌套的message-默认实例/message的原型。

  enum PhoneType {    // 等于枚举类
    MOBILE = 0;
    HOME = 1;
    WORK = 2;
  }

  message PhoneNumber {
    required string number = 1;   
    optional PhoneType type = 2 [default = HOME];  // 使用default定义默认值，
  }

  repeated PhoneNumber phones = 4;    // 表明该字段可以重复任意次数，可以看作一个动态数组
}

message AddressBook {
  repeated Person people = 1;
}
```

### 方法
每个message生成相应类的同时会伴随生成一个Builder类，该类用来创建类实例，其实就是`建造者模式`。message对应类只有getters方法，相应的Builder类则包含setters/getters。生成所有的方法遵守‘驼峰命名法’。
clear(): 每个属性都会有一个clear方法用来对属性清空。
count(): repated字段还有count方法用来计数，setter/getter对指定索引index操作，add()添加单个元素，add()添加集合。其实就是一个List。

### 枚举类/嵌套类


### Message/Builder公共方法
isInitialized(): checks if all the required fields have been set.
toString(): returns a human-readable representation of the message, particularly useful for debugging.
mergeFrom(Message other): (builder only) merges the contents of other into this message, overwriting singular scalar fields, merging composite fields, and concatenating repeated fields.
clear(): (builder only) clears all the fields back to the empty state.

### 序列化/反序列化
byte[] toByteArray();: serializes the message and returns a byte array containing its raw bytes.
static Person parseFrom(byte[] data);: parses a message from the given byte array.
void writeTo(OutputStream output);: serializes the message and writes it to an OutputStream.
static Person parseFrom(InputStream input);: reads and parses a message from an InputStream.

### 扩展pb
在开发过程中，毫无疑问需要扩展``proto`文件，如果新文件需要向后兼容，旧文件需要向前兼容，则在更新的proto文件中需要遵守一些规则：
1. 不能改变任何属性的tag值
2. 不能添加/删除任何required标志字段
3. 可以删除optional/repeated字段
4. 在添加optional/repeated字段时，必须使用新的tag数值，该数值应该是从未出现过的，即使使用该数值的字段已经被删除

## 高级特性
pb已经超越了简单的访问、序列化。一个最关键的特性就是反射，可以遍历message的所有字段、操作value。反射一个非常有用的就是应用可以实现pb message和XML/JSON的相互转换。
发挥你的想象力，pb可以有更广泛的应用场景。

别说了，看了你的文档，我就是犹大！