//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/mainPage.dart';
import 'package:frontend/pages/personal/login.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
       GlobalMaterialLocalizations.delegate,
       GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh','CH'),
        const Locale('en','US')
      ],
      locale: Locale('zh'), // 选择中文环境
      title: '轻记',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        unselectedWidgetColor: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StartApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}


// 根据token是否在有效期判断是登陆 / 直接进入用户主页
class StartApp extends StatefulWidget 
{
   @override
  _StartApp createState() => _StartApp();
}

class _StartApp extends State<StartApp>
{
  bool loginValid;

  @override 
  void initState(){
    super.initState();
    
    check();
  }

  check() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool tmp = false;
    String token = _prefs.getString("token");
    if(token!=null){
      if(JwtDecoder.isExpired(token)==false){
        tmp=true;
        myToken = "token " + token;
        
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        userMobile = decodedToken["data"]["mobile"].toString();
      }
    }
    print("登陆是否有效:"+tmp.toString());
    setState((){
      loginValid = tmp;
    });
  }

  @override
  Widget build(BuildContext context){
    return //LoginPage();
      loginValid==null?
        Center(child:CircularProgressIndicator())
        :
        (loginValid==true?
           MainPage():LoginPage()
        );
      
  }
}
