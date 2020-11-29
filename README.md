# LoseWeight
###
🏃‍♀️ 减肥健身打卡app

## 功能
* 🎯 设定每周打卡任务并完成，完成获得勋章奖励
* 📈 根据打卡记录生成年度、月度、周报表统计
* ✨ 查看他人饮食、运动、健康方面的动态并收藏，也可发布
* 😋 记录每日饮食

## TODO
* 最近太忙了，个人中心个人信息修改功能将留到期末后再做
* 目前后端暂未上传，有部署到服务器的打算，可能会**发布到Android与App Store**。这个也是期末后再做


## 截图

主页 | 完成打卡 | 创建打卡1 | 创建打卡2
 -|-|-|-
 ![sh1](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/2231606217806_.pic_hd.jpg)|![sh2](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/2211606217791_.pic_hd.jpg)|![sh3](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG179.png) | ![sh4](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/2251606217922_.pic_hd.jpg)
周视图 | 月视图 | 年视图 | 单个打卡记录视图
![sh5](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/2261606217939_.pic_hd.jpg) | ![sh6](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG219.png) | ![sh7](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/2271606217951_.pic.jpg) | ![sh8](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/2241606217898_.pic_hd.jpg)
饮食记录 | 饮食记录2 | 浏览动态 | 发布动态
![sh9](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG237.png) | ![sh10](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG250.png) | ![sh11](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG244.png) | ![sh12](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG242.png)
 个人中心 | 我的信息 | 我的收藏 | 我的成就
 ![sh13](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG235.png) | ![sh14](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG238.png) | ![sh15](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG249.png) | ![sh16](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG248.png)
 

## 主要技术
* 插件使用
* 构造可复用组件
* 监听socket消息


 
## `lib`文件说明
```
├── components       抽象出的组件
├── global           全局变量
├── main.dart
├── mainPage.dart
├── models           抽象类
├── pages            界面页，分别对应每日记录、统计奖励、消息和个人中心
└── utils            功能函数
```

