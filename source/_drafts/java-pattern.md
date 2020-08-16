---
title: java--范型
date: 2018-12-26 00:57:06
tags: Java
categpries: Java
---
范型是一种语法糖，

<!-- more -->

### 范型擦除
范型只在编译阶段有效，在生成字节码后类型会被擦除。范型可以用在范型类、范型接口、范型方法

### 范型标识

1. E - Element (在集合中使用，因为集合中存放的是元素)，E是对各方法中的泛型类型进行限制，以保证同一个对象调用不同的方法时，操作的类型必定是相同的。E可以用其它任意字母代替
2. T - Type（Java 类），T代表在调用时的指定类型。会进行类型推断
3. K - Key（键）
4. V - Value（值）
5. N - Number（数值类型）
6. ？ -  表示不确定的java类型，是类型通配符，代表所有类型。？不会进行类型推断

### 通配符，范型上下边界
<?>

<? extends T>

<? super T>

### 范型数组
注意：** 不能创建一个确定类型的范型数组 **

例如：
```
List<String>[] ls = new ArrayList<String>[10];  // 错误
List<?>[] ls = new ArrayList<?>[10];  // 正确
List<String>[] ls = new ArrayList[10];  // 正确
```

### 静态方法和范型

```
public static <T> void test(T t) {
}
```
