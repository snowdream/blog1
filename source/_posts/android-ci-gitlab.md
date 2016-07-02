---
title: "Android项目持续集成实践之Gitlab CI"
date: 2016-07-02 11:39:29
categories: android
tags: android
---

## 简介
持续集成（Continuous integration）是一种软件开发实践，即团队开发成员经常集成它们的工作，通过每个成员每天至少集成一次，也就意味着每天可能会发生多次集成。每次集成都通过自动化的构建（包括编译，发布，自动化测试）来验证，从而尽早地发现集成错误。

## 入门

下面我们来简单介绍，如果通过Gitlab CI来对Android项目持续集成。

一言不合，先甩给你一个项目链接：
https://gitlab.com/snowdream/Citest

项目很简单，就是一个默认创建的Android项目，然后上传至Gitlab。

如果给项目添加持续集成功能呢？    
按照文档的说法，你需要给项目添加一个名称为.gitlab-ci.yml的配置文件。

.gitlab-ci.yml文件怎么写？？此处省略108个字。
通读下面两篇文章，大概就清楚了。
http://doc.gitlab.com/ce/ci/quick_start/README.html
http://doc.gitlab.com/ce/ci/yaml/README.html

当然，也许你读完了，还是感觉蒙了。那你还需要参考下别人怎么实践的。
1. http://doc.gitlab.com/ce/ci/quick_start/README.html
1. http://doc.gitlab.com/ce/ci/yaml/README.html
1. http://www.greysonparrelli.com/setting-up-android-builds-in-gitlab-ci/
1. https://github.com/asura-app/android/blob/master/.gitlab-ci.yml
1. https://github.com/lfuelling/android-sdk-docker
1. https://hub.docker.com/r/jangrewe/gitlab-ci-android/
1. http://blog.goddchen.de/2016/04/configuration-for-gitlab-ci-android-projects/
1. http://stackoverflow.com/questions/35916233/gitlab-com-ci-shared-runner-for-android-projects

## 实践
** 下面是重点:**   
基本流程是：
1. Gitlab Ci通过Docker来拉取包括openjdk-8-jdk的容器
1. 下载Android SDK
1. 通过Gradle Wrapper运行编译工程

** 下面是主菜： **  
适用于Android项目的 .gitlab-ci.yml 文件
当然，在实际过程中，你可以需要做一些调整，比如android sdk 中的版本号等。
```shell
image: java:openjdk-8-jdk
 
before_script:
  - apt-get --quiet update --yes
  - apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1
  - wget --quiet --output-document=android-sdk.tgz https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
  - tar --extract --gzip --file=android-sdk.tgz
  - echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter android-23
  - echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter platform-tools
  - echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter build-tools-23.0.3
  - echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-android-m2repository
  - echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-google-google_play_services
  - echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-google-m2repository
  - export ANDROID_HOME=$PWD/android-sdk-linux
  - chmod u+x ./gradlew
 
build:
  script:
    - ./gradlew assembleRelease
  artifacts:
    paths:
    - app/build/outputs/
```

好了。将.gitlab-ci.yml 添加到你的Android项目中，然后上传至Gitlab系列的Git服务器，就开始持续集成了。

详细的构建过程日志太长，我就不贴了。链接如下：
https://gitlab.com/snowdream/Citest/builds/2140420

## 总结
与Travis Ci相比，Gitlab CI更灵活，可定制性高，但也意味着用起来并不是那么容易。
Travis Ci 更倾向于提供一个开箱即用的 CI服务。
而 Gitlab CI 更倾向于提供一个定制化的CI服务，比如支持Docker。
以上只是对于通过Gitlab CI对Android项目进行持续集成的简单实践。
如果感兴趣，大家可以思考下下面的问题：
1. 怎么通过Gitlab CI进行持续发布？
1. 怎么在Gitlab CI 加密字符串和文件，比如keystore文件？
1. 怎么在Gitlab CI中进行交互性操作，比如输入密码？
1. 怎么在过Gitlab CI中使用缓存？
