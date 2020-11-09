import 'package:flutter/material.dart';


class CusToast extends StatelessWidget
{
  final IconData icon;
  final String hintText;
  CusToast({this.icon, this.hintText});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:24.0, vertical:12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color:Theme.of(context).primaryColor,
      ),
      child:Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,color:Colors.white),
          Container(width: 12.0,),
          Text(hintText,style:TextStyle(color: Colors.white))
        ],
      )
    );
  }
}