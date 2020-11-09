import 'package:flutter/material.dart';


class ReturnButton extends StatelessWidget
{
  @override
  Widget build(BuildContext context){
    return IconButton(icon:Icon(Icons.chevron_left, size:28.0),
      onPressed: (){
        Navigator.pop(context);
      },
    );
  }
}