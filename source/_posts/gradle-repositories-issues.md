---
title: Gradle源仓库相关问题总结
date: 2016-07-26 14:37:12
categories: gradle
tags: gradle
---
## 一. Gradle源仓库（repositories）是什么东西，有什么用？

Gradle 源仓库（repositories）实际上复用了Maven的 源仓库（repositories）。

源仓库，主要用于托管项目构建输出和依赖组件的一个软件仓库。

这样说可能太抽象了。。。

举个例子：
开发者A，通过一个Android 库项目，构建出一个依赖aar包，然后上传至源仓库。
开发者B，通过在一个Android应用项目的build.gradle文件中声明依赖开发者A的库项目。构建过程中，gradle会自动去源仓库拉取改aar依赖包到本地，参与构建。（本地有缓存机制。如果上次拉取了，这次会使用本地缓存。）

## 二. 默认的仓库不可用？
对于Android应用，以前默认的官方仓库是mavenCentral()，后来修改成了jcenter()。

这两个官方仓库默认是通过https来访问的。很可能在国内无法正常使用。

如果你无法正常从源仓库拉取依赖包，有几个办法:
1.改用http访问
        maven { url "http://oss.sonatype.org/content/repositories/snapshots" }
        jcenter { url "http://jcenter.bintray.com/"}
        maven { url "http://repo1.maven.org/maven2"}
        maven { url "https://jitpack.io" }
其中，   
     jcenter { url "http://jcenter.bintray.com/"} 替换  jcenter()
     maven { url "http://repo1.maven.org/maven2"} 替换 mavenCentral()
     如果你需要用到snapshots包，建议添加         maven { url "http://oss.sonatype.org/content/repositories/snapshots" }
    而另外一些包被托管在jitpack.io网站，你可以通过maven { url "https://jitpack.io" }仓库进行访问。


2.采用国内Maven仓库镜像
最早是oschina做了maven镜像，不过很遗憾，稳定性太差，目前处于基本不可用的状态。
目前的做法是：
推荐阿里云的maven镜像:
        maven { url 'http://maven.aliyun.com/mvn/repository/' }


3.通过vpn或者其他工具fq


## 三. Maven 搜索查询
比如：android插件
        classpath 'com.android.tools.build:gradle:1.3.1'
有哪些版本，最新版本号是多少？

你可以通过以下Maven网站/镜像进行查询。
http://maven.aliyun.com/nexus/#welcome
http://search.maven.org/
https://oss.sonatype.org/
