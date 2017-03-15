---
title: "Gradle精选: 关于运行失败的单元测试CASE，显示更多相关信息"
date: 2017-03-15 18:17:38
categories: gradle
tags: gradle
---
在Gradle中运行单元测试很简单。一般情况下，如果有一个单元测试CASE执行失败，也会导致构建失败。但是我们却不能立刻在控制台看到为什么这个单元测试失败。我们需要先打开生成的HTML格式的测试报告。现在我们还有其他办法。

首先，我们创建一个下面的Gradle build文件：
```
// File: build.gradle
apply plugin: 'java'
 
repositories {
    mavenCentral()
}
 
dependencies {
    testCompile 'junit:junit:[4,)'
}
```
然后，我们使用下面的Junit单元测试。注意，这个单元测试一直会失败，因为这就是我们想要的CASE场景。
```
// File: src/test/java/com/mrhaki/gradle/SampleTest.java
package com.mrhaki.gradle;
 
import org.junit.*;
 
public class SampleTest {
 
    @Test public void sample() {
        Assert.assertEquals("Gradle is gr8", "Gradle is great");
    }
     
}
```

我们通过执行test任务，来运行单元测试。如果我们运行这个任务，我们发现控制台显示哪一行单元测试失败了，但是我们却看不到单元测试失败的具体原因:
```
$ gradle test
:compileJava UP-TO-DATE
:processResources UP-TO-DATE
:classes UP-TO-DATE
:compileTestJava
:processTestResources UP-TO-DATE
:testClasses
:test
 
com.mrhaki.gradle.SampleTest > sample FAILED
    org.junit.ComparisonFailure at SampleTest.java:8
 
1 test completed, 1 failed
:test FAILED
 
FAILURE: Build failed with an exception.
 
* What went wrong:
Execution failed for task ':test'.
> There were failing tests. See the report at: file:///Users/mrhaki/Projects/mrhaki.com/blog/posts/samples/gradle/testlogging/build/reports/tests/index.html
 
* Try:
Run with --stacktrace option to get the stack trace. Run with --info or --debug option to get more log output.
 
BUILD FAILED
 
Total time: 4.904 secs
```

我们可以再次运行test任务，但是现在我们通过添加命令行选项-i 或者 --info来设置Gradle日志级别到info。现在我们可以在终端看到单元测试失败的具体原因了。
```
$ gradle test -i
Starting Build
Settings evaluated using empty settings script.
Projects loaded. Root project using build file
...
Successfully started process 'Gradle Worker 1'
Gradle Worker 1 executing tests.
Gradle Worker 1 finished executing tests.
 
com.mrhaki.gradle.SampleTest > sample FAILED
    org.junit.ComparisonFailure: expected:<gradle is gr[8]> but was:<gradle is gr[eat]>
        at org.junit.Assert.assertEquals(Assert.java:115)
        at org.junit.Assert.assertEquals(Assert.java:144)
        at com.mrhaki.gradle.SampleTest.sample(SampleTest.java:8)
Process 'Gradle Worker 1' finished with exit value 0 (state: SUCCEEDED)
 
1 test completed, 1 failed
Finished generating test XML results (0.025 secs)
Generating HTML test report...
Finished generating test html results (0.027 secs)
:test FAILED
 
FAILURE: Build failed with an exception.
 
* What went wrong:
Execution failed for task ':test'.
> There were failing tests. See the report at: file:///Users/mrhaki/Projects/mrhaki.com/blog/posts/samples/gradle/testlogging/build/reports/tests/index.html
 
* Try:
Run with --stacktrace option to get the stack trace. Run with --debug option to get more log output.
 
BUILD FAILED
 
Total time: 5.117 secs
```


但是这样做仍然会产生很多干扰的日志。最好的办法就是通过配置test任务来自定义单元测试日志级别。我们可以配置不同的日志级别。为了获取单元测试失败的具体原因我们可以仅仅将exceptionFormat设置为full。示例如下：
```
// File: build.gradle
apply plugin: 'java'
 
repositories {
    mavenCentral()
}
 
dependencies {
    testCompile 'junit:junit:[4,)'
}
 
test {
    testLogging {
        exceptionFormat = 'full'
    }
}
```

我们可以再次运行test任务，并且使用正常的日志级别，但是这次，我们依然能够看到单元测试失败的具体原因，而没有其他的干扰日志。
```
$ gradle test
:compileJava UP-TO-DATE
:processResources UP-TO-DATE
:classes UP-TO-DATE
:compileTestJava UP-TO-DATE
:processTestResources UP-TO-DATE
:testClasses UP-TO-DATE
:test
 
com.mrhaki.gradle.SampleTest > sample FAILED
    org.junit.ComparisonFailure: expected:<gradle is gr[8]> but was:<gradle is gr[eat]>
        at org.junit.Assert.assertEquals(Assert.java:115)
        at org.junit.Assert.assertEquals(Assert.java:144)
        at com.mrhaki.gradle.SampleTest.sample(SampleTest.java:8)
 
1 test completed, 1 failed
:test FAILED
 
FAILURE: Build failed with an exception.
 
* What went wrong:
Execution failed for task ':test'.
> There were failing tests. See the report at: file:///Users/mrhaki/Projects/mrhaki.com/blog/posts/samples/gradle/testlogging/build/reports/tests/index.html
 
* Try:
Run with --stacktrace option to get the stack trace. Run with --info or --debug option to get more log output.
 
BUILD FAILED
 
Total time: 5.906 secs
```
实例使用 Gradle 1.6 编写。

## 联系方式
* Email：yanghui1986527#gmail.com
* Github: https://github.com/snowdream
* Blog: http://snowdream.github.io/blog/
* 简书：http://www.jianshu.com/u/748f0f7e6432
* 云栖博客：https://yq.aliyun.com/u/snowdream86 
* QQ群: 529327615     
* 微信公众号:  sn0wdr1am    

![sn0wdr1am](https://static.dingtalk.com/media/lADOmAwFCs0BAs0BAg_258_258.jpg)
