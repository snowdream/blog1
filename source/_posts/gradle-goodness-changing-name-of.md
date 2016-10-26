---
title: "Gradle精选: 修改默认的Build配置文件名"
date: 2016-10-26 16:14:14
categories: gradle
tags: gradle
---
>作者：snowdream   
>Email：yanghui1986527#gmail.com    
>Github: [https://github.com/snowdream](https://github.com/snowdream)   
>QQ 群: 529327615        
>原文地址：[https://snowdream.github.io/blog/2016/10/26/gradle-goodness-changing-name-of/](https://snowdream.github.io/blog/2016/10/26/gradle-goodness-changing-name-of/)


翻译自： [http://mrhaki.blogspot.com/2014/10/gradle-goodness-changing-name-of.html](http://mrhaki.blogspot.com/2014/10/gradle-goodness-changing-name-of.html)

Gradle默认使用**build.gradle**作为默认的配置文件文件名。如果我们在**build.gradle**文件中编写代码，那么我们在运行任务的时候，不需要指定build文件名。我们也可以不使用**build.gradle**，而用另外的文件名来创建build配置文件。例如：我们可以在一个名字为**sample.gradle**的文件中编写代码。为了运行这个文件中的任务，我们需要在命令行，使用选项 -b 或者 --build-file，后面指定build文件名。但是，我们可以改变项目设置，并且设置项目的默认build文件名。这样设置，我们不需要再使用前面的命令行选项。

假设我们现在有一个build文件，**sample.gradle**:
```
// File: sample.gradle
task sample(description: 'Sample task') << {
    println 'Sample task'
}
 
defaultTasks 'sample'
```

为了运行sample任务，我们可以使用命令行选项 -b 或者 --build-file：
```
$ gradle -b sample.gradle
:sample
Sample task
 
BUILD SUCCESSFUL
 
Total time: 3.168 secs
$ gradle --build-file sample.gradle
:sample
Sample task
 
BUILD SUCCESSFUL
 
Total time: 2.148 secs
$
```

我们也可以改变项目默认的build文件名。首先，我们在项目根目录下创建项目设置文件**settings.gradle**。 在**settings.gradle**文件中，我们给**rootProject**修改属性值**buildFileName**：
```
// File: settings.gradle
// Change default build file name for this project.
rootProject.buildFileName = 'sample.gradle'
```

现在，我们执行**sample.gradle**中的任务，不再需要使用命令行选项-b 或者 --build-file了。
```
$ gradle
:sample
Sample task
 
BUILD SUCCESSFUL
 
Total time: 3.312 secs
$
```
