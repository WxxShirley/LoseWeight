import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/components/customizedToast.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/weekViewModel.dart';
import 'package:intl/intl.dart' show DateFormat;

class MonthView extends StatefulWidget
{
  @override
  _MonthView createState() => _MonthView();
}

class _MonthView extends State<MonthView>
{
  DateTime _currentDate = DateTime(2020,11,10);

  EventList<Event> _markedDateMap = new EventList<Event>();

  // 返回对应的icon格式
  static Widget _eventIcon = new Container(
    padding: EdgeInsets.all(0),
    decoration: new BoxDecoration(color:Colors.pink, borderRadius: BorderRadius.all(Radius.circular(1000)), border: Border.all(color:Colors.blue, width:2.0)),
    child: new Icon(Icons.check, color:Colors.blue,)
  );

  Map<DateTime, List<DayRecordDetail> > mp=new Map<DateTime, List<DayRecordDetail> >();
  // 显示Toast
  FToast _fToast;
   
  @override
  void initState(){
    super.initState();
    _fToast = FToast();
    _fToast.init(context);
    fetchMonthData();
  }
  
  // 加载当月打卡记录
  fetchMonthData() async{
    Dio _dio = new Dio();
    _dio.options.responseType = ResponseType.plain;
    Response _res = await _dio.get(myHost+"/clockin/month/view", queryParameters: {"mobile":userMobile,}, options:  Options(headers: {'Authorization':myToken}));
    
    DayRecords recs = DayRecords.fromJson(json.decode(_res.data.toString()));
    List<DayRecordDetail> _records = recs.records;

    // 生成markedDateMap
    for(var record in _records){
      var dayStr = record.date.toString().substring(0,10); // 用日期的前十位，形如2020-11-16作为key
      var key = DateTime.parse(dayStr);
      if(mp.containsKey(key)){
        mp[key].add(record);
      }else{
        mp[key]=[record];
      }
    }
    
    mp.forEach((key, value) {
      var dayStr = key.toString().substring(0,10); // 用日期的前十位，形如2020-11-16作为key
      var newKey = DateTime.parse(dayStr);

      List<Event> events = new List<Event>();
      events = value.map((i)=> new Event(date:newKey, title:i.detail, icon:_eventIcon, dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),)).toList();
     
       for(var e in events){
         _markedDateMap.add(newKey, e);
       }

    });
    showToast(_fToast, Icons.info, "仅展示当月记录哦");
    setState(() {
      mp = mp;
      _markedDateMap = _markedDateMap;
    });

  }
  
  @override
  Widget build(BuildContext context){
  return Container(
    margin: EdgeInsets.symmetric(horizontal:10.0, vertical:15.0),
    child: mp==null?
      Center(child:CircularProgressIndicator())
        :
      CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate = date);
      },
      showOnlyCurrentMonthDate: true,
      weekendTextStyle: TextStyle(color:Colors.red),
      thisMonthDayBorderColor: Colors.grey,
      // headerText: '月度统计',
      // headerTextStyle: TextStyle(color:Theme.of(context).primaryColor, fontSize: 16.0),
      weekFormat: false,
      markedDatesMap: _markedDateMap, // 有标记的日子
      height: 600,
      selectedDateTime: DateTime.now(), // 被选中的日子,设定为当日
      showIconBehindDayText: true,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      showHeader: false,
      markedDateIconMaxShown: 5,
      markedDateMoreCustomDecoration: BoxDecoration(color:Theme.of(context).primaryColor),
      selectedDayTextStyle: TextStyle(color:Theme.of(context).primaryColor),
      selectedDayButtonColor: Theme.of(context).primaryColorLight,
      todayTextStyle: TextStyle(color:Theme.of(context).primaryColor),
      minSelectedDate: _currentDate.subtract(Duration(days:60)),
      maxSelectedDate: _currentDate.add(Duration(days:60)),
      todayButtonColor: Colors.transparent,
      todayBorderColor: Colors.green,
      markedDateMoreShowTotal: false,
      // leftButtonIcon: Icon(Icons.chevron_left,color:Theme.of(context).primaryColor,  ),
      // rightButtonIcon: Icon(Icons.chevron_right,color:Theme.of(context).primaryColor,  ),
    )
  );
  }
    
    
}

