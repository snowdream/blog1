---
title: 基于Docker和Debian打造个人专属操作系统
date: 2017-03-22 22:22:03
categories: docker
tags: docker
---
一提到Docker，你可能想到云服务，运维等等。
今天，我们要谈谈Docker的本地应用，如何基于Docker和Debian打造一款个人专属操作系统。

## 简介
一个Docker镜像运行起来就相当于一个没有桌面的Linux系统。

现在，我们给一个基于Debian的Docker镜像，加上Mate桌面，就成了一个完整的Linux操作系统了。

为了保证我们可以通过网络来访问这个系统，我们再安装上OpenSSH和X2GO。

这样，一款基本的个人专属操作系统就完成了。当然，你可以在这个基础上，增加常用的软件，打造自己的个人专属操作系统。

## 构成
主要包含以下几个部分：
* Debian jessie
* Mate Desktop
* Openssh-server
* X2goserver

## 下载 && 安装
### 1. snowdream/desktop
下载Docker镜像：
```bash
docker pull snowdream/desktop
```

### 2. X2Go 客户端
以mac为例，其他参考： http://wiki.x2go.org/doku.php/doc:installation:x2goclient

先下载安装XQuartz-2.7.11.dmg（https://www.xquartz.org）

再下载安装x2goclient （https://code.x2go.org/releases/binary-macosx/x2goclient/releases/4.1.0.0/）

## 运行
### 1. 启动snowdream/desktop
通过以下Docker命令，启动镜像。
请留意提示的root和dockerx用户的密码，并记录下来。
```bash
CID=$(docker run -p 2222:22 -t -d snowdream/desktop)
docker logs $CID
```

### 2. 通过ssh访问
通过以下终端命令，连接上面的镜像。
密码见前面的提示。
```bash
ssh root@localhost -p 2222
```

### 3. 通过x2go访问桌面
1. 启动x2go客户端
2. 配置x2go客户端

点击主界面工具栏第三个按钮，看看全局设置中，XQuartz的路径和版本是否正确。

![配置x2go客户端](https://static.dingtalk.com/media/lALOtOPUL80CS80CZw_615_587.png)

接着，按照下面提示，创建一个会话。

其中，Host为主机IP，Login为用户名，SSH port为ssh端口，
底部的会话桌面选择Mate。

![配置x2go客户端](https://static.dingtalk.com/media/lALOtOL6_s0Ctc0DIg_802_693.png)

3.启动会话，连接桌面。

## 联系方式
* Email：yanghui1986527#gmail.com
* Github: https://github.com/snowdream
* Blog: http://snowdream.github.io/blog/
* 简书：http://www.jianshu.com/u/748f0f7e6432
* 云栖博客：https://yq.aliyun.com/u/snowdream86 
* QQ群: 529327615     
* 微信公众号:  sn0wdr1am    

![sn0wdr1am](https://static.dingtalk.com/media/lADOmAwFCs0BAs0BAg_258_258.jpg)
