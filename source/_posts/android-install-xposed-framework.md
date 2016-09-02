---
title: Xposed框架的安装
date: 2016-09-02 09:25:43
categories: android
tags: [android,xposed]
---

## 简介
提到Xposed框架时，人们总会用到一个词“神器”。     
是的，安装Xposed后，我们似乎脑洞大开，以前不能干的事件，现在都能干了。    
对此，我的理解是：hook android，hook everything

Xposed框架是什么？？？    
  
官方对此的解释是这样的：   
"Xposed是一个适用于Android的框架。基于这个框架开发的模块可以改变系统和app应用的行为，而不需要修改APK。这是一个很棒的特性，意味着Xposed模块可以不经过任何修改，安装在各种不同的ROM上。Xposed模块可以很容易的开启和关闭。你只需要激活或者禁用Xposed模块，然后重启手机即可。"

{% asset_img xposed1.png [xposed1] %}

在手机发烧友的眼中，Xposed是这样子的： 

修改手机主题，权限控制，阻止广告，禁用各种APP滥用权限，微信，游戏等相关的各种外挂...

在开发者的眼中，Xposed是这样子的：    

渗透测试，测试数据构造,环境监控,动态埋点,热补丁,自动化录制...

关于Xposed框架的基本原理以及更多介绍，请参考文末链接，或者自行百度。

## 风险声明
{% asset_img xposed2.jpg [xposed2] %}

在安装Xposed框架之前，我必须把风险告诉你：
1. 软变砖
1. 无限重启

简单解释下：
1. 软砖： 手机能启动，但是进不去桌面
1. 硬砖/黑砖:  手机在按电源键，或者连接电脑没反应，一直黑屏。
1. 软砖可以救 硬砖只能修。
1. 无限重启： 就是手机快要进入桌面的时候，又自动重启。周而复始，无限重启。

