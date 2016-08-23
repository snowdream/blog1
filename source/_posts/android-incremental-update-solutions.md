---
title: Android 应用增量升级方案之实践篇
date: 2016-08-23 16:30:30
categories: android
tags: [android,jni]
---
>作者：snowdream
>Email：yanghui1986527#gmail.com
>QQ 群: 529327615      
>原文地址：[https://snowdream.github.io/blog/2016/08/23/android-incremental-update-solutions/](https://snowdream.github.io/blog/2016/08/23/android-incremental-update-solutions/)

## 名词解释
### 全量升级
每次下载完整的新安装包，进行覆盖安装。

### 增量升级
将新安装包和已经安装的旧安装包进行比对，生成一个差分升级包（Patch包）。用户下载patch包后，和已经安装的旧安装包进行合并，生成新安装包，再进行覆盖安装。

## 背景
在早期的Android应用开发中，由于android应用普遍比较小，因此，普遍采用了全量升级方案。简单粗暴，却行之有效。     
但是，随着Android的发展，Android应用功能越来越多，体积越来越大，再综合以下几个因素考虑，全量升级方案逐渐无法满足我们的需求。
1. 在国内，随着2G,3G,4G的逐步演进，手机网络越来越快，但有一点事实仍然没有改变：流量很贵，非常不够用。(这个因素不适合WIFI用户和土豪用户)   
{% asset_img beijingmobile.png [北京移动流量套餐] %}
以北京移动为例，最基础套餐，5元30M流量。而最新的微信APK安装包35M。也就是说，如果你选了最基础套餐，你一个月内使用全量升级方案，升级一次微信，流量都不够用。
1. 在敏捷开发大行其道的今天，开发者希望尽快将新开发的功能推送到用户面前，并及时得到用户的反馈。恨不能三天一小版，一周一大版。

综合以上因素，开发者必须为用户考虑：省流量，省流量，省流量。

显然，全量升级这种土豪做法已经不再适用，于是，增量升级应运而生。

## 增量升级原理
首先，两句话简单概括增量升级原理:
1. 服务端通过比对最新升级包，和当前应用包，生成差分升级包；
1. 客户端将差分升级包和当前应用包合并，生成最新升级包。


接下来，简单介绍下增量升级的原理：
1. 首先，客户端获取当前应用的Version Code和应用APK文件的MD5值，发送给服务器；
1. 服务器根据既定策略，给用户返回更新包信息。
  1. 通过MD5值没有查询到旧有APK应用信息，返回全量升级包网址，全量升级包MD5值;
  1. 需要返回patch包,但还没有生成patch包时，后台去生成patch包，并返回全量升级包网址，全量升级包MD5值;
  1. 需要返回patch包,并且已经生成patch包时，返回patch包网址，patch包MD5值，全量升级包网址，全量升级包MD5值;
  1. 不需要返回patch包,则返回全量升级包网址，全量升级包MD5值;
1. 客户端根据返回信息进行更新操作。
  1. 如果只有全量升级包相关信息，则下载全量升级包，并在校验MD5值后，安装更新包;
  1. 如果有差分升级包（patch包）,则下载差分升级包。校验差分升级包的MD5值。如果校验失败，走上面一个步骤。如果校验成功，则将差分升级包和当前版本的APK进行合并操作，生成新的应用包。校验新的应用包MD5值。校验通过，这安装这个生成的新应用包。如果校验失败，则走上面一个步骤。

以上只是简单介绍了增量升级的原理，实际应用中还需要细化，考虑更多的场景。

注意： 下载过程中，必须支持断点续传策略。防止网络不畅时，不断重试，造成的流量浪费。

## 增量升级方案
增量升级方案的核心就是使用Diff/Patch算法来对新旧APK进行diff/patch操作。  
目前主流的Diff/Patch算法是bsdiff/bspatch，来自：[http://www.daemonology.net/bsdiff/](http://www.daemonology.net/bsdiff/)   

另外，我了解到，国内有人开源了另外一种Diff/Patch算法,名字叫做HDiffPatch，来自：[https://github.com/sisong/HDiffPatch](https://github.com/sisong/HDiffPatch)

据说，比bsdiff/bspatch更高效呢？详见[《HDiff1.0和BSDiff4.3的对比测试》](http://blog.csdn.net/housisong/article/details/9037743)

我将bsdiff/bspatch和HDiffPatch，使用jni封装成so库，供android调用。项目地址： [https://github.com/snowdream/android-diffpatch](https://github.com/snowdream/android-diffpatch)    
在封装HDiffPatch过程中遇到问题，得到作者@sisong的支持和帮助，在此表示感谢。

bsdiff/bspatch和HDiffPatch算法都是开源的，服务端可以根据源文件来进行编译集成。  
这里我主要在Android客户端的角度，介绍下bsdiff/bspatch和HDiffPatch怎么使用。

### BsDiffPatch
1. 在build.gradle文件中自定义jnilib目录
```
sourceSets {
    main {
        jniLibs.srcDirs = ['libs']
    }
}
```
1. 将 `app/libs/armeabi-v7a/libbsdiffpatch.so` 拷贝到你的工程对应目录下。
1. 将 `app/src/main/java/com/github/snowdream/bsdiffpatch` 和 `app/src/main/java/com/github/snowdream/diffpatch` 拷贝到你的工程对应目录下，包名和文件名都不能改变。
1. 在Java文件中参考以下代码进行调用。
```
IDiffPatch bsDiffPatch = new BSDiffPatch();
bsDiffPatch.init(getApplicationContext()); 
//diff
bsDiffPatch.diff(oldFilePath, newFilePath, diffFilePath);
//patch
bsDiffPatch.patch(oldFilePath, diffFilePath, gennewFilePath);
```

### HDiffPatch
1. 在build.gradle文件中自定义jnilib目录
```
sourceSets {
    main {
        jniLibs.srcDirs = ['libs']
    }
}
```
1. 将 `app/libs/armeabi-v7a/libhdiffpatch.so` 拷贝到你的工程对应目录下。
1. 将`app/src/main/java/com/github/snowdream/hdiffpatch` 和 `app/src/main/java/com/github/snowdream/diffpatch` 拷贝到你的工程对应目录下，包名和文件名都不能改变。
1. 在Java文件中参考以下代码进行调用。
```
IDiffPatch hDiffPatch = new HDiffPatch();
hDiffPatch.init(getApplicationContext()); 
//diff
hDiffPatch.diff(oldFilePath, newFilePath, diffFilePath);
//patch
hDiffPatch.patch(oldFilePath, diffFilePath, gennewFilePath);
```

### BsDiffPatch vs HDiffPatch
这里我选择高德地图Android客户端的两个版本来进行测试。
* 测试来源：[http://www.autonavi.com/](http://www.autonavi.com/)
* 测试版本： Amap_Android_V7.7.4.2128_GuanWang.apk 和 Amap_Android_V7.3.0.2036_GuanWang.apk (注：版本跨度大，差异大)
* 对比算法： BsDiffPatch vs HDiffPatch
* 测试结果：（详见下图）
  1. BsDiffPatch生成的patch包稍小。
  1. 两者的diff操作都非常耗资源，耗时间，无法忍受。（当然diff操作一般在服务端进行）
  1. 两者的patch操作都比较快。通过大概五次测试，BsDiffPatch的patch操作需要13s左右，而HDiffPatch的patch操作仅仅需要1s左右。
  
以上结果仅供参考。
* 测试结论： 
  1. BsDiffPatch应用更广泛
  1. HDiffPatch看起来更高效

{% asset_img test.png [test] %}


## 扩展
以上算是比较成熟的增量升级方案了，但是仔细想想，可能还存在一些问题：
1. 由于多渠道，多版本造成非常多Patch包
1. bs diff/patch算法性能和内存开销太高
第一个问题可以通过服务器策略进行限制。比如，只有最新版5个版本内的升级采用增量升级，其他的仍然采用全量升级。
据说，还有一种更强大的算法，可以解决以上问题。大家有兴趣的话，可以自己去了解。
[crsync-基于rsync rolling算法的文件增量更新.md](https://gist.github.com/9468305/fa8f1307ea4738225fca)


## 参考
1. [友盟增量更新的原理是什么](http://bbs.umeng.com/thread-19-1-1.html)
1. [Android应用增量更新库（Smart App Updates）](http://my.oschina.net/liucundong/blog/160436)
1. [Android实现应用的增量更新\升级](http://blog.csdn.net/yyh352091626/article/details/50579859)
1. [https://github.com/smuyyh/IncrementallyUpdate](https://github.com/smuyyh/IncrementallyUpdate)
1. [浅析android应用增量升级](http://blog.csdn.net/hmg25/article/details/8100896)
1. [https://github.com/cundong/SmartAppUpdates](https://github.com/cundong/SmartAppUpdates)
1. [crsync-基于rsync rolling算法的文件增量更新.md](https://gist.github.com/9468305/fa8f1307ea4738225fca)
1. [https://github.com/sisong/HDiffPatch](https://github.com/sisong/HDiffPatch)
1. [http://www.daemonology.net/bsdiff/](http://www.daemonology.net/bsdiff/)
1. [https://github.com/snowdream/android-diffpatch](https://github.com/snowdream/android-diffpatch)
