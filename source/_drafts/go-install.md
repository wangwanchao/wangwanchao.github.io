---
title: VS Code开发Go Web包安装失败
date: 2020-05-28 10:55:36
tags:
categpries: Go
---
vs code开发，打开项目报错，包安装失败

<!-- more -->

```
Installing github.com/mdempsky/gocode FAILED
Installing github.com/uudashr/gopkgs/v2/cmd/gopkgs FAILED
Installing github.com/ramya-rao-a/go-outline FAILED
Installing github.com/acroca/go-symbols FAILED
Installing golang.org/x/tools/cmd/guru FAILED
Installing golang.org/x/tools/cmd/gorename FAILED
Installing github.com/cweill/gotests/... SUCCEEDED
Installing github.com/fatih/gomodifytags FAILED
Installing github.com/josharian/impl FAILED
Installing github.com/davidrjenni/reftools/cmd/fillstruct FAILED
Installing github.com/haya14busa/goplay/cmd/goplay FAILED
Installing github.com/godoctor/godoctor FAILED
Installing github.com/go-delve/delve/cmd/dlv FAILED
Installing github.com/stamblerre/gocode FAILED
Installing github.com/rogpeppe/godef FAILED
Installing github.com/sqs/goreturns FAILED
Installing golang.org/x/lint/golint FAILED

16 tools failed to install.
```

怀疑是GFW的问题，翻墙镜像`golang.org/x`可以代理

```
cd $GOPATH/src/golang.org/x
git clone https://github.com/golang/lint
cd $GOPATH
go install golang.org/x/lint/golint
```
安装lint继续报错，

```
src/golang.org/x/lint/lint.go:27:2: cannot find package "golang.org/x/tools/go/gcexportdata" in any of:
	/usr/local/Cellar/go/1.12.6/libexec/src/golang.org/x/tools/go/gcexportdata (from $GOROOT)
	/Users/impwang/go/src/golang.org/x/tools/go/gcexportdata (from $GOPATH)
```
可能是tools的兼容问题，删除tools包重新安装
```
cd $GOPATH/src/golang.org/x
rm -rf tools
git clone https://github.com/golang/tools.git tools
```
重新安装成功。