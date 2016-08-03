---
title: Android最佳Mock单元测试方案:Junit + Mockito + Powermock
date: 2016-08-03 11:34:09
categories: android
tags: [android,test]
---

本文旨在从实践出发，引导开发者在Android项目中进行Mock单元测试。

## 什么是单元测试
单元测试由一组独立的测试构成，每个测试针对软件中的一个单独的程序单元。单元测试并非检查程序单元之间是否能够合作良好，而是检查单个程序单元行为是否正确。

## 为什么要进行单元测试
在敏捷开发大行其道的今天，由于时间紧，任务重，过分依赖测试工程师以及下列原因，导致单元测试不被重视，在开发流程中处于一个可有可无的尴尬境地。
1. 浪费的时间太多
1. 软件开发人员不应参与单元测试
1. 我是很棒的程序员，不需要进行单元测试
1. 不管怎样，集成测试将会抓住所有的Bug
1. 单元测试效率不高

那么单元测试是否正的可有可无呢？No! No! No! 

1. 作为android客户端研发，在一个开发周期内，你负责的需求需要Web服务（API），和本地代码（JNI，Native Code）的支持，而你们的工作是同时进行的。
1. 你的需求开发完成了，但是由于需要在特定条件下才能触发，而这些条件在开发过程中很难去模拟，导致需求无法在所有场景下进行充分测试。举个例子，假设你在室内开发一个地图导航的Android应用，你需要在导航过程中，前方出现车祸，积水，施工等多种状况，怎么办？
1. 总结你过去的BUG，你会发现有些你以为写的很完善的逻辑，却在最后被发现有场景未覆盖，或者逻辑错误等问题。
1. 测试工程师给你报了一个BUG，你改完提交了，但是之后由于Merge失误导致代码丢失，或者其他人的修改导致你的BUG再次出现。直到测试工程师再次发现该BUG，并再次给你提出。
1. 你的开发进度很快，但是开发完成后，你会被BUG淹没。你持续不断的修改BUG，持续不断的加班，直至发布版本，身心俱疲。
1. 以前明明很正常的功能，在本次开发周期内，突然不能正常使用了。
...

如果你也经常碰到以上问题，或者困扰，那么你需要持续不断的对项目进行**单元测试**。

## Android单元测试简介
Android的单元测试分为两大类：  

1.Instrumentation

通过Android系统的Instrumentation测试框架，我们可以编写测试代码，并且打包成APK，运行在Android手机上。

**优点**： 逼真  
**缺点**： 很慢

**代表框架**：JUnit(Android自带),espresso


2.JUnit / Mock

通过JUnit，以及第三方测试框架，我们可以编写测试代码，生成class文件，直接运行在JVM虚拟机中。

**优点**： 很快。使用简单，方便。    
**缺点**： 不够逼真。比如有些硬件相关的问题，无法通过这些测试出来。

**代表框架**： JUnit(标准),Robolectric, mockito, powermock

## Android最佳Mock单元测试方案
我通过对比前辈们对各种单元测试框架的实践，总结出Android最佳Mock单元测试方案: Junit + Mockito + Powermock.（自己认证的...）

### Junit + Mockito + Powermock 简介
众所周知，Junit是一个简单的单元测试框架。     
Mockito，则是一个简单的用于Mock的单元测试框架。   
 
那么为什么还需要Powermock呢？    
**EasyMock和Mockito等框架，对static, final, private方法均是不能mock的。**   
这些框架普遍是通过创建Proxy的方式来实现的mock。 而PowerMock是使用CGLib来操纵字节码而实现的mock，所以它能实现对上面方法的mock。


### Junit + Mockito + Powermock 引入

由于PowerMock对Mockito有较强依赖，因此需要按照以下表格采用对应的版本。

|Mockito	| PowerMock|
| ------------- |:-------------:|
|2.0.0-beta - 2.0.42-beta	|1.6.5+|
|1.10.8 - 1.10.x|	1.6.2+|
|1.9.5-rc1 - 1.9.5	|1.5.0 - 1.5.6|
|1.9.0-rc1 & 1.9.0|	1.4.10 - 1.4.12|
|1.8.5	|1.3.9 - 1.4.9|
|1.8.4|	1.3.7 & 1.3.8|
|1.8.3	|1.3.6|
|1.8.1 & 1.8.2|	1.3.5|
|1.8|	1.3|
|1.7	|1.2.5|

