import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/returnButton.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/iconTheme.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/achieve.dart';
import 'package:frontend/utils/utils.dart';


class MyAchievePage extends StatefulWidget
{
  @override
  _MyAchievePage createState() => _MyAchievePage();
}

class _MyAchievePage extends State<MyAchievePage>
{
   bool isLoading = true;

   List<Achieve> _asList;

   @override
   void initState(){
     super.initState();
     load();
   }

   load() async{
      Dio _dio = new Dio();
    _dio.options.responseType = ResponseType.plain;
    Response _res = await _dio.get(myHost+"/clockin/achieve",queryParameters: {'mobile':userMobile, },options: Options(headers: {'Authorization':myToken}));
   
   Achieves _as = Achieves.fromJson(json.decode(_res.data.toString()));
   print(_as.acs);
    
    setState((){
      isLoading = false;
      _asList = _as.acs;
    });
   }

   @override
   Widget build(BuildContext context)
   {
     return Scaffold(
       appBar: AppBar(title:Text("我的成就"),leading: ReturnButton(),),
        body:   
         isLoading == true?
         Center(child:CircularProgressIndicator())
          : 
         
         _asList.length == 0?
         (
           Container(alignment: Alignment.center,
            child: Column(
            children: [
              Container(height: 80.0,),
              Image.asset("assets/images/non.png"),
              Container(height: 20.0,),
              Text("暂时没有达成成就哦")
            ],
           ),
          )
         )
        :
         ListView.builder(
           itemCount: _asList.length,
           itemBuilder: (BuildContext context, int index){
             return 
            Container(
              margin: EdgeInsets.only(left:20.0, right:20.0),
              child:

             Column(
               
               mainAxisSize: MainAxisSize.min,
               children: [
                  ListTile(
                leading: Icon(icons[int.parse(_asList[index].taskIcon)], color:HexColor(_asList[index].taskColor)),
                title: Text.rich(TextSpan(
                  children: [
                    TextSpan(text:"在第"),
                    TextSpan(text:_asList[index].weekNum, style: TextStyle(color:Colors.black45,  fontWeight: FontWeight.w800)),
                    TextSpan(text:"周完成任务:"),
                    TextSpan(text:_asList[index].taskTitle, style:TextStyle(color:HexColor(_asList[index].taskColor), fontWeight: FontWeight.w600)),
                  ]
                ))
              ),
              Divider(),

             ],));
             
           },
         )
     );

   }
}

