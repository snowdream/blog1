---
title: Xposed模块的开发
date: 2016-09-02 14:21:56
categories: android
tags: [android,xposed]
---
>作者：snowdream   
>Email：yanghui1986527#gmail.com    
>Github: [https://github.com/snowdream](https://github.com/snowdream)   
>QQ 群: 529327615        
>原文地址：[https://snowdream.github.io/blog/2016/09/02/android-develop-xposed-module/](https://snowdream.github.io/blog/2016/09/02/android-develop-xposed-module/)

注： 根据[Development tutorial](https://github.com/rovo89/XposedBridge/wiki/Development-tutorial) 整理完成

## 创建Android项目
如果准备从零开始创建Xposed模块,首先应该创建一个Android应用工程。

## 引入 Xposed Framework API 
在 `app/build.gradle`文件中声明Xposed Framework API 的jar包依赖。

```
repositories {
    jcenter();
}

dependencies {
  provided 'de.robv.android.xposed:api:82'
  //如果需要引入文档，方便查看的话
  provided 'de.robv.android.xposed:api:82:sources'
}
```

说明：   
1. 请留意，这个82是Xposed Framework API的版本号，叫做xposedminversion。 
1. xposedminversion可以在这里进行查询：
[https://bintray.com/rovo89/de.robv.android.xposed/api](https://bintray.com/rovo89/de.robv.android.xposed/api)
1. Xposed Framework API文档请参考：[http://api.xposed.info/reference/packages.html](http://api.xposed.info/reference/packages.html)

## 修改AndroidManifest.xml
在AndroidManifest.xml文件中添加以下代码。
```
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="de.robv.android.xposed.mods.tutorial"
    android:versionCode="1"
    android:versionName="1.0" >

    <uses-sdk android:minSdkVersion="15" />

    <application
        android:icon="@drawable/ic_launcher"
        android:label="@string/app_name" >
        <meta-data
            android:name="xposedmodule"
            android:value="true" />
        <meta-data
            android:name="xposeddescription"
            android:value="Easy example which makes the status bar clock red and adds a smiley" />
        <meta-data
            android:name="xposedminversion"
            android:value="53" />
    </application>
</manifest>
```

说明：     
1. xposedmodule： 一般设置为true,表示这是一个xposed模块
1. xposeddescription: 一句话描述该模块的用途，可以引用string.xml中的字符串
1. xposedminversion： 没错，这个就是上面提到的xposedminversion。我理解为要求支持的Xposed Framework最低版本。


## 模块实现
创建一个或者几个类，并实现IXposedHookLoadPackage,IXposedHookZygoteInit或者其他IXposedMod的子接口。
```
package de.robv.android.xposed.mods.tutorial;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.callbacks.XC_LoadPackage.LoadPackageParam;

public class Tutorial implements IXposedHookLoadPackage {
    public void handleLoadPackage(final LoadPackageParam lpparam) throws Throwable {
        XposedBridge.log("Loaded app: " + lpparam.packageName);
    }
}
```

注： XposedBridge.log会将日志输出到logcat，并写入日志文件"/data/data/de.robv.android.xposed.installer/log/debug.log".

好了，现在可以开始Hook了。
大部分的Hook工作，主要通过XposedHelpers类的一些辅助函数来实现。比如：`findAndHookMethod`

```
package de.robv.android.xposed.mods.tutorial;

import static de.robv.android.xposed.XposedHelpers.findAndHookMethod;
import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.callbacks.XC_LoadPackage.LoadPackageParam;

public class Tutorial implements IXposedHookLoadPackage {
    public void handleLoadPackage(final LoadPackageParam lpparam) throws Throwable {
        if (!lpparam.packageName.equals("com.android.systemui"))
            return;

        findAndHookMethod("com.android.systemui.statusbar.policy.Clock", lpparam.classLoader, "updateClock", new XC_MethodHook() {
            @Override
            protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                // this will be called before the clock was updated by the original method
            }
            @Override
            protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                // this will be called after the clock was updated by the original method
            }
    });
    }
}
```
注：根据名称不难发现，beforeHookedMethod/afterHookedMethod会在被Hook函数之前/之后执行。

关于使用Xposed来进行Hook的更多知识，这里就不展开了。大家可以参考以下两篇文章：
1. [Helpers](https://github.com/rovo89/XposedBridge/wiki/Helpers)
1. [android-hook框架xposed篇](http://www.droidsec.cn/android-hook%E6%A1%86%E6%9E%B6xposed%E7%AF%87/)

## 声明实现
在assets目录下创建一个空文件，命名为xposed_init。   
在这个文件中，每一行记录一个类的完整路径，来声明实现类。  
在这里，我们声明 "de.robv.android.xposed.mods.tutorial.Tutorial"

好了，到这里，一个简单的Xposed模块应用项目就构建好了。

## 模块安装与使用
1. 将这个工程，编译，打包，安装到已经支持Xposed的手机中。    
1. 打开Xposed Installer应用，切换到模块界面，你可以看到你开发的Xposed模块。  
1. 通过勾选/取消，来启用/禁用模块。然后，重启手机，进行生效。

## 模块发布
Xposed模块开发完成后，你可以按照以下步骤发布分享。
1. 你首先需要一个XDA论坛帐号。如果没有，请前往论坛注册：     
[http://forum.xda-developers.com/](http://forum.xda-developers.com/)
1. 使用XDA论坛帐号,登录xposed官网，按照操作提示进行发布。        
[http://repo.xposed.info/](http://repo.xposed.info/)

## Xposed模块开发优势和不足
### 优势
1. 功能强大，既可以修改系统应用，也可以修改其他应用。hook android,hook everything.
1. 使用灵活，既可以针对一款应用进行Hook，也可以针对所有应用进行Hook。

### 不足
1. 无法调试。只能通过打印日志进行跟踪。（例如：XposedBridge.log）
1. 无法即时生效。启用/禁用模块，你需要重启手机。
1. multidex支持不足。详见[Multidex support](https://github.com/rovo89/XposedBridge/issues/30#issuecomment-68488797)

## Xposed模块开发实例
在[Xposed-Keylogger](https://github.com/giuliomvr/Xposed-Keylogger/)的基础上，我稍作修改，制作了一个Xposed模块开发实例。
这个模块的作用就是监听键盘按键，记录所有你设置到EditText控件的字符串。

## 建议
Xposed是如此的强大，因此，建议重视手机安全的用户，坚决不要root，不要安装xposed，发烧友，土豪随意。


## 参考
1. [Xposed 官网](http://repo.xposed.info/)
1. [Xposed XDA论坛](http://forum.xda-developers.com/xposed)
1. [Development tutorial](https://github.com/rovo89/XposedBridge/wiki/Development-tutorial)
1. [Helpers](https://github.com/rovo89/XposedBridge/wiki/Helpers)
1. [Replacing resources](https://github.com/rovo89/XposedBridge/wiki/Replacing-resources)
1. [Using the Xposed Framework API](https://github.com/rovo89/XposedBridge/wiki/Using-the-Xposed-Framework-API)
1. [DingDingUnrecalled](https://github.com/veryyoung/DingDingUnrecalled)
1. [FakeXX](https://github.com/qdk0901/FakeXX)
1. [WechatLuckyMoney](https://github.com/veryyoung/WechatLuckyMoney)
1. [Xposed Framework API](http://api.xposed.info/reference/packages.html)
1. [Xposed Framework API in bintray](https://bintray.com/rovo89/de.robv.android.xposed/api)
1. [android-hook框架xposed篇](http://www.droidsec.cn/android-hook%E6%A1%86%E6%9E%B6xposed%E7%AF%87/)
1. [JustTrustMe](https://github.com/TheCjw/JustTrustMe)