建议方案：    
在项目依赖文件build.gradle中添加以下依赖。

```groovy
testCompile 'junit:junit:4.11'
// required if you want to use Mockito for unit tests
testCompile 'org.mockito:mockito-core:1.9.5'
// required if you want to use Powermock for unit tests
testCompile 'org.powermock:powermock-module-junit4:1.5.6'
testCompile 'org.powermock:powermock-module-junit4-rule:1.5.6'
testCompile 'org.powermock:powermock-api-mockito:1.5.6'
```


### Junit + Mockito + Powermock 配置
1. 默认的测试代码位置   
对于通过gradle构建的android项目，在默认的项目结构中，Instrumentation的测试代码放在
src/androidTest/ 目录，而JUnit / Mock的测试代码放在 src/test/ 目录。
1. 自定义测试代码位置
有些项目是由Eclipse构建迁移到由Gradle构建，需要自定义测试代码位置。
举个例子，androidTest和test目录都在项目的根文件夹下。我们需要这样配置：
```groovy
android {  
  sourceSets {
    test {
      java.srcDir 'test'
    }
    androidTest {
      java.srcDir 'androidTest'
    }
  }
}
```


如果在单元测试中遇到类似"Method ... not mocked."的问题，请添加以下设置：
```groovy
android {
  // ...
  testOptions { 
    unitTests.returnDefaultValues = true
  }
}
```

