import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:frontend/components/customizedToast.dart';
import 'package:frontend/components/returnButton.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/iconTheme.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/clockRecord.dart';
import 'package:frontend/models/httpRes.dart';
import 'package:frontend/pages/record/chooseIconTheme.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/utils/utils.dart';

/*
    新建一个打卡记录界面
*/

class Tag extends StatelessWidget
{
   final String content;
   final ValueChanged<String> onChooseTag;
   Tag({this.content, this.onChooseTag});
   

   @override
   Widget build(BuildContext context){
     return GestureDetector( 
       onTap:(){
         onChooseTag(content); 
       },
       child: 
       Container(
           padding: EdgeInsets.only(left:5.0, right:5.0, top:10.0,bottom: 10.0),
           alignment: Alignment.center,
           width:  (content.length+1).toDouble()*20,
           child:
         SizedBox(
           height: 30,
           child: DecoratedBox(
             decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color:Colors.grey[200],),
             child:Align(child: Text("#"+content+"#"))
           )
         )));
   }
}

class CreateTask extends StatefulWidget
{
   @override
  _CreateTask createState() => _CreateTask();
}

class _CreateTask extends State<CreateTask>
{
  // 新的打卡任务属性
  IconData _iconTheme;
  List<DateTime> _date;
  double _freq=1;
  Color _colorTheme = Colors.limeAccent;
  String _showDate;
  int _iconIndex;

  // 表单控制
  TextEditingController _titleController = new TextEditingController();
  GlobalKey _taskKey =new GlobalKey<FormState>();

  // 显示Toast
  FToast _fToast;

  @override
  void initState(){
    super.initState();
    _iconTheme = null;
    _fToast = FToast();
    _fToast.init(context);
  }
  
