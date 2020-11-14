//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/mainPage.dart';
//import 'package:web_socket_channel/io.dart';

void main() {

  /* var channel = IOWebSocketChannel.connect("ws://localhost:8000/ws/chat/");
  channel.sink.add(jsonEncode({"message":"hello world"}));
  channel.stream.listen((event) {
    print("message");
  });*/

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
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

