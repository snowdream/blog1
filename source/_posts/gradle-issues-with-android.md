---
title: "Android开发中遇到的的Gradle相关问题总结"
date: 2016-11-27 15:06:08
categories: gradle
tags: [android,gradle]
---
>作者：snowdream   
>Email：yanghui1986527#gmail.com    
>Github: [https://github.com/snowdream](https://github.com/snowdream)   
>QQ 群: 529327615        
>原文地址：[https://snowdream.github.io/blog/2016/11/27/gradle-issues-with-android/](https://snowdream.github.io/blog/2016/11/27/gradle-issues-with-android/)

现在，大家都慢慢开始习惯使用Android Studio来开发Android应用了。       
在使用过程中，难免碰到一些Gralde相关的使用问题。下面总结我收集整理的一些碰到的问题，以及解决方案：

## 1. 问题： Maven源仓库不可用，或者访问，下载非常慢。
**分析**： 由于主要的仓库Maven，Jcenter都在国外，以及众所周知的原因，这些Maven仓库可能比较慢。而我们从新建／导入工程开始，就要和Maven源仓库进行交互，因此，这可能导致我们导入或者打开工程非常的缓慢。

**解决方案**：
1. 优先使用国内Maven仓库镜像。推荐：阿里云Maven仓库镜像
```
maven { url “http://maven.aliyun.com/mvn/repository/“ }
```

2. 使用http协议访问Maven仓库。使用下面的仓库来替换默认的 jcenter() 和 mavenCentral()
```
jcenter { url “http://jcenter.bintray.com/"}
maven { url “http://repo1.maven.org/maven2"}
```

3. 如果你的项目不需要频繁从Maven仓库更新／下载组件，那么强烈建议你打开offline模式。

## 2. 问题： Android Studio导入工程非常慢，甚至卡死在导入阶段。
**分析**：Android Studio导入工程，默认会采用Gradle Wrapper的方式。也就是当你在本地没有下载过相应版本的Gradle，在导入工程前，就会去尝试下载相应版本的Gradle。

关于Gradle Wrapper的配置文件，在项目根目录下gradle/wrapper下。通常是两个文件：gradle-wrapper.jar和gradle-wrapper.properties

我们来看看gradle-wrapper.properties文件：
```
#Mon Dec 28 10:00:20 PST 2015
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-2.14.1-all.zip
```

没错，如果你之前没有通过Gradle Wrapper方式下载过这个版本Gradle，那么你导入工程后，第一件事情就是通过distributionUrl去下载gradle。然而，我们从这个来自Gradle官方的下载地址下载是非常慢的。

**解决方案**：
1.搭建局域网HTTP服务器，镜像Gradle主流版本安装包。    
参考：腾讯的方案：http://android-mirror.bugly.qq.com:8080/gradle/

2.在项目根目录build.gradle配置一个gradle wrapper任务。
```
task wrapper(type: Wrapper) {
    gradleVersion = '3.1'
    distributionUrl = "http://android-mirror.bugly.qq.com:8080/gradle/gradle-${gradleVersion}-bin.zip"
}
```
其中：gradleVersion对应gradle版本号，而distributionUrl则是对应版本的Gradle安装包下载地址。

3.在根目录下执行gradle wrapper 命令，然后将根目录下的gradle目录提交至git仓库。

## 3. 问题： 导入工程后，在Gradle Sync阶段卡死。
具体表现为：你以前已经在Android Studio中打开该工程，但是当你升级了本地Gradle版本，又或者使用Intellij IDEA打开，你会发现导入很慢。即使进去主界面，Gradle Sync也会处于假死状态，好像一直在加载什么。。。

**分析**： 不明

**解决方案**：根据网上的建议，排除以上原因之后，你可以这么干：删除工程下的.gradle文件夹，然后重新导入工程。
