import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frontend/components/diet.dart';
import 'package:frontend/components/returnButton.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/meal.dart';
import 'package:frontend/utils/utils.dart';


// 最近饮食界面


class RecentMealPage extends StatefulWidget
{
   @override
   _RecentMealPage createState() => _RecentMealPage();
}


class _RecentMealPage extends State<RecentMealPage>
{
   bool isLoading = true;

   DayMealList _list;

   Map<DateTime, DayMeal > mps = new Map<DateTime, DayMeal >();
  


   @override
   void initState()
   {
     super.initState();
     fetchMeals();
   }

   fetchMeals() async
   {
     Dio _dio = new Dio();
     _dio.options.responseType = ResponseType.plain;
     Response _res = await _dio.get(myHost+"/meal/recent", queryParameters: {"mobile":userMobile,}, options:  Options(headers: {'Authorization':myToken}));
     
     try{
       _list = DayMealList.fromJson(json.decode(_res.data.toString()));

      setState((){
        isLoading = false;
        _list = _list;
      });

     }catch(e){
       print(e);
     }
     
   }

   @override
   Widget build(BuildContext context)
   {
     return Scaffold(
       appBar: AppBar(leading: ReturnButton(),
         title: Text("最近饮食"),
       ),
       body: 
         isLoading==true? 
          Center(child:CircularProgressIndicator())
          :
          ListView.builder(
            itemCount: _list.meals.length,
            itemBuilder: (context, index){
              return 
              Container(
                margin: EdgeInsets.symmetric(horizontal:20.0, vertical: 15.0),
                child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
          
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( _list.meals[index].day.toString().substring(0,10)+"  "+fetchWeekDay(_list.meals[index].day),
                      style: TextStyle(color: Colors.pink, fontSize:20.0, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        ShowMeal(meal:Meal(fileName: _list.meals[index].breakfast, type:"早餐", timestamp: "")),
                        ShowMeal(meal:Meal(fileName:  _list.meals[index].lunch, type:"午餐", timestamp: "")),
                        ShowMeal(meal: Meal(fileName: _list.meals[index].dinner, type:"晚餐", timestamp: ""),)
                      ],
                    ),
                  ],
                )],
                ));
            },
          )
     );

   }
   
}






