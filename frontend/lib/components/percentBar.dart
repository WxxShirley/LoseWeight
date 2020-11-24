import 'package:flutter/material.dart';

import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';


// ignore: must_be_immutable
class PercentBar extends StatelessWidget
{
  int len, totalLen;
  String title;
  PercentBar({this.len, this.totalLen, this.title});

  @override
  Widget build(BuildContext context){
    return Container(
      child: 
       Column(
         children: [
       // 展示文字内容
       Container(padding:EdgeInsets.symmetric(horizontal:10.0, vertical:0),alignment: Alignment.topLeft ,child:  Text(title==null?"打卡完成情况":title, style:TextStyle(color:Theme.of(context).primaryColor, fontWeight: FontWeight.w600,),),),
       Container(
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                Text(len.toString(),style: TextStyle( fontSize: 18.0, fontWeight: FontWeight.w900,color: Theme.of(context).primaryColorLight,  ),),
                Text(totalLen.toString(), style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w900,color: Theme.of(context).primaryColorLight, ),),
            ],
          ),
        ),
 
        // 展示进度条
        Container(
          padding: EdgeInsets.symmetric(horizontal:10.0),
          child:RoundedProgressBar( height: 25.0 , 
            style: RoundedProgressBarStyle(borderWidth: 0, widthShadow: 0, colorProgress:  Theme.of(context).primaryColorLight),
            margin: EdgeInsets.only(top:10.0, bottom:16.0),
            borderRadius: BorderRadius.circular(24.0),
            percent: len/totalLen *100,
          ),
        )
         ],
       )
    );
  }

}