---
title: Scala基础入门
date: 2018-05-13 06:48:37
tags: Scala, 函数式编程
---
与Scala大约是三年之前，在一本《程序员面试宝典》看到，2016年买了《Scala快速入门》，感觉好繁琐，后来慢慢放下，去年接触到Apache Apollo，是一个MQTT的代理服务器开源软件(貌似是2007年发布的，就没有更新过)。最近突然想要捡起来

学习新语言语法最快的途径就是打开[菜鸟教程网](http://www.runoob.com/scala/scala-tutorial.html "菜鸟教程Scala")跟着敲一遍，以下内容权当记录：

<!-- more -->

#### 一、基础语法：
> 区分大小写 -  Scala是大小写敏感的，这意味着标识Hello 和 hello在Scala中会有不同的含义。

>类名 - 对于所有的类名的第一个字母要大写。

>如果需要使用几个单词来构成一个类的名称，每个单词的第一个字母要大写。示例：class MyFirstScalaClass

>方法名称 - 所有的方法名称的第一个字母用小写。

>如果若干单词被用于构成方法的名称，则每个单词的第一个字母应大写。示例：def myMethodName()

>程序文件名 - 程序文件的名称应该与对象名称(object)完全匹配。

>保存文件时，应该保存它使用的对象名称（记住Scala是区分大小写），并追加".scala"为文件扩展名。 （如果文件名和对象名称不匹配，程序将无法编译）。

>def main(args: Array[String]) - Scala程序从main()方法开始处理，这是每一个Scala程序的强制程序入口部分。(类似于Java)

#### 二、标识符
>避免使用$开头的标识符

>避免使用下划线结尾的标识符

**混合标识符**：例如unary_+

**字面标识符**：例如`x``yield`

***在Scala中不能使用Thread.yield(),必须使用Thread.`yield`();***

#### 三、包
定义包
引用包，import语句可以出现在任何地方，而不只是文件顶部

引入包内所有成员：import java.awt._

重命名成员：import java.util.{HashMap => JavaHashMap}

隐藏成员：import java.util.{HashMap => _, _}

***默认情况下，Scala 总会引入 java.lang._ 、 scala._ 和 Predef._，这里也能解释，为什么以scala开头的包，在使用时都是省去scala.的。***


#### 四、数据类型

Unit
Null
Nothing
Any
AnyRef

符号字面量
字符字面量 'wangsir'
字符串字面量 "Hello World!"
多行字符串
	val foo = """ Hello
		World!
		Scala
	"""

#### 五、变量
var 声明变量

val 声明常量

变量不一定要声明类型，会有类型推断; 但是如果声明类型，必须初始化。

声明多个变量 val xmax, ymax = 100 //xmax=ymax=100
声明元组 val person = ("wangsir", 27)

#### 六、访问修饰符
> private：比Java更严格，在嵌套类情况下，外部类甚至不能访问嵌套类的私有成员

> protected：比Java更严格，只允许在该类的子类中被访问

> public：和Java不同，Scala默认访问为public

作用域保护：private[x] protected[x]


#### 七、
Scala不支持break或continue语句，但是2.8版本后提供了一种中断循环

1、字符串
Scala本身没有String类，所以Scala中的String类实际上是Java String

	API：str1.concat(str2)

2、数组:
var z:Array[String] = new Array[String](3)
var z = new Array[String](3)
var z = Array("","","")
区间数组：var z = range(10, 20, 2)

for(a <- array)
for(i <- 0 to (array.length-1))

3、集合(类似于Java、Python)

List:

Set:

Map:

元组: var x = (10, "")

Option:Option有两个子类(Some、None) var x:Option[Int] = Some(5)

Iterator:

4、模式匹配，类似于Java中的switch
x match {case Any => Any}

#### 八、函数
**函数传名调用**：传名调用，传值调用

**内嵌函数**

**偏应用函数**

递归函数

**高阶函数**：允许使用其他函数作为参数/返回值 def f1(f2(), arg) = f2();

**匿名函数**：
`var inc = (x:Int) => x+1; var print = () => {System.getProperty("")}`

**函数柯里化**

闭包**：


#### 九、对象、类、特征
1、继承
  > 1、重写一个非抽象方法必须使用override修饰符。
  > 
  > 2、只有主构造函数才可以往基类的构造函数里写参数。
  > 
  > 3、在子类中重写超类的抽象方法时，你不需要使用override关键字。

***Scala没有static***

Scala定义单利模式时，需要在同一个源文件中定义一个类(伴生类)，和一个同名的object对象(伴生对象),类和对象可以互相访问其私有成员

2、特征：相当于Java的接口，不同的是特征可以定义属性和方法的实现，所以更像Java的抽象类
特征也有构造器

构造器的执行顺序：
> 调用超类的构造器；
> 
>特征构造器在超类构造器之后、类构造器之前执行；
>
>特征由左到右被构造；
>
>每个特征当中，父特征先被构造；
>
>如果多个特征共有一个父特征，父特征不会被重复构造
>
>所有特征被构造完毕，子类被构造。

3、样例类，用于模式匹配

`case class Person(name: String, age: Int)`

在声明样例类时，下面的过程自动发生了：
>构造器的每个参数都成为val，除非显式被声明为var，但是并不推荐这么做；
>
>在伴生对象中提供了apply方法，所以可以不使用new关键字就可构建对象；
>
>提供unapply方法使模式匹配可以工作；
>
>生成toString、equals、hashCode和copy方法，除非显示给出这些方法的定义。

4、提取器：从传递的对象中提出构造该对象的参数
apply
unapply



#### 十、异常
和Java类似

#### 十一、web框架
Lift框架
Play框架