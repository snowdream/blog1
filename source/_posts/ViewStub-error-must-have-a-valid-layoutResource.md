---
title: ViewStub报错:must have a valid layoutResource解决
date: 2016-02-19 14:17:39
categories: android
tags: android
---
最近在优化UI布局，试图解决GPU过度绘制的问题时，用到了ViewStub。
有个地方原来是include，用viewstub优化时，编译通过，但是运行报错。
```
java.lang.IllegalArgumentException: ViewStub must have a valid layoutResource
```

用法：
```java
stub = (ViewStub)findViewById(R.id.realtime_bus_layout);  
stub.inflate();  
```

在网上搜了一下，发现问题所在。
`<include>` 标签布局是这样设置的：

```xml
layout="@layout/realtime_bus_layout"  
```

而 `<viewstub>`中标签布局是这样设置的：

```xml
android:layout="@layout/realtime_bus_layout"
```

问题就在于，我改了标签，但是没有修改布局的引用方式。
而这个问题难以发现的原因是，这样使用编译器不会报错，而是在运行的时候报错。


## 参考文档：
1. [ViewStub报错:must have a valid layoutResource解决](http://blog.csdn.net/palatine/article/details/37764369)
