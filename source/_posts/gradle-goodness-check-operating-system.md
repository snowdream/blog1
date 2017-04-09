---
title: "Gradle精选: 在构建脚本中检测操作系统"
date: 2017-04-10 00:15:27
categories: gradle
tags: gradle
---
原文： http://mrhaki.blogspot.com/2017/02/gradle-goodness-check-operating-system.html

有时候，我们想检测下构建脚本在哪个操作系统上执行。举个例子，比如我们有一些Task，需要在Windows操作系统上执行，但是不在其他操作系统上执行。Gradle有一个内部的类`org.gradle.nativeplatform.platform.internal.DefaultOperatingSystem`，但是我们不应该在构建脚本中使用这个类。Gradle在内部使用这个类，并且可能毫无警告地修改它。如果我们依赖这个类，一旦这个类被修改了，我们的构建脚本可能无法正常运行。但是，我们可以使用一个来自Ant的类（`org.apache.tools.ant.taskdefs.condition.Os`）。这个类包含各种方法和变量，来检测操作系统名称，版本和架构。 这些取值都基于Java的系统变量，包括os.name, os.version 和 os.arch.

在下面的例子中，为了我们稍后能够直接调用这个类的方法和引用这个类的常量，我们在构建脚本中静态引入这个Os类。 我们添加了几个基于onlyif条件的Task。只有当onlyif条件为true时，Task才会被执行。Task osInfo则简单显示了当前操作系统的一些属性值：

```
// File: build.gradle
import static org.apache.tools.ant.taskdefs.condition.Os.*
 
task os {
    description 'Run all conditional os tasks'
}
 
// Create 3 tasks that simply print
// the task name that is executed
// if the build scripts runs on the
// recognized operating system.
[FAMILY_WINDOWS, FAMILY_UNIX, FAMILY_MAC].each { osName ->
 
    // Create task.
    tasks.create(osName) {
        description "Run when OS is ${osName}"
 
        // Add condition to check operating system.
        onlyIf { isFamily(osName) }
 
        doLast {
            println "Execute task '${it.name}'"
        }
    }
 
    // Add task as dependency for the os task.
    os.dependsOn osName
}
 
 
task osInfo {
    description 'Show information about the operating system'
    doLast {
        println "Family:       ${OS_NAME}"
        println "Version:      ${OS_VERSION}"
        println "Architecture: ${OS_ARCH}"
    }
}
```

接下来，让我们在MacOS上运行这些Task： os and osInfo
```
$ gradle os osInfo
mac
Execute task 'mac'
:unix
Execute task 'unix'
:windows SKIPPED
:os
:osInfo
Family:       mac os x
Version:      10.12.3
Architecture: x86_64
 
BUILD SUCCESSFUL
 
Total time: 0.697 secs
```

基于Gradle 3.3编写。

## 联系方式
* Email：yanghui1986527#gmail.com
* Github: https://github.com/snowdream
* Blog: http://snowdream.github.io/blog/
* 简书：http://www.jianshu.com/u/748f0f7e6432
* 云栖博客：https://yq.aliyun.com/u/snowdream86 
* QQ群: 529327615     
* 微信公众号:  sn0wdr1am    

![sn0wdr1am](https://static.dingtalk.com/media/lADOmAwFCs0BAs0BAg_258_258.jpg)
