---
title: Flutter使用SkSL预热优化编译(译)
date: 2020-08-09 10:53:18
tags:
categpries: Flutter
---
原文地址：https://github.com/flutter/flutter/wiki/Reduce-shader-compilation-jank-using-SkSL-warm-up

Flutter app在第一次启动的时候通常比较糟糕，SkSL(Skia Shader Laguage)渲染预热技术可以加速超过2倍的速度。

<!-- more -->
shader通常是运行在GPU上的一段程序。当一个shader第一次运行的时候，需要先编译。编译时间在几百毫秒，流畅的动画需要在'60FPS/16s'，所以导致数十倍的帧丢失，FPS可以从60降到6。轨迹中`GrGLProgramBuilder::finalize`就是最好的证据。

## SkSL预热
Flutter提供了命令行工具可以查看哪些shaders需要使用SkSL技术，SkSL可以被打包到app，在用户第一次打开app进行预热从而减少编译时间。
使用步骤：
1. `flutter run --profile --cache-sksl`
2. 操作app触发所有需要运行动画的地方
3. 在运行`flutter run`的命令行输入`M`将SkSL shaders保存到本地文件`flutter_01.sksl.json`
4. 使用SkSL预热技术编译app
    ```
    flutter build apk --bundle-sksl-path flutter_01.sksl.json for Android
    flutter build ios --bundle-sksl-path flutter_01.sksl.json for iOS.
    ```
5. app编译完成

注意：可以在app整合一些测试用例用一个命令来完成
```
flutter drive --profile --cache-sksl --write-sksl-on-exit flutter_01.sksl.json -t test_driver/app.dart
```
以[Flutter gallery](https://github.com/flutter/flutter/tree/master/dev/integration_tests/flutter_gallery)为例，使用测试用例整合到CI，每次提交后都会产生SkSLs验证性能

## 思考

### 为什么不预热所有的shaders
如果只有有限的shaders，可以事先预热所有的shaders。实际中为了最优的性能，Flutter后台运行的Skia GPU可以在运行中根据参数(例如, draws, device models, and driver versions)动态的生成shaders。由于各种参数的组合，shaders的数量可能是指数级别的。

### 从一台设备捕获的SkSL是否可以帮助着shader在另一台设备上进行编译
理论上并不保障，但是如果跨设备不兼容也不会导致问题。实际上，SkSL即使在以下场景表现也出奇的好:
(1) 从iOS获取的SkSLs应用在Android设备上
(2) 从模拟器获取的SkSLs应用在手机上
目前，由于Flutter实验室只有有限的设备，并没有足够的数据，不能提供足够的跨设备案例。

### SkSL在新版iPhones上不起作用
对于所有iOS设备来说，FLutter最近从OpenGL迁移到Metal上。但是SkSL只是针对OpenGL实现了预热功能，所以SkSL技术默认只对老版本的iOS设备有用。