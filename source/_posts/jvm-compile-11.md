---
title: Linux环境下编译JDK11(1)
date: 2021-03-20 00:38:17
tags:
categpries: JVM
---
第n次编译jdk，以前的编译功力尚浅，之后没再去探索。这次在编译OS之后对C语言有一些更好的理解，希望能够深入JDK。对比`OpenJDK1.8-`，`OpenJDK11+`简直是简直是easy模式。

<!-- more -->

# 编译源码
理解jdk和hotspot的关系：

## Linux下编译
linux主要分两大分支：
基于apt安装库的分支：Debian, Ubuntu, Deepin
基于rpm安装库的分支：Fedora, Red Hat, CentOS
以下主要基于Deepin系统编译。(不同版本可能会有问题，喜欢Ubuntu的建议Ubuntu)

### 编译jdk

#### 安装依赖包
```
sudo apt-get install build-essential
```
检查依赖工具版本：
```
gcc -v 
clang -v
```
版本需要`gcc 4.8+`，`clang 3.2+`，我的系统为`gcc version 6.3.0`，`clang version 3.8.1-24`

#### 安装Boot JDK
JDK的编译需要依赖于前置版本，否则一些依赖类找不到会报错。`java -version`检查默认JDK的版本，也可以通过`--with-boot-jdk`指定Boot JDK的路径。

#### 安装编译工具
`make -v`检测make版本，我的默认`GNU Make 4.1`。
`bash --version`，`GNU bash，版本 4.4.12`

#### 检测编译依赖环境，同时生成编译脚本(至关重要)
在根目录下`build/linux-x64-normal-server-${BUILD}`，比如编译fastdebug版本，则生成`build/linux-x64-normal-server-fastdebug`包路径。

```
cd $OPENJDK_SRC_HOME
bash configure --enable-debug --with-jvm-variants=server --enable-dtrace
```

自定义编译参数：
`--enable-debug`：指定fastdebug版本，`--with-debug-level=<level>`的简洁版本，level可以是：`release`, `fastdebug`, `slowdebug` or `optimized`。
`--with-native-debug-symbols=<method>`：指定本地方法符号是否被构建。method可以是`none`, `internal`, `external`, `zipped`
`--with-jvm-variants=<variant>[,<variant>...]`：指定hotspot的模式，variant可以是`server`, `client`, `minimal`, `core`, `zero`, `custom`
`--with-target-bits=<bits>`：设置编译32/64位系统，可以减少交叉编译。

本地编译参数：
`--enable-dtrace`：开启debug模式

依赖环境参数：
`--with-boot-jdk=<path>`：

#### 编译
编译可以不指定target，`make`等同于`make default`/`make jdk`。还可以只编译单个模块儿。
核心target主要有以下几个：
* `hotspot` - 只编译hotspot
* `hotspot-<variant>` - Build just the specified jvm variant
* `images` or `product-images` - 编译JDK镜像

```
make JOBS=4 jdk  # 等同于`bash configure --with-jobs=4`
```
可以看到编译后的目录如下：
![编译目录](https://impwang.oss-cn-beijing.aliyuncs.com/java/jdk-build.png)

# hotspot在IDEA下的调试

### 编写测试代码

```
mkdir -p examples/com/wang

vi Test.java

package com.wang;

public class Test {

	public static void main(String[] args) {
		System.out.println("Hello Hotspot");
	}

}

cd examples
javac com/wang/Test.java
```

配置Application
![demo](https://impwang.oss-cn-beijing.aliyuncs.com/java/hotspot-demo.png)

配置lib库
![lib](https://impwang.oss-cn-beijing.aliyuncs.com/java/hotspot-env.png)

开始debug
![debug](https://impwang.oss-cn-beijing.aliyuncs.com/java/hotspot-debug.png)

运行结果
![result](https://impwang.oss-cn-beijing.aliyuncs.com/java/hotspot-result.png)

待续...