---
title: Android应用开发中的不良编程习惯
date: 2016-02-18 22:00:07
tags: android
categories: android
---

下面总结下Android应用开发中的不良编程习惯，欢迎对号入座。

## 不注意NULL判断
**原因:**    粗心。 在不确认一个对象是否为Null的前提下，就大胆调用该对象的成员变量或者成员方法。       
**结果：**   空指针异常。      
**解决方案：**   细心。 参考：[防止NullPointerException的最佳解决方案](http://snowdream.github.io/blog/2016/02/18/android-avoid-null/)

## 滥用变量
**原因:**   滥用变量。 定义很多变量，而且变量名字并不能表达变量的意思。       
**结果：**     代码难以理解，维护困难。          
**解决方案：**   规范变量命名，尽量让名字能表达变量的意思。同时，变量应该在于精，而不在于多。           

## 函数的重复调用
**原因:**    函数功能不清晰，搭车调用其他函数。举个例子，假如：函数A，B，C。 函数B中调用函数C,函数A中调用函数B。最后使用的时候，同时调用函数A，C，造成函数C被调用多次。           
**结果：**     轻者，造成程序性能下降，耗时，耗电。重者，导致程序逻辑混乱，造成各种意想不到的BUG。        
**解决方案：**   函数功能单一，并且稳定。        

## 耗时操作/IO操作放在子线程
**原因:**     贪图快，把耗时操作/IO操作放在主线程执行。     
**结果：**    轻则造成应用卡顿，重则出现ANR，导致应用崩溃。        
**解决方案：**   将所有耗时操作/IO操作封装到子线程去。       

## 拷贝函数/代码
**原因:**    有时候因为项目紧，开发任务中。在开发新功能时，经常将已有功能代码，拷贝过来改改，却没注意有部分内容需要修改或者去掉的。    
**结果：**     功能不符合预期，导致BUG。        
**解决方案：**   能重用的代码抽取出来公用。拷贝的时候，一定要过一遍，切记拿过来直接用。

## 滥用设计模式
**原因:**    当维护一个项目的人员比较多时，容易发生。你想用MVP，他想用MVC，别人还要用MVVM。      
**结果：**     项目代码出现百家争鸣，百花齐放的现象。难以维护。        
**解决方案：**   统一设计模式，便于开发维护。     

## 保留大量废弃代码/功能
**原因:**    有可能是产品反复增加/删除某个功能，或者其他原因，导致开发人员不敢删除废弃代码。   
**结果：**     无故增加代码量和方法数，增加阅读和维护成本。        
**解决方案：**   废弃功能/废弃代码统统删掉。自觉抵制产品反复增加/删除同一个功能。

## 代码风格不统一
**原因:**    使用不同的代码风格，同时又喜欢整个文件进行格式化。   
**结果：**     版本管理困难。 合并/比较代码时，满屏幕都是不一样代码。      
**解决方案：**   统一代码风格。否则，不要尝试对整个文件进行格式化。

## 函数臃肿
**原因:**    函数体代码太长，成百上千行的都有。      
**结果：**       代码阅读困难。     
**解决方案：**   拆分成多个小函数。    

## 函数命名随意，不规范
**原因:**     函数命名随意，不规范，又没有注释。     
**结果：**       一眼看过去，不知道这个函数干什么的。需要读完整个函数才知道函数的功能。     
**解决方案：**   函数命名尽量能体现函数的作用。如果无法完整体现，加函数注释，说清楚函数的作用，以及参数的含义。  

## 硬编码
**原因:**     在java代码中直接写字符串，而不定义在string.xml。      
**结果：**       不利于字符串重用和国际化。     
**解决方案：**     将字符串都定义到string.xml。

## 可见性控制不当
**原因:**     不注意控制成员变量和成员方法的可见性，都是用public来进行修饰。     
**结果：**       导致可见性失控。     
**解决方案：**    严格控制成员变量和成员方法的可见性，尽量缩小。

## 其他
想到再来补充。