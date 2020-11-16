import 'dart:convert';

import 'package:calendar_strip/calendar_strip.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:frontend/components/circleBedge.dart';
import 'package:frontend/components/percentBar.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/iconTheme.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/weekViewModel.dart';
import 'package:frontend/utils/utils.dart';

import 'package:flutter_calendar_week/flutter_calendar_week.dart';

/*
    周视图
*/
class WeekView extends StatefulWidget
{
  @override
  _WeekView createState() => _WeekView();
}

class _WeekView extends State<WeekView>
{
   
   final CalendarWeekController _controller = CalendarWeekController();


   bool isLoading = true; // 是否正在加载
   DateTime selectedDate = DateTime.now();

   DateTime startDate=DateTime.now(), endDate=DateTime.now();

  
   // 有标注的日期 [打卡日]
   List<DateTime> markedDates =new List<DateTime>();
   List<DayRecordDetail> lists=new List<DayRecordDetail>();
  
   // 加载的每日打卡记录
   Map<DateTime, List<DayRecordDetail> > mp=new Map<DateTime, List<DayRecordDetail> >();
   
   // 每个日期的装饰
   List<DecorationItem> _items=new List<DecorationItem>();

   @override
   void initState(){
     super.initState();
     dataLoad();
   }

   // 加载打卡记录数据
  dataLoad() async{
    Dio _dio = new Dio();
    _dio.options.responseType = ResponseType.plain;
    Response _res = await _dio.get(myHost+"/clockin/week/view", queryParameters: {"mobile":userMobile,}, options:  Options(headers: {'Authorization':myToken}));
    
    DayRecords recs = DayRecords.fromJson(json.decode(_res.data.toString()));
    List<DayRecordDetail> _records = recs.records;
    
    // 进行按时间的整理归档
    for(var record in _records){
      var dayStr = record.date.toString().substring(0,10); // 用日期的前十位，形如2020-11-16作为key
      var key = DateTime.parse(dayStr);
      if(mp.containsKey(key)){
        mp[key].add(record);
      }else{
        mp[key] = [record];
        markedDates.add(key);
      }
    }

    selectedDate = DateTime.now();
    if(mp.containsKey(DateTime.parse(selectedDate.toString().substring(0,10)))==true){
      lists = mp[ DateTime.parse(selectedDate.toString().substring(0,10))];
    }
    
    // 将时间限制在本周
    while(startDate.weekday != 1){
      startDate = startDate.subtract(Duration(days:1));
    }

    while(endDate.weekday != 7){
      endDate = endDate.add(Duration(days: 1));
    }

    mp.forEach((key, value) {
      
      List<Widget> _row=new List<Widget>();
      for(var detail in value){
        _row.add(Icon(icons[int.parse(detail.iconTheme)], color:HexColor(detail.colorTheme)));
      }
      DecorationItem _item = new DecorationItem(date: key, decorationAlignment: value.length<=3? FractionalOffset.bottomCenter: FractionalOffset.bottomLeft,decoration: Row(children: _row));
      _items.add(_item);
    });

    setState(() {
      markedDates =  markedDates;
      mp = mp;
      selectedDate = DateTime.now();
      lists = lists;
      isLoading = false;
      startDate = startDate;
      endDate = endDate;
      _items = _items;
    });
  }

  onDayPress(DateTime time){
    setState((){
      selectedDate = time;
    });
  }
  
  
  // 奖章与成就widget
  achieve(DateTime select){
    // 如果被点击的当日无打卡行为, 返回为空
    var key = DateTime.parse(select.toString().substring(0,10));
    if(mp.containsKey(key)==false){
      return Container(
        margin: EdgeInsets.fromLTRB(25.0, 50, 25.0, 40),
        child:Center(
          child: Column(children: [
            Image.asset("assets/images/non.png"),
            Container(height:30.0),
            Text("当日无打卡行为哦", )
          ],)
        )
      );
    }else{
    
    // 完成的打卡形成一行成就

    // 需要根据条目不同来判断
    Widget _son; 
    if(mp[key].length<=3){
      List<Widget> achieves = new List<Widget>();
      for(var detail in mp[key]){
       achieves.add(
        CircleBadge( color:HexColor(detail.colorTheme),title: detail.title, subtitle: detail.detail,)
      );
      _son = Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: achieves,);
     }
    }else{
      List<Widget> row1 = new List<Widget>(), row2 = new List<Widget>();
      int mid = mp[key].length==4?2:3;
      for(int i=0;i<mid;i++){
        var detail = mp[key][i];
        row1.add(CircleBadge(color:HexColor(detail.colorTheme), title: detail.title, subtitle: detail.detail,));
      }
      for(int i=mid;i<mp[key].length;i++){
        var detail = mp[key][i];
        row2.add(CircleBadge(color:HexColor(detail.colorTheme), title: detail.title, subtitle: detail.detail,));
      }
      _son = Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: row1),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: row2),
      ],);
    }
    


    return 
    Container(
      margin: EdgeInsets.only(top:20.0),
     //decoration: BoxDecoration(  color: Colors.grey[200]),
     padding:  EdgeInsets.fromLTRB(5.0, 25.0, 5.0, 15.0),
     decoration: BoxDecoration(color: Colors.grey[200], boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.2), blurRadius: 10.0,spreadRadius: 1)]),
     child:

    Column(
      
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(padding:EdgeInsets.symmetric(horizontal:10.0, vertical:0),child:Text('成就', style: TextStyle(fontSize: 18.0, color:Theme.of(context).primaryColor,fontWeight: FontWeight.w600,),),) ,
        Container(
         margin: EdgeInsets.only(bottom: 30.0),
         child: _son
        ),
        PercentBar(len: mp[key].length, totalLen: totalLen),
      ],));
  }}



   @override 
   Widget build(BuildContext context){
     return 
  isLoading==true? 
    Center(child:CircularProgressIndicator()):

      ListView(
    children: [
      // 周日历视图
      Container(
        decoration: BoxDecoration(boxShadow: [BoxShadow(color:Theme.of(context).primaryColor.withOpacity(0.2),blurRadius: 10, spreadRadius: 1)]),
        child: CalendarWeek(
          controller:  _controller,
          height: 100,
          maxDate:endDate,
          minDate:startDate,
          onDatePressed: onDayPress,
          onDateLongPressed: onDayPress,

          onWeekChanged: () {},
          weekendsStyle: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
          dayOfWeekStyle: TextStyle(color: Theme.of(context).primaryColorLight, fontWeight: FontWeight.w600),
          dayOfWeekAlignment: FractionalOffset.bottomCenter,
          dateStyle: TextStyle(color: Theme.of(context).primaryColorLight, fontWeight: FontWeight.w400),
          dateAlignment: FractionalOffset.topCenter,
          todayDateStyle:TextStyle(color: Colors.orange, fontWeight: FontWeight.w400),
          todayBackgroundColor: Colors.black.withOpacity(0.15),
          pressedDateBackgroundColor: Theme.of(context).primaryColor,
          pressedDateStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          dateBackgroundColor: Colors.transparent,
          backgroundColor: Colors.white,
          dayOfWeek: ['周一', '周二', '周三', '周四', '周五', '周六', '周天'],
          showMonth:false,
          spaceBetweenLabelAndDate: 0,
          dayShapeBorder: CircleBorder(),
          decorations: _items,
        ),
       ),

      // 当日成就
      achieve(selectedDate),

     ],);
   }


}




