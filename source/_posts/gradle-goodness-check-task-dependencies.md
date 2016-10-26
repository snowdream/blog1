---
title: "Gradle精选: 通过模拟运行检查Task依赖"
date: 2016-10-26 18:20:56
categories: gradle
tags: gradle
---
>作者：snowdream   
>Email：yanghui1986527#gmail.com    
>Github: [https://github.com/snowdream](https://github.com/snowdream)   
>QQ 群: 529327615        
>原文地址：[https://snowdream.github.io/blog/2016/10/26/gradle-goodness-check-task-dependencies/](https://snowdream.github.io/blog/2016/10/26/gradle-goodness-check-task-dependencies/)


翻译自： [http://mrhaki.blogspot.com/2014/11/gradle-goodness-check-task-dependencies.html](http://mrhaki.blogspot.com/2014/11/gradle-goodness-check-task-dependencies.html)

我们可以运行Gradle的任务，但是不实际执行动作。这就是所谓的模拟运行。我们可以通过模拟运行来查看，我们定义的任务依赖关系是否正确。因为，我们在进行模拟运行时，我们可以看到所有的任务和任务依赖关系输出日志。

例如，我们定义了一个简单的build文件，包含三个任务和一些任务依赖关系:
```
def printTaskNameAction = {
    println "Running ${it.name}"
}
 
task first << printTaskNameAction
 
task second(dependsOn: first) << printTaskNameAction
 
task third(dependsOn: [first, second]) << printTaskNameAction
```

我们通过添加命令行选项 -m or --dry-run来进行模拟运行。因此，我们这样执行第三个任务：
```
$ gradle -m third
:first SKIPPED
:second SKIPPED
:third SKIPPED
 
BUILD SUCCESSFUL
 
Total time: 2.242 secs
$
```

我们在输出中可以看到，没有任何任务是实际被执行的，在输出日志中显示SKIPPED，但是我们可以看到所有被执行任务的名字。
