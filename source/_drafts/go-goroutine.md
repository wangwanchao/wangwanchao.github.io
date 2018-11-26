---
title: go并发
tags: Go
categories: Go
---

调度器

通信顺序进程(CSP): 消息传递模型


通道: 通道可以共享内置类型、命名类型、结构类型、引用类型、指针

协程：

sync.WaitGroup类似于Java中的CountDownLatch

检测代码中并发竞争冲突

	go build -race