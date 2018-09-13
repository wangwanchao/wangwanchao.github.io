---
title: shell常用命令之grep
date: 2018-08-27 19:38:31
tags: linux, shell
categories: linux
---
一些常用的shell命令、参数还是需要整理一下，以防每次都要去查询

## 正则表达式 ##

### 基本的正则表达式： ### 

1. 元字符： 

<!-- more -->

	'.':匹配任意单个字符 
	
		eg：查找包含student且student后面带一个字符的行 
		grep ‘student.’ /etc/passwd （模式可以用单引号和双引号，如果模式中要做变量替换时则必须用双引）      
	
	'[]':匹配指定范围内的任意单个字符,[abc],[a-z],[0-9],[a-zA-Z] 
	
		eg：查找带有数字的行 
		grep ‘[0-9]’ /etc/passwd 
	
	'[^]':匹配指定范围外的任意单个字符 
	
	    eg：查找没有小写字母的行。 
	    grep ‘[^a-z]’ /etc/inittab 
	
	[:space:]:表示空白字符 
	
	[:punct:]:表示所有标点符号的集合 
	
	[:lower:]:表示所有的小写字母 
	
	[:upper:]:表示所有的大写字母 
	
	[:alpha:]:表示大小写字母 
	
	[:digit:]:表示数子 
	
	[:alnum:]:表示数字和大小写字母-----使用格式[[:alnum:]]等 

2. 次数匹配： 

	'*':匹配其前面的字符任意次 
	
		eg：查找root出现0次或0次以上的行 
		grep ‘root*’ /etc/passwd 
	
	'.*':任意字符  
	
		eg：查找包含root的行 
		grep 'root.*' /etc/passwd 
	
	'\?'：匹配其前面的字符1次或0次 
	
	'\{m,n\}':匹配其前字符最少m，最多n次） 

3. 字符锚定： 

    '^':锚定行首，此字符后面的任意内容必须出现在行首 

        eg：查找行首以#开头的行 
        grep '^#' /etc/inittab 

    '$':锚定行尾，此字符前面的任意内容必须出现在行尾 

        eg：查找行首以root结尾的行 

        grep 'root$' /etc/inittab   

    '^$':锚定空白行，可以统计空白行 

    '\<或者\b':锚定词首，其后面的任意字符必须做为单词首部出现 

	    eg:查找root且root前面不包含任何字符的行 
	    grep '\<root' /etc/man.config 

    '\>或者\b':锚定词尾，其前面的任意字符必须做为单词尾部出现                         

		eg：\<root\> 查找root单词  
		grep "\<root\>" =grep "\broot\b" 


### 扩展的正则表达式:

扩展的正则表达只是在基本的正则表达上作出了小小的一点修改，其修改如下： 

在扩展的正则表达中把' '写成'()'; '\{ \}'写成'{ }'，

另外加入了:

+：次数匹配，匹配其前面的字符至少出现一次，无上限、

