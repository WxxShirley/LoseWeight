import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/components/customizedToast.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/mainPage.dart';
import 'package:frontend/models/httpRes.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
    注册页
*/

class RegisterPage extends StatefulWidget
{
  _RegisterPage createState() => _RegisterPage();

}


class _RegisterPage extends State<RegisterPage>
{
   
   // 接收用户键入的手机号、密码、昵称
   TextEditingController _mobileController = new TextEditingController();
   TextEditingController _pwdController = new TextEditingController();
   TextEditingController _nnController = new TextEditingController();
   
   // 密码不显示
   bool _isObscure = true;

   final _formKey = GlobalKey<FormState>();

   Color _eyeColor = Colors.grey;
   FToast _fToast;

    @override
  void initState(){
    super.initState();
     _fToast = FToast();
    _fToast.init(context);
   }

   @override
   void dispose(){
     _mobileController.dispose();
     _pwdController.dispose();
     _nnController.dispose();
     super.dispose();
   }


   @override
   Widget build(BuildContext context)
   {
     return Scaffold(
       body: Form(
         key: _formKey,
         child: ListView(
           padding: EdgeInsets.symmetric(horizontal: 20.0),
           children: 
           [
             SizedBox(height: 60.0,),
             buildTitle(), // 标题行 - 欢迎加入
             buildMobileField(),
             SizedBox(height:20.0),
             buildPasswordField(context),
             SizedBox(height: 20.0,),
             buildNicknameField(context),
             SizedBox(height: 80.0,),
             buildSubmitButton(context), //完成按钮
           ],
        )
       )
     );
   }

  
  // 标题行
  Padding buildTitle(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:0, vertical:10.0),
      child:Row(
        children: [
          IconButton(icon:Icon(Icons.chevron_left, size:28.0, color:Colors.pink),
            onPressed: (){
              Navigator.pop(context);
             },
          ),
          Text("欢迎加入", style: TextStyle(color:Colors.pink, fontSize: 32.0)),

        ],
      )
    );
  }

  // 用户输入手机号码
  TextFormField buildMobileField(){
    return TextFormField(
      autofocus: true,
      controller: _mobileController,
      decoration: InputDecoration(labelText: '手机号码(11位)'),
      // ignore: missing_return
      validator: (String value){
        //检查手机号是否为11位 - 正确的中国大陆手机号码
        var mobileReg = RegExp(r"1[3456789]\d{9}$");
        if(!mobileReg.hasMatch(value)){
          return '请输入正确的手机号码';
        }
      },
    );
  }

  // 用户输入密码
  TextFormField buildPasswordField(BuildContext context)
  {
    return TextFormField(
      controller: _pwdController,
      obscureText: _isObscure,
      validator: (String value){
        var pwdReg = RegExp(r"[0-9A-Za-z~!@#$%^&*\\_]{6,16}$");
        if(!pwdReg.hasMatch(value)){
          return '密码需要6-16位字母/数字/特殊字符组成，请检查!';
        }
      },
      decoration: InputDecoration(
        labelText: '密码',
        suffix: IconButton(icon:Icon(Icons.remove_red_eye, color: _eyeColor),
           onPressed: (){
             setState((){
               _isObscure = !_isObscure;
               _eyeColor = _isObscure ?   Colors.grey : Theme.of(context).primaryColor;
             });
           },
         )
      ),
    );
  }

  TextFormField buildNicknameField(BuildContext context){
    return TextFormField(
      controller: _nnController,
      // ignore: missing_return
      validator: (String value){
        var nicknameReg = RegExp(r"^[a-zA-Z0-9_\u4e00-\u9fa5]+$");
        if(!nicknameReg.hasMatch(value)){
          return '昵称由汉字、字母、数字构成';
        }
        if(value==""){
          return '昵称不能为空';
        }
      },
      decoration: InputDecoration(labelText: "昵称"),
    );
  }

  Container buildSubmitButton(BuildContext context){
    return Container(
      child: FloatingActionButton.extended(
        onPressed: ()async{
          if(_formKey.currentState.validate()){
            _formKey.currentState.save();
          }

          Dio _dio = new Dio();
          var queryParams = {
            "mobile": _mobileController.text,
            "password": _pwdController.text,
            "nickname": _nnController.text,
          };
          Response _res = await _dio.get(myHost+"/user/register",queryParameters: queryParams, );
          HttpRes _result = HttpRes.fromJson(json.decode(_res.data.toString()));

          if(_result.status=='ok'){
            print("创建成功");
            showToast(_fToast,Icons.check, "创建成功~");
            
            String token = _result.type;
            myToken = "token "+token;
            userMobile = _mobileController.text;
            print(myToken);
            print(userMobile);
                
            // 将token缓存到本地
            SharedPreferences _prefs = await SharedPreferences.getInstance();
            await _prefs.setString("token", token);

            Navigator.push(context, MaterialPageRoute(builder: (context)=>new MainPage()));

          }else {
            print("失败");
            showToast(_fToast,Icons.error, "创建失败,手机号已被注册!");
          }

        },
        backgroundColor: Theme.of(context).primaryColor,
        label: Row(children: [
          Icon(Icons.send),
          Text("创建账号")
       ],)
      )
    );
  }

}


