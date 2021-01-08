import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/yearViewModel.dart';
import 'package:frontend/utils/utils.dart';
import 'package:heatmap_calendar/heatmap_calendar.dart';
import 'package:heatmap_calendar/time_utils.dart';



// 年视图抽象模版
// ignore: must_be_immutable
class YearViewUtil extends StatelessWidget
{
  Map<DateTime, int> times;
  Color color;
  String title;
  YearViewUtil({this.times, this.color, this.title});

  @override
  Widget build(BuildContext context){
    return
    Container(
      margin: EdgeInsets.symmetric(horizontal:3.0, vertical:8.0),
      child:Column(
        children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Text(title, style:TextStyle(color:color,fontWeight: FontWeight.w800)),
            Text(times.length.toString()+"次",)]
         ),
        
          HeatMapCalendar(
            input: times,
            colorThresholds: { 1: Theme.of(context).primaryColor},
            weekDaysLabels: [' ', ' ', ' ', ' ', ' ', ' ', ' '],
            monthsLabels: [""," ", " ", " ", " ", " ", " "," "," "," ", " "," ", " ",],
            squareSize: 10.0,
            textOpacity: 0.3,
            labelTextColor: color,
            dayTextColor: color,
          )
        ],
      )
    );
  }
}


// 年视图
class YearView extends StatefulWidget
{
  @override
  _YearView createState() => _YearView();
}

class _YearView extends State<YearView>
{
  bool _isLoading = false;
  List<YearRecord> _recs=new List<YearRecord>();
  Map<String, List<DateTime> > mps=new Map<String ,List<DateTime> >();
  Map<String, Color> mp2color = new Map<String, Color>();

  List<Widget> _show = new List<Widget>();
  
  @override
  void initState(){
    super.initState();
    load();
  }
  
  // 加载数据
  load() async{
    Dio _dio = new Dio();
    _dio.options.responseType = ResponseType.plain;
    Response _res = await _dio.get(myHost+"/clockin/year/view", queryParameters: {"mobile":userMobile,},options:  Options(headers: {'Authorization':myToken}));
    YearRecords yearRec = YearRecords.fromJson(json.decode(_res.data.toString()));
    _recs = yearRec.recs;
    
    
    for(var rec in _recs){
      List<DateTime> _dates = new List<DateTime>();
      _dates = rec.times.map((i)=>DateTime.parse(i)).toList();
      mps[rec.title]=_dates;
      mp2color[rec.title]=HexColor(rec.color);
    }

    print(mps);
    print(mp2color);

    mps.forEach((key, value) { 
   
      _show.add(
       new YearViewUtil(
        times: Map.fromIterable(value, key: (e)=>TimeUtils.removeTime(e), value:(e)=>1),
        color: mp2color[key],
        title: key,
      )
      
      );

    });

    setState((){
      mps = mps;
      mp2color = mp2color;
      _isLoading = true;
      _show = _show;
    });
    print(_show.length);
  }

  @override
  void dispose(){
    super.dispose();
  }

 // 没有打卡记录返回空
  Widget nullView(){
    return Container(alignment: Alignment.center,
      child: Column(
        children: [
          Container(height: 80.0,),
          Image.asset("assets/images/non.png"),
          Container(height: 20.0,),
          Text("今年没有打卡记录哦")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return 
     _isLoading==false || _show==null?
    Center(child:CircularProgressIndicator()) 
     :
   (
     // 根据用户该年打卡记录是否为空来判断
      _show.length==0?
      nullView():ListView(children: _show,)
   );
  }




}



/*
class YearView extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return ListView(
    children: [
      HeatMapCalendar(
        input: {
          TimeUtils.removeTime(DateTime.now().subtract(Duration(days: 30))): 50,
          TimeUtils.removeTime(DateTime.now().subtract(Duration(days: 100))): 50,
          TimeUtils.removeTime(DateTime.now().subtract(Duration(days: 150))): 50,
          TimeUtils.removeTime(DateTime.now()): 5,
        },
        colorThresholds: {
            1: Colors.green[100],
            10: Colors.green[300],
            30: Colors.green[500]
        },
        weekDaysLabels:  ['', '', '', '', '', '', ''],
        monthsLabels: 
            [
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
            ],

            squareSize: 6.0,
            textOpacity: 0.3,
            labelTextColor: Colors.blueGrey,
            dayTextColor: Colors.blue[500],
          ),
   

    ],);
  }

}

*/
