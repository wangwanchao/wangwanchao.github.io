---
title: shell常用命令之sed
date: 2018-08-27 20:32:18
tags: linux, shell
categories: linux
---
sed是一个比较高级的命令，回头再细细整理

## sed ##

用法: sed [选项]... {脚本(如果没有其他脚本)} [输入文件]...

选项：

<!-- more -->

	-n, --quiet, --silent
	             取消自动打印模式空间
	-e 脚本, --expression=脚本
	             添加“脚本”到程序的运行列表
	-f 脚本文件, --file=脚本文件
	             添加“脚本文件”到程序的运行列表
	--follow-symlinks
	             直接修改文件时跟随软链接
	-i[SUFFIX], --in-place[=SUFFIX]
	             edit files in place (makes backup if SUFFIX supplied)
	-c, --copy
	             use copy instead of rename when shuffling files in -i mode
	-b, --binary
	             does nothing; for compatibility with WIN32/CYGWIN/MSDOS/EMX (
	             open files in binary mode (CR+LFs are not treated specially))
	-l N, --line-length=N
	             指定“l”命令的换行期望长度
	--posix
	             关闭所有 GNU 扩展
	-r, --regexp-extended
	             在脚本中使用扩展正则表达式
	-s, --separate
	             将输入文件视为各个独立的文件而不是一个长的连续输入
	-u, --unbuffered
	             从输入文件读取最少的数据，更频繁的刷新输出
	-z, --null-data
	             separate lines by NUL characters
	--help
	             display this help and exit
	--version
	             output version information and exit

命令：

	a    新增， a 的后面可以接字串，而这些字串会在新的一行出现(目前的下一行)～
	c    取代， c 的后面可以接字串，这些字串可以取代 n1,n2 之间的行！
	d    删除，因为是删除啊，所以 d 后面通常不接任何咚咚；
	i    插入， i 的后面可以接字串，而这些字串会在新的一行出现(目前的上一行)；
	p    列印，亦即将某个选择的资料印出。通常 p 会与参数 sed -n 一起运作～
	s    取代，通常这个 s 的动作可以搭配正规表示法！例如 1,20s/old/new/g 
	n    读取下一个输入行, 用下一个命令处理新的行

替换标记：

 	g    表示行内全面替换
	p    表示打印行
	w    表示把行写入一个文件
	x    表示互换模快板中的文本和缓冲区中的文本
	y    表示把一个字符翻译为另外的字符(不用于正则表达式)


常用案例：


## sed中n、N的区别 ##

[sed模式空间](https://www.cnblogs.com/fhefh/archive/2011/11/14/2248942.html)

## sed中N,D,P的使用 ##

[sed中N,D,P组合](http://blog.chinaunix.net/uid-22556372-id-1773472.html)

N: 将当前读入行的下一行读取到当前的模式空间

P: 打印当前模式空间中的第一行

D: 删除当前模式空间中的第一行，重新开始下一次循环

	sed 'N;$!D' num

	sed 'N;P' num

	sed 'N;p' num

	sed 'N;D' num

	sed 'N;d' num

	sed 'N;p;D' num

	

