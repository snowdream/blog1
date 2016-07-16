---
title: Android项目持续集成实践之Gitlab CI（Docker版本）
date: 2016-07-16 11:43:33
categories: android
tags: [android,ci]
---

接上一篇 [Android项目持续集成实践之Gitlab CI](https://snowdream.github.io/blog/2016/07/02/android-ci-gitlab/).

在我看来，.gitlab-ci.yml 配置还是有些复杂，写的脚本还是有点多，有没有办法更精简一点呢？

有，那就是Android环境Docker化。（注：对Docker感兴趣的同学，请参考这本书[《Docker —— 从入门到实践》](https://yeasy.gitbooks.io/docker_practice/content/)）。

我在这本书的指导下封装了一个包含Android开发环境的Docker镜像。
1. https://github.com/snowdream/docker-android
1. https://hub.docker.com/r/snowdream/docker-android/

现在有了合适的Docker镜像，.gitlab-ci.yml 将会变得非常简单:
```bash
image: snowdream/docker-android:1.0

build:
  script:
    - gradle assembleRelease
  artifacts:
    paths:
    - app/build/outputs/
```
第一行的意思是，采用标签为1.0，名称为snowdream/docker-android的Docker镜像，用于本工程的CI环境。

是不是很简单呢？

详细的构建过程日志太长，我就不贴了。链接如下：
https://gitlab.com/snowdream/Citest/builds/2155883

如果你在使用过程中，碰到什么问题，可以通过以下方式联系我：
* Email：yanghui1986527#gmail.com
* QQ Group: 529327615 
