import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/awards/views.dart';
import 'package:frontend/pages/awards/weekView.dart';
import 'package:frontend/pages/awards/yearView.dart';
import 'package:frontend/pages/record/recordPage.dart';


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