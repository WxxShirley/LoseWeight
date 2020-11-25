import 'dart:convert';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/circleBedge.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/pages/awards/views.dart';
import 'package:frontend/pages/record/recordPage.dart';
import 'package:web_socket_channel/io.dart';

class MainPage extends StatefulWidget
{
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> with SingleTickerProviderStateMixin
{
  int _selectedIndex = 0;
  List<Widget> _bottomNavPages = List();
  TabController _tabController;

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState(){
    super.initState();
    _tabController = new  TabController(vsync: this, length: 3);
    _bottomNavPages..add(Record())..add(AllViewScreen(controller: _tabController,))..add(Text("消息"))..add(Text("个人中心"));

    //开启完成本周打卡任务的socket监听
    listen();
    
  }

  listen(){
    var channel = IOWebSocketChannel.connect("ws://127.0.0.1:8000/ws/message/"+userMobile+"/");
    channel.sink.add(jsonEncode({"message":"hello world"}));
    channel.stream.listen((event) async{
       print(event);
       // 已完成打卡的名字
       String title = event;
       
       
       // 展示对话框提示
       showDialog(
         context: context,
         builder: (BuildContext context){
           return AlertDialog(
             title: Text("系统提示"),
             content: 
             Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 Text("恭喜你，完成了本周"+title+"打卡任务!"),
                 CircleBadge(color:Theme.of(context).primaryColor, title:title, subtitle:"继续努力!")
               ],
             ),
             actions: [
               FlatButton(child:Text("确定"), onPressed: ()=>{Navigator.of(context).pop()},)
             ],
           );
         }
       );

    });
  }

   @override
   void dispose(){
     _tabController.dispose();
     super.dispose();
  } 

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.settings),
        title:Text("轻记"),
        bottom: _selectedIndex==1? new TabBar(isScrollable: true,
           unselectedLabelColor: Colors.grey,
           labelColor: Colors.white,
           indicatorSize: TabBarIndicatorSize.tab,
           indicator: new BubbleTabIndicator(indicatorHeight:25.0, indicatorColor:Theme.of(context).primaryColor, tabBarIndicatorSize: TabBarIndicatorSize.tab),
           tabs: [new Tab(text:"周视图"), new Tab(text:"月视图"), new Tab(text:"年视图")],
           controller: _tabController,
         ):null,
      ),
      body: _bottomNavPages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label:"主页"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label:"统计"),
          BottomNavigationBarItem(icon: Icon(Icons.camera),label:"发现"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "我的")
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        selectedLabelStyle: TextStyle(),
        onTap: _onItemTapped,
        
      ),
    );
  }

}