---
title: mintty 中文乱码解决方案
date: 2016-03-23 11:20:35
categories: tools
tags:
---

## 问题
最新的Git For Windows采用了Mintty终端，在实际使用过程中，出现中文乱码，影响阅读体验。


## 解决方案
1. 右键选择Git Bash终端窗口顶栏，选择"Option";
1. 左侧窗口，选中“Text”标签；
1. 在右侧窗口，Locale 选择 "zh_CN", Character set 选择 “GBK”。

{% asset_img 20160323112648.png [mintty 中文乱码解决方案] %}
