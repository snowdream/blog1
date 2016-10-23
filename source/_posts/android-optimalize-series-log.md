---
title: Android优化系列一： 日志清理
date: 2016-10-22 22:19:41
categories: android
tags: android
---
>作者：snowdream   
>Email：yanghui1986527#gmail.com    
>Github: [https://github.com/snowdream](https://github.com/snowdream)   
>QQ 群: 529327615        
>原文地址：[https://snowdream.github.io/blog/2016/10/22/android-optimalize-series-log/](https://snowdream.github.io/blog/2016/10/22/android-optimalize-series-log/)


## 简介
在Android应用开发过程中，通过Log类输出日志是一种很重要的调试手段。    
大家对于Log类的使用，一般会形成几点共识：
1. 在Debug模式下打印日志，在Release模式下不打印日志
1. 避免滥用Log类进行输出日志。因为这样可能造成日志刷屏，淹没真正有用的日志。
1. 封装Log类，以提供同时输出日志到文件等功能

具体细化为以下几点建议：
1. 禁用System.out.println   
Android应用中，一般通过封装过的Log类来输出日志，方便控制。而System.out.println是标准的Java输出方法，使用不当，可能造成Release模式下输出日志的结果。
1. 禁用e.printStackTrace    
禁用理由同上     
建议通过封装过的Log类来输出异常堆栈信息

1. Debug模式下，通过一个静态变量，控制日志的显示隐藏。   
我一般习惯直接使用BuildConfig.DEBUG，当然，你也可以自己定义一个。 
      
```
private static final boolean isDebug = BuildConfig.DEBUG;

public static void i(String tag, String msg) {
    if (isDebug) {
        Log.i(tag, msg);
    }
}
```
4.Release模式下，通过Proguard配置来移除日志     
在Proguard配置文件中，确保没有添加 --dontoptimize选项 来禁用优化的前提下，
添加以下代码：
```     
-assumenosideeffects class android.util.Log {
        public static *** d(...);
        public static *** e(...);
        public static *** i(...);
        public static *** v(...);
        public static *** println(...);
        public static *** w(...);
        public static *** wtf(...);
}
```

那么，是否我们按照上面的做，就真的一劳永逸呢？
我的脑海中浮现出几个相关问题：
1. Proguard配置中添加的配置，真的可以在Release模式下，移除日志吗？
1. 如果我们用的是封装过的Log工具类，应该怎么配置？
1. 移除日志后，原来在日志方法中的拼接字符串参数，是否还会申请/占用内存？    
...

本着大胆假设，小心求证的原则，下面我们通过实践来探索上面的问题答案。

本文基于以下项目进行测试实践：
[https://github.com/snowdream/test/tree/master/android/test/logtest](https://github.com/snowdream/test/tree/master/android/test/logtest)
反编译工具：[JD-GUI](http://jd.benow.ca/)
## 验证Proguard配置清理日志的有效性
### CASE 
```
Log.i(TAG,"这样使用，得到的LOGTAG的值就是DroidSettings，" +
        "然而并非如此，当DroidSettings这个类进行了混淆之后，类名变成了类似a,b,c这样的名称，" +
        "LOGTAG则不再是DroidSettings这个值了。这样可能造成的问题就是，内部混淆有日志的包，我们去过滤DroidSettings " +
        "却永远得不到任何信息。");
```
在添加上述Proguard配置前后，编译打包Release模式的正式包，使用JD-GUI进行反编译，对比上述代码的编译后代码。

### 结果
添加配置前
{% asset_img case1-a.png [case1-a] %}

添加配置后
{% asset_img case1-b.png [case1-b] %}

### 结论
通过比对结果，我们可以得出结论：      
通过添加Proguard配置，可以在Release模式下，移除掉日志。


## 验证封装过的Log工具类，是否有必要进行而外配置

### CASE 
```
LogUtil.i(TAG,"这样使用，得到的LOGTAG的值就是DroidSettings，" +
        "然而并非如此，当DroidSettings这个类进行了混淆之后，类名变成了类似a,b,c这样的名称，" +
        "LOGTAG则不再是DroidSettings这个值了。这样可能造成的问题就是，内部混淆有日志的包，我们去过滤DroidSettings " +
        "却永远得不到任何信息。");
        
```
在添加上述Proguard配置前后，编译打包Release模式的正式包，使用JD-GUI进行反编译，对比上述代码的编译后代码。

### 结果
添加配置前
{% asset_img case2-a.png [case2-a] %}

添加配置后
{% asset_img case2-b.png [case2-b] %}

### 结论
通过比对结果，我们可以得出结论：      
在这种简单封装的情况下，我们不需要额外的配置，也可以将封装过的Log工具类调用日志一起移除。

当然，实际使用过程中，可能封装更复杂。为了保险起见，可以也添加上Log工具类的配置。示例如下：
```
-assumenosideeffects class com.github.snowdream.logtest.LogUtil {
        public static *** d(...);
        public static *** e(...);
        public static *** i(...);
        public static *** v(...);
        public static *** w(...);
}
```

## 验证移除日志后，字符串拼接是否还存在？

### CASE 
```
Log.i(TAG,"这样使用，得到的LOGTAG的值就是DroidSettings，" +
        "然而并非如此，当DroidSettings这个类进行了混淆之后，类名变成了类似a,b,c这样的名称，" +
        "LOGTAG则不再是DroidSettings这个值了。这样可能造成的问题就是，内部混淆有日志的包，我们去过滤DroidSettings " +
        "却永远得不到任何信息。");

Log.i(TAG, "这样使用，得到的LOGTAG的值就是DroidSettings，" +
        "然而并非如此，当DroidSettings这个类进行了混淆之后，类名变成了类似a,b,c这样的名称，" +
        "LOGTAG则不再是DroidSettings这个值了。这样可能造成的问题就是，内部混淆有日志的包，我们去过滤DroidSettings " +
        "却永远得不到任何信息。" + index ++);
        
```
上面代码的区别是：
前面是简单的字符串相加，而后面是字符串和变量的相加
在添加上述Proguard配置的前提下，分别针对以上两段代码，编译打包Release模式的正式包，使用JD-GUI进行反编译，对比上述代码的编译后代码。

### 结果
简单字符串相加
{% asset_img case1-b.png [case1-b] %}

字符串和变量相加
{% asset_img case3.png [case3.png] %}

### 结论
通过比对结果，我们可以得出结论：    
如果只是简单字符串相加，是会彻底移除的，并且字符串拼接也不见了，不会占用内存。
而如果是字符串和变量相加，日志会移除，但是字符串拼接还在，还会占用内存。



## 验证日志中使用函返回值的情况

### CASE 
```

        LogUtil.i(TAG, getMessage());

        LogUtil.i(TAG, "FROM FUNCTION " + getMessage());
        
        private String getMessage() {
            return  "这样使用，得到的LOGTAG的值就是DroidSettings，" +
                "然而并非如此，当DroidSettings这个类进行了混淆之后，类名变成了类似a,b,c这样的名称，" +
                "LOGTAG则不再是DroidSettings这个值了。这样可能造成的问题就是，内部混淆有日志的包，我们去过滤DroidSettings " +
                "却永远得不到任何信息。"；
        }
        
```
上面代码的区别是：
前面是直接使用函数返回值，而后面是字符串和函数返回值的相加
在添加上述Proguard配置的前提下，分别针对以上两段代码，编译打包Release模式的正式包，使用JD-GUI进行反编译，对比上述代码的编译后代码。

### 结果
直接使用函数返回值
{% asset_img case1-b.png [case1-b] %}

字符串和函数返回值相加
{% asset_img case4.png [case4.png] %}

### 结论
通过比对结果，我们可以得出结论：    
以上两种场景下，日志移除，拼接字符串不在了，也不会占用内存。

## 经过大量实践后的结论
如果你以为上面就是全部真相的话，就错了。
经过大量的测试实践，实际上真相更复杂。

以下是开启Proguard前提下，各种情况下的测试结论：
1. Log.i（简单字符串）
1. Log.i（局部变量）
1. Log.i（成员变量）
1. Log.i（简单字符串+局部变量）    
以上四种情况，日志被彻底移除，不会额外增加内存。
1. Log.i（简单字符串+成员变量）    
日志被移除，但是字符串拼接会存在，并占用内存。
1. Log.i（成员函数） 其中，成员函数返回值为： 简单字符串
1. Log.i（成员函数） 其中，成员函数返回值为： 简单字符串+局部变量       
以上两种情况，日志被彻底移除，不会额外增加内存。
1. Log.i（成员函数） 其中，成员函数返回值为： 简单字符串+成员变量       
日志被移除，但是字符串拼接会存在，并占用内存。  
  
注：以上所有情况,参数都是指第二个或者后面的参数。第一个参数，我都使用了静态成员变量：    
private static final String TAG = MainActivity.class.getSimpleName();

### 优化建议
1. 确保没有开启 --dontoptimize选项的前提下，添加Proguard优化日志配置
```     
-assumenosideeffects class android.util.Log {
        public static *** d(...);
        public static *** e(...);
        public static *** i(...);
        public static *** v(...);
        public static *** println(...);
        public static *** w(...);
        public static *** wtf(...);
}
```
1. 针对这种情况“Log.i（成员函数） 其中，成员函数返回值为： 简单字符串+成员变量”
目前并没有办法规避，不建议这么使用。
1. 针对这种情况"Log.i（简单字符串+成员变量)"
我们的解决方案是，在封装的Log工具类方法中，使用变长参数。
下面是一个简单的示例：
```
package com.github.snowdream.logtest;

import android.text.TextUtils;
import android.util.Log;

/**
 * Created by snowdream on 16-10-22.
 */
public class LogUtil {
    private static final boolean isDebug = BuildConfig.DEBUG;

    public static void i(String tag, String... args) {
        if (isDebug) {
            Log.i(tag, getLog(tag,args));
        }
    }

    public static void d(String tag, String... args) {
        if (isDebug) {
            Log.i(tag, getLog(tag,args));
        }
    }

    public static void v(String tag, String... args) {
        if (isDebug) {
            Log.i(tag, getLog(tag,args));
        }
    }

    public static void w(String tag, String... args) {
        if (isDebug) {
            Log.i(tag, getLog(tag,args));
        }
    }

    public static void e(String tag, String... args) {
        if (isDebug) {
            Log.i(tag, getLog(tag,args));
        }
    }

    private static String getLog(String tag, String... args){
        StringBuilder builder = new StringBuilder();
        for (String arg : args){
            if (TextUtils.isEmpty(arg)) continue;

            builder.append(arg);
        }

        return builder.toString();
    }
}
```

## 参考
1. [如何安全地打印日志](http://weishu.me/2015/10/19/how-to-log-safely-in-android/)
1. [关于Android Log的一些思考](http://droidyue.com/blog/2015/11/01/thinking-about-android-log/)
1. [Androrid应用打包release版时关闭log日志输出](http://www.jianshu.com/p/4b61391a665f)
