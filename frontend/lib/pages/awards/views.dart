import 'package:flutter/material.dart';
// import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:frontend/pages/awards/weekView.dart';
import 'package:frontend/pages/awards/yearView.dart';

class AllViewScreen extends StatefulWidget
{
  TabController controller;
  AllViewScreen({this.controller});

   @override
  _AllViewScreen createState() => _AllViewScreen(controller: controller);
}

class _AllViewScreen extends State<AllViewScreen> 
{
   TabController controller;
  _AllViewScreen({this.controller});

   @override
  void initState(){
    super.initState();
  }
  
  @override
  Widget build(BuildContext context){
    return 
        TabBarView(
          controller: controller,
          children: [ WeekView(),Center(child:Text("TODO: 月视图..")), YearView(),],
    );
  }
 

}

