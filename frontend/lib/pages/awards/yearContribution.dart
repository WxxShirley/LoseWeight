import 'package:flutter/material.dart';
import 'package:heatmap_calendar/heatmap_calendar.dart';
import 'package:heatmap_calendar/time_utils.dart';


class YearContributionDemo extends StatelessWidget
{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
          child: HeatMapCalendar(
            input: {
              TimeUtils.removeTime(DateTime.now().subtract(Duration(days: 3))): 5,
              TimeUtils.removeTime(DateTime.now().subtract(Duration(days: 2))): 35,
              TimeUtils.removeTime(DateTime.now().subtract(Duration(days: 1))): 14,
              TimeUtils.removeTime(DateTime.now()): 5,
            },
            colorThresholds: {
              1: Colors.green[100],
              10: Colors.green[300],
              30: Colors.green[500]
            },
            weekDaysLabels:  ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
            monthsLabels: 
            [
              "",
              "1",
              "2",
              "3",
              "4",
              "5",
              "6",
              "7",
              "8",
              "9",
              "10",
              "11",
              "12",
            ],

            squareSize: 8.0,
            textOpacity: 0.3,
            labelTextColor: Colors.blueGrey,
            dayTextColor: Colors.blue[500],
          ),
        ),
    );
  }
}
