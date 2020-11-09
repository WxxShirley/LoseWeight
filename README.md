# LoseWeight
![build-env](https://img.shields.io/badge/ENV-flutter-brightgreen)
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


## 文件说明
```
├── components       抽象出的组件
│   ├── clockinItem.dart       // 一个打卡条目
│   ├── customizedToast.dart   // 好看的toast
│   ├── diet.dart              // 展示一顿餐
│   ├── returnButton.dart     
│   └── todayCard.dart  
├── global           全局变量
│   └── iconTheme.dart
├── main.dart
├── mainPage.dart
├── models           抽象类
│   ├── clockin.dart
│   ├── iconThemeAttribute.dart
│   └── meal.dart
├── pages            界面页，分别对应每日记录、统计奖励、消息和个人中心
│   ├── awards
│   │   └── yearContribution.dart
│   ├── message
│   ├── personal
│   └── record
│       ├── chooseIconTheme.dart
│       ├── createTask.dart
│       └── recordPage.dart
└── utils            功能函数
    └── utils.dart
```

