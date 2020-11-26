import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/menu.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/personInfo.dart';
import 'package:frontend/pages/personal/login.dart';
import 'package:frontend/pages/personal/setPersonInfo.dart';
import 'package:frontend/utils/utils.dart';

class PersonalPage extends StatefulWidget
{
  @override
  _PersonalPage createState() => _PersonalPage();
}



class _PersonalPage extends State<PersonalPage>
{
  
  @override 
  void initState(){
    super.initState();
  }
  
  // 登出账号
  Widget logout(BuildContext context){
    return Container(
     margin: EdgeInsets.all(20.0),
     padding: EdgeInsets.only(left:10.0, right: 10.0),
     child: 
       Align(child: 
        FlatButton(
          child: Text("退出登陆", style:  TextStyle(color:Colors.black54, fontSize:18.0, fontWeight: FontWeight.w400)),
          onPressed: (){
            showDialog(
              context: context, 
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text("提示"),
                  content: Text("确定退出当前帐号吗?"),
                  actions: [
                    FlatButton(child:Text("确定"), onPressed: () async{
                      Navigator.of(context).pop();
                      await reset();
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>new LoginPage()));
                    },),
                    FlatButton(child:Text("取消", style:TextStyle(color:Colors.grey)), onPressed: ()=>{Navigator.of(context).pop()},)
                  ],
                );
              }
            );
          },
        )
      )
    );
  }
  
  @override
  Widget build(BuildContext context)
  {
    return 
      ListView(
        children: 
        [
           new ProfileHeader(), 
           Container(height:20.0),
           new MainMenu(),
           logout(context),
        ],
      );
  }
}


// 个人头像，点击进入个人信息修改页
class ProfileHeader extends StatefulWidget
{
  @override
  _ProfileHeader createState() => _ProfileHeader();
}

class _ProfileHeader extends State<ProfileHeader>
{
  PersonInfo myInfo;
  
  @override 
  void initState(){
    super.initState();
    fetchPersonInfo();
  }

  // 加载个人信息
  fetchPersonInfo()async{
    Dio _dio = new Dio();
    Response _res = await _dio.get(myHost+"/user/load",queryParameters: {"mobile": userMobile}, options: Options(headers: {'Authorization':myToken}));
    myInfo = PersonInfo.fromJson(json.decode(_res.data.toString()));
    setState(() {
      myInfo = myInfo;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return
     myInfo == null?
     Center(child:CircularProgressIndicator())
     : 
     GestureDetector(
       child:
     Container(
      height: 150.0,
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.only(left:10.0, right: 10.0),
      decoration: new BoxDecoration(
        color:Colors.grey[200], 
        borderRadius:  BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow( color: Colors.grey, blurRadius: 10.0, offset: Offset(5.0, 5.0), ),
        ],
      ),
      alignment: Alignment.topLeft,
      child: 
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(icon:Icon(Icons.star, color:Colors.pink), onPressed: (){}),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 30.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.network(myHost+"/user/profile?path="+myInfo.profile,width:50.0,height: 50.0,),
                ),
                Container(
                  padding: EdgeInsets.only(left:10.0),
                  child:Text(myInfo.nickname, style:TextStyle(color: Colors.black45, fontWeight: FontWeight.w500,fontSize:24.0)),
                ),
              ],
            ))

          ],)
    ),
    onTap:(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>new SetPersonInfoPage(myInfo: myInfo)));
    }
    );
  }

}

