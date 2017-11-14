---
title: 用了WifiManager这么多年，今天才知道彻底用错了
date: 2017-11-13 20:15:45
categories: android
tags: android
---
---
>作者：snowdream   
>Email：yanghui1986527#gmail.com    
>Github: [https://github.com/snowdream](https://github.com/snowdream)   
>原文地址：[https://snowdream.github.io/blog/2017/11/13/android-wifimanager-leak-context/](https://snowdream.github.io/blog/2017/11/13/android-wifimanager-leak-context/)

## 问题
之前在处理内存泄漏相关问题时，碰到一个奇怪的问题。有一个闪屏界面，由于包含大图片，屡次内存泄漏，屡次修改。屡次修改，屡次还内存泄漏。
直到有一天，通过MAT工具分析一个相关hprof文件时，发现一个新的case: 内存泄漏矛头直指WifiManager。
![android-wifimanager-leak-context](https://static.dingtalk.com/media/lALPBbCc1SB50q5GzQKq_682_70.png_620x10000q90g.jpg)

关于WifiManager内存泄漏问题，在Android官方网站得到确认：
1. [Memory leak in WifiManager/WifiService of Android 4.2](https://issuetracker.google.com/issues/36964970)
1. [WifiManager use AsyncChannel leading to memory leak](https://issuetracker.google.com/issues/63244509)

## 解决
对于WifiManager，我一直都是这么用的：
```java
WifiManager wifiManager = ((WifiManager) this.getSystemService(Context.WIFI_SERVICE));
```

但是当我查阅WifiManager相关文档后，我终于改变了看法。
在WifiManager官方文档 https://developer.android.com/reference/android/net/wifi/WifiManager.html 中，提到一句话：

"On releases before N, this object should only be obtained from an application context, and not from any other derived context to avoid memory leaks within the calling process."

大概意思便是：      
在Android N以前，你应该只通过ApplicationContext来获取WifiManager，否则可能面临内存泄漏问题。

```java
WifiManager wifiManager = ((WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE));
```

## 分析
为什么WifiManager可能发生内存泄漏？

下面我们具体分析一下：

以Android 5.1.1_r6为例进行分析。

1.打开在线源码网站： http://androidxref.com/   。找到ContextImpl.java类源码。

2.从ContextImpl.java源码中，我们可以看到：一个进程可能创建多个WifiManager。同时，我们把Activity(也就是ctx.getOuterContext())，传给了WifiManager。    

```java
class ContextImpl extends Context {

  @Override
  public Object getSystemService(String name) {
     ServiceFetcher fetcher = SYSTEM_SERVICE_MAP.get(name);
     return fetcher == null ? null : fetcher.getService(this);
  }


  static {
   registerService(WIFI_SERVICE, new ServiceFetcher() {
          public Object createService(ContextImpl ctx) {
              IBinder b = ServiceManager.getService(WIFI_SERVICE);
              IWifiManager service = IWifiManager.Stub.asInterface(b);
              return new WifiManager(ctx.getOuterContext(), service);
          }});
  }
}
```

3.我们再接着浏览 WifiManager源码。这里把Context传给了sAsyncChannel，而这个sAsyncChannel竟然是一个静态变量。

```java
public class WifiManager {
  private static AsyncChannel sAsyncChannel;

  public WifiManager(Context context, IWifiManager service) {
      mContext = context;
      mService = service;
      init();
  }

  private void init() {
      synchronized (sThreadRefLock) {
          if (++sThreadRefCount == 1) {
              Messenger messenger = getWifiServiceMessenger();
              if (messenger == null) {
                  sAsyncChannel = null;
                  return;
              }

              sHandlerThread = new HandlerThread("WifiManager");
              sAsyncChannel = new AsyncChannel();
              sConnected = new CountDownLatch(1);

              sHandlerThread.start();
              Handler handler = new ServiceHandler(sHandlerThread.getLooper());
              sAsyncChannel.connect(mContext, handler, messenger);
              try {
                  sConnected.await();
              } catch (InterruptedException e) {
                  Log.e(TAG, "interrupted wait at init");
              }
          }
      }
  }
}
```

4.再接着浏览AsyncChannel的源码。这个context被保存在了AsyncChannel内部。
换一句话来说：你传进来的Activity/Fragment，被一个静态对象给持有了。一旦这个静态对象没有正确释放，就会造成内存泄漏。

```java
public class AsyncChannel {

    /** Context for source */
    private Context mSrcContext;

    /**
     * Connect handler and messenger.
     *
     * Sends a CMD_CHANNEL_HALF_CONNECTED message to srcHandler when complete.
     *      msg.arg1 = status
     *      msg.obj = the AsyncChannel
     *
     * @param srcContext
     * @param srcHandler
     * @param dstMessenger
     */
    public void connect(Context srcContext, Handler srcHandler, Messenger dstMessenger) {
        if (DBG) log("connect srcHandler to the dstMessenger  E");

        // We are connected
        connected(srcContext, srcHandler, dstMessenger);

        // Tell source we are half connected
        replyHalfConnected(STATUS_SUCCESSFUL);

        if (DBG) log("connect srcHandler to the dstMessenger X");
    }

    /**
     * Connect handler to messenger. This method is typically called
     * when a server receives a CMD_CHANNEL_FULL_CONNECTION request
     * and initializes the internal instance variables to allow communication
     * with the dstMessenger.
     *
     * @param srcContext
     * @param srcHandler
     * @param dstMessenger
     */
    public void connected(Context srcContext, Handler srcHandler, Messenger dstMessenger) {
        if (DBG) log("connected srcHandler to the dstMessenger  E");

        // Initialize source fields
        mSrcContext = srcContext;
        mSrcHandler = srcHandler;
        mSrcMessenger = new Messenger(mSrcHandler);

        // Initialize destination fields
        mDstMessenger = dstMessenger;

        if (DBG) log("connected srcHandler to the dstMessenger X");
    }
}
```

5.最后。既然google声称Android 7.0已经改了这个问题。那我们就来围观一下这个改动:WiFiManager中的AsyncChannel已经被声明为普通对象，而不是静态的。

[http://androidxref.com/7.0.0_r1/xref/frameworks/base/wifi/java/android/net/wifi/WifiManager.java#mAsyncChannel](http://androidxref.com/7.0.0_r1/xref/frameworks/base/wifi/java/android/net/wifi/WifiManager.java#mAsyncChannel)


## 发散
另外，查询资料，发现不止WiFiManager，还有AudioManager等也可能存在内存泄漏问题。具体参考： [https://android-review.googlesource.com/#/c/platform/frameworks/base/+/140481/](https://android-review.googlesource.com/#/c/platform/frameworks/base/+/140481/)

因此，建议，除了和UI相关的系统service，其他一律使用ApplicationContext来获取。



欢迎大家关注我的微信公众号:  sn0wdr1am    
![sn0wdr1am](https://static.dingtalk.com/media/lADOmAwFCs0BAs0BAg_258_258.jpg)

## 参考
1. [WifiManager](https://developer.android.com/reference/android/net/wifi/WifiManager.html)
1. [WifiManager use AsyncChannel leading to memory leak](https://issuetracker.google.com/issues/63244509)
1. [Memory leak in WifiManager/WifiService of Android 4.2
](https://issuetracker.google.com/issues/36964970)
1. [Fix context leak with AudioManager](https://android-review.googlesource.com/#/c/platform/frameworks/base/+/140481/)
1. [@SystemService for WifiManager causes a memory leak #1628](https://github.com/androidannotations/androidannotations/issues/1628)
1. [Memory leak in WiFiManager from Android SDK](https://github.com/pwittchen/NetworkEvents/issues/106)
1. [signed apk error [WifiManagerLeak]](https://stackoverflow.com/a/42639000)
1. [Android: 记一次Android内存泄露](https://segmentfault.com/a/1190000004882511)


## 联系方式
* Email：yanghui1986527#gmail.com
* Github: https://github.com/snowdream
* Blog: http://snowdream.github.io/blog/
* 简书：http://www.jianshu.com/u/748f0f7e6432
* 云栖博客：https://yq.aliyun.com/u/snowdream86
