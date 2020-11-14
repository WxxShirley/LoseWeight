import 'package:flutter/material.dart';

class Clockin{
  final String todo; // 名称(title)
  final String detail; // 详细情况(如果已经打卡)
  final int icon; // 对应的icon index
  final Color itemColor; // 对应的颜色
  final DateTime timestamp; // 今天打卡的时间戳
  final bool finish;  //今天是否完成

  Clockin({this.todo, this.detail, this.icon, this.itemColor, this.timestamp, this.finish});
}