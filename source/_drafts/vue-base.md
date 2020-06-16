---
title: Vue基础入门(一)
tags: Vue
date: 2018-10-22 22:57:15
categories: Vue
---
自从写过jQuery就很少接触前端了，作为一个全干工程师，忍受不住冲动，写一点Vue

<!-- more -->
## 基础语法
### 特性

**补充：** Mustache语法
### 指令

#### 指令参数
```
<a v-bind:href="url"></a>
<a v-on:click="action"></a>
```
#### 动态指令参数
```
<a v-bind:[attributeName]="url"> ... </a>
<a v-on:[eventName]="doSomething"> ... </a>
```
#### 指令修饰符
```
<form v-on:submit.prevent="onSubmit">...</form>
```
#### 指令缩写

#### 自定义指令

### 过滤器

## 计算属性/监听器
### 计算
`computed`

### 监听
`watch`

## 事件
### 事件修饰符

### 按键修饰符
#### 修饰符
```
keyup
```
#### 按键码
用于兼容不同的浏览器

## 组件

### 全局注册

### 局部注册

### 混入

### 插槽

### 自定义组件

## 插件
### 自定义插件

## 路由
### 官方路由

### 第三方路由

## 自定义函数 & JSX

## SSR服务端渲染

## 搭建环境
vue的开发可以使用多种方式，无非都是js引用
### 直接JS引用

### CDN远程JS引用

### NPM搭建本地环境
方便和webpack、browserify打包工具配合
```
npm install vue
```

#### 初始化
使用命令行工具初始化
```
vue init webpack vue-demo
```

### 安装依赖
```
cd vue-demo
npm install
```
#### 启动

```
npm run dev
```
#### 打包
```
npm run build
```
#### 版本升级
```
vue -V
npm install --global vue-cli 
```

### eslint检查

