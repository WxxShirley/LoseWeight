//import 'dart:convert';

//import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/returnButton.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/models/personInfo.dart';


// ignore: must_be_immutable
class SetPersonInfoPage extends StatefulWidget
{
  PersonInfo myInfo;
  SetPersonInfoPage({this.myInfo});

  @override
  _SetPersonInfoPage createState() => _SetPersonInfoPage(myInfo: myInfo);
}



class _SetPersonInfoPage extends State<SetPersonInfoPage>
{
  PersonInfo myInfo;
  _SetPersonInfoPage({this.myInfo});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        leading: ReturnButton(),
        title: Text("修改个人信息"),
      ),
      body:
       ListView(
         padding: EdgeInsets.all(20.0),
         children: [
           ListTile(leading: Text("头像"), title: 
            ClipOval(child: Image.network(myHost+"/user/profile?path="+myInfo.profile, height: 50.0, width: 50.0,)), trailing: Icon(Icons.chevron_right),
             onTap:(){
               print("修改头像");
             }
           ),

           Divider(),
           
           ListTile(leading: Text("昵称"), title: Text(myInfo.nickname, style: TextStyle(color:Colors.grey,fontSize:16.0),),
             trailing: Icon(Icons.chevron_right),
             onTap: (){
               print("修改昵称");
             },
           ),

           Divider(),

           ListTile(leading:Text("手机"),title: Text(myInfo.mobile, style:TextStyle(color:Colors.grey,fontSize:16.0)),),
           
           Divider(),

            ListTile(leading: Text('修改密码'),
                trailing: Icon(Icons.chevron_right),
                onTap:(){
                  print("修改密码");
                }
              ),

            Divider(),


         ],
       )
    );
  }

}

