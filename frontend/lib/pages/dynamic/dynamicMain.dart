import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/dynamic.dart';
import 'package:frontend/pages/dynamic/oneWidget.dart';
import 'package:nine_grid_view/nine_grid_view.dart';


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
    load();
  }  

  load() async{
    print("fecth data, start:"+startPos.toString());
    Dio _dio = new Dio();
    _dio.options.responseType = ResponseType.plain;
    Response _res = await _dio.get(myHost+"/dynamic/load/1",queryParameters: {'mobile':userMobile, "start": startPos},options: Options(headers: {'Authorization':myToken}));
   
    Dynamics dys = Dynamics.fromJson(json.decode(_res.data.toString()));
    shows.addAll(dys.dys);

    if(dys.dys==null || dys.dys.length==0){
      setState(() {
        hasMore = false;
      });
    }

    setState((){
      isLoading = false;
      startPos+=3;
      shows = shows;
    });

  }


    @override
   Widget build(BuildContext context)
   {

     return
       isLoading==null || isLoading==true?
       Center(child:CircularProgressIndicator()):
       ListView.builder(
         itemCount: shows.length,
         itemBuilder:(context, index){
           if(index==shows.length-1&&hasMore==true) 
              load();
          if(index==shows.length-1&&hasMore==false){
            return Column(children: [
              OneWidget(dy: shows[index]),
              Align(child: Text("没有更多数据了"),),
            ],);
          }
          return OneWidget(dy: shows[index]);
         }
       );
      
   }
}








