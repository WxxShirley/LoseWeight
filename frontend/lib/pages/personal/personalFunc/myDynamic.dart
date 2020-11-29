import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/components/customizedToast.dart';
import 'package:frontend/components/returnButton.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/dynamic.dart';
import 'package:frontend/models/httpRes.dart';
import 'package:frontend/pages/dynamic/oneWidget.dart';


// 我的动态界面

class MyDynamics extends StatefulWidget
{
  @override
  _MyDynamics createState() => _MyDynamics();
}


class _MyDynamics extends State<MyDynamics>
{
  bool isLoading = true;

  List<Dynamic> shows = new List<Dynamic>();

  // 显示Toast
  FToast _fToast;

   @override 
   void initState()
   {
     super.initState();
     load();
      _fToast = FToast();
    _fToast.init(context);
   }

   load() async{
   
    Dio _dio = new Dio();
    _dio.options.responseType = ResponseType.plain;
    Response _res = await _dio.get(myHost+"/dynamic/load/2",queryParameters: {'mobile':userMobile, },options: Options(headers: {'Authorization':myToken}));
   
    Dynamics dys = Dynamics.fromJson(json.decode(_res.data.toString()));
    shows.addAll(dys.dys);

    setState((){
      isLoading = false;
      shows = shows;
    });
  }

  delete(int index) async{
    Dynamic _del = shows[index];

    Dio _dio = new Dio();
     _dio.options.responseType = ResponseType.plain;
     var queryParam = {
       "mobile": userMobile,
       "dynamic_id": _del.id,
     };
    Response _res = await _dio.get(myHost+"/dynamic/delete",queryParameters: queryParam,options: Options(headers: {'Authorization':myToken}));
    HttpRes _httpRes = HttpRes.fromJson(json.decode(_res.data.toString()));
    if(_httpRes.status == 'ok'){
      showToast(_fToast, Icons.check, "删除成功");
      shows.removeAt(index);
      setState((){
        shows = shows;
      });
    }else {
      showToast(_fToast, Icons.error, "删除失败，请重试");
    }

  }


   @override
   Widget build(BuildContext context)
   {
     return Scaffold(
       appBar: AppBar(title:Text("我的发布"),
         leading: ReturnButton(),
       ),

       body:  
         isLoading==true?
           Center(child:CircularProgressIndicator())
           :
           ListView.builder(
         itemCount: shows.length,
         itemBuilder:(context, index){ 

           // 提供侧滑删除功能
          return 
          
          Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child:  OneWidget(dy: shows[index]),
            actions: [
               IconSlideAction(
                 caption: "删除",
                 color:Colors.red,
                 icon:Icons.delete,
                 onTap: (){
                   print("tap delete");
                   delete(index);
                   // TODO：删除功能
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> new SetTask(record: item)));

                 },
               ),
            ],
          );
          
         
         }
       )
     );


   }
}