  void changeColor(Color color) => setState(() => _colorTheme = color);
  void onTagChosenCallback(String content){
    setState((){
      _titleController.text = content;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("新建打卡"),leading: ReturnButton(),),
      body: Form(
        key: _taskKey,
      child:
      ListView(
        padding: EdgeInsets.only( top: 5.0,left: 20.0,right: 20.0,),
        children: [
          Container(
            child: TextField(
              autofocus: true,
              controller: _titleController,
              decoration: InputDecoration(labelText: "任务名",hintText: "开启打卡的任务名",icon:Icon(Icons.alarm_on),border: InputBorder.none),
            ),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200],width: 1.0)),)
          ),
         
         // 展示热门的tag
         Container(
           padding: EdgeInsets.all(10.0),
           child:Column(
             children: [
               Row(children: [
                 Icon(FontAwesome.fire,color:Theme.of(context).primaryColor),Text("热门",style: TextStyle(color:Theme.of(context).primaryColor),)
               ],),
               Row(children: [
                 Tag(content: "跑步", onChooseTag: onTagChosenCallback,),
                 Tag(content:"Hit运动",onChooseTag: onTagChosenCallback,),
                 Tag(content:"不喝奶茶",onChooseTag: onTagChosenCallback,),
               ],),
               Row(children: [
                 Tag(content:"健身餐",onChooseTag: onTagChosenCallback),
                 Tag(content:"撸铁",onChooseTag: onTagChosenCallback),
                 Tag(content:"帕梅拉",onChooseTag: onTagChosenCallback,),
                 Tag(content:"早睡",onChooseTag: onTagChosenCallback,),
               ],
               )
             ],
           ),
           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
         ),
         Divider(),
     
          ListTile(title:Text("选择时间区间",),
            trailing: _showDate==null? Icon(Icons.chevron_right):Text(_showDate),
            onTap:() async{
              final List<DateTime> picked = await DateRangePicker.showDatePicker(
                context: context,
                initialFirstDate: new DateTime.now(),
                initialLastDate: (new DateTime.now()).add(new Duration(days:7)),
                firstDate: (new DateTime.now()).subtract(new Duration(days:20)),
                lastDate: (new DateTime.now()).add(new Duration(days:360)),
              );
              if (picked != null && picked.length == 2 && picked[1].compareTo(DateTime.now())>0 ) {
                 print(picked);
                 String show = picked[0].toString().substring(0,10) + "至" + picked[1].toString().substring(0,10);
                 setState((){
                   _date = picked;
                   _showDate = show;
                 });
              }else{
                showToast(_fToast, Icons.error, "请选择合法时间");
              }
            }
          ),
          Divider(),
         
          // 选择频率
          Row(
            children: [
              Container(width: 15.0,),
              Text("选择频率",style:TextStyle(fontSize: 18.0)),
              Slider(value: _freq, min:0,max:7,divisions: 7,label: "每周"+_freq.round().toString()+"次",
                onChanged: (double value){
                  setState((){
                    _freq = value;
                 });
              },
             ),
             Text( "每周"+_freq.round().toString()+"次",style:TextStyle(fontSize: 12.0))
            ],
         ),

          Divider(),

          ListTile(title:Text("选择主题"),trailing: Icon( _iconTheme==null? Icons.chevron_right: _iconTheme, color: _iconTheme==null?  Colors.grey: Theme.of(context).primaryColor),
             onTap: ()async {
               // 等待前一界面返回结果
               final _icon = await  Navigator.push(context, MaterialPageRoute(builder: (context)=>new IconsPage()));
               if(_icon>0){
                 setState(() {
                   _iconTheme = icons[_icon];
                   _iconIndex = _icon;
                 });
               }
             },
          ),
          Divider(),


          ListTile(title:Text("选择主题色"),trailing: Icon( Icons.color_lens,color:_colorTheme),
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    titlePadding: const EdgeInsets.all(0.0),
                    contentPadding: const EdgeInsets.all(0.0),
                    content: SingleChildScrollView(
                      child: 
                        MaterialPicker(
                            pickerColor: _colorTheme,
                            onColorChanged: changeColor,
                            enableLabel: true,
                          ),
                    ),
                    actions: [
                      FlatButton(child:Text("取消",style:TextStyle(color: Colors.grey)),onPressed: (){Navigator.pop(context);},),
                      FlatButton(child:Text("确定",style:TextStyle(color: Theme.of(context).primaryColor)),onPressed: (){Navigator.pop(context);},),
                    ],
                  );
                }
              );
            },
          ),

          Divider(),

          Container(height: 20.0,),

          FloatingActionButton.extended(
            onPressed: ()async{


              print(_titleController.text);
              print(_freq.toString());
              
              if(_titleController.text=="" || _freq.toInt()==0 || _iconTheme==null || _date.length!=2){
                showToast(_fToast,Icons.error, "请检查表单");
              }

             
              var queryParams = {
                "mobile":userMobile,
                "startDate":_date[0].toString().substring(0,10),
                "endDate":_date[1].toString().substring(0,10),
                "color": encodeColor(_colorTheme.toString()), //提取color对应的int
                "icon": _iconIndex, //存储icon对应的index
                "title": _titleController.text,
                "freq":_freq.toInt(),
              };
              print(queryParams);

              Dio _dio = new Dio();
              _dio.options.responseType = ResponseType.plain;
              Response _res = await _dio.get(myHost+"/clockin/create",queryParameters: queryParams,options: Options(headers: {'Authorization':myToken}));
              
              HttpRes _httpRes = HttpRes.fromJson(json.decode(_res.data.toString()));
              // 将新对象传递给前页
              if(_httpRes.status=='ok'){
                 showToast(_fToast,Icons.check, "创建成功");
                 ClockRecord newRecord = ClockRecord(
                   id:int.parse( _httpRes.type),
                   title: queryParams["title"],
                   startDate: queryParams["startDate"],
                   endDate: queryParams["endDate"],
                   freq: queryParams["freq"],
                   icon: queryParams["icon"].toString(),
                   color: queryParams["color"],
                   cTime: DateTime.now().toString().substring(0,10),
                   hasTodayTag: 0,
                 );
                 // 如果今天也在打卡日子中
                 if(_date[0].compareTo(DateTime.now())<=0 && _date[1].compareTo(DateTime.now())>=0){
                   Navigator.pop(context, newRecord);
                 }else{
                   Navigator.pop(context);
                 }
                 
              }else if(_httpRes.status=='error' && _httpRes.type=='over length'){
                showToast(_fToast,Icons.error, "超过最多打卡数目限制!");
              }else {
                showToast(_fToast,Icons.error, "创建失败");
              }
              

            }, 
            backgroundColor: Theme.of(context).primaryColor,
            label: Row(children: [
              Icon(Icons.send),
              Text("新建任务")
            ],)
        )
      ],)
    ));
  }

  /*_showToast(IconData icon, String hintText){
    _fToast.showToast(child: CusToast(icon:icon, hintText:hintText),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds:2),
    );
  }*/

}
