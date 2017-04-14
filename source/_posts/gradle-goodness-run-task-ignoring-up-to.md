---
title: "Gradle精选: 忽略Up-to-date检查，强制执行Task"
date: 2017-04-11 21:01:48
categories: gradle
tags: gradle
---
原文：http://mrhaki.blogspot.com/2016/12/gradle-goodness-run-task-ignoring-up-to.html

Gradle构建很快，是因为支持增量任务。简单来说，Gradle可以在运行Task前，就知道Task的输入和输出是否改变。如果什么都没有改变，那么这个Task将会被标记为up-to-date，并且不会被执行，否则则会被执行。如果不管一个Task是否是up-to-date，我们都希望能够运行它，此时我们需要增加一个命令行选项`--rerun-tasks`。

在下面的例子中，我们为一个简单的Java工程，运行assemble任务，可以看到所有的task都运行了。当我们再次运行此Task的时候，我们看到所有的task都提示“up-to-date”：
```
$ gradle assemble
 
:compileJava
:processResources
:classes
:jar
:assemble
 
BUILD SUCCESSFUL
 
Total time: 1.765 secs
$ gradle assemble
 
:compileJava UP-TO-DATE
:processResources UP-TO-DATE
:classes UP-TO-DATE
:jar UP-TO-DATE
:assemble UP-TO-DATE
 
BUILD SUCCESSFUL
 
Total time: 0.715 secs
$
```

为了忽略up-to-date检查，强制执行所有task，我们需要添加这个选项 --rerun-tasks：
```
$ gradle --rerun-tasks assemble
:compileJava
:processResources
:classes
:jar
:assemble
 
BUILD SUCCESSFUL
 
Total time: 1.037 secs
$
```

基于Gradle 3.2.1编写。






## 联系方式
* Email：yanghui1986527#gmail.com
* Github: https://github.com/snowdream
* Blog: http://snowdream.github.io/blog/
* 简书：http://www.jianshu.com/u/748f0f7e6432
* 云栖博客：https://yq.aliyun.com/u/snowdream86 
* QQ群: 529327615     
* 微信公众号:  sn0wdr1am    

![sn0wdr1am](https://static.dingtalk.com/media/lADOmAwFCs0BAs0BAg_258_258.jpg)
