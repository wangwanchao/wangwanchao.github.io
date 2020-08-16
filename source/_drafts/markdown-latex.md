---
title: Markdown Pad实现数学公式的编写
date: 2018-11-24 16:10:50
tags: Markdown
categpries: Markdown
---
最近写博客需要用到LaTex描述数学公式，以前配置过，但是具体忘了，结果这次又浪费了一段时间，特别记录一下

1. Markdown Pad2右侧栏不能预览数学公式(也许是我没找到合适的解决方法)
2. 可以通过“F6”实现浏览器页面预览，最好不要使用IE，IE浏览器需要打开激活ActiveX，否则不能正常显示公式
3. LaTex有一套自己的语法，使用时要注意

<!-- more -->

## 配置插件


1、 在Tools-->Options-->Advanced-->HTML Head Editor插入脚本

### 使用CDN脚本 ###

	<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"> </script>

### 使用本地脚本 ###

![test](http://impwang.oss-cn-beijing.aliyuncs.com/latex.PNG)


2、根据LaTex的语法编写

[在线手册](https://www.zybuluo.com/codeep/note/163962#2%E5%A6%82%E4%BD%95%E8%BE%93%E5%85%A5%E4%B8%8A%E4%B8%8B%E6%A0%87)

简单编写测试：

When \\( a \ne 0 \\), there are two solutions to \\(ax^2 + bx + c = 0\\) and they are:
$$ x = {-b \pm \sqrt{b^2-4ac} \over 2a} $$

