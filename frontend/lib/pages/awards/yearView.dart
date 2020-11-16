import 'package:flutter/material.dart';
import 'package:heatmap_calendar/heatmap_calendar.dart';
import 'package:heatmap_calendar/time_utils.dart';


class YearView extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return ListView(
    children: [
      HeatMapCalendar(
        input: {
          TimeUtils.removeTime(DateTime.now().subtract(Duration(days: 30))): 50,
          TimeUtils.removeTime(DateTime.now().subtract(Duration(days: 100))): 50,
          TimeUtils.removeTime(DateTime.now().subtract(Duration(days: 150))): 50,
          TimeUtils.removeTime(DateTime.now()): 5,
        },
        colorThresholds: {
            1: Colors.green[100],
            10: Colors.green[300],
            30: Colors.green[500]
        },
        weekDaysLabels:  ['', '', '', '', '', '', ''],
        monthsLabels: 
            [
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
            ],

            squareSize: 6.0,
            textOpacity: 0.3,
            labelTextColor: Colors.blueGrey,
            dayTextColor: Colors.blue[500],
          ),
      
      Container(height: 30.0,),
      
            HeatMapCalendar(
        input: {
          TimeUtils.removeTime(DateTime.now().subtract(Duration(days: 270))): 50,
          TimeUtils.removeTime(DateTime.now().subtract(Duration(days: 130))): 50,
          TimeUtils.removeTime(DateTime.now().subtract(Duration(days: 110))): 50,
          TimeUtils.removeTime(DateTime.now()): 5,
        },
        colorThresholds: {
            1: Colors.pink[100],
            10: Colors.pink[300],
            30: Colors.pink[500]
        },
        weekDaysLabels:  ['', '', '', '', '', '', ''],
        monthsLabels: 
            [
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
              "",
            ],

            squareSize: 6.0,
            textOpacity: 0.3,
            labelTextColor: Colors.blueGrey,
            dayTextColor: Colors.blue[500],
          ),


    ],);
  }

}



