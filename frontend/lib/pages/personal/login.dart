import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/components/customizedToast.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/mainPage.dart';
import 'package:frontend/models/httpRes.dart';
import 'package:frontend/pages/personal/register.dart';
import 'package:shared_preferences/shared_preferences.dart';


/*
   登陆界面
*/



class LoginPage extends StatefulWidget
{
   @override
  _LoginPage createState() => _LoginPage();
}


class _LoginPage extends State<LoginPage>
{
  TextEditingController _userController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  bool _isObscure = true; //默认显示'*'
  Color _eyeColor=Colors.grey;
  
  final _formkey = GlobalKey<FormState>(); //表单控制
  FToast _fToast;

  @override
  void initState(){
    super.initState();
     _fToast = FToast();
    _fToast.init(context);
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Form(
        key: _formkey,
        child : ListView(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          children: <Widget>[
            SizedBox(
              height: kToolbarHeight,
            ),
            buildTitle(),
            buildTitleLine(),
            SizedBox(height:70.0),
            buildUserTextFiled(),
            SizedBox(height:30.0),
            buildPasswordTextField(context),
            buildForgetPasswordText(context),
            SizedBox(height: 60.0),
            buildLoginButton(context),
            SizedBox(height:30.0),
            buildRegisterText(context),
          ],
        )
      )

    );
  } 

  //左上方标题栏
  Padding buildTitle(){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '轻记',
        style: TextStyle(fontSize:42.0,color:Colors.pink),
      ));}
  
  //标题下方的横线
  Padding buildTitleLine(){
    return Padding(
      padding: EdgeInsets.only(left:12.0, top:4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.pink,
          width: 80.0,
          height: 2.0,
        )
      )
    );
  }

  //用户名输入框
  //这里指定输入为手机号码（正则表达式检验)
  TextFormField buildUserTextFiled(){
    return TextFormField(
      autofocus: true,
      controller: _userController,
      decoration: InputDecoration(
        labelText: '手机号码',
      ),
      validator: (String value){
        //检查手机号码为11位
        var userReg = RegExp(r"^1[3456789]\d{9}$");
        if(!userReg.hasMatch(value)){
          return '请输入正确的手机号码';
        }
      },
    );
  }
  
  //密码栏
  //检验密码不为空，同时设置用户可以切换是否明文看密码
  TextFormField buildPasswordTextField(BuildContext context)
  {
    return TextFormField(
      controller: _pwdController,
      obscureText: _isObscure, //展示为‘*’
      validator: (String value){
        if (value.isEmpty){
          return '请输入密码';
        }}, //检验非空
      decoration: InputDecoration( //调整密码是否为可见
          labelText:'密码',
          suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: _eyeColor,
            ),
            onPressed:(){
              setState((){
                _isObscure = !_isObscure;
                 _eyeColor = _isObscure
                   ? Colors.grey : Theme.of(context).primaryColor;
              });
            })
      ),
    );
  }
  
  //忘记密码一栏，点击即切入忘记密码界面
  Padding buildForgetPasswordText(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
          child: Text('忘记密码',style: TextStyle(fontSize:14.0,color:Colors.grey),),
          onPressed:(){
            //Navigator.push(context,new MaterialPageRoute(builder: (context)=> ForgetPwd1()));
          }
        )
      )
    );
  }
  
  //注册新用户入口
  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('没有账号？'),
            GestureDetector(
              child: Text(
                '点击注册',
                style: TextStyle(color: Theme.of(context).primaryColor)
              ),
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder:(context) => new RegisterPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose(){
    _userController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  Align buildLoginButton(BuildContext context)
  {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child:FlatButton(
          child: Text('登陆', style:TextStyle(fontSize:24.0, color:Colors.white, fontWeight: FontWeight.bold)),
          color:Colors.pink,
          onPressed: () async{
            if(_formkey.currentState.validate()){
              _formkey.currentState.save();

              Dio _dio = new Dio();
              var queryParams = {
               "mobile": _userController.text,
               "pwd": _pwdController.text,
              };
              Response _res = await _dio.get(myHost+"/user/login",queryParameters: queryParams, );
              HttpRes _result = HttpRes.fromJson(json.decode(_res.data.toString()));

              if(_result.status=='ok'){
                print("创建成功");
                print(_result.type);
                String token = _result.type;
                myToken = "token "+token;
                userMobile = _userController.text;
                
                // 将token缓存到本地
                SharedPreferences _prefs = await SharedPreferences.getInstance();
                await _prefs.setString("token", token);

                Navigator.push(context, MaterialPageRoute(builder: (context)=>new MainPage()));

              }else {
                showToast(_fToast,Icons.error, "登陆失败，检查用户名或密码");
              }

            }
          },
        )
      ),
    );
  }

}

