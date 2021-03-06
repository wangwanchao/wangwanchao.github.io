---
title: 深入理解计算机系统--存储
date: 2018-09-28 23:53:05
tags: CSAPP
categories: CSAPP
---
高级缓存

<!-- more -->

## 随机访问存储

#### 1. 静态RAM
每个位存储在一个双稳态的存储单元，每个位都处于一个稳态。
每个单元是用一个六晶体管电路组成。

#### 2. 动态RAM DRAM
每个位存储在一个电容内，
每个单元是用一个电容和一个访问晶体管组成，存储单元对干扰敏感，光线会导致电容电压改变。

区别：
只要有电，SRAM就会保持不变，与DRAM不同，SRAM不需要刷新
SRAM的存取比DRAM快
SRAM对光电等的干扰不敏感，但是比DRAM要贵


#### 3. 传统的DRAM
传统DRAM芯片被分成d个超单元，每个超单元由w个DRAM单元组成
超单元集合被组成逻辑的r行c列，d=r*c，data引脚 + addr引脚
数据通过引脚连接超单元，传输信息

#### 4. 内存模块
DRAM芯片封装在内存模块中，插在主板扩展槽内

m个内存模块组成主存，每个内存模块由n个DRAM芯片组成。假如接收到地址A，先找到包含A的模块k，再将A转为(i, j)形式的地址，将模块内所有的芯片内 
	
#### 5. 增强的DRAM
快页模式DRAM

扩展数据输出DRAM

同步DRAM

双倍数据速率同步DRAM

视频RAM

#### 6. 非易失性存储器
DRAM和SRAM断电，会丢失信息，属于易失性存储器。非易失性存储器即使断电后，依然可以保存信息。

ROM：
PROM：只能被编程一次
可擦写可编程ROM：EPROM，
	电子可擦除PROM：EEPROM
闪存：基于EEPROM，
	固态硬盘：闪存芯片 + 闪存翻译层

固件：存储在ROM设备中的程序通常称为固件。例如：PC的BIOS例程


#### 总线
总线：用于CPU和主存之间的数据传输，能够携带地址、数据、控制信号。

系统总线：连接CPU和I/O桥接器
内存总线：连接I/O桥接器和主存

补充：不同的硬件厂商使用不同的总线设计
Intel： 北桥 南桥
AMD：超传输互联
Intel Core i7：快速通道互联

## 磁盘存储

逻辑磁盘块：
#### 连接I/O设备
I/O总线：连接CPU/主存到图形卡、监视器、鼠标、磁盘

主机总线适配器：将一个或多个磁盘连接到I/O总线，使用一个特别的主机总线接口定义的通信协议。
磁盘接口：
	SCSI：可以支持多个磁盘驱动器
	SATA：只能支持一个驱动器
	
补：I/O总线进展
PCI模型中，所有设备共享总线，一个时刻只能有一台设备访问这些线路。
现代系统：共享的PCI总线被PCIe总线取代，PCIe是一组高速串行、通过开关连接的点到点链路


#### 访问磁盘
内存映射I/O：作为CPU向I/O设备发射命令的技术
I/O端口：为与I/O设备通信保留的地址空间


## 局部性

时间局部性
空间局部性

### 高速缓存

L1高速缓存
L2高速缓存
L3高级缓存

系统：
每个存储器地址m位，形成$M=2^m$个不同的地址
高速缓存被组织成$S=2^s$个高速缓存组
每个高速缓存组包含E个高速缓存行
每个行由一个$B=2^b$字节的数据块组成
这样的高速缓存可以用结构$(S, E, B, m)$表示。

### 直接映射高速缓存

### 组相联高速缓存

### 读/写问题
读：

写：









































