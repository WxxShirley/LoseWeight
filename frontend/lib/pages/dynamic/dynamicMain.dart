import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/components/collectDialog.dart';
import 'package:frontend/components/customizedToast.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/dynamic.dart';
import 'package:frontend/models/httpRes.dart';
import 'package:frontend/pages/dynamic/oneWidget.dart';
import 'package:nine_grid_view/nine_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class DynamicMain extends StatefulWidget 
{
   @override
   _DynamicMain createState() => _DynamicMain();
}


class _DynamicMain extends State<DynamicMain>
{
  bool isLoading = true;
  int startPos=0;

  List<Dynamic> shows = new List<Dynamic>();

  bool hasMore = true;

  // 显示Toast
  FToast _fToast;

  @override
  void initState(){
    super.initState();
    load(0);
     _fToast = FToast();
    _fToast.init(context);
    // showToast(_fToast, Icons.star, "右滑可以收藏哦");
  }  

  load(int pos) async{
    print("fecth data, start:"+startPos.toString());
    Dio _dio = new Dio();
    _dio.options.responseType = ResponseType.plain;
    Response _res = await _dio.get(myHost+"/dynamic/load/1",queryParameters: {'mobile':userMobile, "start": pos},options: Options(headers: {'Authorization':myToken}));
   
    Dynamics dys = Dynamics.fromJson(json.decode(_res.data.toString()));
    shows.addAll(dys.dys);

    if(dys.dys==null || dys.dys.length==0){
      setState(() {
        hasMore = false;
      });
    }

    setState((){
      isLoading = false;
      startPos=pos+3;
      shows = shows;
    });
   
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  
  void _onRefresh() async{
     shows = new List<Dynamic>();
     setState(() {
       shows = shows;
     });
     load(0);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    load(startPos);
    _refreshController.loadComplete();
  }

    @override
   Widget build(BuildContext context)
   {

     return
       isLoading==null || isLoading==true?
       Center(child:CircularProgressIndicator()):

       SmartRefresher(
         enablePullDown: true,
         enablePullUp: true,
         header: WaterDropHeader(),
         footer: CustomFooter(
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
        child:
            ListView.builder(
             itemCount: shows.length,
             itemBuilder:(context, index){
               return 
               Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child:  OneWidget(dy: shows[index]),
                  actions: [
                   IconSlideAction(
                     iconWidget: Icon(Icons.star, color:Colors.white),
                     caption: "收藏",
                     color:Colors.red[100],
                     onTap: ()async{
                      print("tap delete");
                      bool _default=false, _sport=false, _food=false, _daily= false;
                      //弹出收藏
                     List<bool> res=await showDialog<List<bool> >(
                        context: context,
                        builder: (context){
                         return AlertDialog(
                            title: Text("加入收藏夹"),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(children: [
                                  Row( children: [
                                    Text("默认收藏夹"),DialogCheckbox(  value: _default, onChanged: (bool value){ _default = !_default; },
                                    ) ],
                                   ),
                                   Row(children: [
                                     Text("运动"), DialogCheckbox(value: _sport, onChanged: (bool value){_sport=!_sport;})
                                   ],),
                                   Row(children: [
                                     Text("经验"), DialogCheckbox(value: _daily, onChanged: (bool value){_daily=!_daily;})
                                   ],),
                                   Row(children: [
                                     Text("饮食"), DialogCheckbox(value: _food, onChanged: (bool value){_food=!_food;})
                                   ],),
                                ],)
                              ],
                            ),
                            actions: [
                              FlatButton(child: Text("取消"),onPressed: ()=>Navigator.of(context).pop(),),
                              FlatButton(child:Text("确定"),
                                onPressed: () async{
                                  print("确定");
                                  Navigator.of(context).pop([_default, _sport, _daily, _food]);

                                  Dio _dio = new Dio();
                                  String collectName="";
                                  if(_default){
                                    collectName="默认收藏夹";
                                  }else if(_sport){
                                    collectName="运动";
                                  }else if(_daily){
                                    collectName="日常";
                                  }else {
                                    collectName="饮食";
                                  }
                                  _dio.options.responseType = ResponseType.plain;
                                  var queryParam = {
                                    "mobile": userMobile,
                                    "collection_name": collectName,
                                    "bind_dynamic": shows[index].id,
                                  };
                                  Response _res = await _dio.get(myHost+"/dynamic/collect",queryParameters: queryParam,options: Options(headers: {'Authorization':myToken}));
                                  HttpRes _httpRes = HttpRes.fromJson(json.decode(_res.data.toString()));
                                  if(_httpRes.status=='ok'){
                                    showToast(_fToast, Icons.star, "收藏成功");
                                  }else{
                                    showToast(_fToast, Icons.error, "收藏失败，请重试");
                                  }
                                  
                                },
                              )
                            ],
                          );
                        }
                      );
                    print(res);
                 },
               ),
            ],

               );
               
         }
       )
       );
      
   }
}








