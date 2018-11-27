---
title: Mac使用U盘制作启动盘
date: 2018-11-27 19:34:37
tags: Mac
categories: Mac
---
以前都是使用Windows系统制作启动盘UltraISO、老毛桃、大白菜，今天第一次使用Mac制作Centos7系统盘，一时有点懵逼，记录一下。

<!-- more -->

## 制作步骤

### 查看挂载点

```
$ diskutil list
/dev/disk0 (internal):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                         500.3 GB   disk0
   1:                        EFI EFI                     314.6 MB   disk0s1
   2:                 Apple_APFS Container disk1         500.0 GB   disk0s2

/dev/disk1 (synthesized):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      APFS Container Scheme -                      +500.0 GB   disk1
                                 Physical Store disk0s2
   1:                APFS Volume Macintosh HD            82.9 GB    disk1s1
   2:                APFS Volume Preboot                 22.3 MB    disk1s2
   3:                APFS Volume Recovery                515.0 MB   disk1s3
   4:                APFS Volume VM                      5.4 GB     disk1s4

/dev/disk2 (disk image):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        +91.9 MB    disk2
   1:                  Apple_HFS MailMaster              91.8 MB    disk2s1

/dev/disk3 (disk image):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:                            MySQL Workbench com... +314.6 MB   disk3

/dev/disk4 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *15.6 GB    disk4
   1:             Windows_FAT_32 18810998015             15.6 GB    disk4s4

```

看到internal、external即可知道这是内置磁盘、U盘

### 卸载挂载点

```
$ diskutil unmountDisk /dev/disk4                                                       
Unmount of all volumes on disk4 was successful

```

### 使用dd命令写入

```
sudo dd if=/Users/wanchaowang/Downloads/CentOS-7-x86_64-Minimal-1804.iso of=/dev/disk4 bs=1m
906+0 records in
906+0 records out
950009856 bytes transferred in 666.618035 secs (1425119 bytes/sec)

```
显示in、out即为dd完成

**注意：中间耗时较长，而且过程中没有任何提示信息，第一次我以为没有拷贝，中断，导致U盘不可读**

bs=1M和bs=1m会有坑，如果出错‘dd: invalid number: ‘1m’’可以尝试不同的

U盘不可读时MacOS会有明确的提示，抹除重新dd即可