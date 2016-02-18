---
title: Android handler.removeCallbacksAndMessages(null)的妙用
date: 2016-02-18 10:59:53
tags: android
categories: android
---
## 问题

在Android项目中，Handler通常被用作主线程和子线程之间的通信。在实际应用过程中，我们经常通过Hander发送Message或者Runnable到主线程，但却很少主动在UI（Activity/Fragment）销毁时，进行移除Message或者Runnable操作，造成的后果可能是内存泄露，空指针。。。

## 解决方案
参考网上的做法，这里建议在基础UI类（BaseActitivy/BaseFragment）的onDestory函数中，调用以下函数，自动移除Message或者Runnable。

```java
private void releaseHandlers(){
   try {
      Class<?> clazz = getClass();
      Field[] fields = clazz.getDeclaredFields();
      if (fields == null || fields.length <= 0 ){
               return;
       }

      for (Field field: fields){
         field.setAccessible(true);
         if(!Handler.class.isAssignableFrom(field.getType())) continue;

               Handler handler = (Handler)field.get(this);
               if (handler != null && handler.getLooper() == Looper.getMainLooper()){
                  handler.removeCallbacksAndMessages(null);
               }
         field.setAccessible(false);
      }
   } catch (IllegalAccessException e) {
      e.printStackTrace();
   }
}
```

**注：** 这里只是针对当前类进行处理。如果需要处理父类，则还需要一层遍历。

## 优缺点

### 优点
在基础UI类中统一修改，改动小，作用大。

### 缺点

影响范围大。只是用于Hander被用作主线程和子线程之间通信的场景。
如果Hander被创建在主线程，却被有意用在UI销毁后仍然能够执行的场景下，不适合使用这种方法。

## 欢迎讨论。

## 参考文档：
1. [http://blog.csdn.net/ouyang_peng/article/details/16801497](http://blog.csdn.net/ouyang_peng/article/details/16801497)   
1. [http://stackoverflow.com/questions/5883635/how-to-remove-all-callback-from-a-handler/10145615#10145615](http://stackoverflow.com/questions/5883635/how-to-remove-all-callback-from-a-handler/10145615#10145615)
