import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/clockinItem.dart';
import 'package:frontend/components/diet.dart';
import 'package:frontend/components/todayCard.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/global/mottos.dart';
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
  List<ClockRecord> _clocks;

  Timer _timer; 
  String motto=mottos[0]; // 每隔5min切换一次motto

  // 按照待打卡任务是否已经完成本周任务进行区分
  List<ClockRecord> _finishWeekList=new List<ClockRecord>();
  List<ClockRecord> _notFinishWeekList=new List<ClockRecord>();
  bool _show = true;

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  
  @override
  void initState(){
    super.initState();
    
   //mockLogin()
   _loadItems();
   
   // 设置定时切换motto的任务
   _timer = Timer.periodic(Duration(seconds: 300), (timer) { 
     String newMotto = mottos[Random().nextInt(8)];
     setState((){
       motto = newMotto;
     });
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
      totalLen = _clocks.length;
    });
    split();
  }
  
  // 下拉刷新
  void _onRefresh() async{
    _loadItems();
    _refreshController.refreshCompleted();
  }

  // 下拉加载
  void _onLoading() async{
    await Future.delayed(Duration(microseconds: 1000));
    _refreshController.loadComplete();
  }

  // 用户创建了新的打卡任务时回调
  onCreatedNew(ClockRecord newRecord){
    _clocks.add(newRecord);
    totalLen = _clocks.length;
    print("new Record:"+newRecord.title);
    split();
  }


  split(){
     _finishWeekList=new List<ClockRecord>();
      _notFinishWeekList=new List<ClockRecord>();
     for(int i=0;i<_clocks.length;i++){
      if(_clocks[i].hasWeekTaskFinish==1){
        _finishWeekList.add(_clocks[i]);
      }else{
        _notFinishWeekList.add(_clocks[i]);
      }
    }

    setState((){
      _finishWeekList = _finishWeekList;
      _notFinishWeekList = _notFinishWeekList;
    });
    
  }

  // 用户完成今日打卡回调
  onFinish(String title){
    for(int i=0;i<_notFinishWeekList.length;i++){
      if(_notFinishWeekList[i].title==title){
        _notFinishWeekList[i].hasTodayTag = 1;
        setState(() {
          _notFinishWeekList = _notFinishWeekList;
        });
        return ;
      }
    }
    for(int i=0;i<_finishWeekList.length;i++){
      if(_finishWeekList[i].title==title){
        _finishWeekList[i].hasTodayTag = 1;
        setState(() {
          _finishWeekList = _finishWeekList;
        });
        return ;
      }
    }
  }

  onDelete(String title){
    for(int i=0;i<_clocks.length;i++){
      if(_clocks[i].title==title){
        _clocks.removeAt(i);
        break;
      }
    }

    for(int i=0;i<_notFinishWeekList.length;i++){

      if(_notFinishWeekList[i].title==title){
        _notFinishWeekList.removeAt(i);
        print("found and delete");
        setState(() {
          totalLen = _clocks.length;
          _clocks = _clocks;
          _notFinishWeekList = _notFinishWeekList;
        });
        return ;
      }
    }
    for(int i=0;i<_finishWeekList.length;i++){
      if(_finishWeekList[i].title==title){
        _finishWeekList.removeAt(i);
        setState(() {
          totalLen = _clocks.length;
          _clocks = _clocks;
          _finishWeekList = _finishWeekList;
        });
        return ;
      }
    }

  }
  

  @override
  Widget build(BuildContext context){
    return
   SmartRefresher(
     enablePullDown: true,
     enablePullUp: true,
     header: WaterDropHeader(),
     footer: 
     CustomFooter(
       builder: (BuildContext context, LoadStatus mode){
         Widget body;
         if(mode==LoadStatus.idle){
           body = Text("下拉刷新", style: TextStyle(color: Theme.of(context).primaryColor),);
         }else if(mode==LoadStatus.loading){
           body = CupertinoActivityIndicator();
         }else if(mode==LoadStatus.failed){
           body = Text("加载失败，请重试", style: TextStyle(color: Theme.of(context).primaryColor),);
         }else if(mode==LoadStatus.canLoading){
           body=Text("下拉更多",style: TextStyle(color: Theme.of(context).primaryColor),);
         }else {
           body = Text("没有更多数据了",style: TextStyle(color: Theme.of(context).primaryColor),);
         }
         return Container(height: 50.0, child:Center(child:body));
       },
     ),
     controller: _refreshController,
     onRefresh: _onRefresh,
     onLoading: _onLoading,
     child: ListView(
      padding: EdgeInsets.only( top: 20.0,left: 20.0,right: 20.0,),
      children:<Widget>[
   
         CalendarCard(motto: motto,),
         Container(height:20.0),
         Diet(),
         _clocks ==null?  Center( child:CircularProgressIndicator(strokeWidth: 4,)) : 
        // ClockIns(list: _clocks,),
        
        Container(
       child: Column(children: [
         for(int i=0;i<_notFinishWeekList.length;i++)
            ClockinItem(item: _notFinishWeekList[i], index:i, onFinish: onFinish,onDelete: onDelete,),
         EmptyClockinItem(onCreate: onCreatedNew,),
         
         _finishWeekList.length>0?
         Column(
           children: [
             GestureDetector(child:
               Row(
                 children: [
                   Expanded(child: Divider(color: Theme.of(context).primaryColor),),
                   Text(" 显示本周已完成的任务 ",style: TextStyle(color: Theme.of(context).primaryColor),),
                   Expanded(child:Divider(color: Theme.of(context).primaryColor)),
                 ],
               ),
               onTap:(){
                 setState((){
                   _show = !_show;
                 });
               }
             ),
             Offstage(
               offstage: _show,
               child: Column(children: [
                 for(int i=0;i<_finishWeekList.length; i++)
                    ClockinItem(item: _finishWeekList[i], index:i, onFinish: onFinish,onDelete: onDelete,),
               ],)
             )
           ],
         ):Container()

       ],),
     )


         
    ])
   );
  }

  




}