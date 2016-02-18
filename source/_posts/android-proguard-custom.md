---
title: Android项目中Proguard配置文件的定制
date: 2016-02-18 11:16:48
tags: android
categories: android
---
## 简介
默认的Proguard配置文件在$ANDROID_HOME\sdk\tools\proguard 目录下。   
1.  proguard-android.txt      默认的Proguard配置文件（未优化）
1.  proguard-android-optimize.txt      默认的Proguard配置文件（已优化）
1.  proguard-project.txt       默认的用户定制Proguard配置文件。

最近，我通过对Proguard文档的学习，以及各种开源项目Proguard配置文件的分析，总结了几个加强版本的Proguard配置文件。

项目主页：[https://github.com/SnowdreamFramework/android-proguard-configs](https://github.com/SnowdreamFramework/android-proguard-configs)

## Proguard配置文件列表
1. proguard-android-all.txt    android项目中可能用到的Proguard配置，仅供参考
1. proguard-android-lib.txt        android library工程的Proguard配置（未优化）
1. proguard-android-lib-optimize.txt       android library工程的Proguard配置（已优化）
1. proguard-android-app.txt       android app工程的Proguard配置（未优化）
1. proguard-android-app-optimize.txt       android app工程的Proguard配置（已优化）

## 使用方法（Gradle）
下载项目中的Proguard配置文件，然后拷贝到$ANDROID_HOME\sdk\tools\proguard 目录下。   
```java
    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-app-optimize.txt'), 'proguard-rules.txt'
        }
    }
```
注：对于lib项目，推荐使用proguard-android-lib.txt
对于app项目，推荐使用proguard-android-app-optimize.txt

## Reference
1. [http://proguard.sourceforge.net/index.html#manual/usage.html](http://proguard.sourceforge.net/index.html#manual/usage.html)
2. [http://proguard.sourceforge.net/index.html#manual/examples.html](http://proguard.sourceforge.net/index.html#manual/examples.html)
3. [http://developer.android.com/tools/help/proguard.html](http://developer.android.com/tools/help/proguard.html)
4. [https://chromium.googlesource.com/external/google-cache-invalidation-api/+/master/src/example-app-build/proguard.cfg](https://chromium.googlesource.com/external/google-cache-invalidation-api/+/master/src/example-app-build/proguard.cfg)
5. [https://google-gson.googlecode.com/svn/trunk/examples/android-proguard-example/proguard.cfg](https://google-gson.googlecode.com/svn/trunk/examples/android-proguard-example/proguard.cfg)
6. [https://github.com/47deg/translate-bubble-android/blob/master/proguard-sbt.txt](https://github.com/47deg/translate-bubble-android/blob/master/proguard-sbt.txt)
7. [http://sourceforge.net/p/proguard/discussion/182456/thread/32de9f92/](http://sourceforge.net/p/proguard/discussion/182456/thread/32de9f92/)
8. [http://www.cnblogs.com/royi123/archive/2013/02/28/2937657.html](http://www.cnblogs.com/royi123/archive/2013/02/28/2937657.html)
9. [https://code.google.com/p/csipsimple/source/browse/trunk/CSipSimple/proguard.cfg](https://code.google.com/p/csipsimple/source/browse/trunk/CSipSimple/proguard.cfg)
10. [http://blog.csdn.net/lovexjyong/article/details/24652085](http://blog.csdn.net/lovexjyong/article/details/24652085)
