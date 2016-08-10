---
title: Android项目中的Gradle Task流程可视化
date: 2016-08-10 19:23:54
categories: android
tags: [android,gradle]
---

大家在用Gradle开发Android项目的时候，想必都知道构建过程是由一个一个的任务（Task）组成的。     
那么项目中到底有那些Task呢？
```
gradle tasks --all
```
执行上面的命令，你会看到项目中定义的所有Task。

这些Task是怎样依赖的，构建过程中又是怎样的流程？

在实践过程中，我找到两个gradle插件，可以帮助我们实现流程的可视化。

## [gradle-task-tree](https://github.com/dorongold/gradle-task-tree)
gradle-task-tree可以将项目下的task依赖关系以树的形式，输出到终端。

### 引入
```
buildscript {
  repositories {
    maven {
      url "https://plugins.gradle.org/m2/"
    }
  }
  dependencies {
    classpath "gradle.plugin.com.dorongold.plugins:task-tree:1.2.2"
  }
}

apply plugin: "com.dorongold.task-tree"
```

### 使用
gradle <task 1>...<task N> taskTree --no-repeat

### 输出
结果会打印在终端。
```
:build
+--- :assemble
|    \--- :jar
|         \--- :classes
|              +--- :compileJava
|              \--- :processResources
\--- :check
     \--- :test
          +--- :classes
          |    +--- :compileJava
          |    \--- :processResources
          \--- :testClasses
               +--- :compileTestJava
               |    \--- :classes
               |         +--- :compileJava
               |         \--- :processResources
               \--- :processTestResources
```
  
## [gradle-visteg](https://github.com/mmalohlava/gradle-visteg)
gradle-visteg可以将项目下的task依赖关系以图的形式，输出到文件。    
默认是输出到.dot文件中，通过Graphviz工具可以将.dot文件转换成.png文件。   

### 引入

```
buildscript {
    repositories {
        jcenter()
    }
    dependencies {
        classpath 'cz.malohlava:visteg:1.0.0'
    }
}

apply plugin: 'cz.malohlava.visteg'
```

### 配置

```
visteg {
    enabled        = true
    colouredNodes  = true
    colouredEdges  = true
    destination    = 'build/reports/visteg.dot'
    exporter       = 'dot'
    colorscheme    = 'spectral11'
    nodeShape      = 'box'
    startNodeShape = 'hexagon'
    endNodeShape   = 'doubleoctagon'
}
```

详细配置请参考：[https://github.com/mmalohlava/gradle-visteg](https://github.com/mmalohlava/gradle-visteg)

### 使用
执行正常的task。
默认会生成build/reports/visteg.dot文件。
在ubuntu下，可以通过xdot，直接打开该文件。

通过以下命令可以转换成png图片

```
cd build/reports/
dot -Tpng ./visteg.dot -o ./visteg.dot.png
```

### 输出
task流程图
{% asset_img visteg.dot.png [task流程图] %}


## 参考
1. [https://github.com/dorongold/gradle-task-tree](https://github.com/dorongold/gradle-task-tree)
1. [https://github.com/mmalohlava/gradle-visteg](https://github.com/mmalohlava/gradle-visteg)
