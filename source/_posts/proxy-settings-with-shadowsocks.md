---
title: 代理服务器设置 - Shadowsocks && XX-Net
date: 2016-03-31 17:35:12
categories: settings
tags: [git,npm,gradle,maven]
---

本文主要关注通过shadowsocks和XX-Net工具，为git,nodejs,gradle,maven等进行代理服务器的配置。

## 简介
### Shadowsocks
Shadowsocks 是一个高性能，跨平台，安全的socks5代理服务器。      
Windows上的客户端大概是下面这个样子。

{% asset_img 20160331174929.png [代理服务器设置 - Shadowsocks] %}

在开发过程中，我们可能需要用到它。

一般对应的本地代理服务器是：
```
proxy = http://127.0.0.1:1080
https-proxy = http://127.0.0.1:1080
```
注意：实际端口号可能不一样，以Shadowsocks客户端设置的本地端口号为准。

### XX-Net
XX-Net是一个基于Goagent的免费翻墙工具套件。
一般对应的本地代理服务器是：
```
proxy = http://127.0.0.1:8087
https-proxy = http://127.0.0.1:8087
```
注意：实际端口号可能不一样，以XX-Net客户端设置的本地端口号为准。

## 设置
下面以Shadowsocks为例，介绍各项工具应该怎么配置代理服务器。
如果使用XX-Net,请注意修改代理服务器的端口号。

### Gradle
在用户主目录下.gradle目录下，找到gradle.properties,并使用文本编辑器编辑。
```bash
systemProp.http.proxyHost=127.0.0.1
systemProp.http.proxyPort=1080
systemProp.http.proxyUser=userid
systemProp.http.proxyPassword=password
systemProp.http.nonProxyHosts=*.nonproxyrepos.com|localhost

systemProp.https.proxyHost=127.0.0.1
systemProp.https.proxyPort=1080
systemProp.https.proxyUser=userid
systemProp.https.proxyPassword=password
systemProp.https.nonProxyHosts=*.nonproxyrepos.com|localhost
```

### Maven
在用户主目录下.m2目录下，找到settings.xml,并使用文本编辑器编辑。
```bash
<proxies>
  <proxy>  
     <active>true</active>  
     <protocol>http</protocol>  
     <host>127.0.0.1</host>  
     <port>1080</port>  
     <username>proxyuser</username>  
     <password>somepassword</password>  
     <nonProxyHosts>www.google.com|*.somewhere.com</nonProxyHosts>  
  </proxy>
  <proxy>  
     <active>true</active>  
     <protocol>https</protocol>  
     <host>127.0.0.1</host>  
     <port>1080</port>  
     <username>proxyuser</username>  
     <password>somepassword</password>  
     <nonProxyHosts>www.google.com|*.somewhere.com</nonProxyHosts>  
  </proxy>
</proxies>
 
```

### NPM
```bash
npm config set proxy http://127.0.0.1:1080
npm config set https-proxy http://127.0.0.1:1080
```

### APM
```bash
apm config set proxy http://127.0.0.1:1080
apm config set https-proxy http://127.0.0.1:1080
```
  
### Git
```bash
git config --global http.proxy http://127.0.0.1:1080
git config --global https.proxy http://127.0.0.1:1080
git config --global http.sslverify false
```  

### IDEA
打开“settings”,在左侧窗口搜索"proxy",在右侧窗口，按照下图设置代理服务器。
{% asset_img 20160331190004.png [代理服务器设置 - IDEA] %}

## 参考文档
1. [Shadowsocks](https://github.com/shadowsocks/shadowsocks)
1. [XX-Net](https://github.com/XX-net/XX-Net)
1. [npm 镜像、代理设置](http://my.oschina.net/liucao/blog/522593)
1. [git代理设置](http://ricksu.blog.163.com/blog/static/18906433820125294929508/)
1. [Windows下git使用代理服务器的设置方法](http://blog.useasp.net/archive/2015/08/26/config-git-proxy-settings-on-windows.aspx)
1. [配置git使用proxy](http://leolovenet.com/blog/2014/05/28/git-and-proxy/)
1. [Gradle代理服务器的设置方法](https://yutuo.net/archives/815b6ab682f94304.html)
1. [Configuring a proxy](https://maven.apache.org/guides/mini/guide-proxies.html)
1. [How to configure a proxy server for both HTTP and HTTPS in Maven's settings.xml?](http://stackoverflow.com/questions/31032174/how-to-configure-a-proxy-server-for-both-http-and-https-in-mavens-settings-xml)
