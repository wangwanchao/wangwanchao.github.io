---
title: shell常用命令之awk
date: 2018-08-27 22:01:10
tags: linux, shell
categories: Linux
---
awk同样作为高级命令，需要不断地完善

<!-- more -->
## awk ##

用法：

	awk [POSIX or GNU style options] -f progfile [--] file ...
	
	awk [POSIX or GNU style options] [--] 'program' file ...

选项：

POSIX options:		GNU long options: (standard)

	-f progfile		--file=progfile
	-F fs			--field-separator=fs
	-v var=val		--assign=var=val

Short options:		GNU long options: (extensions)

	-b			--characters-as-bytes
	-c			--traditional
	-C			--copyright
	-d[file]		--dump-variables[=file]
	-e 'program-text'	--source='program-text'
	-E file			--exec=file
	-g			--gen-pot
	-h			--help
	-L [fatal]		--lint[=fatal]
	-n			--non-decimal-data
	-N			--use-lc-numeric
	-O			--optimize
	-p[file]		--profile[=file]
	-P			--posix
	-r			--re-interval
	-S			--sandbox
	-t			--lint-old
	-V			--version

案例：
	
	eg: 找出文件2到5行内容
	awk '{if(NR>=2 && NR <=4) print $5}' nginx.log


#### BEGIN、END模块 ####
	
	eg: 统计用户数量
	awk '{count++;print $0;} END{print "user count is: ", count}' /etc/passwd

命名符：
FS: 定义字段，如：'FS=\n'表示每个字段占据一行
RS: 分隔符变量，如：'RS=""'表示记录分隔符为空白行

	awk 'BEGIN{FS="\n"; RS=""}{print $1","$2","$3}' awk-hello-3.txt 
	
NF: 字段数量 (即列数)
NR: 记录数量（即行数）
OFS: 输出字段分隔符(即$1和$2之间填充OFS)
	
	awk 'BEGIN{FS=":";OFS="#"}{print $1,$2,$3}' awk-hello.txt
	
ORS: 输出记录分隔符(即每次print后打印'\n\n')

	awk 'BEGIN{FS="\n"; RS=""; ORS="\n\n"}{print $1","$2","$3}' awk-hello-2.txt




## gawk、nawk和awk ##

gawk是awk的GPL版

nawk(new awk)是awk的增强版，增加了很多函数







