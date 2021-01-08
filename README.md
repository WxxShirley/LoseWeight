# LoseWeight
###
🏃‍♀️ 减肥健身打卡app

## 运行方法
* 后端
> 安装了非常多的库来实现异步和socket通信 需要先安装
``` 
redis-server   # 开启redis
cd ./LoseWeightBackend
python3 manage.py runserver
```
可以进入`http://127.0.0.1:8000/admin`查看数据

* 前端
编译完成后可以终止flutter运行的项目，直接打开手机或模拟机中已经安装好的app
> 许多图片的并发访问使得直接运行的时候可能会报异常

## 功能
* 🎯 设定每周打卡任务并完成，完成获得勋章奖励
* 📈 根据打卡记录生成年度、月度、周报表统计
* ✨ 查看他人饮食、运动、健康方面的动态并收藏，也可发布
* 😋 记录每日饮食

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
   * jwt-token 根据token是否过期来决定返回主页/登陆页
   * socket监听 推送消息
   * 图片选择 - 单张/多张格式；图片的显示
   * 本地内容缓存，缓存token，每日饮食的一些内容
   * 周视图、月视图、年视图分别用了不同的插件
   * 下拉刷新插件pull_to_refresh => 实现动态界面的无限加载
* 构造可复用组件(在`compontents`下)
   * 九宫格显示图片
   * 类似朋友圈文字的收起与展开
   ······
* 状态管理
   * 根据用户的操作实时反馈消息(toast)
   * 根据用户操作刷新界面，有些功能的实现需要**父子组件通信**(回调函数)
   * 对话框中状态管理(在加入收藏夹的对话框中)



 
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

