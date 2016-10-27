---
title: Android WiFi ADB
date: 2016-10-27 11:50:16
categories: tools
tags: tools
---
>作者：snowdream   
>Email：yanghui1986527#gmail.com    
>Github: [https://github.com/snowdream](https://github.com/snowdream)   
>QQ 群: 529327615        
>原文地址：[https://snowdream.github.io/blog/2016/10/27/wifi-adb-without-usb/](https://snowdream.github.io/blog/2016/10/27/wifi-adb-without-usb/)

## 简介
大家在开发调试Android应用的时候，都需要使用USB连接电脑和测试手机。   
那么如何通过WIFI来连接电脑和测试手机呢？  

通常的做法是这样：
安装idea插件[AndroidWiFiADB](https://github.com/pedrovgs/AndroidWiFiADB)。通过这个插件，只需要用USB连接一次电脑和测试手机，之后就可以只通过WIFI来连接了。   

那么有没有方法，完全通过WIFI来进行连接呢？
下面就要介绍这样一款工具：[WIFIADB](https://github.com/Sausure/WIFIADB)

## 前提
Android手机需要Root

## 安装
### WIFIADBIntelliJPlugin
在Idea/Android studio插件安装对话框输入“WIFI ADB ULTIMATE”，安装插件，然后重启IDE。
![WIFIADBIntelliJPlugin](https://raw.githubusercontent.com/Sausure/WIFIADB/master/WIFIADBIntelliJPlugin/art/search.png)


### WIFIADBAndroid
1. 点击，下载安装[WIFIADBANDROID-RELEASE-1.0.APK](https://github.com/Sausure/WIFIADB/raw/master/WIFIADBAndroid/app/out/WIFIADBANDROID-RELEASE-1.0.APK)
1. 测试手机连接wifi
1. 启动应用，点击主界面中间的圆形按钮。如果启动成功，底部会提示IP地址和端口号。
![WIFIADBAndroid](https://raw.githubusercontent.com/Sausure/WIFIADB/master/WIFIADBAndroid/art/demo.gif)

## 运行
在Idea/Android studio界面右侧，点击标签““WIFI ADB ULTIMATE””，输入IP地址和端口号,点击“Connect”即可。

![WIFI ADB ULTIMATE](https://raw.githubusercontent.com/Sausure/WIFIADB/master/WIFIADBIntelliJPlugin/art/screenshot1.png)![WIFI ADB ULTIMATE](https://raw.githubusercontent.com/Sausure/WIFIADB/master/WIFIADBIntelliJPlugin/art/screenshot2.png)

## 参考
1. [WIFIADB](https://github.com/Sausure/WIFIADB)
1. [AndroidWiFiADB](https://github.com/pedrovgs/AndroidWiFiADB)
1. [ADBWIFI](https://github.com/layerlre/ADBWIFI)
