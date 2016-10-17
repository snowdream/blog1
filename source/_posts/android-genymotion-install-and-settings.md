---
title: Genymotion安装配置指南
date: 2016-10-17 11:54:52
categories: android
tags: android
---
>作者：snowdream   
>Email：yanghui1986527#gmail.com    
>Github: [https://github.com/snowdream](https://github.com/snowdream)   
>QQ 群: 529327615        
>原文地址：[https://snowdream.github.io/blog/2016/10/17/android-genymotion-install-and-settings/](https://snowdream.github.io/blog/2016/10/17/android-genymotion-install-and-settings/)

注： 由[snowdream](https://github.com/snowdream)收集整理

## 简介
Genymotion是一款基于x86架构的Android模拟器，由于系统启动速度，应用运行速度远远快于Android SDK自带模拟器而受到广泛应用。

## 优缺点
### 优点
* 系统启动速度快
* 应用运行速度快
* 跨平台
* IDE支持

### 缺点
* 与真机相比，无法支持一些硬件相关的传感器特性等
* 由于市场上大部分应用都是基于ARM架构来编译的，因此，与默认模拟器，真机相比，对于包含仅支持ARM架构的so的应用，默认不支持。

注：基于x86架构的模拟器/真机，兼容ARM指令有两个解决方案：
1. 对于x86真机，x86处理器已经能够基本兼容ARM指令了。参考[《涨姿势！x86处理器兼容ARM架构App的秘密》](http://blog.csdn.net/hshl1214/article/details/50972589)
1. 对于Genymotion模拟器，则通过安装ARM_Translation_Android来进行兼容。

## 安装Genymotion
### 安装步骤
1. [安装虚拟机VirtualBox  ](https://www.virtualbox.org/wiki/Downloads)

1. [注册Genymotion帐号](https://www.genymotion.com/account/create/)

1. [登录，下载并安装Genymotion](https://www.genymotion.com/download/)

### 安装指南
详细安装步骤，请参考以下文章：
1. [Installation](https://docs.genymotion.com/Content/01_Get_Started/Installation.htm)
1. [Genymotion安装方法](http://www.jianshu.com/p/cb0e43e0996e)

{% asset_img genymotion.png [Genymotion效果图] %}

## 安装ARM_Translation_Android系列包
由于genymotion是基于x86的，而大部分应用都是基于ARM的，因此，我们需要安装一个ARM_Translation_Android系列包来增强兼容性。

### 安装步骤
1. 点击下载ARM_Translation_Android系列包
 * Android 4.4及以下：     [ARM Translation Installer v1.1](http://www.mirrorcreator.com/files/0ZIO8PME/Genymotion-ARM-Translation_v1.1.zip_links)
 * Android 5.x： [ARM_Translation_Lollipop](https://mega.nz/#!Mt8kyBxa!iVJYC7eI7ruLVoaarWIa85QOm_VlH53G0knVGpoSlAE)
 * Android 6.x： [ARM_Translation_Marshmallow](https://mega.nz/#!p4lFlCZR!TFsb8dMqNdAJjKoCDPDDvNtcQdEB0-KkVlTgQVwG20s)
1. 将下载的zip包，拖进Genymotion模拟器窗口，按照提示安装
1. 安装成功后，重启Genymotion模拟器即可。

### 安装指南
1. [Genymotion with Google Play Services](https://gist.github.com/wbroek/9321145)
1. [Use ARM Translation on 5.x image](http://23pin.logdown.com/posts/294446-genymotion-use-arm-translation-on-5x-image)
1. [Use ARM Translation on 6.x image](http://23pin.logdown.com/posts/691046-genymotion-use-arm-translation-on-6x-image)

注：以上步骤，便可满足大部分的开发测试需求。以下的步骤，都是可选步骤。

下面是安装微信的效果

{% asset_img wechat.png [wechat] %}


## 安装Google Apps
1. 根据平台，android版本等选择不同的安装包，下载。  
http://opengapps.org/   
https://github.com/opengapps/opengapps
1. 将下载的zip包，拖进Genymotion模拟器窗口，按照提示安装
1. 安装成功后，重启Genymotion模拟器即可。

## 安装Xposed
1. 根据平台，android版本等选择不同的安装包，下载。  
http://dl-xda.xposed.info/framework/    
其中，sdk21，sdk22，sdk23，分别对应Android 5.0，5.1， 6.0.
1. 将下载的zip包，拖进Genymotion模拟器窗口，按照提示安装
1. 安装成功后，重启Genymotion模拟器即可。
1. 对于Android 5.0以上的手机，请前往XDA论坛主题贴下载附件 XposedInstaller_3.0_alpha4.apk，并安装。
下载地址：http://forum.xda-developers.com/showthread.php?t=3034811   
如果你看到以下界面，恭喜你，Xposed Framework安装完成。

{% asset_img xposed3.png [xposed3] %}

## 参考
1. [Android模拟器Genymotion](http://www.jianshu.com/p/82afc1c0212e)
1. [Genymotion安装方法](http://www.jianshu.com/p/cb0e43e0996e)
1. [快到极致的 Android 模拟器Genymotion](http://www.jianshu.com/p/7e87693e1dcd)
1. [Genymotion那点事儿](http://www.jianshu.com/p/66ec5295fc65)
1. [Xposed 官网](http://repo.xposed.info/)
1. [Xposed XDA论坛](http://forum.xda-developers.com/xposed)
1. [[OFFICIAL] Xposed for Lollipop/Marshmallow [Android 5.0/5.1/6.0, v86, 2016/10/16]](http://forum.xda-developers.com/showthread.php?t=3034811)
1. [Xposed框架的安装](https://snowdream.github.io/blog/2016/09/02/android-install-xposed-framework/)
1. [Genymotion with Google Play Services](https://gist.github.com/wbroek/9321145)
1. [Use ARM Translation on 5.x image](http://23pin.logdown.com/posts/294446-genymotion-use-arm-translation-on-5x-image)
1. [Use ARM Translation on 6.x image](http://23pin.logdown.com/posts/691046-genymotion-use-arm-translation-on-6x-image)
