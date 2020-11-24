import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/components/customizedToast.dart';
import 'package:frontend/components/percentBar.dart';
import 'package:frontend/components/returnButton.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/iconTheme.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/clockRecord.dart';
import 'package:frontend/models/httpRes.dart';
import 'package:frontend/utils/utils.dart';

/*
   查看和修改某个打卡任务详情界面
*/


class SetTask extends StatefulWidget
{
  ClockRecord record;
  SetTask({this.record});

  @override
  _SetTask createState() => _SetTask(record: record);
}

class _SetTask extends State<SetTask>
{
  ClockRecord record;
  _SetTask({this.record});

  Color _newColor = Colors.limeAccent;
  // 显示Toast
  FToast _fToast;

  int total_weeks, finish_weeks, clockin_nums; // 总周数，完成的周数，总打卡次数

  @override
  void initState(){
    super.initState();
     _fToast = FToast();
    _fToast.init(context);

    fetch();
  }

  // 获得统计结果
  void fetch() async{
    Dio _dio = new Dio();

    Response _res = await _dio.get(myHost+"/clockin/analysis", queryParameters: {"mobile":userMobile,  "title":record.title}, options: Options(headers: {'Authorization':myToken}));
    print(_res.data.toString());
    List<String> ss = _res.data.toString().split("\r\n");
    setState((){
      clockin_nums = int.parse(ss[0]);
      total_weeks = int.parse(ss[1]);
      finish_weeks = int.parse(ss[2]);
    });
  }

  void changeColor(Color color) => setState(() => _newColor = color);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("打卡任务详情"),leading: ReturnButton(),),
      body: 

      clockin_nums==null?
      Center(child:CircularProgressIndicator()):
       ListView(
         padding: EdgeInsets.only( top: 5.0,left: 20.0,right: 20.0,),
         children: [
           // 打卡任务名称
           ListTile(
             leading: Icon(Icons.alarm_on, color: Theme.of(context).primaryColor),
             title: Text(record.title, style: TextStyle(color:Theme.of(context).primaryColor )),
           ),

           Divider(),
           
           // 主题色
           ListTile(
             title: Text("主题色"),
             subtitle: Text("点击可修改"),
             trailing: Icon(Icons.color_lens, color:HexColor(record.color)),
             onTap: ()async{
               showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    titlePadding: const EdgeInsets.all(0.0),
                    contentPadding: const EdgeInsets.all(0.0),
                    content: SingleChildScrollView(
                      child: 
                        MaterialPicker(
                            pickerColor: _newColor,
                            onColorChanged: changeColor,
                            enableLabel: true,
                          ),
                    ),
                    actions: [
                      FlatButton(child:Text("取消",style:TextStyle(color: Colors.grey)),onPressed: (){Navigator.pop(context);},),
                      FlatButton(child:Text("确定",style:TextStyle(color: Theme.of(context).primaryColor)),onPressed: () async{
                        setState((){
                          record.color = encodeColor(_newColor.toString());
                        });

                        // 发起服务端请求
                        Dio _dio = new Dio();
                        _dio.options.responseType = ResponseType.plain;
                        var queryParams = {
                          "mobile": userMobile,
                          "title": record.title,
                          "color": encodeColor(_newColor.toString())
                        };
                        Response _res = await _dio.get(myHost+"/clockin/set/color",queryParameters: queryParams,options: Options(headers: {'Authorization':myToken}));
              
                        HttpRes _httpRes = HttpRes.fromJson(json.decode(_res.data.toString()));
                        if(_httpRes.status=='ok'){
                          print("succ");
                          showToast(_fToast,Icons.check, "修改成功");
                        }else{
                          showToast(_fToast, Icons.error, "修改失败,请重试");
                        }
                         
                        Navigator.pop(context);
                      },),
                    ],
                  );
                }
              );
             },
           ),

           Divider(),
           
           // icon
           ListTile(
             title: Text("对应图标"),
             trailing: Icon(icons[int.parse(record.icon)], color: HexColor(record.color)),
           ),

           Divider(),

           // 开始时间
           ListTile(
             title: Text("开始时间"),
             trailing: Text(record.startDate),
           ),

           Divider(),
           // 结束时间
           ListTile(
             title: Text("结束时间"),
             subtitle: Text("点击可修改"),
             trailing: Text(record.endDate),
             onTap:() async{
               DateTime _date = await showDatePicker(
                 context:context, 
                 initialDate: DateTime.now(),
                 initialDatePickerMode: DatePickerMode.day,
                 firstDate: DateTime.now().subtract(Duration(days:2)),
                 lastDate: DateTime(2101),
               );
               if(_date!=null){

                 // 发起服务端请求
                 Dio _dio = new Dio();
                _dio.options.responseType = ResponseType.plain;
                var queryParams = {
                    "mobile": userMobile,
                    "title": record.title,
                    "end_date": _date.toString().substring(0,10)
                };
                Response _res = await _dio.get(myHost+"/clockin/set/end_date",queryParameters: queryParams,options: Options(headers: {'Authorization':myToken}));
              
                HttpRes _httpRes = HttpRes.fromJson(json.decode(_res.data.toString()));
                if(_httpRes.status=='ok'){
                    print("succ");
                    showToast(_fToast,Icons.check, "修改成功");
                }else{
                    showToast(_fToast, Icons.error, "修改失败,请重试");
                }

                setState((){
                  record.endDate = _date.toString().substring(0,10);
                });
               }
             }
           ),

           Divider(),

           // 每周频率
           ListTile(
             title: Text("每周频率"),
             trailing: Text("每周"+record.freq.toString()+"次"),
           ),


           Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 children: [
                   Expanded(child: Divider()),
                   Center(child: Text("整体完成情况",style: TextStyle(color:Theme.of(context).primaryColor, fontSize: 20.0 ) ),),
                   Expanded(child: Divider()),
                 ],
               ),

               // 共打卡..次，共..周完成任务, 计划完成情况 %
               Container(
                 margin: EdgeInsets.only(left:10.0),
                 child: Text("共打卡"+clockin_nums.toString()+"次", style:TextStyle(color:Theme.of(context).primaryColor, fontWeight: FontWeight.w600,),),
               ),

               PercentBar(len: finish_weeks, totalLen: total_weeks, title:"总周数与完成打卡周数"),
               
           ],),




       ],)
    );
  }

}

