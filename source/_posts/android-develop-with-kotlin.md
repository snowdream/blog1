---
title: 使用Kotlin开发Android应用
date: 2016-08-13 16:46:06
categories: android
tags: [android,kotlin]
---
>作者：snowdream
>Email：yanghui1986527#gmail.com
>QQ 群: 529327615      
>原文地址：[https://snowdream.github.io/blog/2016/08/13/android-develop-with-kotlin/](https://snowdream.github.io/blog/2016/08/13/android-develop-with-kotlin/)


## 目标
本文旨在引导开发者使用Kotlin来开发Android应用。   

至于Kotlin语言的语法和教程等，不在本文讨论范围，请参考以下官网文档和网上的开发教程。
1. [kotlin-android](https://kotlinlang.org/docs/tutorials/kotlin-android.html)
1. [《Kotlin for android Developers》中文翻译](https://wangjiegulu.gitbooks.io/kotlin-for-android-developers-zh/content/)
1. [Kotlin-in-Chinese](https://huanglizhuo.gitbooks.io/kotlin-in-chinese/content/)
1. [Kotlin 官方参考文档 中文版](https://hltj.gitbooks.io/kotlin-reference-chinese/content/)
1. [Kotlin 官方文档中文翻译版](https://drakeet.gitbooks.io/the-kotlin-programming-language/content/)


## 简介
### 名词解释
#### Kotlin
Kotlin 是一个基于 JVM 的新的编程语言，由 JetBrains 开发。      
Kotlin可以编译成Java字节码，也可以编译成JavaScript，方便在没有JVM的设备上运行。     
JetBrains，作为目前广受欢迎的Java IDE IntelliJ 的提供商，在 Apache 许可下已经开源其Kotlin 编程语言。 

官方网站：[http://kotlinlang.org/](http://kotlinlang.org/)

Github仓库: [https://github.com/JetBrains/kotlin](https://github.com/JetBrains/kotlin)

## 教程
本节介绍如何使用Kotlin开发android应用。

以下几点需要谨记：
1. 所有Kotlin类文件，以.kt为后缀。
1. Kotlin的源码目录规则和默认的是一样的。分别放在src/main/kotlin, src/test/kotlin, src/androidTest/kotlin 和任意的src/${buildVariant}/kotlin。

### Kotlin and Java
使用Kotlin来开发android，需要经过以下几个步骤进行配置。
1.在项目根目录下的build.gradle文件中添加以下代码：
```
buildscript {
    ext.kotlin_version = '1.0.1-2'

    repositories {
        jcenter()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:2.1.2'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
```

2.在模块目录下的build.gradle文件中添加以下代码：
```
apply plugin: 'kotlin-android'
apply plugin: 'kotlin-android-extensions'
dependencies {
  compile "org.jetbrains.kotlin:kotlin-stdlib:$kotlin_version"
}
```

3.配置完成，你可以在src/main/kotlin目录下愉快地使用Kotlin来写Android应用了。

实例展示：
1. [https://github.com/JetBrains/kotlin-examples](https://github.com/JetBrains/kotlin-examples)
1. [https://github.com/snowdream/test/tree/master/android/kotlin/HelloWorld](https://github.com/snowdream/test/tree/master/android/kotlin/HelloWorld)

### Java 2 Kotlin
上面是手动给android项目增加kotlin支持。    
其实还有一种自动转换的方法，也可以添加kotlin支持。
1. 通过菜单“ Help | Find Action”或者快捷键“Ctrl+Shift+A”调出动作查询窗口
1. 输入"Configure Kotlin in Project",回车，按照提示操作，即可添加Kotlin配置。
1. 重复第一步，调出动作查询窗口。输入“Convert Java File to Kotlin File”。即可将现有的Java文件自动转换成Kotlin文件。当然，如果只想转换某一个java文件，方法就是，打开改Java文件，然后选择菜单“ Code | Convert Java File to Kotlin File”，即可将当前打开的Java文件自动转换成Kotlin文件。 
1. 转换完成。

## 总结
根据Kotlin官网描述，Kotlin是一种适用于JVM，Android
根据个人的开发实践，总结出使用Kotlin开发Android应用的优缺点：
### 优点
1. 和Java相比，更简洁，更安全。
1. 和Java无缝集成，官网宣称kotlin可以100%和java混合使用。
1. 由jetbrains推出，Idea可以更好的进行支持。

### 缺点
1. 会将支持kotlin的相关jar包打散，打包到apk中。这部分内容最终会给apk增加700k左右的大小。这个和前面的groovy相比，情况要好很多，勉强还是可以接受的。
1. 和java相比，使用Kotlin的开发者还太少。
1. 诞生时间较晚，有待时间的检验。

### 结论
1. 使用Kotlin是可以更快，更有效地开发Android应用的。
1. 在应用于生产实践之前，还需要更多的评估，包括稳定性，运行效率，耗电量，兼容性，研发的接受程度等。


## 参考
1. [Kotlin名词解释](http://baike.baidu.com/view/9189237.htm)
1. [Kotlin官网](https://kotlinlang.org)
1. [kotlins-android-roadmap](https://blog.jetbrains.com/kotlin/2016/03/kotlins-android-roadmap/)
1. [Getting started with Android and Kotlin](https://kotlinlang.org/docs/tutorials/kotlin-android.html)
1. [Kotlin Android Extensions](https://kotlinlang.org/docs/tutorials/android-plugin.html)
1. [kotlin-examples](https://github.com/JetBrains/kotlin-examples)
1. [HelloWorld](https://github.com/snowdream/test/tree/master/android/kotlin/HelloWorld)
1. [如何评价 Kotlin 语言](http://www.zhihu.com/question/25289041)
1. [Kotlin：Android世界的Swift](http://www.infoq.com/cn/news/2015/06/Android-JVM-JetBrains-Kotlin)
1. [初见Kotlin](http://www.2gua.info/post/53)
1. [Android开发中使用kotlin你遇到过哪些坑？](http://www.zhihu.com/question/36735834)
