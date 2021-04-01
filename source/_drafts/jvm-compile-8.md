---
title: 编译JDK
date: 2021-03-20 00:38:17
tags:
categpries: JVM
---


## 编译hotspot 1.8
CentOS7.4编译

配置环境变量
```
export LANG=C
export ALT_BOOTDIR=
export ALT_OUTPUTDIR=
export USE_PRECOMPILED_HEADER=true
export BUILD_HOTSPOT=true

export SKIP_DEBUG_BUILD=false
export SKIP_FASTDEBUG_BUILD=true
export DEBUG_NAME=debug
```

编译
```
make ARCH_DATA_MODEL=64 -j4 jvmg jvmg1 
```

make ARCH_DATA_MODEL=64 jvmg jvmg1 ALT_BOOTDIR=/usr/lib/jvm/java-1.11.0-openjdk-amd64/

错误1

错误2
export ARCH_DATA_MODEL=64
```
cc1plus: 错误：the "stabs" debug format cannot be used with pre-compiled headers [-Werror=deprecated]
cc1plus: all warnings being treated as errors
gmake[4]: *** [precompiled.hpp.gch] 错误 1
gmake[4]: 离开目录“/usr/local/openjdk8-src-bak/hotspot/build/linux/linux_i486_compiler2/product”
gmake[3]: *** [the_vm] 错误 2
gmake[3]: 离开目录“/usr/local/openjdk8-src-bak/hotspot/build/linux/linux_i486_compiler2/product”
gmake[2]: *** [product] 错误 2
gmake[2]: 离开目录“/usr/local/openjdk8-src-bak/hotspot/build/linux”
gmake[1]: *** [generic_build2] 错误 2
gmake[1]: 离开目录“/usr/local/openjdk8-src-bak/hotspot/make”
gmake: *** [product] 错误 2
```

错误3
```
In file included from /usr/include/c++/4.8.2/cstdint:35:0,
                 from /usr/local/openjdk8-src-bak/hotspot/src/share/vm/precompiled/precompiled.hpp:249:
/usr/include/c++/4.8.2/bits/c++0x_warning.h:32:2: error: #error This file requires compiler and library support for the ISO C++ 2011 standard. This support is currently experimental, and must be enabled with the -std=c++11 or -std=gnu++11 compiler options.
 #error This file requires compiler and library support for the \
  ^
gmake[4]: *** [precompiled.hpp.gch] Error 1
gmake[4]: Leaving directory `/usr/local/openjdk8-src-bak/hotspot/build/linux/linux_amd64_compiler2/product'
gmake[3]: *** [the_vm] Error 2
gmake[3]: Leaving directory `/usr/local/openjdk8-src-bak/hotspot/build/linux/linux_amd64_compiler2/product'
gmake[2]: *** [product] Error 2
gmake[2]: Leaving directory `/usr/local/openjdk8-src-bak/hotspot/build/linux'
gmake[1]: *** [generic_build2] Error 2
gmake[1]: Leaving directory `/usr/local/openjdk8-src-bak/hotspot/make'
gmake: *** [product] Error 2
```

错误4
找不到PRODUCT

错误5
```
/usr/bin/ld: cannot find -lstdc++
collect2: error: ld returned 1 exit status
/usr/bin/chcon: cannot access 'libjvm.so': No such file or directory
ERROR: Cannot chcon libjvm.so
/usr/bin/objcopy --only-keep-debug libjvm.so libjvm.debuginfo
/usr/bin/objcopy: 'libjvm.so': No such file
make[4]: *** [libjvm.so] Error 1
make[4]: Leaving directory `/usr/local/openjdk8-src-bak/hotspot/build/linux/linux_amd64_compiler2/debug'
make[3]: *** [the_vm] Error 2
make[3]: Leaving directory `/usr/local/openjdk8-src-bak/hotspot/build/linux/linux_amd64_compiler2/debug'
make[2]: *** [debug] Error 2
make[2]: Leaving directory `/usr/local/openjdk8-src-bak/hotspot/build/linux'
make[1]: *** [generic_build2] Error 2
make[1]: Leaving directory `/usr/local/openjdk8-src-bak/hotspot/make'
make: *** [debug] Error 2
```
安装包
```
sudo yum install gcc-c++
```


```
echo "**NOTICE** Dtrace support disabled: "/usr/include/sys/sdt.h not found""
**NOTICE** Dtrace support disabled: /usr/include/sys/sdt.h not found
make[4]: warning:  Clock skew detected.  Your build may be incomplete.
make[4]: Leaving directory `/usr/local/openjdk8-src-bak/hotspot/build/linux/linux_amd64_compiler2/debug'
All done.
make[3]: Leaving directory `/usr/local/openjdk8-src-bak/hotspot/build/linux/linux_amd64_compiler2/debug'
make[2]: Leaving directory `/usr/local/openjdk8-src-bak/hotspot/build/linux'
make[1]: Leaving directory `/usr/local/openjdk8-src-bak/hotspot/make'
cd /usr/local/openjdk8-src-bak/hotspot/make; \
make BUILD_DIR=/usr/local/openjdk8-src-bak/hotspot/build/linux/linux_amd64_compiler1 BUILD_FLAVOR=debug VM_TARGET=debug1 generic_build1
/usr/local/openjdk8-src-bak/hotspot
INFO: ENABLE_FULL_DEBUG_SYMBOLS=1
INFO: /usr/bin/objcopy cmd found so will create .debuginfo files.
INFO: STRIP_POLICY=min_strip
INFO: ZIP_DEBUGINFO_FILES=1
make[1]: Entering directory `/usr/local/openjdk8-src-bak/hotspot/make'
mkdir -p /usr/local/openjdk8-src-bak/hotspot/build/linux/linux_amd64_compiler1/debug
cat /usr/local/openjdk8-src-bak/hotspot/make/hotspot.script | sed -e 's|@@LIBARCH@@|amd64|g' | sed -e 's|@@JDK_IMPORT_PATH@@|/java/re/j2se/1.8.0/promoted/latest/binaries/linux-amd64|g' > /usr/local/openjdk8-src-bak/hotspot/build/linux/linux_amd64_compiler1/debug/hotspot
chmod +x /usr/local/openjdk8-src-bak/hotspot/build/linux/linux_amd64_compiler1/debug/hotspot
mkdir -p /usr/local/openjdk8-src-bak/hotspot/build/linux
No compiler1 (debug1) for ARCH_DATA_MODEL=64
make[1]: Leaving directory `/usr/local/openjdk8-src-bak/hotspot/make'
```