import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/components/customizedToast.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/iconTheme.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/clockRecord.dart';
import 'package:frontend/models/httpRes.dart';
import 'package:frontend/pages/record/createTask.dart';
import 'package:frontend/pages/record/setTask.dart';
import 'package:frontend/utils/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
   final ValueChanged<String> onFinish;
   final ValueChanged<String> onDelete;
   ClockinItem({this.item, this.index, this.onFinish, this.onDelete});

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
       // ignore: missing_return
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
     Widget con =  Container(
    //padding: EdgeInsets.only(top:10.0, bottom: 5.0),
    child:
     DecoratedBox(
       decoration: BoxDecoration(
         color: HexColor(item.color),
        // borderRadius: BorderRadius.circular(10.0),
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
                            onFinish(item.title);
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
     
     return 
     Container(
       padding: EdgeInsets.only(top:10.0, bottom: 5.0),
       child:
     Slidable(
       actionPane: SlidableDrawerActionPane(),
       actionExtentRatio: 0.25,
       child: con,
       actions: <Widget>[
         IconSlideAction(
           caption: "设置",
           color:Colors.grey[300],
           icon:Icons.more_horiz,
           onTap: (){
             print("taped");
             Navigator.push(context, MaterialPageRoute(builder: (context)=> new SetTask(record: item)));
           },
         ),
         IconSlideAction(
           caption: "删除",
           color:Colors.red,
           icon: Icons.delete,
           onTap:()async{
             print("delete");
             
             // 弹出对话框
             showDialog(
               context: context,
               builder: (context){
                 return AlertDialog(
                   title: Text("提示"),
                   content: Column(
                     mainAxisSize: MainAxisSize.min,
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("确认删除这个打卡条目吗?"),
                       Text("与该项目有关的记录和成就都将被删除", style:TextStyle(color: Colors.black45)),

                     ],
                   ),
                   actions: [
                      FlatButton(child: Text("取消"),onPressed: ()=>Navigator.of(context).pop(),),
                      FlatButton(child: Text("确定"),
                        onPressed: () async{
                            Dio _dio = new Dio();
                            _dio.options.responseType = ResponseType.plain;
                            Response _res = await _dio.get(myHost+"/clockin/delete", queryParameters: {"mobile":userMobile,  "title":item.title}, options: Options(headers: {'Authorization':myToken}));
             
                            HttpRes _httpRes = HttpRes.fromJson(json.decode(_res.data.toString()));
                            if(_httpRes.status=='ok'){
                              print("succ");
                              showToast(_fToast,Icons.check, "删除成功");
                              onDelete(item.title);//回调
                            }else{
                              showToast(_fToast, Icons.error, "删除失败,请重试");
                          }
                          Navigator.pop(context);
                        },
                      )
                   ],
                 );
               }
             );
           }
         )
       ]
     ));

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
  
  // 按照待打卡任务是否已经完成本周任务进行区分
  List<ClockRecord> _finishWeekList=new List<ClockRecord>();
  List<ClockRecord> _notFinishWeekList=new List<ClockRecord>();
  bool _show = true;
  
  // 用户创建了新的打卡任务时回调
  onCreatedNew(ClockRecord newRecord){
    list.add(newRecord);
    print("new Record:"+newRecord.title);
    /*setState(() {
      list = list;
    });*/
    split();
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
    for(int i=0;i<_notFinishWeekList.length;i++){
      if(_notFinishWeekList[i].title==title){
        _notFinishWeekList.removeAt(i);
        print("found and delete");
        setState(() {
          _notFinishWeekList = _notFinishWeekList;
        });
        return ;
      }
    }
    for(int i=0;i<_finishWeekList.length;i++){
      if(_finishWeekList[i].title==title){
        _finishWeekList.removeAt(i);
        setState(() {
          _finishWeekList = _finishWeekList;
        });
        return ;
      }
    }
  }

  // 初始化
  void initState(){
    super.initState();
    split();
  }

  split(){
     for(int i=0;i<list.length;i++){
       print(i.toString()+","+list[i].title);
      if(list[i].hasWeekTaskFinish==1){
        _finishWeekList.add(list[i]);
      }else{
        _notFinishWeekList.add(list[i]);
      }
    }

    setState((){
      _finishWeekList = _finishWeekList;
      _notFinishWeekList = _notFinishWeekList;
    });
    
  }
   
   @override
  Widget build(BuildContext context){
    return Container(
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
     );

  }
}