### Junit + Mockito + Powermock 使用
强烈建议你熟读以下内容，来熟悉Junit + Mockito + Powermock的使用。
1. [Mockito 中文文档 ( 2.0.26 beta )](https://github.com/hehonghui/mockito-doc-zh)
1. [Mockito reference documentation](http://site.mockito.org/mockito/docs/current/org/mockito/Mockito.html)
1. [powermock wiki](https://github.com/jayway/powermock/wiki)
1. [Unit tests with Mockito - Tutorial](http://www.vogella.com/tutorials/Mockito/article.html)

下面通过举例来简单说明Junit + Mockito + Powermock 使用，更多详情清参考Demo项目：
[https://github.com/snowdream/test/tree/master/android/test/mocktest](https://github.com/snowdream/test/tree/master/android/test/mocktest)

源码： [https://github.com/snowdream/test/blob/master/android/test/mocktest/app/src/main/java/snowdream/github/com/mocktest/Calc.java](https://github.com/snowdream/test/blob/master/android/test/mocktest/app/src/main/java/snowdream/github/com/mocktest/Calc.java)

测试代码：[https://github.com/snowdream/test/blob/master/android/test/mocktest/app/src/test/java/snowdream/github/com/mocktest/CalcUnitTest.java](https://github.com/snowdream/test/blob/master/android/test/mocktest/app/src/test/java/snowdream/github/com/mocktest/CalcUnitTest.java)

1.验证某些行为,主要是验证某些函数是否被调用，以及被调用的具体次数。  

```java
//using mock
mockedList.add("once");

mockedList.add("twice");
mockedList.add("twice");

mockedList.add("three times");
mockedList.add("three times");
mockedList.add("three times");

//following two verifications work exactly the same - times(1) is used by default
// 下面的两个验证函数效果一样,因为verify默认验证的就是times(1)
verify(mockedList).add("once");
verify(mockedList, times(1)).add("once");

//exact number of invocations verification
// 验证具体的执行次数
verify(mockedList, times(2)).add("twice");
verify(mockedList, times(3)).add("three times");

//verification using never(). never() is an alias to times(0)
// 使用never()进行验证,never相当于times(0)
verify(mockedList, never()).add("never happened");

//verification using atLeast()/atMost()
// 使用atLeast()/atMost()
verify(mockedList, atLeastOnce()).add("three times");
verify(mockedList, atLeast(2)).add("five times");
verify(mockedList, atMost(5)).add("three times");
```
2.验证执行顺序，主要验证某些函数是否按照预定顺序执行。
```java
// A. Single mock whose methods must be invoked in a particular order
// A. 验证mock一个对象的函数执行顺序
List singleMock = mock(List.class);

//using a single mock
singleMock.add("was added first");
singleMock.add("was added second");

//create an inOrder verifier for a single mock
// 为该mock对象创建一个inOrder对象
InOrder inOrder = inOrder(singleMock);

//following will make sure that add is first called with "was added first, then with "was added second"
// 确保add函数首先执行的是add("was added first"),然后才是add("was added second")
inOrder.verify(singleMock).add("was added first");
inOrder.verify(singleMock).add("was added second");

// B. Multiple mocks that must be used in a particular order
// B .验证多个mock对象的函数执行顺序
List firstMock = mock(List.class);
List secondMock = mock(List.class);

//using mocks
firstMock.add("was called first");
secondMock.add("was called second");

//create inOrder object passing any mocks that need to be verified in order
// 为这两个Mock对象创建inOrder对象
InOrder inOrder = inOrder(firstMock, secondMock);

//following will make sure that firstMock was called before secondMock
// 验证它们的执行顺序
inOrder.verify(firstMock).add("was called first");
inOrder.verify(secondMock).add("was called second");

// Oh, and A + B can be mixed together at will

```

3.使用powermock必须使用两个annotation：
```java
@RunWith(PowerMockRunner.class)
@PrepareForTest({Calc.class})
public class CalcUnitTest {
}
//PrepareForTest 后面要加准备被mock或stub的类，单个class直接()起来即可，多个用{}，并用逗号隔开。
```

4.测试公开成员变量
```java
@Test
public void testPublicField() {
    assertEquals(mCalc.mPublicField, 0);
    assertEquals(mCalc.mPublicFinalField, 0);
    assertEquals(Calc.mPublicStaticField, 0);
    assertEquals(Calc.mPublicStaticFinalField, 0);

    mCalc.mPublicField = 1;
    Calc.mPublicStaticField = 2;

    assertEquals(mCalc.mPublicField, 1);
    assertEquals(mCalc.mPublicFinalField, 0);
    assertEquals(Calc.mPublicStaticField, 2);
}
```

5.测试公开成员方法
```java
@Test
public void testAddPublicMethod() {
    //when
    when(mCalc.addPublic(anyInt(), anyInt()))
            .thenReturn(0)
            .thenReturn(1)
            .thenReturn(2)
            .thenReturn(3)
            .thenReturn(4)
            .thenReturn(5);

    //call method
    for (int i = 0; i < 6; i++) {

        //verify
        assertEquals(mCalc.addPublic(i, i), i);
    }

    //verify
    verify(mCalc, times(6)).addPublic(anyInt(), anyInt());
    verify(mCalc, atLeast(1)).addPublic(anyInt(), anyInt());
    verify(mCalc, atLeastOnce()).addPublic(anyInt(), anyInt());
    verify(mCalc, atMost(6)).addPublic(anyInt(), anyInt());
}
```

6.测试公开无返回值成员方法
```java
@Test
public void testAddPublicVoidMethod() {
    //when
    doNothing().when(mCalc).voidPublic(anyInt(), anyInt());

    mCalc.voidPublic(anyInt(), anyInt());
    mCalc.voidPublic(anyInt(), anyInt());

    verify(mCalc, atLeastOnce()).voidPublic(anyInt(), anyInt());
    verify(mCalc, atLeast(2)).voidPublic(anyInt(), anyInt());
}
```

7.测试公开静态成员方法
```java

    @Test
    public void testAddPublicStaicMethod() throws Exception {
        PowerMockito.mockStatic(Calc.class);

        PowerMockito.when(Calc.class, "addPublicStatic", anyInt(), anyInt())
                .thenReturn(0)
                .thenReturn(1)
                .thenReturn(2)
                .thenReturn(3)
                .thenReturn(4)
                .thenReturn(5);


        //call method
        for (int i = 0; i < 6; i++) {

            //verify
            assertEquals(Calc.addPublicStatic(i, i), i);
        }


        //verify static
        PowerMockito.verifyStatic(times(6));
    }
```

8.测试私有成员变量
Powermock提供了一个Whitebox的class，可以方便的绕开权限限制，可以get/set private属性，实现注入。也可以调用private方法。也可以处理static的属性/方法，根据不同需求选择不同参数的方法即可。
```java
@Test
public void testPrivateField() throws IllegalAccessException {
    PowerMockito.mockStatic(Calc.class);

    assertEquals(Whitebox.getField(Calc.class, "mPrivateField").getInt(mCalc), 0);
    assertEquals(Whitebox.getField(Calc.class, "mPrivateFinalField").getInt(mCalc), 0);
    assertEquals(Whitebox.getField(Calc.class, "mPrivateStaticField").getInt(null), 0);
    assertEquals(Whitebox.getField(Calc.class, "mPrivateStaticFinalField").getInt(null), 0);


    Whitebox.setInternalState(mCalc, "mPrivateField", 1);
    Whitebox.setInternalState(Calc.class, "mPrivateStaticField", 1, Calc.class);

    assertEquals(Whitebox.getField(Calc.class, "mPrivateField").getInt(mCalc), 1);
    assertEquals(Whitebox.getField(Calc.class, "mPrivateFinalField").getInt(mCalc), 0);
    assertEquals(Whitebox.getField(Calc.class, "mPrivateStaticField").getInt(null), 1);
    assertEquals(Whitebox.getField(Calc.class, "mPrivateStaticFinalField").getInt(null), 0);
}
```

9.测试私有成员方法
```java
@Test
    public void testAddPrivateMethod() throws Exception {
        PowerMockito.mockStatic(Calc.class);

        //when
        PowerMockito.when(mCalc,"addPrivate",anyInt(),anyInt())
                .thenReturn(0)
                .thenReturn(1)
                .thenReturn(2)
                .thenReturn(3)
                .thenReturn(4)
                .thenReturn(5);

        //call method
        for (int i = 0; i < 6; i++) {

            //verify
            assertEquals(Whitebox.invokeMethod(mCalc,"addPrivate",i,i), i);
        }

        //verify static
        PowerMockito.verifyPrivate(mCalc,times(6)).invoke("addPrivate",anyInt(),anyInt());
        PowerMockito.verifyPrivate(mCalc,atLeast(1)).invoke("addPrivate",anyInt(),anyInt());
    }
```

10.测试私有静态成员方法
```java
@Test
  public void testAddPrivateStaicMethod() throws Exception {
      PowerMockito.mockStatic(Calc.class);

      PowerMockito.when(Calc.class, "addPrivateStatic", anyInt(), anyInt())
              .thenReturn(0)
              .thenReturn(1)
              .thenReturn(2)
              .thenReturn(3)
              .thenReturn(4)
              .thenReturn(5);


      //call method
      for (int i = 0; i < 6; i++) {

          //verify
          assertEquals(Whitebox.invokeMethod(Calc.class,"addPrivateStatic",i, i), i);
      }


      //verify static
      PowerMockito.verifyStatic(times(6));
  }
```

通过以上介绍，相信你对Android项目的Mock单元测试有一定的了解。      
如果你有任何相关疑问，请通过以下方式联系我：
>Email：yanghui1986527#gmail.com
>QQ 群: 529327615



## 参考
1. [详细讲解单元测试的内容](http://developer.51cto.com/art/201106/268749.htm)
1. [浅谈单元测试的意义](http://developer.51cto.com/art/201106/268752.htm)
1. [敏捷开发之测试](http://blog.csdn.net/ruisheng_412/article/details/7997936)
1. [Unit testing support](http://tools.android.com/tech-docs/unit-testing-support)
1. [junit4](http://junit.org/junit4/)
1. [mockito](http://mockito.org/)
1. [powermock](https://github.com/jayway/powermock)
1. [mocktest](https://github.com/snowdream/test/tree/master/android/test/mocktest)
1. [在Android Studio中进行单元测试和UI测试](http://www.jianshu.com/p/03118c11c199)
1. [whats-the-best-mock-framework-for-java](http://stackoverflow.com/a/23048)
1. [mock测试](http://baike.baidu.com/view/2445748.htm)
1. [使用PowerMock来Mock静态函数](http://asialee.iteye.com/blog/981176)
1. [PowerMock介绍](http://blog.csdn.net/jackiehff/article/details/14000779)
1. [Sharing code between unit tests and instrumentation tests on Android](http://blog.danlew.net/2015/11/02/sharing-code-between-unit-tests-and-instrumentation-tests-on-android/)
1. [Unit tests with Mockito - Tutorial](http://www.vogella.com/tutorials/Mockito/article.html)
1. [Android单元测试之Mockito浅析](http://hlong.xyz/2016/06/16/Android%E5%8D%95%E5%85%83%E6%B5%8B%E8%AF%95%E4%B9%8BMockito%E6%B5%85%E6%9E%90/)
1. [Mockito 简明教程](http://waylau.com/mockito-quick-start/)
1. [ mockito简单教程](http://blog.csdn.net/sdyy321/article/details/38757135/)