根据[官方的警示](http://forum.xda-developers.com/showthread.php?t=3034811)和网友的反馈， **三星的手机，以及索尼，戴尔的部分手机** 容易导致以上风险。

## 安装
Xposed框架的安装需要经过root，安装第三方Recovery，安装Xposed框架，安装Xposed Installer等几个步骤。这些步骤都是依次进行的，任何步骤的失败，都会导致Xposed框架的安装过程中止。

因此，建议在 **国际国内的主流Android机型** 上进行安装。

### Root
根据我的个人实践，这里我推荐使用 **KingRoot** 这款工具进行Root。     

官方网址： [https://kingroot.net/?myLocale=zh_CN](https://kingroot.net/?myLocale=zh_CN])

Root之前，我建议你查询下，你的机型是否被支持： [https://kingroot.net/model](https://kingroot.net/model)

### TWRP
对于Android 5.0以上的手机，官方提示，必须要先刷入第三方Recovery, 比如: TWRP

官方网址： [https://twrp.me/](https://twrp.me/)

刷机之前，请先查询下，你的机型是否被支持：
[https://twrp.me/Devices/](https://twrp.me/Devices/)

以Nexus 5 为例， 网站有详细的操作指南。[https://twrp.me/devices/lgnexus5.html](https://twrp.me/devices/lgnexus5.html)

当然有些非主流手机，也可以在相关论坛找到TWRP的修改版本。  

比如我的手机，中兴 Blade A1(C880U) 16G 灵动白 移动4G手机 双卡双待

我就是参考：[中兴小鲜3中兴Blade a1移动版全网通版本TWRP刷写教程@root](中兴小鲜3中兴Blade a1移动版全网通版本TWRP刷写教程@root)

按照 [TWRP for ZTE Blade Apex 2](https://twrp.me/devices/ztebladeapex2.html) 强行刷入的。

刷机完成后，重启可以进入Recovery界面。

### Xposed Framework
#### 下载
Xposed Framework下载地址：[http://dl-xda.xposed.info/framework/](http://dl-xda.xposed.info/framework/)

其中，sdk21，sdk22，sdk23，分别对应Android 5.0，5.1， 6.0.
根据，手机ROM版本和处理器类型选择Xposed Framework刷机包。

比如，中兴Blade a1移动版(5.1, arm64)，我选择了刷机包[xposed-v86-sdk22-arm64.zip](http://dl-xda.xposed.info/framework/sdk22/arm64/xposed-v86-sdk22-arm64.zip) 和卸载包[xposed-uninstaller-20150831-arm64.zip](http://dl-xda.xposed.info/framework/uninstaller/xposed-uninstaller-20150831-arm64.zip)

下载之后，将这两个压缩包，拷贝到SD卡根目录下。

#### 安装
1. 重启手机,进入Recovery界面。(adb reboot recovery)
1. 选择【安装刷机包】进入下级页面，选择【从SD卡选择ZIP文件】
1. 在SD卡根目录找到Xposed Framework刷机包(xposed-v86-sdk22-arm64.zip)，并选择。
1. 滑动底部的滑动条，确认刷入，等待提示刷机完成。
1. 重启手机，等待进入桌面。

#### 卸载
如果刷入Xposed Framework刷机包之后，无限重启，进不去桌面怎么办？      
那就按照下面提示，卸载掉Xposed Framework。
1. 重启手机,进入Recovery界面。(adb reboot recovery)
1. 选择【安装刷机包】进入下级页面，选择【从SD卡选择ZIP文件】
1. 在SD卡根目录找到Xposed Framework卸载刷机包(xposed-uninstaller-20150831-arm64.zip)，并选择。
1. 滑动底部的滑动条，确认刷入，等待提示刷机完成。
1. 重启手机，等待进入桌面。

### Xposed Installer
这是一个管理Xposed模块的官方应用。通过它，你可以随时禁用或者启用Xposed模块，然后重启手机。

对于Android 5.0以上的手机，请前往XDA论坛主题贴下载附件	XposedInstaller_3.0_alpha4.apk，并安装。

下载地址：[http://forum.xda-developers.com/showthread.php?t=3034811](http://forum.xda-developers.com/showthread.php?t=3034811)

如果你看到以下界面，恭喜你，Xposed Framework安装完成。

{% asset_img xposed3.png [xposed3] %}

## FAQ
1. [Xposed FAQ / Known issues](http://forum.xda-developers.com/xposed/xposed-faq-issues-t2735540)
1. [Xposed in zhihu](https://www.zhihu.com/search?type=content&q=xposed)
1. [Xposed in Stackoverflow](http://stackoverflow.com/search?q=xposed)

## 参考
1. [Xposed 官网](http://repo.xposed.info/)
1. [Xposed XDA论坛](http://forum.xda-developers.com/xposed)
1. [[OFFICIAL] Xposed for Lollipop/Marshmallow [Android 5.0/5.1/6.0, v86, 2016/07/08]](http://forum.xda-developers.com/showthread.php?t=3034811)
1. [Xposed framework 作者rovo89 原文（xda）介绍大译](http://xposed.appkg.com/1159.html)
1. [Xposed:不得不说的 Android 神器](http://www.jianshu.com/p/fee6c8a808d5)
1. [Android 系统上的 Xposed 框架中都有哪些值得推荐的模块？](https://www.zhihu.com/question/22063862/answer/31085624)
1. [xposed模块整理](https://www.b521.net/archives/139.html)
1. [基于Xposed修改微信运动步数](http://blog.csdn.net/chenhao0428/article/details/51436837)
1. [用黑客思维做测试——神器 Xposed 框架介绍](https://testerhome.com/topics/3819)
1. [安卓注入框架Xposed分析与简单应用](http://blog.idhyt.com/2015/09/25/android-injection-xposed/)
1. [Xposed框架初体验](http://www.yangyanxing.com/article/first-use-Xposed.html)
