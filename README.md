# LoseWeight
###
🏃‍♀️ 减肥健身打卡app

## 进度
 - [x] 11.9 打卡与主页原型设计完成
 - [x] 11.15 创建和完成打卡前后端联调完成
 - [x] 11.23 周视图、月视图、年视图
 - [x] 11.26 登陆注册、个人中心、每日饮食模块

## 功能
* 设定打卡任务并完成，相应本地消息推送提醒、完成后勋章奖励
* 根据打卡记录生成年度、月度报表统计
* 查看他人饮食、运动、健康方面的动态
* 个性化报告

## 运行截图

主页 | 完成打卡 | 创建打卡1 | 创建打卡2
 -|-|-|-
 ![sh1](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/2231606217806_.pic_hd.jpg)|![sh2](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/2211606217791_.pic_hd.jpg)|![sh3](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG179.png) | ![sh4](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/2251606217922_.pic_hd.jpg)
周视图 | 月视图 | 年视图 | 单个打卡记录视图
![sh5](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/2261606217939_.pic_hd.jpg) | ![sh6](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG219.png) | ![sh7](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/2271606217951_.pic.jpg) | ![sh8](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/2241606217898_.pic_hd.jpg)
饮食记录 | 个人中心 | 浏览动态 | 发布动态
![sh9](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG237.png) | ![sh10](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG235.png) | ![sh11](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG244.png) | ![sh12](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG242.png)
 
## `lib`文件说明
```
├── components       抽象出的组件
├── global           全局变量
├── main.dart
├── mainPage.dart
├── models           抽象类
├── pages            界面页，分别对应每日记录、统计奖励、消息和个人中心
│   ├── awards
│   ├── message
│   ├── personal
│   └── record
└── utils            功能函数
```

