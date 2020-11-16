import 'package:flutter/material.dart';
import 'package:frontend/pages/awards/weekView.dart';
import 'package:frontend/pages/awards/yearView.dart';
import 'package:frontend/pages/record/recordPage.dart';


class MainPage extends StatefulWidget
{
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage>
{
  int _selectedIndex = 0;
  List<Widget> _bottomNavPages = List();

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState(){
    super.initState();
    _bottomNavPages..add(Record())..add(WeekView())..add(YearView())..add(Text("个人中心"));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:Text("轻记")),
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