import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/clockinItem.dart';
import 'package:frontend/components/diet.dart';
import 'package:frontend/components/todayCard.dart';
import 'package:animated_background/animated_background.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/clockRecord.dart';

/*
    每日记录主页
*/

class Record extends StatefulWidget
{
  @override
  _Record createState() => _Record();
}

class _Record extends State<Record>  with TickerProviderStateMixin
{
  bool allFinish = false;
  ParticleOptions particleOptions;
  List<ClockRecord> _clocks;
  
  @override
  void initState(){
    super.initState();
    
    particleOptions = ParticleOptions(
    //image: Image.asset('assets/images/celebrate3.jpg'),
    baseColor: allFinish==true? Colors.pink : Colors.white,
    spawnOpacity: 0.0,
    opacityChangeRate: 0.1,
    minOpacity: 0.5,
    maxOpacity: 1,
    spawnMinSpeed: 30.0,
    spawnMaxSpeed: 70.0,
    spawnMinRadius: 7.0,
    spawnMaxRadius: 15.0,
    particleCount: 40,
   );
   //mockLogin()
   _loadItems();
   setState((){
     particleOptions = particleOptions;
   });
  }

  // 模拟登陆
  mockLogin() async{
    Dio _dio = new Dio();
    Response _res = await _dio.get(myHost+"/user/login",queryParameters: {'mobile':userMobile,'pwd':myPwd});
    // 赋值给token
    myToken = _res.toString();
  }

  
  // 加载今天需要打卡的条目
  _loadItems() async{
    Dio _dio = new Dio();
    _dio.options.responseType = ResponseType.plain;
    Response _res = await _dio.get(myHost+"/clockin/load",queryParameters: {'mobile':userMobile},options: Options(headers: {'Authorization':myToken}));
    var _result = _res.data.toString();
    var _jsonResult = json.decode(_result);
    List<ClockRecord> _c = ClockRecords.fromJson(_jsonResult).records;
    
    setState(() {
      _clocks = _c;
    });
    print(_clocks);
  }
  

  @override
  Widget build(BuildContext context){
    return
    AnimatedBackground(
      behaviour: RandomParticleBehaviour(options: particleOptions ) ,
      vsync: this,
      child: 
       ListView(
      padding: EdgeInsets.only( top: 20.0,left: 20.0,right: 20.0,),
      children:<Widget>[
   
         CalendarCard(),
         Container(height:20.0),
         Diet(),
         _clocks ==null?  Center( child:CircularProgressIndicator(strokeWidth: 4,)) : ClockIns(list: _clocks),
         
    ])
    );
  }
}