---
title: 关于异步任务设计的几点思考
date: 2016-02-18 10:31:32
tags: android
categories: android
---
## 为什么需要异步任务
1. 手机上的CPU和内存等资源是有限的。
1. android应用有一个主线程常用于界面的更新。如果所有事情（包括耗时操作，IO操作，网络操作）都在主线程进行，可能因为系统无法及时处理而导致界面卡顿，甚至ANR。
1. 为了避免ANR，解决卡顿问题，提高应用操作流畅性，我们需要把（耗时操作，IO操作，网络操作）等耗时/耗资源的操作放到异步的子线程中进行。

ANR超时时间在ActivityManagerService.java文件中进行了定义
```java
1.前台broadcast超时时间为10秒，后台broadcast超时时间为60秒
    // How long we allow a receiver to run before giving up on it.
    static final int BROADCAST_FG_TIMEOUT = 10*1000;
    static final int BROADCAST_BG_TIMEOUT = 60*1000;


2.按键无响应的超时时间为5秒
    // How long we wait until we timeout on key dispatching.
    static final int KEY_DISPATCHING_TIMEOUT = 5*1000;
```

## 异步任务需要具有的几个特点
### 界面关联性（Fragment/Activity） 可选
异步任务通常是用来执行耗时操作，最后将执行结果回调给主线程，进行更新界面。
假如，异步任务回调结果的时候，界面已经销毁，又将会发生什么？？？
应用很可能会崩溃，并抛出以下错误日志：
```java
Java.lang.IllegalStateException Activity has been destroyed
```

解决办法：       
异步任务中保存界面（Fragment/Activity）的弱引用。在将要回调之前，判断界面是否已经被销毁。如果已经被销毁，则不进行回调。

### 可取消特性 可选
假设异步任务在执行一个耗时的循环操作，此时，用户按返回键退出界面，异步任务怎么处理？？？
如果该异步任务的目的也是为了更新界面，那么界面销毁，应该及时停止任务，并不进行回调。

解决办法：         
创建异步任务的时候，返回一个Cancellable的接口。
用户通过该接口进行取消。在将要回调之前，判断异步任务是否被取消。如果异步任务已经被取消，则不进行回调。

### 统一线程池 必选
建议统一线程池，所有异步任务都扔给线程池执行。
不推荐直接使用Thread类。

## 异步任务方案
1. AsyncTask
2. 自己封装异步任务（Runnable/Callable）

其中，AsyncTask简单，方便，但缺少可定制性。如果条件允许，建议自己封装异步任务。
