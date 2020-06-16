---
title: Go语言基础入门
date: 2018-07-25 14:12:45
tags: 语言, go
categories: Go
---
一段时间不写Go,很多东西都忘了，还是记录一下吧！
## 一、基础入门 ##

`go run hello.go`

行分隔符：一行代表一个语句结束，不需要分号';'，多个语句在一行使用';'，类似于Scala

25个关键字：

break  default	func  interface	 select
case	defer	go	map	struct
chan	else	goto	package	switch
const	fallthrough	if	range	type
continue	for	import	return	var

<!-- more -->

36个预定义标识符:

append 	bool 	byte 	cap 	close 	complex 	complex64 	complex128 	uint16
copy 	false 	float32 	float64 	imag 	int 	int8 	int16 	uint32
int32 	int64 	iota 	len 	make 	new 	nil 	panic 	uint64
print 	println 	real 	recover 	string 	true 	uint 	uint8 	uintptr

## 二、数据类型 ##

1、布尔类型

2、数字类型

>uint8 无符号 8 位整型 (0 到 255)
>
>uint16 无符号 16 位整型 (0 到 65535)
>
>uint32 无符号 32 位整型 (0 到 4294967295)
>
>uint64 无符号 64 位整型 (0 到 18446744073709551615)
>
>int8 有符号 8 位整型 (-128 到 127)
>
>int16 有符号 16 位整型 (-32768 到 32767)
>
>int32 有符号 32 位整型 (-2147483648 到 2147483647)
>
>int64 有符号 64 位整型 (-9223372036854775808 到 9223372036854775807)

byte 类似 uint8
rune 类似 int32
uint 32 或 64 位
int 与 uint 一样大小
uintptr 无符号整型，用于存放一个指针

3、字符串类型

4、派生类型：
	(a) 指针类型（Pointer）
	(b) 数组类型
	(c) 结构化类型(struct)
	(d) Channel 类型
	(e) 函数类型
	(f) 切片类型
	(g) 接口类型（interface）
	(h) Map 类型 

## 三、变量与常量 ##

| 数据类型 	| 初始化默认值   |
|-| :-:|
| int 		| 0             |
| float32 	| 0             |
| pointer 	| nil           |


1、var 声明变量

`var identifier type  //声明后若不赋值，则使用默认值

var v_name = value  //不声明类型时，执行类型推断，类似于Scala

v_name := value`

多变量声明：var a, b, c = a1, b1, c1

2、const 声明常量
const可以用于枚举

`const( 

  Unkonwn = 0

  Female = 1

  Male = 2

)
`

常量可以用len(), cap(), unsafe.Sizeof()函数计算表达式的值。常量表达式中，函数必须是内置函数，否则编译不过

`
const(
	a = "abc"
	b = len(a)
)
`

3、**iota 特殊常量**


	
空白标识符'_'用于抛弃值，类似于Scala
	
## 四、 ##
Go语言循环中有：break、continue、goto



## 五、函数 ##

Go语言中全局变量和局部变量可以相同，函数内变量优先考虑

Go函数可以返回多个值，这个比Java好很多

`func swap(x, y string) (string, string){
	return y, x
}`
	
值传递: 值传递是指在调用函数时将实际参数复制一份传递到函数中，这样在函数中如果对参数进行修改，将不会影响到实际参数。

引用传递: 引用传递是指在调用函数时将实际参数的地址传递到函数中，那么在函数中对参数所进行的修改，将影响到实际参数。

**默认情况下，Go 语言使用的是值传递，即在调用过程中不会影响到实际参数。**

函数作为值传递，类似于Scala高阶函数
getSquareRoot := func(x float64) float64 {  //类似于Scala匿名函数
    return math.Sqrt(x)
}

*Go支持匿名函数可以作为闭包，和Scala的闭包有什么区别？*

Go语言中函数不同于方法。一个方法就是一个包含了接受者的函数，接受者可以是命名类型或者结构体类型的一个值或者是一个指针。

**接口类型(interface)**

**方法集**

	
## 六、 ##
1、数组

`
var array [size] arr_type
var array = [5]int{1,2,3,4,5}
`

2、切片：切片是对数组的抽象，数组长度不可变，切片是动态数组
`
var slice [] slice_type
var slice [] slice_type = make([]slice_type, len)
slice := make([]slice_type, len)
`

3、范围range 类似于Java在for-Each，Scala中<-遍历
Go 语言中 range 关键字用于for循环中迭代数组(array)、切片(slice)、通道(channel)或集合(map)的元素。
在数组和切片中它返回元素的索引值，在集合中返回 key-value 对的 key 值。 

4、Map声明后必须make初始化，否则为nil，类似于Java的null

`var cmap map[string]string
cmap = make(map[string]string) `

5、类型转换，不同于Java的向上向下转型

`
var i int = 10
float32(i)
`


结构体：类似于c语言的结构体

结构体指针

## 七、错误处理 ##

Go语言通过内置的错误接口(error)提供了非常简单的错误处理机制。


	
	
	
	
	
	
	
	
	
	
	
	
	