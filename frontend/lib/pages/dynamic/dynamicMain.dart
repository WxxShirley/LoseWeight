import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/dynamic.dart';
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

  @override
  void initState(){
    super.initState();
    load(0);
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
                     onTap: (){
                      print("tap delete");
                      
                 },
               ),
            ],

               );
               
         }
       )
       );
      
   }
}








