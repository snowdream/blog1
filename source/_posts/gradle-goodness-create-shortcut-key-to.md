---
title: "Gradle精选: 在IntellIJ IDEA中创建快捷方式，用于刷新Gradle工程"
date: 2017-03-28 22:36:20
categories: gradle
tags: gradle
---
翻译自： http://mrhaki.blogspot.com/2017/03/gradle-goodness-create-shortcut-key-to.html

我们可以在IntelliJ IDEA中打开一个Gradle工程，并且获得IntelliJ对Gradle的原生支持。当我们在Gradle build文件中添加一个新的依赖或者插件时，需要在 IntelliJ IDEA中刷新工程。我们需要刷新这个Gradle工程，来保证IntelliJ IDEA 能够同步这些改变。Gradle工具栏有一个Icon，点击它可以刷新所有Gradle工程。但是这样做，意味着我们需要移动鼠标，而我们现在需要一个快捷键来完成这些操作，这样，我们就不需要把手移开键盘。

刷新所有Gradle项目的操作，实际上是刷新所有外部功能的操作。我们可以通过  Preferences | Keymap 来添加键盘快捷键。我们在搜索栏搜索“refresh all external”来找到这个动作。

![idea-refresh-gradle-keymap.png](http://upload-images.jianshu.io/upload_images/66954-210d8142097b28fa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们可以右键点击这个Action，然后选择“Keyboard Shortcut”来定义新的键盘快捷键。

现在当我们修改Gradle build文件时，我们可以简单的使用快捷键来刷新Gradle工程。

下面我们介绍如何将这个刷新Gradle工程的Action添加到工具栏。右键点击工具栏，并且选择“option Customize Menus and Toolbars.... ”。现在可以将”Refresh all external projects”添加到工具栏：

![idea-refresh-gradle-keymap-assign.png](http://upload-images.jianshu.io/upload_images/66954-6ec3b83690e2f4ab.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 联系方式
* Email：yanghui1986527#gmail.com
* Github: https://github.com/snowdream
* Blog: http://snowdream.github.io/blog/
* 简书：http://www.jianshu.com/u/748f0f7e6432
* 云栖博客：https://yq.aliyun.com/u/snowdream86 
* QQ群: 529327615     
* 微信公众号:  sn0wdr1am    

![sn0wdr1am](https://static.dingtalk.com/media/lADOmAwFCs0BAs0BAg_258_258.jpg)
