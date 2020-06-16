---
title: 网络中的NAT、P2P
date: 2019-06-07 11:56:03
tags: NetWork
categpries: NetWork
---
网络其实相当有意思，接触NAT主要是在VMware中用到过，一种是懵懵懂懂。

<!-- more -->
## Bridge
桥接模式，
> 每个新建的虚拟机系统都是局域网内和宿主机对等的独立主机，
> 需要手动分配一个和宿主机同IP段的IP地址
> 可以访问公网

## Host-only
主机模式，
> 虚拟环境和宿主真实环境隔离，
> 虚拟机无法访问公网

## NAT
网络地址转换器，
> 可以通过宿主机访问公网
> 虚拟机和宿主机可以互相访问，但是和宿主机之外的局域网主机无法互通

### Basic NAT
### NAPT
网络地址-端口转换器


### Cone NAT 
锥形NAT

#### Full Cone NAT
全锥形NAT

#### Restricted Cone NAT
受限锥形NAT

#### Port-Restricted Cone NAT
端口受限型NAT

### 对称NAT

## P2P通信
### Relaying
中继

### Connection reversal
逆向连接

### UDP hole punching
UDP打洞
#### 端点在不同的NAT之下

#### 端点在相同的NAT之下

#### 固定端口绑定

