---
title: Android 高效布局的几点建议
date: 2016-03-16 04:18:29
categories: android
tags: android
---

在Android应用开发过程中，布局是一项最基础的工作。     
如何进行高效布局，提高开发效率呢? 我经过长期实践，总结了以下几条建议：

## 一、 静态布局为主，动态布局为辅
1.静态布局

就是我们最常用的，通过xml来进行布局。

优点：所见即所得。布局创建，修改，预览都非常的方便。    
缺点：灵活性稍差。

2.动态布局      

 通过Java代码来实现布局。    

优点：灵活性好。在应用运行过程中，可以随时去调整布局，例如：增加未加载的新控件，调整控件的位置等。      
缺点：可见性差，维护非常的繁琐。

大家都知道，一个项目，一个功能，不可能自始至终都是同一个人进行维护的。人员流动，工作调整，这些都可能造成以下结果：你去接手别人维护的功能/模块，别人接手你维护的功能/模块。**基于这种现状，在Android应用布局方面，可见性，可维护性显得尤为重要。** 因此，我推荐的布局原则是：“静态布局为主，动态布局为辅。”

推荐的理由有两点：    
1. 布局是一个相对持续的过程。可能UI/UE会随时让你调整下控件之间的间距，位置等。动态布局，需要每次修改后，编译运行在手机上才能看到实际的效果。而静态布局，可以随时修改，随时预览效果。
1. 静态布局，你可以通过阅读xml，预览效果，对于整个界面，可以快速的熟悉和掌握。而对于动态布局，你必须确认你对所有有关的代码熟悉后，静态布局和动态布局相结合，在脑海中对整个界面进行拼接，才能有一个整体把握。而随着布局变得复杂，这将变得越来越难。

## 二、 善用tools工具
有些布局，预览效果非常差。咋一看上去，一片空白。这样其实丧失了静态布局的一大优点“所见即所得。”整个布局之后，你编译运行到手机上，才能看到你设置的属性，间距等是否正常生效了。

这里，我推荐一个原则：“尽量在布局中展示你要的效果。”  
怎么实现呢？这里需要用到一个工具，tools。

### Tools 简介和用法
** Tools工具的使用仅仅针对IDE有效，并不会被打包进应用。**

具体步骤如下：
1. 在布局最外层，加上下面这句话，声明一下。
```xml
xmlns:tools="http://schemas.android.com/tools"
```
1. 一般的控件属性以“android:”开头。新增一个同样的属性，改为以“tools:”开头。

例如：一个TextView控件，需要设置默认状态为不可见。

```xml
<TextView
            android:text="Name"
            android:visiblity="gone"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content" />
```
但是你想预览它，又担心改为`android:visiblity="visible"`之后忘了改回来，直接提交了。现在你不必担心，新增一个同样名称的属性，以“tools:”开头，就可以了。
```xml
<TextView
            android:text="Name"
            android:visiblity="gone"
            tools:visiblity="visible"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content" />
```

## 三、 时刻谨记UI适配
由于Android开源的特性，造成Android手机种类繁多。这些手机拥有不同版本的系统，不同的屏幕分辩率，不同的配置等。   
我们在进行布局的时候，要时刻谨记UI适配，尽最大限度去适配不同的分辨率。  
这里，我总结几点经验：
1. Android控件，默认会带有一点padding。 有些背景切图，可能会留有较大的余白。而UI/UE的标注图可能并没有考虑这些因素，因此，UI/UE的标注图仅供参考。实际布局过程中，可能需要稍微调整。
1. 保留重要标注尺寸，忽略次要标注尺寸。举个简单的例子。假设一个顶部区域，固定高度。需要放置主标题，副标题两个文本控件。 建议这么布局，主标题和副标题使用一个竖直的LinearLayout进行包裹。主标题和副标题控件之间按照标注图设置精准的间距。之后，把整个LinearLayout竖直居中在顶部区域。
1. 设置android:weight,来进行按照比例布局。
1. 文本控件，需要考虑，文本过长时的省略策略。
1. 防止控件相互压盖
1. 切图至少提供两套，hdpi和xhdpi


## 参考
1. [Designtime Layout Attributes](http://tools.android.com/tips/layout-designtime-attributes)
1. [Tools Attributes](http://tools.android.com/tech-docs/tools-attributes)
