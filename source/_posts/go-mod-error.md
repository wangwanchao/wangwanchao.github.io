---
title: Go模块化错误
date: 2020-05-28 11:09:14
tags:
categpries: Go
---
使用iris开发web应用，在升级框架、修改模块化过程中遇到问题

<!-- more -->
1. 更新项目

```
go get github.com/kataras/iris/v12@latest

go get: warning: modules disabled by GO111MODULE=auto in GOPATH/src;
        ignoring go.mod;
        see 'go help modules'
go: cannot use path@version syntax in GOPATH mode
```
2. 应该是go升级后模块化问题，网上有人说设置环境变量
```
export GO111MODULE=on
```
报错不认识标识：flag provided but not defined: -w

3. 升级go版本
`go version`查看go版本为go1.12.6，卸载升级为go1.14.3，成功更新