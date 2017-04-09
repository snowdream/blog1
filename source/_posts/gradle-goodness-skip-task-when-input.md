---
title: "Gradle精选: 当输入为空时，使用注解@SkipWhenEmpty来跳过Task"
date: 2017-04-09 23:39:37
categories: gradle
tags: gradle
---
原文： http://mrhaki.blogspot.com/2017/02/gradle-goodness-skip-task-when-input.html

Gradle 能够很好的支持增量构建。这就是说，Gradle可以根据Task的输入和输出来决定一个Task是否需要被执行。举个例子，假如输入和输出文件没有任何改变，那么这个Task将会被跳过。通过定义Task的输入和输出，可以让我们自定义的Task也支持增量构建。我们还可以定义一个Task，当它的输入文件集合／文件夹不存在或者为空时，跳过不执行。Gradle提供了一个注解@SkipWhenEmpty，我们可以应用于Task的输入。

下面的例子，我们将会定义一个DisplayTask，用于打印一个文件夹下所有文件的内容。当这个文件夹为空时，我们希望跳过这个Task，不执行。

```
task display(type:DisplayTask) {
    contentDir = file('src/content')
}
 
class DisplayTask extends DefaultTask {
 
    @SkipWhenEmpty
    @InputDirectory
    File contentDir
 
    DisplayTask() {
        description = 'Show contents of files'
    }
 
    @TaskAction
    void printMessages() {
        contentDir.eachFile { file ->
            println file.text
        }
    }
 
}
```

当输入文件夹下没有任何文件时，我们运行这个Task，将会在终端看到 NO-SOURCE 字样。如果我们不添加这个注解@SkipWhenEmpty，这个构建任务将会失败。

```
$ gradle display
:display NO-SOURCE
 
BUILD SUCCESSFUL
 
Total time: 0.866 secs
```

接下来，我们在这个文件夹（src/content）下添加一个文件，然后再次运行这个Task：
```
$ gradle display
:display
Gradle rocks!
 
 
BUILD SUCCESSFUL
 
Total time: 0.866 secs
```

使用Gradle 3.4编写。

## 联系方式
* Email：yanghui1986527#gmail.com
* Github: https://github.com/snowdream
* Blog: http://snowdream.github.io/blog/
* 简书：http://www.jianshu.com/u/748f0f7e6432
* 云栖博客：https://yq.aliyun.com/u/snowdream86 
* QQ群: 529327615     
* 微信公众号:  sn0wdr1am    

![sn0wdr1am](https://static.dingtalk.com/media/lADOmAwFCs0BAs0BAg_258_258.jpg)
