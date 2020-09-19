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

## 简介
流程：
1. 定义`.proto`文件，文件按照proto的语法编写
2. 使用protoc编译器编译`.proto`文件，生成包含setters/getters的文件
3. Java调用pb框架API

### 安装protoc编译器
### Mac
```
brew install protobuf
```
### Linux
Linux系统下直接下载解压，解压后自动生成一个bin文件夹
```
wget protoc-3.13.0-linux-x86_64.zip
unzip  protoc-3.13.0-linux-x86_64.zip
bin/protoc --version
```

### Windows
win系统和linux一样生成一个包含执行程序的bin文件夹

### 编译文件
```
protoc -I=$SRC_DIR --java_out=$DST_DIR $SRC_DIR/addressbook.proto
```
java_out：指定生成文件的根路径，


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

## 原理
理解pb的编码/序列化原理之前，首先需要理解变长数值`varints`，`varints`使用一个或者多个字节对一个整数序列化，越小的数字使用的字节数越少。
在`varints`中，除了最后一个字节外，每一个字节都有msb set。msb set表明接下来还有多少字节，每一个字节的低7位用来存储'二位补码'。pb默认采用`least significant group first`，其实就是LSB的一个变种(杂种)。

序列化/反序列化的核心规则还是下面这些：

|序列化后类型|占位|实际类型|
|:-:|:-|:-|
|0	|变长|int32, int64, uint32, uint64, sint32, sint64, bool, enum |
|1	|64位/8字节 |	fixed64, sfixed64, double |
|2	|长度界定(需要指定后续字节长度) |	string, bytes, embedded messages, packed repeated fields |
|3	|Start group |	groups (deprecated) |
|4	|End group |	groups (deprecated) |
|5	|32位/4字节 |	fixed32, sfixed32, float |

例如：
1. 单字节
0000 0001 // 数值1，单字节，所以不需要设置msb
2. 多字节
1010 1100 0000 0010 // 数值300？小朋友，你脑子里是否有很多问号？
计算步骤：
1) 首先去除每一个字节的msb位，即第一位。得到：010 1100 000 0010，这时候其实是两个组(010 1100) (000 0010)
2) 根据`least significant group first`规则，得到：000 0010 010 1100，十进制为300

### message
众所众知，message其实就是key-value的键值对，每个key都对应一个数值number。序列化后的二进制对每个key的存储以tag为键，而在`.proto`文件定义的类型、key作为反序列化使用。(一切协议皆是约定，只不过对扩展性、通用性做了封装，才有了好坏之分)。
序列化把所以key-value编码为字节流，反序列化是解析器所以对于增加新的属性后，解析器仍然可以解析旧的编码格式。二进制存储中每个key实际上是`(field_number << 3) | wire_type`，type用来指定value占用的字节数。大多数语言实现中都将这个key称为tag。
例如：
000 1000  //
96 01  // 150

### 有符号整数

### 非变长数值

### 字符串
定义proto，设置对象name="testing"
```
message Person {
  string name = 2;
}
```
writeTo(OutputStream output)方法生成的二进制
```
12 07 74 65 73 74 69 6e 67  // ..testing
```
writeDelimitedTo(OutputStream output)方法生成的二进制
```
09 12 07 74 65 73 74 69 6e 67  // ...testing
```

### 嵌套message
```
message Person {
  string name = 2;

  message Desc {
    int32 a = 1;
  }

  Desc desc = 3;
}
```
只对Person.Desc二进制序列化
```
08 96 01
```
在Person中填充属性对Person序列化
```
12 07 74 65 73 74 69 6e 67 1a 03 08 96 01
```

### optional/repeated元素
增加repeated属性，girl属性添加'test'值
```
message Person {
  string name = 2;

  message Desc {
    int32 a = 1;
  }

  Desc desc = 3;

  repeated string girl = 4;
}
```
序列化后的二进制
```
12 07 74 65 73 74 69 6e 67 1a 03 08 96 01 22 04
74 65 73 74
```

### 字段顺序
id=1，序列化
```
08 12 12 07 74 65 73 74 69 6e 67 1a 03 08 96 01 
22 04 74 65 73 74 
```
修改id=5，序列化
```
12 07 74 65 73 74 69 6e 67 1a 03 08 96 01 22 04
74 65 73 74 28 12
```

## 拓展
MSB(most significant bit)和LSB(least significant bit)的区别是位传输顺序的不同，在二进制表示中，MSB指的是最左端的最高位，LSB指的是左右端的最低位。在并行接口传输中，传输端-接收端没有问题，但是在串行接口中，数据的传输需要保持有序，就需要确定传输的顺序。`MSB first`从最高位开始传输
在SRAM架构中，21根地址线(A0-A20)，8根数据线(D0-D7)

### LSB
在电脑运算中，LSB比特位用来标记一个数值是奇数还是偶数。按照'按位计数法'的规定，处于右端，有时候也叫低端位/最右端位。
在数字密码学中，图片、声音等敏感信息，可以通过使用这种LSB的方式计算、存储来达到加密的效果。

应用场景：伪随机数生成、密码工具、哈希函数、校验和
### MSB
在电脑运算中，MSB比特位用来标记一个数值是奇数还是偶数。按照'按位计数法'的规定，处于左端，有时候也叫高端位/最左端位。
在有符号二进制数中，MSB相当于符号位，在1位、二位补码表示法中，1代表负数，0代表正数。
MSB也支持字节，简写`MSbit`和`MSbyte`

Protocol buffers需要安装protoc编译器，重要的是pb支持扩展，即便格式被改变后，仍然可以反序列化旧的格式。

## 高级特性
pb已经超越了简单的访问、序列化。一个最关键的特性就是反射，可以遍历message的所有字段、操作value。反射一个非常有用的就是应用可以实现pb message和XML/JSON的相互转换。
发挥你的想象力，pb可以有更广泛的应用场景。

别说了，看了你的文档，我就是犹大！