|: 或者(二取一）

其余的都一样， 基本正则表达式，使用'('、 ')' '{' '}' '.' '?' '|'都需要转义,在扩展正则表达中不需要加\. 

 1. 字符匹配的命令和用法与基本正则表达式的用法相同，这里不再重复阐述。 

 2. 次数匹配： 

     '*':匹配其前面字符的任意次 

     '?':匹配其前面字符的0此或着1此 

     '+':匹配其前面字符至少1此 

     fg：至少一个空白符： '[[:space:]]+' 

     {m,n} :匹配其前面字符m到n次 

 3. 字符锚定的用法和基本正则表达式的用法相同，在此不再阐述。 

 4. 特殊字符： 

	'|': 代表或者的意思。 
	
	'fg'：grep -E 'c|cat' file：表示在文件file内查找包含c或者cat 
	
	'\.':\表示转义字符，此表示符号.


## grep ##

只能使用基本的正则表达式来搜索文本。

grep [option] '字符串' filename

### 参数： ###

正则表达式选择与解释:

	-E, --extended-regexp     PATTERN 是一个可扩展的正则表达式(缩写为 ERE)
	-F, --fixed-strings       PATTERN 是一组由断行符分隔的定长字符串。
	-G, --basic-regexp        PATTERN 是一个基本正则表达式(缩写为 BRE)
	-P, --perl-regexp         PATTERN 是一个 Perl 正则表达式
	-e, --regexp=PATTERN      用 PATTERN 来进行匹配操作
	-f, --file=FILE           从 FILE 中取得 PATTERN
	-i, --ignore-case         忽略大小写
	-w, --word-regexp         强制 PATTERN 仅完全匹配字词
	-x, --line-regexp         强制 PATTERN 仅完全匹配一行
	-z, --null-data           一个 0 字节的数据行，但不是空行

Miscellaneous:

	-s, --no-messages         suppress error messages
	-v, --invert-match        select non-matching lines
	-V, --version             display version information and exit
	    --help                display this help text and exit

输出控制:

	-m, --max-count=NUM       NUM 次匹配后停止
	-b, --byte-offset         输出的同时打印字节偏移
	-n, --line-number         输出的同时打印行号
	  --line-buffered       每行输出清空
	-H, --with-filename       为每一匹配项打印文件名
	-h, --no-filename         输出时不显示文件名前缀
	  --label=LABEL         将LABEL 作为标准输入文件名前缀
	-o, --only-matching       show only the part of a line matching PATTERN
	-q, --quiet, --silent     suppress all normal output
	  --binary-files=TYPE   assume that binary files are TYPE;
	                        TYPE is 'binary', 'text', or 'without-match'
	-a, --text                equivalent to --binary-files=text
	-I                        equivalent to --binary-files=without-match
	-d, --directories=ACTION  how to handle directories;
	                        ACTION is 'read', 'recurse', or 'skip'
	-D, --devices=ACTION      how to handle devices, FIFOs and sockets;
	                        ACTION is 'read' or 'skip'
	-r, --recursive           like --directories=recurse
	-R, --dereference-recursive
	                        likewise, but follow all symlinks
	  --include=FILE_PATTERN
	                        search only files that match FILE_PATTERN
	  --exclude=FILE_PATTERN
	                        skip files and directories matching FILE_PATTERN
	  --exclude-from=FILE   skip files matching any file pattern from FILE
	  --exclude-dir=PATTERN directories that match PATTERN will be skipped.
	-L, --files-without-match print only names of FILEs containing no match
	-l, --files-with-matches  print only names of FILEs containing matches
	-c, --count               print only a count of matching lines per FILE
	-T, --initial-tab         make tabs line up (if needed)
	-Z, --null                print 0 byte after FILE name

文件控制:

	-B, --before-context=NUM  打印以文本起始的NUM 行
	-A, --after-context=NUM   打印以文本结尾的NUM 行
	-C, --context=NUM         打印输出文本NUM 行
	-NUM                      same as --context=NUM
	  --group-separator=SEP use SEP as a group separator
	  --no-group-separator  use empty string as a group separator
	  --color[=WHEN],
	  --colour[=WHEN]       use markers to highlight the matching strings;
	                        WHEN is 'always', 'never', or 'auto'
	-U, --binary              do not strip CR characters at EOL (MSDOS/Windows)
	-u, --unix-byte-offsets   report offsets as if CRs were not there
	                        (MSDOS/Windows)



## egrep ##

可以使用扩展的正则表达式来搜索文本，grep不能使用扩展正则表达式的语法

egrep = grep -E

	eg: 查找至少包含一个大写字母的行
	grep '[A-Z]+' nginx.log   #没有任何返回值，也不报错

	egrep '[A-Z]+' nginx.log  #返回匹配行



## fgrep ##

利用固定的字符串来搜索文本，不支持正则表达式的引用。类似于精确匹配

fgrep = grep -F

	eg:查找包含'Apr'字符串的行
	fgrep 'Apr*' nginx.log	#没有返回值，不报错

	fgrep 'Apr' nginx.log	#返回包含Apr字符串的行