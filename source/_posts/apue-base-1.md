---
title: apue-base-1
date: 2019-09-07 13:53:10
tags:
categpries:
---
编译apue源码

<!-- more -->
## Mac
使用CLion快捷生成，**注意：有些依赖库MacOS不支持**


## CentOS7
内核环境：

	uname -a
	Linux localhost.localdomain 3.10.0-957.27.2.el7.x86_64 #1 SMP Mon Jul 29 17:46:05 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

make编译报错：

1、错误一 

```
gcc -ansi -I../include -Wall -DLINUX -D_GNU_SOURCE  barrier.c -o barrier  -L../lib -lapue -pthread -lrt -lbsd
/tmp/ccGw8KOc.o：在函数‘thr_fn’中：
barrier.c:(.text+0x80)：对‘heapsort’未定义的引用
collect2: 错误：ld 返回 1
make[1]: *** [barrier] 错误 1
make[1]: 离开目录“/usr/local/apue.3e/threads”
make: *** [all] 错误 1
```

解决：安装libbsd、libbsd-devel依赖

2、cmake-make编译整个项目报错 添加CMakeLists.txt编译报错

```
/usr/local/apue.3e/exercises/fmemopen.c: 在函数‘fmemopen’中:
/usr/local/apue.3e/exercises/fmemopen.c:86:2: 警告：隐式声明函数‘funopen’ [-Wimplicit-function-declaration]
  fp = funopen(ms, mstream_read, mstream_write,
  ^
/usr/local/apue.3e/exercises/fmemopen.c:86:5: 警告：赋值时将整数赋给指针，未作类型转换 [默认启用]
  fp = funopen(ms, mstream_read, mstream_write,
     ^
/usr/local/apue.3e/exercises/fmemopen.c: 在函数‘mstream_seek’中:
/usr/local/apue.3e/exercises/fmemopen.c:214:7: 错误：将‘fpos_t’赋值给‘int’时类型不兼容
   off = pos;
       ^
/usr/local/apue.3e/exercises/fmemopen.c:217:19: 错误：双目运算符 + 操作数(‘size_t’和‘fpos_t’)无效
   off = ms->vsize + pos;
                   ^
/usr/local/apue.3e/exercises/fmemopen.c:220:20: 错误：双目运算符 + 操作数(‘size_t’和‘fpos_t’)无效
   off = ms->curpos + pos;
                    ^
/usr/local/apue.3e/exercises/fmemopen.c:225:3: 错误：将‘int’返回为‘fpos_t’时类型不兼容
   return -1;
   ^
/usr/local/apue.3e/exercises/fmemopen.c:228:2: 错误：将‘int’返回为‘fpos_t’时类型不兼容
  return(off);
  ^
make[2]: *** [CMakeFiles/apue_3e.dir/exercises/fmemopen.c.o] 错误 1
make[1]: *** [CMakeFiles/apue_3e.dir/all] 错误 2
make: *** [all] 错误 2
```

3、单独编译源文件文件报错

1）make正常编译，个别文件编译出错
2）使用gcc timeout.c单独编译报错

```
gcc timeout.c
/tmp/ccGYU7T4.o：在函数‘timeout’中：
timeout.c:(.text+0x168)：对‘makethread’未定义的引用
/tmp/ccGYU7T4.o：在函数‘main’中：
timeout.c:(.text+0x1c0)：对‘pthread_mutexattr_init’未定义的引用
timeout.c:(.text+0x1dd)：对‘err_exit’未定义的引用
timeout.c:(.text+0x1ec)：对‘pthread_mutexattr_settype’未定义的引用
timeout.c:(.text+0x209)：对‘err_exit’未定义的引用
timeout.c:(.text+0x235)：对‘err_exit’未定义的引用
collect2: 错误：ld 返回 1
```

缺少依赖文件，手动添加`#include "./detach.c"`。增加
