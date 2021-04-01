---
title: 第零天
date: 2020-12-20 12:47:58
tags:
categpries: OS
---
本文主要介绍环境需要的一些工具，越到后面，发现这些工具越重要，遇到问题可以很好地调试。

<!-- more -->
# 工具

## 编译工具
编译这一块儿可以看看《汇编语言》-王爽，《程序员的自我修养》

### nasm
```
sudo apt-get install nasm
```

### gcc
c语言编译器，该书中的代码运行在32位系统上，64位系统需要跨平台交叉编译。
```
sudo apt-get install gcc g++ gcc-multilib make
```

### ld
```
ld -m
```

-f []: 可以指定elf、elf64、win32、win64不同平台的链接。

**注意：**链接过程中，如果C代码中使用了一些动态库的函数，一定要自己重新实现，内核无法使用系统自带的动态库。例如：mysprintf.c

### gdb
虽然QEMU的monitor也支持调试，但是功能有限。

```
gdb -q
```
尝试界面化启动
```
gdb -tui 
(gdb) layout regs
```


## Qemu
[qemu下载地址](https://www.qemu.org/download/)

QEMU是一款运行模拟器，本质上类似于VMWare、VirtualBox一些软件。

### 命令
```
qemu-system-i386 
```

### QEMU Monitor
可以实现一些gdb的功能。
```
qemu-system-i386 -monitor stdio
```

一些常用的调试命令：
```
info block

gdbserver tcp::12345 # 启动监听端口，也可以直接在qemu启动时监听
info registers
print $eax           # 打印寄存器信息
mouse_move 300 300   # 调试鼠标移动
mouse_button 1       # 调试键盘

```

### Linux安装
中间因为Deepin15.11对qemu的键盘中断支持问题，切换到Ubuntu20.04
#### Deepin系统
apt安装
```
apt-get install qemu
```
编译安装

```
xz -d
tar -xvf
cd $QEMU_HOME
./configure
make -j4
make install
```

#### Ubuntu系统
命令基本和Deepin系统一样

## Bochs
这个我个人用的比较少，不是很熟悉。中间在qemu遇到问题时，用来校验过
```
sudo apt-get install bochs
```
需要配置`.bochsrc`文件
```
bochs -f .bochsrc
```

# 系统镜像

## 制作镜像
### 使用dd命令制作
```
// 空镜像ipl.img
dd if=/dev/zero of=ipl.img bs=512 count=4 conv=notrunc
// ipl.bin输出到ipl.img
dd if=ipl.bin of=ipl.img bs=512 count=4 conv=notrunc
// 追加模式
dd if=haribote.sys of=ipl.img bs=512 count=1 seek=1 conv=notrunc
```

### 使用qemu-img制作

```
qemu-img create -f qcow2 -o backing_file=ipl.bin
```

### 使用Makefile制作

## 启动镜像
```
qemu-system-i386 -s -S
```

-s: 启动GDB端口，默认1234。等于`-gdb tcp:1234`
-S: 加电后CPU挂起 
-kernel: 
-m: 

## 分析镜像
objdump

nm

xxd

hexdump
```
hexdump -C ipl.bin|less
```

gdb
```
gdb q
(gdb) target remote localhost:1234
(gdb) set architecture i8086
(gdb) set disassemble-next-line on
```

