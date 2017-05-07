---
title:  "ToyBricks用户手册"
date: 2017-05-07 20:32:22
categories: android
tags: android
---
注：阅读本文之前，建议先阅读一下：
[ToyBricks简介以及原理分析](https://mp.weixin.qq.com/s?__biz=MzIyNTczOTYwMA==&mid=2247483911&idx=1&sn=16a661bee016146fa7ee83f15a0ea615&chksm=e87a5438df0ddd2e847a742fca7c5e31538350a1585158ee72a31f83cf4dc549aff13080c5f7#rd)

### ToyBricks简介
ToyBricks是一个Android项目模块化的解决方案，主要包括四个部分，APT注解，APT注解处理器，ToyBricks插件（Gradle Plugin）,ToyBricks库。

![ToyBricks简介](http://upload-images.jianshu.io/upload_images/66954-57bf455f0fdee874.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

其中：
1. APT注解，主要定义了两个注解：Interface（接口，例如：IText）,Implementation （实现，例如：TextImpl）
1. APT注解处理器，在javac编译java源码之前。APT注解处理器会扫描Java源码中带有上面两个注解的接口和类，并且生成一个json文件， ToyBricks.json.
1. ToyBricks插件（Gradle Plugin）,负责ToyBricks.json的打包，合并，生成Java源文件等工作
1. ToyBricks，提供对外调用方法。通过参数传入接口，返回相应的实现。

### ToyBricks特性
1. 同时支持Kotlin，Java
1. 支持Android Build Variants
1. Proguard免配置

### ToyBricks局限性
ToyBricks具有传染性。    
任何Android Application 或者 Android Library 使用包含ToyBricks.json的jar包或者aar包作为依赖，都必须继续使用ToyBricks，否则无法保证代码能正确运行。

### ToyBricks规则
**每个模块分为接口和实现两个部分。接口部分提供给模块外部调用，而实现部分则禁止来自外部的调用。**

![模块划分](http://upload-images.jianshu.io/upload_images/66954-3c4fa19a7bfca742.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**接口** 以@Interface进行注解，示例如下：
```java
@Interface
public interface IText {

    String getText();
}
```

**实现** 以@Implementation进行注解，示例如下：
```java
@Implementation(IText.class)
public class NewTextImpl implements IText {
    @Override
    public String getText() {
        return "NewTextImpl Implementation from "+ getClass().getCanonicalName();
    }
}
```

@Implementation更详细的使用方法如下：
```java
@Implementation(value = IText.class,global = true,singleton = true)
public class NewTextGobalImpl implements IText {
    @Override
    public String getText() {
        return "NewTextImpl Implementation from "+ getClass().getCanonicalName() ;
    }
}
```
参数说明如下：
1. value后面应该填写接口的class
1. global代表这个实现拥有高优先级。如果没有设置，默认取值为false。
1. singleton代表这个实现将会以单例形式存在。如果没有设置，默认取值为false。由于单例会一直存在于APP的整个生命周期，因此，不应该滥用单例。

使用ToyBricks应该遵守以下规则：
1. 接口命令强烈建议以I开头，例如：IText
1. 每一个接口都必须至少有一个相应实现，否则编译出错。
1. 每个实现类必须是public的。
1. 每个实现类必须实现注解中标明的接口。
1. 每个实现类必须拥有一个默认无参数的构造函数。
1. 每个实现类不可以是abstract抽象类。
1. 实现一共分成三类，全局实现（global=true）,普通实现(global=false),替补实现(按照默认的包名和类名进行加载)。它们的优先级从前往后一直降低。**每一类只能同时存在一个实现，否则编译出错。**
1. 替补实现遵循以下规则：       
假如接口为：com.github.snowdream.toybricks.app.IText,   
则替补实现为：com.github.snowdream.toybricks.app.impl.TextImpl      
实现的包名为接口的包名+".impl",实现的类名为接口名去掉第一个字母，第二个字母大写，然后加上"Impl"。
1. 任何发布到Maven仓库的库，都应该将global设置为false。global设置为true，只适合Android Application测试新实现，或者替换默认实现。

### ToyBricks使用方法
由于ToyBricks对Android的Gradle编译流程稍微进行了修改，因此，请注意按照下面的说明进行详细操作。
对于编译流程的修改如下：
1. Android Application模块：首先按照上面的步骤生成ToyBricks.json，然后和依赖库中的ToyBricks.json进行合并，校验，最后按照预定规则，生成InterfaceLoaderImpl.java源代码，并参与编译。
1. Android Library: 通过APT生成Json文件（ToyBricks.json，生成目录在“build/generated/source/apt”或者“build/generated/source/kapt”），然后打包到aar。如果你需要打包成jar包，并发布到maven仓库，请参考下面代码:         

```java
task androidReleaseJar(type: Jar,dependsOn: "assembleRelease") {
    from "$buildDir/intermediates/classes/release/"
    from "$buildDir/generated/source/kapt/release/ToyBricks.json"
    from "$buildDir/generated/source/apt/release/ToyBricks.json"
    exclude '**/BuildConfig.class'
    exclude '**/R.class'
    exclude '**/R$*.class'
    includeEmptyDirs false
}

task androidJavadocsJar(type: Jar) {
    classifier = 'javadoc'
    from "generateReleaseJavadoc.destinationDir"
    includeEmptyDirs false
}

task androidSourcesJar(type: Jar) {
    classifier = 'sources'
    from android.sourceSets.main.java.srcDirs
    from "$buildDir/generated/source/kapt/release/ToyBricks.json"
    from "$buildDir/generated/source/apt/release/ToyBricks.json"
    includeEmptyDirs false
}
```

#### Gradle主工程 
在主工程的build.gradle文件中添加ToyBricks的gradle插件。
```java
buildscript {
    repositories {
        jcenter()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:2.2.2'
        
        classpath 'com.github.snowdream.toybricks:android-toybricks-gradle-plugin:0.9.10'
    }
}
```

#### Android Library模块
在Library模块的build.gradle文件中添加ToyBricks的相关库依赖。
```java
kapt {
    generateStubs = true
}

dependencies {
    compile "com.github.snowdream:toybricks:0.9.10@aar"
    compile "com.github.snowdream.toybricks:annotation:0.9.10"

    kapt "com.github.snowdream.toybricks:processor:0.9.10"
    //annotationProcessor "com.github.snowdream.toybricks:processor:0.9.10"
}

apply plugin: 'com.github.snowdream.toybricks'
```

**注：** 有两种引用方式，一种是kotlin的kapt方式，需要配置上面的generateStubs。另外一种，是Android默认支持的annotationProcessor方式。

**如果你的工程中包含任何Kotlin源文件，则必须选择kapt的方式，否则，可以选择annotationProcessor方式。**

#### Android Application模块
在Application模块的build.gradle文件中添加ToyBricks的相关库依赖。
```java

kapt {
    generateStubs = true
}

dependencies {
    compile 'com.github.snowdream:annotation:0.7@aar'

    compile "com.github.snowdream:toybricks:0.9.10@aar"
    compile "com.github.snowdream.toybricks:annotation:0.9.10"

    kapt "com.github.snowdream.toybricks:processor:0.9.10"
    //annotationProcessor "com.github.snowdream.toybricks:processor:0.9.10"
}

apply plugin: 'com.github.snowdream.toybricks'
```

#### ToyBricks使用方法
通过上面的方式，开发好接口和实现模块后。只需要引用接口，就可以通过下面方式获取接口的实现：
```java
IText text = ToyBricks.getImplementation(IText.class);
```
其中，IText为接口。

#### ToyBricks最佳实践
按照替补实现的命名规则，来开发接口的实现类。


如果您对ToyBricks有什么问题或者建议，欢迎通过后面的联系方式联系我。

### 参考资料：
1. [SnowdreamFramework/ToyBricks](https://github.com/SnowdreamFramework/ToyBricks)
1. [SnowdreamFramework/log](https://github.com/SnowdreamFramework/log)

### 联系方式
* Email：yanghui1986527#gmail.com
* Github: https://github.com/snowdream
* Blog: http://snowdream.github.io/blog/
* 简书：http://www.jianshu.com/u/748f0f7e6432
* 云栖博客：https://yq.aliyun.com/u/snowdream86 
* QQ群: 529327615     
* 微信公众号:  sn0wdr1am    

![sn0wdr1am](https://static.dingtalk.com/media/lADOmAwFCs0BAs0BAg_258_258.jpg)
