---
title: "Gradle精选: 为所有的构建启用构建缓存"
date: 2017-04-14 22:07:57
categories: gradle
tags: gradle
---
原文：http://mrhaki.blogspot.com/2017/04/gradle-goodness-enable-build-cache-for.html

Gradle 3.5 引入了构建缓存特性。通过构建缓存，我们可以在不同的电脑之间，不同的builds之间，共享Task输出结果。举个例子，持续集成服务器上构建的输出，可以在开发者的电脑上复用。要启用这项特性，我们只需要添加命令行选项`--build-cache`。或者，我们还可以我们工程下的`gradle.properties`文件中，将`org.gradle.caching`属性设置为true。为了对所有工程都启用构建缓存特性，我们可以在Gradle主目录下的`gradle.properties`文件（ USER_HOME/.gradle/gradle.properties）中设置这个属性。

在下面的例子中，我们在`~/.gradle/gradle.properties`文件中设置`org.gradle.caching`属性：
```
# File: ~/.gradle/gradle.properties
org.gradle.caching=true
```

如果我们想禁用这项特性，我们可以添加命令行选项`--no-build-cache`。

基于 Gradle 3.5 编写。

## 联系方式
* Email：yanghui1986527#gmail.com
* Github: https://github.com/snowdream
* Blog: http://snowdream.github.io/blog/
* 简书：http://www.jianshu.com/u/748f0f7e6432
* 云栖博客：https://yq.aliyun.com/u/snowdream86 
* QQ群: 529327615     
* 微信公众号:  sn0wdr1am    

![sn0wdr1am](https://static.dingtalk.com/media/lADOmAwFCs0BAs0BAg_258_258.jpg)
