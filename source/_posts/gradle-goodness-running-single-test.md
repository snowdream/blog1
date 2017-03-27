---
title: "Gradle精选: 运行单个单元测试"
date: 2017-03-27 21:53:17
categories: gradle
tags: gradle
---
在Gradle下，我们可以通过由Java插件添加的测试任务，来运行单元测试代码。默认情况下，项目下的所有单元测试代码都会执行。但是，如果我们只想运行一个简单的单元测试，我们可以通过Java系统属性test.single来制定这个单元测试的名字。实际上，系统属性的样式是`taskName.single`. 其中`taskName`是项目下测试类任务的名称。下面我们将展示在构建中如何实践的：

首先，我们创建一个简单的build.gradle文件，用来运行单元测试。
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
        // Show that tests are run in the command-line output
        events 'started', 'passed'
    }
}
```

下一步，我们创建两个测试类，每个测试类包含一个简单的单元测试方法。稍后，我们会演示，如何运行其中的一个单元测试。


```
// File: src/test/java/com/mrhaki/gradle/SampleTest.java
package com.mrhaki.gradle;
 
import static org.junit.Assert.*;
import org.junit.*;
 
public class SampleTest {
 
    @Test public void sample() {
        assertEquals("Gradle is gr8", "Gradle is gr8");
    }
     
}
```

```
// File: src/test/java/com/mrhaki/gradle/AnotherSampleTest.java
package com.mrhaki.gradle;
 
import static org.junit.Assert.*;
import org.junit.*;
 
public class AnotherSampleTest {
 
    @Test public void anotherSample() {
        assertEquals("Gradle is great", "Gradle is great");
    }
}
```

为了只运行SampleTest，我们需要在终端执行test任务的时候，添加一个Java系统属性 `-Dtest.single=Sample`：
```
$ gradle -Dtest.single=Sample test
:compileJava UP-TO-DATE
:processResources UP-TO-DATE
:classes UP-TO-DATE
:compileTestJava
:processTestResources UP-TO-DATE
:testClasses
:test
 
com.mrhaki.gradle.SampleTest > sample STARTED
 
com.mrhaki.gradle.SampleTest > sample PASSED
 
BUILD SUCCESSFUL
 
Total time: 11.404 secs
```

请注意，现在只有一个单元测试执行了。Gradle将会获取Sample的值，并且按照下面的样式 `**/<Java system property value=Sample>*.class`去查找单元测试类。因此，我们不需要输入单元测试的完整包名和类名。而为了仅仅执行AnotherSampleTest单元测试类，我们可以通过改变这个Java系统属性（test.single）来实现：

```
$ gradle -Dtest.single=AnotherSample test
:compileJava UP-TO-DATE
:processResources UP-TO-DATE
:classes UP-TO-DATE
:compileTestJava
:processTestResources UP-TO-DATE
:testClasses UP-TO-DATE
:test
 
com.mrhaki.gradle.AnotherSampleTest > anotherSample STARTED
 
com.mrhaki.gradle.AnotherSampleTest > anotherSample PASSED
 
BUILD SUCCESSFUL
 
Total time: 5.62 secs
```

我们还可以使用Java系统样式来执行多个单元测试。例如：我们可以使用`*Sample`来同时运行 SampleTest 和A notherSampleTest。

```
$ gradle -Dtest.single=*Sample test
:compileJava UP-TO-DATE
:processResources UP-TO-DATE
:classes UP-TO-DATE
:compileTestJava
:processTestResources UP-TO-DATE
:testClasses UP-TO-DATE
:test
 
com.mrhaki.gradle.AnotherSampleTest > anotherSample STARTED
 
com.mrhaki.gradle.AnotherSampleTest > anotherSample PASSED
 
com.mrhaki.gradle.SampleTest > sample STARTED
 
com.mrhaki.gradle.SampleTest > sample PASSED
 
BUILD SUCCESSFUL
 
Total time: 5.605 secs
```

为了展示对于其他类型的测试任务，这种Java系统属性都有效。我们在build.gradle 文件中添加了一个新的任务。我们命名这个测试任务为sampleTest，包含了我们所有的测试类。我们同样应用了和之前一样的testLogging设置，方便跟踪单元测试输出结果。
```
// File: build.gradle
apply plugin: 'java'
 
repositories {
    mavenCentral()
}
 
dependencies {
    testCompile 'junit:junit:[4,)'
}
 
task sampleTest(type: Test, dependsOn: testClasses) {
    include '**/*Sample*'
}
 
tasks.withType(Test) {
    testLogging {
        events 'started', 'passed'
    }
}
```

下面我们值运行SampleTest测试类，但是我们换一种方式使用Java系统属性 `-DsampleTest.single=S*`: 
```
$ gradle -DsampleTest.single=S* sampleTest
:compileJava UP-TO-DATE
:processResources UP-TO-DATE
:classes UP-TO-DATE
:compileTestJava UP-TO-DATE
:processTestResources UP-TO-DATE
:testClasses UP-TO-DATE
:sampleTest
 
com.mrhaki.gradle.SampleTest > sample STARTED
 
com.mrhaki.gradle.SampleTest > sample PASSED
 
BUILD SUCCESSFUL
 
Total time: 10.677 secs
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
