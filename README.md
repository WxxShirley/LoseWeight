# LoseWeight
![build-env](https://img.shields.io/badge/flutter-1.22.3-brightgreen)
![progress](https://img.shields.io/badge/progress-10%25-yellowgreen)
![status](https://img.shields.io/badge/status-ongoing-red)

###
🏃‍♀️ 减肥健身打卡app

## 进度
 - [x] 11.9 打卡与主页原型设计完成

## 功能
* 设定打卡任务并完成，相应本地消息推送提醒、完成后勋章奖励
* 根据打卡记录生成年度、月度报表统计
* 查看他人饮食、运动、健康方面的动态
* 个性化报告

## 运行截图

 Screenshot1 | Screenshot2 | Screenshot3 
 -|-|-
 ![sh1](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG177.png)|![sh2](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG178.png)|![sh3](https://github.com/WxxShirley/LoseWeight/blob/master/README.assets/WechatIMG179.png)


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

