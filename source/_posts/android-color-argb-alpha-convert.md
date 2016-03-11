---
title: Android 颜色透明度换算
date: 2016-03-11 10:57:35
categories: android
tags: android
---

## 简介
### 颜色
Android中的颜色值通常遵循RGB/ARGB标准，使用时通常以“#”字符开头，以16进制表示。      
常用的颜色值格式为：
```
#RGB
#ARGB
#RRGGBB
#AARRGGBB
```
其中，ARGB 依次代表透明度（alpha）、红色(red)、绿色(green)、蓝色(blue)。
以颜色值 #FF99CC00 为例，其中，FF 是透明度，99 是红色值， CC 是绿色值， 00  是蓝色值。


### 透明度
1. 透明度分为256阶（0-255），计算机上用16进制表示为（00-ff）。透明就是0阶，不透明就是255阶,如果50%透明就是127阶（256的一半当然是128，但因为是从0开始，所以实际上是127）。
1. `透明度` 和 `不透明度` 是两个概念， 它们加起来是1，或者100%.
1. ARGB 中的透明度alpha，表示的是不透明度。依据来自维基百科中的定义。
> The alpha channel is normally used as an opacity channel. If a pixel has a value of 0% in its alpha channel, it is fully transparent (and, thus, invisible), whereas a value of 100% in the alpha channel gives a fully opaque pixel (traditional digital images). Values between 0% and 100% make it possible for pixels to show through a background like a glass, an effect not possible with simple binary (transparent or opaque) transparency. It allows easy image compositing.

## 换算
在开发过程中，UI/UE给的标注图上，所有颜色值是RGB，但是透明度经常都是百分比，例如:颜色值:#FFFFFF,透明度40%。
使用过程中我们需要进行换算。以之前的值为例，换算过程如下:
1. 将透明度转换成不透明度(转换方式参考“透明度”，第2条) 。 不透明度为60%
1. 不透明度乘以255。 我们得到结果：153
1. 将计算结果转换成16进制。得到最终的不透明度：99
1. 将不透明度和颜色值拼接成ARGB格式。得到最终的颜色值： #99FFFFFF

简单的换算，可以先将透明度，转换成不透明度，再根据下面的表格进行对应。
<pre>
100% — FF
95% — F2
90% — E6
85% — D9
80% — CC
75% — BF
70% — B3
65% — A6
60% — 99
55% — 8C
50% — 80
45% — 73
40% — 66
35% — 59
30% — 4D
25% — 40
20% — 33
15% — 26
10% — 1A
5% — 0D
0% — 00
</pre>

## 参考
1. [Color](http://developer.android.com/intl/ko/guide/topics/resources/more-resources.html#Color)
1. [標示色碼的方法](http://akanelee.logdown.com/posts/190198-color)
1. [RGBA color space](https://en.wikipedia.org/wiki/RGBA_color_space#ARGB_.28word-order.29)
1. [Understanding colors in Android ](http://stackoverflow.com/questions/5445085/understanding-colors-in-android-6-characters)
1. [How to make a background transparent 20% in android](http://stackoverflow.com/questions/11285961/how-to-make-a-background-transparent-20-in-android)
