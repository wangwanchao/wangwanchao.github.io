---
title: 树莓派实现简单的人脸识别
date: 2018-07-25 17:20:30
tags: raspberry, python, 人脸识别
categories: Python
---
**硬件需求：**

>树莓派开发板
>
>pi摄像头
>
>16g内存卡
>
>读卡器


<!-- more -->

## 1、更新镜像源

	apt-get update
	
	apt-get upgrade
	
	apt-get install python-opencv

## 2、针对PiCamera安装包

	apt-get install python-pip
	
	apt-get install python-dev
	
	pip install picamera


**pip报错(1)**

TypeError: unsupported operand type(s) for -=: 'Retry' and 'int'

解决方案：pip内部bug,升级pip版本

**pip报错(2)**

from pip import main ImportError: cannot import name main

解决方案：pip版本冲突，pip -V; cd /usr/bin; cat pip; mv pip9.0; pip2 -V

**下载open-cv报错**

Unable to establish SSL connection

解决方案：手动下载

https://github.com/opencv/opencv/archive/3.4.0.tar.gz

https://codeload.github.com/opencv/opencv_contrib/zip/master


### 安装视频I/O包
	sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev 
	
	sudo apt-get install libgtk2.0-dev

### 优化函数包：
`
sudo apt-get install libatlas-base-dev gfortran
`

**报错,安装依赖包**

	apt-get install libgstreamer-plugins-base1.0-dev
	
	apt-get install libgphoto2-dev
	
	apt-get install libavresample-dev
	
	apt-get install libdc1394-22-dev
	
	apt-get install libgtk-3-dev


**如果中间缺少以下依赖包，则进行安装**
apt-get install gtk+-3.0 gtk+-2.0 gthread-2.0 gstreamer-base-1.0

apt-get install libavresample libgphoto2

## 3、编译open-cv

`
sudo cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local  -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.3.1/modules ..
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D BUILD_EXAMPLES=ON ..
`


## 4、编写pytho脚本，并执行

    python TestOpencv.py 

**报错**

Found 0 face(s)

Unable to init server: Could not connect: Connection refused

(Frame:15788): Gtk-WARNING **: cannot open display: 

解决：原因是raspberry系统stetch最小化安装，没有图形界面

	sudo apt-get install xorg

	sudo apt-get install lxde openbox

	sudo startx  #不要通过ssh执行

	sudo apt-get install raspberrypi-ui-mods













