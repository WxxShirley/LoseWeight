import 'package:flutter/material.dart';


class DynamicMain extends StatefulWidget 
{
   @override
   _DynamicMain createState() => _DynamicMain();
}


class _DynamicMain extends State<DynamicMain>
{
    
    @override
   Widget build(BuildContext context)
   {

     return Scaffold(
       appBar:AppBar(title:Text("发现动态"),
         actions: [
           IconButton(
             icon: Icon(Icons.add),
             onPressed: (){
               print("add");
             },
           )
         ],
       
       ),
      
     );
   }
}








