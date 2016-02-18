---
title: NPM 国内被墙的解决方法
date: 2016-02-18 11:06:49
tags: nodejs
categories: nodejs
---

NPM 国内被墙的解决方法## 使用国内镜像

镜像使用方法（三种办法任意一种都能解决问题，建议使用第三种，将配置写死，下次用的时候配置还在）:

1.通过config命令

```bash
npm config set registry https://registry.npm.taobao.org
npm info underscore （如果上面配置正确这个命令会有字符串response）
```


2.命令行指定
```bash
npm --registry https://registry.npm.taobao.org info underscore
```

3.编辑 ~/.npmrc 加入下面内容
```bash
registry = https://registry.npm.taobao.org
```

## 设置代理服务器
可以运行如下两句命令设置代理，注意代理的地址改为自己实际可用的代理。
使用Goagent系列，包括XX-Net的同学可以直接使用下面的命令。

```bash
npm config set proxy=http://127.0.0.1:8087
npm config set registry=http://registry.npmjs.org
```


## 参考文档
1.  [使用npm安装一些包失败了的看过来（npm国内镜像介绍）](https://cnodejs.org/topic/4f9904f9407edba21468f31e)
2. [淘宝 NPM 镜像](http://npm.taobao.org/)
3. [如何给 NPM 设置代理](http://blog.csdn.net/cnbird2008/article/details/8442333)
