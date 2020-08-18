---
title: 微服务--断路器(四)
date: 2019-01-17 21:20:00
tags: 断路器
categpries: SpringCloud
---
服务之间的依赖，中间的某个服务响应时间太长、或者不可用，导致占用过多的系统资源，整个服务不可用，就会导致'雪崩效应'。针对服务雪崩。
注意服务熔断和服务降级是两个不同的概念。
服务熔断：一般是指软件系统中，由于某些原因使得服务出现了过载现象，为防止造成整个系统故障，从而采用的一种保护措施，所以很多地方把熔断亦称为过载保护。很多时候刚开始可能只是系统出现了局部的、小规模的故障，然而由于种种原因，故障影响的范围越来越大，最终导致了全局性的后果。
服务降级：当服务器压力剧增的情况下，根据当前业务情况及流量对一些服务和页面有策略的降级，以此释放服务器资源以保证核心任务的正常运行。
<!-- more -->
## Hystrix ##
### 工作原理
熔断器:Circuit Breaker
每个请求都会先经过熔断器，判断是否打开状态，每个熔断器维护10个bucket，每个bucket记录(成功、失败、超时、拒绝)的次数，每秒创建一个bucket，旧的bucket会被抛弃

#### 熔断机制
默认是5s内20次调用失败，就会触发熔断机制。也可以通过以下参数调整。
配置属性：
```
hystrix.command.default.metrics.rollingStats.timeInMilliseconds 	
circuitBreaker:
    forceClosed： true      # 是否强制关闭熔断
	requestVolumeThreshold: 20   	# 滑动窗口大小，默认20次/10s
	sleepWindowInMilliseconds: 5000  # 过多久断路器再次检测是否开启
	errorThresholdPercentage: 50  	# 错误率
```
1. 快照时间窗口：timeInMilliseconds 默认为10s
2. 请求总数阀值: requestVolumeThreshold 在快照时间窗内，必须满足请求总数阀值才有资格熔断。例如：默认为20，意味着在10秒内，如果该hystrix命令的调用次数不足20次，即使所有的请求都超时或其他原因失败，断路器都不会打开
3. 错误百分比阀值：errorThresholdPercentage 默认50，主要根据依赖(强依赖、弱依赖)重要性进行调整，当请求总数在快照时间窗内请求失败率超过了该阀值，则打开断路器
**注意**
**默认**超过50%的请求失败，将打开断路器()，不再调用后端服务而直接失败，调用降级服务`fallback`，过一段时间后尝试一部分请求到后端()，如果成功则关闭断路器()，否则重新打开

#### 超时时间
可以手动设置，当调用后端服务超过超时时间时，直接返回/执行fallback逻辑
```
execution.isolation.thread.timeoutInMilliseconds # 超时时间	
默认值：1000
在THREAD模式下，达到超时时间，可以中断
在SEMAPHORE模式下，会等待执行完成后，再去判断是否超时
```

### 线程池
默认情况下，使用线程池模式
每个请求对于一个线程池，接收请求后提交到线程池，下游服务在各自的单独线程中执行，达到资源隔离的作用。
微服务之间的调用包裹在HystrixCommand类中，这样每次都会启动一个新的线程执行

#### 配置属性
```
coreSize
execution.isolation.thread.interruptOnTimeout=true  #是否打开超时线程中断
execution.timeout.enabled: true  # 是否打开超时	
maxQueueSize: -1   # 请求等待队列	默认值：-1 如果使用正数，队列将从SynchronizeQueue改为LinkedBlockingQueue
```

### 信号量
本服务接收请求和下游服务的执行都在一个线程内执行，内部通过一个计数器(信号量)实现线程计数，当线程的并发数大于信号量阈值时将进入fallback。

#### 配置属性：调整为信号量模式
```
execution.isolation.strategy = ExecutionIsolationStrategy.SEMAPHORE
execution.isolation.semaphore.maxConcurrentRequests=1000  # 限制下游服务调用，当并发请求数达到阈值时，请求线程可以快速失败，执行降级
```

### 应用场景：

1. 隔离（线程隔离、信号量隔离）：主要是限制调用分布式服务的资源，避免个别服务出现问题时对其他服务产生影响
2. 熔断（容错）：当失败率达到一定阈值时，熔断器触发快速失败
3. 降级（超时降级、熔断降级）：触发降级时可以使用回调方法返回托底数据
4. 缓存：请求缓存、请求合并
5. 实时监控、报警

### 线程池和信号量的区别
线程池：

信号量：
## Sentinel(阿里) ##
### 原理
特性：

1. 轻量级、高性能： sentinel-core不到200KB，单机超过25W QPS才会有影响
2. 流量控制：以不同的运行指标为基准，
	> 直接拒绝模式
	> 慢启动预热模式
	> 匀速度模式
3. 系统负载保护

### 应用场景：

1. 和Dubbo整合，通过限流实现服务的高可用
2. 和RocketMQ整合，通过匀速请求和冷启动保障服务的稳定性

### Hystrix和Sentinel的对比 ###
