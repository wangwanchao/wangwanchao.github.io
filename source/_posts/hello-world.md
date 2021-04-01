---
title: Hello World
date: 2018-03-02 11:11:11
tags: Hello
categories: Hello
top: true
---
从高中上网都不会的小白，到从事这个行业，我知道我是真心地喜欢这个行业，只不过一直在探索最终的方向，如果可以，我真的希望自己可以写到退休，然后达到研究者的水平，像linus torvalds一样。
这个行业有太多太多的偏见，毕竟“文人相轻”的道理还是存在的，你只需要做好自己，追求极致。
最后，在这条路上见过了太多太多的大佬。
2020，我的目标：成为这样的大佬，未来做出自己的开源产品:)(2020.08.01)
博客间歇式更新 PS: 今年对很多东西有了重新的认识，整个博客的内容，大部分会推翻，重新构建(2020.08.27)
凡事问一下：
1. 她是什么？what
2. 她用来做什么？for
3. 她解决了什么问题？solve
4. 她的设计原理是什么？design
5. 你自己如何实现她？practice

<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=330 height=86 src="//music.163.com/outchain/player?type=2&id=444267928&auto=1&height=66"></iframe>

## 计划： ##

~~2019主线目标：造轮子(有进步，改了两个开源产品的简单功能，继续努力)~~
2020主线目标：做出一款自己的产品

<!-- more -->
## npm包管理
现在很多的语言框架都会采用包管理，像Maven、Gradle、Cargo、Go，npm的包管理原理差不多，无非要考虑全局/本地问题、镜像问题、包路径问题。

### 配置镜像
配置淘宝镜像(个人感觉不是很好用)
```
npm config set registry https://registry.npm.taobao.org/
npm config get registry
```
配置代理，npm只支持http，如果使用socks代理，需要安装插件
```
npm config set proxy http://127.0.0.1:1087
npm config set https-proxy http://127.0.0.1:1087
# 设置用户密码的代理
npm config set proxy "http://username:password@localhost:8080"
npm confit set https-proxy "http://username:password@localhost:8080"

```
也可以使用cnpm来代替npm
```
sudo npm install -g cnpm --registry=https://registry.npm.taobao.org
cnpm install xxx
```
查看配置
```
npm config list
```
### 安装依赖包
```
npm install hexo-generator-index --save
```
### 卸载依赖包
```
npm uninstall hexo-generator-index --save
```
### 查看安装的模块
```
npm ls --depth 0  
```
### 升级npm包
```
npm update
```
### npm自升级
```
sudo npm install npm -g
sudo npm install npm@6.13.4 -g  // 指定升级版本
```

