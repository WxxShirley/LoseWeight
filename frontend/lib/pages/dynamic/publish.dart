import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/components/addPics.dart';
import 'package:frontend/components/customizedToast.dart';
import 'package:frontend/components/returnButton.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/httpRes.dart';


// 用户发布动态界面
class PublishPage extends StatefulWidget
{
  @override
  _PublishPage createState() => _PublishPage();
}


class _PublishPage extends State<PublishPage>
{
  // 用户文本输入
  TextEditingController _txtController = new TextEditingController();
  List<File> images = new List();

  // 类型选择
  String selectedType = "";
  String selectedSecondType = "";
  List<Widget> widgets = [];
  List<String> choices = ["健身", "饮食", "经验"];
  List<String> descriptions = ["跑步、有氧、无氧运动等相关🏊‍♀️", "日常三餐，减肥食谱，低卡美食, 😋", "日常打卡，成果分享，心路历程🌈"];
  List<String> formatChoices = ["sport", "food", "experience"];

  // 是否正在提交
  bool isSubmitting = false;
  final _formKey = GlobalKey<FormState>();

  // 是否发布成功
  bool isSubmitSucc = false;

  // 显示Toast
  FToast _fToast;

  @override
  void initState()
  {
    super.initState();
     _fToast = FToast();
    _fToast.init(context);
  }


   @override
   Widget build(BuildContext context)
   {
     return Scaffold(
       appBar: AppBar(
         leading: ReturnButton(),
         title: Text("发布动态"),
        ),
       body:
       isSubmitSucc==true?
       Container(
         alignment: Alignment.center,
         child: Column(
           children: [
             Container(height: 200.0,),
           Icon(Icons.check, color:Theme.of(context).primaryColor, size:80.0),
           Text("发布成功!", style:TextStyle(color:Colors.black54, fontWeight: FontWeight.w600, fontSize: 24.0)),
         ],),
       ) : 
        Form(
         key: _formKey,
         child: 
           ListView(
             padding: EdgeInsets.all(15.0),
             children: [
               // 多行文本输入文字内容
               TextFormField(
                 controller: _txtController,
                 autofocus: false,
                 maxLines: 8,
                 decoration: InputDecoration(labelText: "内容", hintText:"记录下你想要分享的动态吧"),
                 // ignore: missing_return
                 validator: (String value){
                   if(value.isEmpty){
                     return "发布内容不能为空！";
                   }
                 },
               ),

               // 图片选择与展示
               showAllPics(),

               // type / secondary_type选择
               Text("选择类型", style: TextStyle(color:Colors.black45, fontWeight: FontWeight.w600, fontSize: 20.0)),
               for(var i=0;i<choices.length;i++)
                 RadioListTile(
                   value: formatChoices[i],
                   groupValue: selectedType,
                   title: Text(choices[i]),
                   subtitle: Text(descriptions[i]),
                   onChanged: (currentType){
                     setState((){
                       selectedType = currentType;
                     });
                    },
                   selected: selectedType==formatChoices[i],
                   activeColor: Colors.pink,
                ),
      
    
               Container(height:50.0),

               // 发布按钮 => 防止用户点击两次
               submit(context),
             ],
          )
       )
     );

   }


   callback(List<File> imgs){
     images.addAll(imgs);
     setState((){
       images = images;
     });
   }
   
  

   // 展示一张图片 - 图片内容+右上角叉号删除
   Widget showPic(File img)
   {
      return Container(
        margin: EdgeInsets.only(left:5.0, right:5.0, top:10.0,bottom: 10.0),
        child: Image.file(img, width: 100, height: 100, fit:BoxFit.contain),
        width: 100,
        height: 100,
      );
   }

   // 图片Widget 
   Widget showAllPics()
   {
      // 根据目前的imgList实时渲染
      if(images.length==0)
      {
        print("render null");
        return Row(
          children: [new AddPicBox(chooseImgCallback: callback,)],
        );
      }

      print("render pics");

      List<Widget> picsWidget = new List<Widget>();
      
      for(int i=0;i<images.length;i++)
      {
        picsWidget.add(showPic(images[i]));
      }

      if(images.length<6){
        picsWidget.add(new AddPicBox(chooseImgCallback: callback,));
      }

      // 根据当前的picsWidget分行展示widget
      if(picsWidget.length<=3)
      {
        return Row(
          children: picsWidget,
        );
      }else{
        Widget row1 = new Row(children: [picsWidget[0],picsWidget[1], picsWidget[2] ]);

        List<Widget> append = new List<Widget>();
        for(var i=3;i<picsWidget.length;i++){
          append.add(picsWidget[i]);
        }
        Widget row2 = new Row(children: append);
        return Column(
          children: [
            row1,
            row2,
          ],
        );
      }

   }
  
  
  // 发布按钮
  Align submit(BuildContext context)
  {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: FlatButton(
          child: Text("发布",  style:TextStyle(fontSize:24.0, color:Colors.white, fontWeight: FontWeight.bold)),
          color:Colors.pink,
          onPressed: () async{
             if(_formKey.currentState.validate())
             {
               _formKey.currentState.save();
             }
             
             if(images.length==0){
               showToast(_fToast,Icons.error, "请选择图片");
               return ;
             }
             if(selectedType==""){
               showToast(_fToast,Icons.error, "请选择类型");
               return;
             }

             if(isSubmitting){
               showToast(_fToast, Icons.error, "正在提交，请勿重复");
               return ;
             }

            print("发布～");
            var queryParams = {
              "mobile": userMobile==""?"18933928018":userMobile,
              "txt_content": _txtController.text,
              "type": selectedType,
              "image_len": images.length.toString(),
            };
            setState((){
              isSubmitting=true;
            });
            for(int i=0;i<images.length;i++)
            {
              var key="image_content"+i.toString();
              List<int> imageBytes = await images[i].readAsBytesSync();
              queryParams[key]=base64Encode(imageBytes);

              var nameKey = "image_name"+i.toString();
              String name = images[i].toString().split("/").last.toLowerCase();
              if(name[name.length-1]=='\''){
                name = name.substring(0,name.length-1);
                print(name);
              }
              print(name);
              queryParams[nameKey]=name;
            }
          
            http.Response res = await http.post(myHost+"/dynamic/publish", 
              body: queryParams
            );

            setState(() {
              isSubmitting = false;
            });

            HttpRes _res = HttpRes.fromJson(json.decode(res.body.toString()));
            if(_res.status=='ok'){
              //showToast(_fToast, Icons.info, "发布成功，请等待审核");
              setState((){
                isSubmitSucc = true;
              });
            }else{
              showToast(_fToast, Icons.error, "发布失败，请重试");
            }
           
          },
        )

      )
    );
  }

}



