---
title: Hello World
date: 2018-03-02 11:11:11
tags: Hello
categories: Hello
top: true
---
“间歇性踌躇满志，持续性混吃等死”，在这条路上见过了太多太多的大佬，默默的做一个小码农，当然能够有点产出是最好的:)
博客间歇式更新

<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=330 height=86 src="//music.163.com/outchain/player?type=2&id=444267928&auto=1&height=66"></iframe>

## 计划： ##

~~2019主线目标：造轮子(有进步，改了两个开源产品的简单功能，继续努力)~~
2020主线目标：做出一款自己的产品

<!-- more -->

## Hexo搭建博客

[Hexo GitHub仓库](https://github.com/theme-next/hexo-theme-next.git)

1、新建博客

```
$ hexo new "My New Post"/hexo new post hello-world
```
详情: [Writing](https://hexo.io/docs/writing.html)

2、生成草稿

```
$ hexo new draft hello-world
```

3、发布草稿

``` bash
$ hexo publish [post] hello-world
```

4、生成静态文件

``` bash
$ hexo generate/hexo g
```
详情: [Generating](https://hexo.io/docs/generating.html)

5、运行服务

``` bash
$ hexo 
$ hexo server/hexo s
```
详情: [Server](https://hexo.io/docs/server.html)

6、发布博客到github

``` bash
$ hexo deploy/hexo d
```
详情: [Deployment](https://hexo.io/docs/deployment.html)

## 优化博客

1、修改主题

采用Next

2、添加RSS，RSS迁移; 添加Search本地搜索
rss:
hexo-generator-feed插件
修改主题下config文件，添加 `rss: /atom.xml`

search:

3、添加博客访问量PV/UV
两种方法：
1)、在`theme/next/layout/_partials/footer.swig`添加'不蒜子'js脚本、统计标签

2）、直接开启config配置

4、添加博客字数、阅读时长; 修改博客国际化
统计也遇到两种方法：
1）、hexo-wordcount插件 + 开启config + 修改post-swig添加统计

2）、hexo-symbols-count-time插件，只需要开启config即可


5、修改博文底部标签样式; 添加`Read more`

修改模板 `/themes/next/layout/_macro/post.swig`，搜索 `rel="tag">#`，将'#'换成`<i class="fa fa-tag"></i>`

6、增加博文置顶功能
两种方案：
1）、hexo-generator-index

2）、hexo-generator-index-pin-top

找到`/blog/themes/next/layout/_macro/post.swig`文件，定位到`<div class="post-meta">`标签下，插入代码：

```
	{% if post.top %}
	  <i class="fa fa-thumb-tack"></i>
	  <font color=7D26CD>置顶</font>
	  <span class="post-meta-divider">|</span>
	{% endif %}
```

7、添加评论功能

8、修改域名

9、网站备案


## 常用命令
操作都在博客根目录下进行

```
cd $HEXO_BLOG
```

1、安装依赖包

```
 npm install hexo-generator-index --save
```

2、卸载依赖包

```
 npm uninstall hexo-generator-index --save
```

3、查看安装的模块

```
$ npm ls --depth 0                                                
```