## Hexo搭建博客
[Hexo GitHub仓库](https://github.com/theme-next/hexo-theme-next.git)

### 新建博客

```
$ hexo new "My New Post"/hexo new post hello-world
```
详情: [Writing](https://hexo.io/docs/writing.html)

### 生成草稿

```
$ hexo new draft hello-world
```

### 发布草稿

``` bash
$ hexo publish [post] hello-world
```

### 生成静态文件

``` bash
$ hexo generate/hexo g
```
详情: [Generating](https://hexo.io/docs/generating.html)

### 运行服务

``` bash
$ hexo 
$ hexo server/hexo s  // 本地运行
```
详情: [Server](https://hexo.io/docs/server.html)

### 发布博客到github

``` bash
$ hexo deploy/hexo d
```
详情: [Deployment](https://hexo.io/docs/deployment.html)

## 优化博客

### 修改主题

采用Next

### 添加RSS，RSS迁移; 添加Search本地搜索
rss:
hexo-generator-feed插件
修改主题下config文件，添加 `rss: /atom.xml`

search:

### 添加博客访问量PV/UV
两种方法：
1). 在`$HEXO_BLOG/themes/next/layout/_partials/footer.swig`添加'不蒜子'js脚本、统计标签

2).直接开启config配置

### 添加博客字数、阅读时长; 修改博客国际化
统计也遇到两种方法：
1）、hexo-wordcount插件 + 开启config + 修改post-swig添加统计

2）、hexo-symbols-count-time插件，只需要开启config即可

### 修改博文底部标签样式; 添加`Read more`

修改模板 `$HEXO_BLOG/themes/next/layout/_macro/post.swig`，搜索 `rel="tag">#`，将'#'换成`<i class="fa fa-tag"></i>`

### 增加博文置顶功能
两种方案：
1）hexo-generator-index

2）hexo-generator-index-pin-top

找到`$HEXO_BLOG/themes/next/layout/_macro/post.swig`文件，定位到`<div class="post-meta">`标签下，插入代码：

```
	{% if post.top %}
	  <i class="fa fa-thumb-tack"></i>
	  <font color=7D26CD>置顶</font>
	  <span class="post-meta-divider">|</span>
	{% endif %}
```

### 添加评论功能

### 修改域名


### 网站备案

### 支持LaTex
总结一下
markdown文件对LaTex数学公式的支持，最开始在windows上博客编辑使用`Markdown Pad 2`，可以支持实时预览。最近更换到`VSCode`，看了支持实时预览的大概几种方案：Tex Live(MaxTex)体积太大；MikTex对中文的支持不是很好；Overleaf采用线上编译模式。
最后放弃实时预览，只在编译后的博客中支持。
Hexo的Next主题已经提供了对LaTex的支持，只需要使用npm安装插件，编辑config配置文件开启即可，目前Next支持`Mathjax`和`Katex`两种编译引擎。
** 注意：不同的主题配置方式不同 **
1. npm安装插件
```
cd $BLOG_HOME

安装hexo-math
$ npm install hexo-math --save

卸载默认引擎，安装支持latex的引擎
$ npm uninstall hexo-renderer-marked --save
$ npm install hexo-renderer-kramed --save
```
2. 修改npm插件的编译规则
Latex和Markdown的一些语法一致导致render渲染规则存在冲突，可以通过修改插件的正则表达式来避免冲突。
```
vi $BLOG_HOME/node_modules/kramed/lib/rules/inline.js

调整为
escape: /^\\([`*\[\]()#$+\-.!_>])/,
em: /^\*((?:\*\*|[\s\S])+?)\*(?!\*)/,
```

3. 修改`$HEXO_BLOG/themes/next/_config.yml`开启功能按钮
这里有人在Hexo的根目录下直接修改`_config.yml`，要注意themes的区别。
```
# Math Equations Render Support
math:
  enable: true
  # 默认值为true， 只在添加了`mathjax: true`的文章中价值latex脚本。false会在所有的文章页加载`mathjax / katex`脚本
  per_page: true
  engine: mathjax
  #engine: katex

  # 安装 hexo-renderer-pandoc (or hexo-renderer-kramed)
  mathjax:
    enable: true
    per_page: false
		# 这块儿js文件路径注意是否能正常访问
    # cdn: //cdn.jsdelivr.net/npm/mathjax@2/MathJax.js?config=TeX-AMS-MML_HTMLorMML
    cdn: //cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML
    # See: https://mhchem.github.io/MathJax-mhchem/
    #mhchem: //cdn.jsdelivr.net/npm/mathjax-mhchem@3
    #mhchem: //cdnjs.cloudflare.com/ajax/libs/mathjax-mhchem/3.3.0

  # 插件2 hexo install hexo-renderer-markdown-it-plus (or hexo-renderer-markdown-it with markdown-it-katex plugin)
  # katex:
  #   cdn: //cdn.jsdelivr.net/npm/katex@0/dist/katex.min.css
  #   #cdn: //cdnjs.cloudflare.com/ajax/libs/KaTeX/0.7.1/katex.min.css

  #   copy_tex:
  #     # See: https://github.com/KaTeX/KaTeX/tree/master/contrib/copy-tex
  #     enable: false
  #     copy_tex_js: //cdn.jsdelivr.net/npm/katex@0/dist/contrib/copy-tex.min.js
  #     copy_tex_css: //cdn.jsdelivr.net/npm/katex@0/dist/contrib/copy-tex.min.css
```

4. 文章头添加`mathjax: true`标识。
使用数学公式验证一下
```
$$ evidence_{i}=\sum_{j}W_{ij}x_{j}+b_{i} $$

$$ \frac{m}{n} %n分之m $$
```
本地启动
```
hexo clean
hexo s
```
** 加载会变慢，js脚本可以考虑使用镜像 **

## 附录

```
1. 错误1
seems to be corrupted. Trying one more time
解决方案
更换网络：数据网络、代理、镜像，墙内世界总有一款适合你

2. 错误2 权限问题
Unhandled rejection Error: EACCES: permission denied, mkdir
解决方案
sudo chown -R $USER:$GROUP ~/.npm
sudo chown -R $USER:$GROUP ~/.config

```