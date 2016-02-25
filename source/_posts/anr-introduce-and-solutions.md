---
title: ANR简介以及解决方案
date: 2016-02-25 21:38:21
categories: android
tags: android
---

## ANR
  ANR，英文全称为 Application Not Responding，即应用无响应。
  具体表现，弹出一个应用无响应的窗口，也可能不弹出直接闪退。

## ANR的类型
ANR一般有三种类型：    
1. KeyDispatchTimeout(5 seconds) --主要类型 按键或触摸事件在特定时间内无响应      
定义参考：ActivityManagerService.java
```java
// How long we wait until we timeout on key dispatching.
static final int KEY_DISPATCHING_TIMEOUT = 5*1000;
```

2. BroadcastTimeout(前台 10 seconds，后台 60 seconds) BroadcastReceiver在特定时间内无法处理完成
定义参考：ActivityManagerService.java
```java
// How long we allow a receiver to run before giving up on it.
static final int BROADCAST_FG_TIMEOUT = 10*1000;
static final int BROADCAST_BG_TIMEOUT = 60*1000;
```
3. ServiceTimeout(前台 20 seconds，后台 200 seconds) --小概率类型 Service在特定的时间内无法处理完成
定义参考：ActiveServices.java    
```java   
// How long we wait for a service to finish executing.
static final int SERVICE_TIMEOUT = 20*1000;
// How long we wait for a service to finish executing.
static final int SERVICE_BACKGROUND_TIMEOUT = SERVICE_TIMEOUT * 10;
```

## ANR的原因    
这里不得不介绍下Android的单线程模型。      

当一个程序第一次启动时，Android会同时启动一个对应的主线程（Main Thread），主线程主要负责处理与UI相关的事件，如：用户的按键事件，用户接触屏幕的事件以及屏幕绘图事件，并把相关的事件分发到对应的组件进行处理。所以主线程通常又被叫做UI线程。

** ANR的原因只有一个： 那就是把IO操作/耗时操作放在了主线程，导致主线程无法及时处理份内的事情（诸如：响应按键，点击事件，刷新界面等），超过了预定时间阀值，最终导致ANR。** 

## ANR的解决方案
### 分析ANR Trace文件 （被动方案）　
应用内通过UncaughtExceptionHandler检测到全局崩溃时，上传ANR　Trace文件到后台服务器，归类分析。

ANR Trace文件的路径通常是：data/anr/traces.txt 但是文件名可能稍有不同。因此，建议上传data/anr/下所有文件。

具体上传方法不展开，请自行百度，或者参考：[浅谈ANR及log分析ANR](http://blog.csdn.net/itachi85/article/details/6918761)

### 预防ANR （主动方案）　
1. #### 同步改异步
将IO操作/耗时操作全部封装成异步任务，放进子线程。

1. #### 工具辅助检测
通过[BlockCanary](https://github.com/moduth/blockcanary)检测耗时操作，通过优化算法，放进子线程等方法进行优化。       

具体使用方法请参考：[BlockCanary 中文简介](https://github.com/moduth/blockcanary/blob/master/README_CN.md)
