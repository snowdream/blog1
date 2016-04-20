---
title: Gitbook离线电子书打包方案 
date: 2016-04-20 13:13:42
categories: android
tags: android
---

Gitbook是一个开源的跨平台电子书解决方案。通过Gitbook，你可以使用Markdown或者AsciiDoc来编写电子书，然后生成静态网页电子书，pdf，mobi，epub格式。    
这里，我们简单介绍一个适用于Android的离线电子书打包方案。 [gitbook-android](https://github.com/snowdream/gitbook-android)

## 原理
通过Gitbook，将电子书打包成静态网站。再将静态网站放到Android APP的assets目录下，作为离线网站，打包成一个离线电子书应用（Android APP）。


## 步骤
1. 按照Gitbook规范，编写gitbook电子书
1. 通过Gitbook，将电子书打包成静态网站
1. 使用git将工程[gitbook-android](https://github.com/snowdream/gitbook-android)克隆下来
1. 将静态网站放在gitbook-android工程的assets/book目录下
1. 在“gitbook-android\app\src\main\res\values\strings.xml”中修改app_name
1. 在“gitbook-android\app\build.gradle”中修改包名 applicationId "com.github.snowdream.apps.gitbook"
1. 新增以下四个keystore相关的环境变量，用于APK签名.
```
KEYSTORE
KEYSTORE_PASSWORD
KEY_ALIAS
KEY_PASSWORD
```
1. 在gitbook-android工程目录下，运行`gradle assembleRelease --info`即可。


## 参考
1. [gitbook-android](https://github.com/snowdream/gitbook-android)
1. [Gitbook](https://github.com/GitbookIO/gitbook)
1. [gitbook.com](https://www.gitbook.com)
