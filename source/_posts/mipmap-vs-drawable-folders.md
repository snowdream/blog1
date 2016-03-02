---
title: mipmap和drawable文件夹的区别
date: 2016-03-02 10:26:20
tags: android
categories: android
---
现在，通过Android Studio创建Android工程，默认会创建mipmap文件夹，而不是以前的drawable文件夹。那么mipmap和drawable文件夹到底有什么区别呢？  

## 定位不同      
mipmap文件夹下的图标会通过Mipmap纹理技术进行优化。关于Mipmap纹理技术的介绍，请参考：[Mipmap纹理技术简介](http://blog.csdn.net/linber214/article/details/3342051/)

经过查询官方和第三方资料，得出结论：
>mipmap文件夹下，仅仅建议放启动图标/app launcher icons，也就是应用安装后，会显示在桌面的那个图标。而其他的图片资源等，还是按照以前方式，放在drawable文件夹下。


下面再详细阐述下，得出以上结论的依据：     
1. [google官方关于mipmap和drawable的定位](http://developer.android.com/intl/ko/tools/projects/index.html)
> ### drawable/   
> For bitmap files (PNG, JPEG, or GIF), 9-Patch image files, and XML files that describe Drawable shapes or Drawable objects that contain multiple states (normal, pressed, or focused). See the Drawable resource type.    
> ### mipmap/    
> **For app launcher icons.** The Android system retains the resources in this folder (and density-specific folders such as mipmap-xxxhdpi) regardless of the screen resolution of the device where your app is installed. This behavior allows launcher apps to pick the best resolution icon for your app to display on the home screen. For more information about using the mipmap folders, see Managing Launcher Icons as mipmap Resources.

1. [stackoverflow上关于mipmap和drawable的区别](http://stackoverflow.com/a/28065664)
>The mipmap folders are for placing your app icons in only. Any other drawable assets you use should be placed in the relevant drawable folders as before.


## 用法不同
以ic_launcher为例。    
1. 放在mipmap文件夹下时，引用方式如下：
```xml
android:icon="@mipmap/ic_launcher"

R.mipmap.ic_launcher
```
1. 放在drawable文件夹下时，引用方式如下：
```xml
android:icon="@drawable/ic_launcher"

R.drawable.ic_launcher
```
