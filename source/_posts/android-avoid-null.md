---
title: 防止NullPointerException的最佳解决方案
date: 2016-02-18 22:11:30
categories: android
tags: android
---
NullPointerException在bug跟踪时经常发现，如何防止？
主要分阶段进行：
## 一. 开发阶段
### 1.方法的返回值尽量返回空对象，而不是null
* 对于数组，比如GeoPoint，返回空对象，return new GeoPoint[0];
* 对于容器，比如ArraryList,返回空对象。如果需要泛型支持，retrun Collections.emptyList();
如果不需要泛型支持，则 return  Collections.EMPTY_LIST; 详细内容，参考：http://moto0421.iteye.com/blog/1447836
* 对于字符串String,返回空对象， return ""; 而不是return null;
* 对于其他对象，如果可以定义空对象/初始对象，则return这个对象。否则，return null,并采用下面一种方法；

### 2.使用android annotations注解库
对于方法需要返回null的情况下，在方法的头部加上一个nullable的注解。

通过IDE来检测可能出现的空指针，并提出警告。
以Intellij Idea为例，这里需要设置一下。
默认情况下Intellij Idea没有使用support-annotations.jar中的annotation来做nullity的分析。需要在preferences中配置。

先找到Preferences -> Inspections, 搜索 Nullable, 找到 Probable bugs中的 @NotNull/@Nullable problems。
![screenshot](http://img1.tbcdn.cn/L1/461/1/cb8fa40216fb2a1cf76d567f2a6d5184913ce5d1.png)

![screenshot](http://img3.tbcdn.cn/L1/461/1/1c8533e643e7c53773f88d5ebd828bf06b3ec751.png)

  选择 Configure Annotations
![screenshot](http://img2.tbcdn.cn/L1/461/1/7d97c8623ca632c115229d718407d3e46c547317.png)

在弹出窗口中分别添加并选中 support lib 中的 Nullable/NonNull。

![screenshot](http://img2.tbcdn.cn/L1/461/1/2c952d0de7bb21e10fb36677309a5dbe8abb851f.png)

之后Intellij Idea会报告代码中可能存在的NullPointException的问题，也可以把 Severity 从Warning改为Error，这样更醒目。

### 3.其他
* 避免使用以下方式进行调用：A.getB().getC().getD()
 这样做很危险，只要中间有一个返回null，就出现空指针了。
* 使用单例的时候要慎重。尤其不能将有生命周期的对象做单例。
...


## 二. 测试阶段
### 1.持续集成
通过Jenkins + Findbugs/Lint等插件，来实时检查每次build中存在的问题。比如，出现空指针，或者可能出现空指针的情况，及时修改。

### 2.测试
* 通过Monkey来帮助发现问题，对于发现的空指针进行及时修改。
* 通过QA测试反馈，对于发现的空指针进行及时修改。

## 三. 用户反馈
通过对用户反馈，以及在线崩溃日志进行分析，对于其中的问题进行及时修改。


### 最后总结一下：不要把问题留给用户，尤其是会导致崩溃的问题，比如空指针。
