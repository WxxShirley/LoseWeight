import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/components/customizedToast.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/iconTheme.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/clockRecord.dart';
import 'package:frontend/models/clockin.dart';
import 'package:frontend/models/httpRes.dart';
import 'package:frontend/pages/record/createTask.dart';
import 'package:frontend/utils/utils.dart';

/*
    打卡记录组件
     - 新建打卡记录 EmptyClockinItem
     - 显示一条打卡记录 ClockinItem
*/


// ignore: must_be_immutable
class ClockinItem extends StatelessWidget
{
   ClockRecord item;
   int index;
   final ValueChanged<int> onFinish;
   ClockinItem({this.item, this.index, this.onFinish});

   final _detailKey = GlobalKey<FormState>();
   TextEditingController _detailController = new TextEditingController();

   // 显示Toast
  FToast _fToast;

   // 完成的输入文字框
   TextFormField _buildFinishTextField(){
     return TextFormField(
       autofocus: true,
       controller: _detailController,
       initialValue: null,
       decoration: InputDecoration(labelText: "记下想说的话吧.."),
       validator: (String value){
         if(value.isEmpty)
           return "说点什么吧～";
       },
     );
   }
   

   @override
   Widget build(BuildContext context){
     _fToast = FToast();
     _fToast.init(context);
     return Container(
    padding: EdgeInsets.only(top:10.0, bottom: 5.0),
    child:
     DecoratedBox(
       decoration: BoxDecoration(
         color: HexColor(item.color),
         borderRadius: BorderRadius.circular(10.0),
       ),
       child: 
         ListTile(leading: Icon(icons[int.parse(item.icon)]),
          title: Text(item.title, style:TextStyle(color: Colors.white)),
          trailing: item.hasTodayTag >0 ?Text("🎉") : Text("❎"),
          onTap: (){
            print("tapped");
            if(item.hasTodayTag==0){
              // 尚未完成今日的打卡，弹出对话框以完成
              showDialog(context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    content: Form(
                      key: _detailKey,
                      child: _buildFinishTextField(),
                    ),
                    actions: [
                      new FlatButton(onPressed: (){Navigator.pop(context);},child:Text("取消", style:TextStyle(color:Colors.grey))),
                      new FlatButton(child:Text("确定",style:TextStyle(color:Theme.of(context).primaryColor)),
                        onPressed: ()async{
                          Dio _dio = new Dio();
                          _dio.options.responseType = ResponseType.plain;
                          Response _res = await _dio.get(myHost+"/clockin/record", queryParameters: {"mobile":userMobile, "detail": _detailController.text, "title":item.title}, options: Options(headers: {'Authorization':myToken}));
                          HttpRes _httpres = HttpRes.fromJson(json.decode(_res.data.toString()));
                          if(_httpres.status=='ok'){
                            // 完成回调
                            onFinish(index);
                            showToast(_fToast, Icons.check, "打卡成功!");
                            Navigator.pop(context);
                          }else{
                            print("error");
                            showToast(_fToast, Icons.error, "打卡失败");
                          }
                        },
                       )
                    ],
                  );
                }
              );
            }
          },
         )
      )
     );
   }
}


class EmptyClockinItem extends StatelessWidget{
  // 用户创建时回调
  final ValueChanged<ClockRecord> onCreate;
  EmptyClockinItem({this.onCreate});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
        child: DecoratedBox(
          decoration: BoxDecoration(color:Colors.grey[200], borderRadius: BorderRadius.circular(5.0)),
          child: Container(
            width: 500.0,
            height: 50.0,
            child:Icon(Icons.add),
          )
        ),
      ),
      onTap: () async{
        final newRecord = await Navigator.push(context, MaterialPageRoute(builder: (context)=> new CreateTask()));
        
        // 执行回调函数
        if(newRecord!=null){
          onCreate(newRecord);
        }
      },
    );
  }
}



// ignore: must_be_immutable
class ClockIns extends StatefulWidget
{
  List<ClockRecord> list;
  ClockIns({this.list});

  @override
  _ClockIns createState() => _ClockIns(list: list);
}

class _ClockIns extends State<ClockIns>
{
  List<ClockRecord> list;
  _ClockIns({this.list});
  
  // 用户创建了新的打卡任务时回调
  onCreatedNew(ClockRecord newRecord){
    list.add(newRecord);
    setState(() {
      list = list;
    });
  }

  // 用户完成今日打卡回调
  onFinish(int index){
    list[index].hasTodayTag = 1;
    
    setState(() {
      list = list;
    });
  }
   
   @override
  Widget build(BuildContext context){
    return Container(
       child: Column(children: [
         for(int i=0;i<list.length;i++)
            ClockinItem(item: list[i], index:i, onFinish: onFinish,),
         EmptyClockinItem(onCreate: onCreatedNew,),
       ],),
     );

  }
}

