---
title: 使用Groovy开发Android应用
date: 2016-08-12 09:52:50
categories: android
tags: [android,groovy]
---
>作者：snowdream
>Email：yanghui1986527#gmail.com
>QQ 群: 529327615      
>原文地址：[https://snowdream.github.io/blog/2016/08/12/android-develop-with-groovy/](https://snowdream.github.io/blog/2016/08/12/android-develop-with-groovy/)

## 目标
本文旨在引导开发者使用Groovy来开发Android应用。

## 简介
### 名词解释
#### Groovy
Groovy是一种基于JVM（Java虚拟机）的敏捷开发语言，它结合了Python、Ruby和Smalltalk的许多强大的特性，Groovy 代码能够与 Java 代码很好地结合，也能用于扩展现有代码。由于其运行在 JVM 上的特性，Groovy 可以使用其他 Java 语言编写的库。  

官方网站：[http://www.groovy-lang.org/](http://www.groovy-lang.org/)

Github仓库:[https://github.com/apache/groovy](https://github.com/apache/groovy)

#### Gradle
Gradle是一个开源的自动化构建工具，主要用于持续发布（Continuous Delivery）。
Gradle主要基于Java和Groovy开发,用于支持多种开发语言和开发平台的自动化构建，包括Java, Scala, Android, C/C++, 和 Groovy, 并且可以无缝集成在Eclipse, IntelliJ, and Jenkins等开发工具和持续集成服务中。

官方网站：[https://gradle.org/](https://gradle.org/)

Github仓库:[https://github.com/gradle/gradle](https://github.com/gradle/gradle)

#### Groovy with Android
groovy-android-gradle-plugin是一款由groovy推出的插件，主要用于支持使用groovy来开发android应用。

Github仓库: [groovy-android-gradle-plugin](https://github.com/groovy/groovy-android-gradle-plugin)

实例展示:
[https://github.com/snowdream/test/tree/master/android/groovy/HelloWorld](https://github.com/snowdream/test/tree/master/android/groovy/HelloWorld)


## 教程
本节介绍使用Groovy开发android应用，主要分两种：
一种是只使用Groovy来开发，另外一种是混合使用Groovy和Java来开发。

至于Groovy语言的语法和教程等，不在本文讨论范围，请参考官网文档和网上的开发教程。

以下几点需要谨记：
1. 所有Groovy类文件，以.groovy为后缀。
1. 任何新建的Groovy类，请在类的头部加上注解：@CompileStatic .具体原因请移步：[Melix's blog ](http://melix.github.io/blog/2014/06/grooid.html)和 [here for more technical details
](http://melix.github.io/blog/2014/06/grooid2.html)
1. Groovy的源码目录规则和默认的是一样的。分别放在src/main/groovy, src/test/groovy, src/androidTest/groovy 和任意的src/${buildVariant}/groovy。
1. Groovy的源码目录可以在build.gradle文件中自定义，定义规则如下：
```groovy
androidGroovy {
  sourceSets {
    main {
      groovy {
        srcDirs += 'src/main/java'
      }
    }
  }
}
```
为了让Android Studio识别这些自定义目录为源码目录，可能还需要在android插件的sourceSets中再添加一遍。

### Groovy
仅仅使用Groovy来开发android，步骤比较简单。
1.在项目根目录下的build.gradle文件中添加以下代码：
```
buildscript {
    repositories {
        jcenter()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:2.1.2'
        classpath 'org.codehaus.groovy:groovy-android-gradle-plugin:1.0.0'
    }
}
```

2.在模块目录下的build.gradle文件中添加以下代码：
```
apply plugin: 'groovyx.android'
dependencies {
    compile 'org.codehaus.groovy:groovy:2.4.6:grooid'
}
```

3.配置完成，你可以在src/main/groovy目录下愉快地使用Groovy来写Android应用了。

实例展示：[https://github.com/groovy/groovy-android-gradle-plugin/tree/master/groovy-android-sample-app](https://github.com/groovy/groovy-android-gradle-plugin/tree/master/groovy-android-sample-app)


### Groovy and Java
仅仅使用Groovy来开发android，步骤也比较简单。

1.这一步，和上面的一样。
2.在模块目录下的build.gradle文件中添加以下代码：

```
apply plugin: 'groovyx.android'


androidGroovy {
    skipJavaC = true

    sourceSets {
        main {
            groovy {
                srcDirs += 'src/main/java'
            }
        }
    }

    options {
        configure(groovyOptions) {
            encoding = 'UTF-8'
            forkOptions.jvmArgs = ['-noverify'] // maybe necessary if you use Google Play Services
            javaAnnotationProcessing = true
        }
        sourceCompatibility = '1.7' // as of 0.3.9 these are automatically set based off the android plugin's
        targetCompatibility = '1.7'
    }
}

dependencies {
    compile 'org.codehaus.groovy:groovy:2.4.6:grooid'
}
```
3.配置完成，你既可以在src/main/groovy下写Groovy类，也可以在src/main/java下写Java类。


实例展示：[https://github.com/snowdream/test/tree/master/android/groovy/HelloWorld](https://github.com/snowdream/test/tree/master/android/groovy/HelloWorld)


#### 注意事项

1.引用使用groovy开发的lib时，需要排除groovy的jar包。       

例如：引用groovy-xml库，操作如下：

```
compile ('org.codehaus.groovy:groovy-xml:2.4.3') {
    exclude group: 'org.codehaus.groovy'
}
```

2.Groovy编译选项在androidGroovy块下的options块进行编写。

```
androidGroovy {
  options {
    configure(groovyOptions) {
      encoding = 'UTF-8'
      forkOptions.jvmArgs = ['-noverify'] // maybe necessary if you use Google Play Services
    }
    sourceCompatibility = '1.7' // as of 0.3.9 these are automatically set based off the android plugin's
    targetCompatibility = '1.7'
  }
}
```

3.如果需要在java文件中引用Groovy文件内容，需要将所有源码文件使用groovyc来编译，而不要通过javac编译。

```
androidGroovy {
  skipJavaC = true
}
```

4.如果需要用到注解(annoation)，还需要作如下设置：

```
androidGroovy {
  options {
    configure(groovyOptions) {
      javaAnnotationProcessing = true
    }
  }
}
```
注： 这一步，首先要确保第三步已经设置skipJavaC = true.

5.如果需要用到Data Binding，需要用到一个插件[https://bitbucket.org/hvisser/android-apt](https://bitbucket.org/hvisser/android-apt)

更多配置，请参考： [groovy-android-gradle-plugin](https://github.com/groovy/groovy-android-gradle-plugin)

## 总结
根据个人的开发实践，总结出使用Groovy开发Android应用的优缺点：
### 优点
1. 引入Groovy的诸多特性，包括闭包，函数式编程，静态编译，DSL等。
1. 和Java无缝集成，可以平滑过渡。

### 缺点
1. 会将支持Groovy的相关jar包打散，打包到apk中。这部分内容最终会给apk增加2～3M的大小。这个目前看来是硬伤，希望以后能够精简一下。
1. 会将一些License文件打包到apk中，这个可以通过android开发插件的packagingOptions进行过滤，问题不大。
1. 和java相比，使用Groovy的开发者还太少。
1. 中文文档少，主要是官方英文文档。

### 结论
1. 使用Groovy是可以开发Android应用的。
1. 在应用于生产实践之前，还需要更多的评估，包括稳定性，运行效率，耗电量，兼容性，研发的接受程度等。


## 参考
1. [Groovy现在可运行于Android平台](http://www.infoq.com/cn/news/2014/06/groovy-android)
1. [groovy-android-gradle-plugin](https://github.com/groovy/groovy-android-gradle-plugin)
1. [groovy-android-helloworld](https://github.com/snowdream/test/tree/master/android/groovy/HelloWorld)
1. [Groovy官网](http://www.groovy-lang.org/)
1. [Groovy名词解释](http://baike.baidu.com/view/707298.htm)
1. [Java之外，选择Scala还是Groovy？](http://www.infoq.com/cn/news/2008/01/scala_or_groovy)
1. [http://www.groovy-lang.org/](http://www.groovy-lang.org/)
1. [https://gradle.org/](https://gradle.org/)
