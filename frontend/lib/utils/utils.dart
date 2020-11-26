

import 'package:flutter/material.dart';
import 'package:frontend/global/info.dart';
import 'package:shared_preferences/shared_preferences.dart';

String formatDate (){
  var date = DateTime.now();
  return date.year.toString()+"-"+date.month.toString()+"-"+date.day.toString();
}

String formateTime() {
  var hour = DateTime.now().hour.toString();
  if(hour.length==1){
    hour = "0"+hour;
  }
  var minute = DateTime.now().minute.toString();
  if(minute.length==1){
    minute = "0"+minute;
  }

  return hour+":"+minute;
}

String weekdayInfo(){
  List weekdayList = ['','周一','周二','周三','周四','周五','周六','周末'];

  return weekdayList[DateTime.now().weekday];
}

String fetchWeekDay(DateTime time)
{
  List weekdayList = ['','周一','周二','周三','周四','周五','周六','周末'];

  return weekdayList[time.weekday];
}


// 色彩提取 遍历找到第一个出现0x...的
String encodeColor(String color){
  for(int i=0;i<color.length;i++){
    if( color[i]=='0' && i+1<color.length && color[i+1]=='x')
    {
      for(int j=i+1;j<color.length+1;j++){
        if(color[j]==')'){
          return color.substring(i+2,j);
        }
      }
    }
  }
  return "0xffeeff41"; // 默认颜色
}

// 解析color
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}


Future<void> reset() async{
  userMobile = "";
  myToken = "";
  SharedPreferences _prefs =  await SharedPreferences.getInstance();
  _prefs.setString("token", null);
}


String key()
{
  return DateTime.now().toString().substring(0,10)+userMobile;
}