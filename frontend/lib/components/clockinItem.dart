import 'package:flutter/material.dart';
import 'package:frontend/models/clockin.dart';
import 'package:frontend/pages/record/createTask.dart';

/*
    打卡记录组件
     - 新建打卡记录 EmptyClockinItem
     - 显示一条打卡记录 ClockinItem
*/


// ignore: must_be_immutable
class ClockinItem extends StatelessWidget
{
   Clockin item;
   ClockinItem({this.item});

   @override
   Widget build(BuildContext context){
     return Container(
    padding: EdgeInsets.only(top:10.0, bottom: 5.0),
    child:
     DecoratedBox(
       decoration: BoxDecoration(
         color: item.itemColor,
         borderRadius: BorderRadius.circular(10.0),
       ),
       child: 
         ListTile(leading: Icon(item.icon),
          title: Text(item.todo),
          trailing: item.finish==true?Text("🎉") : Text("❎"),
          onTap: (){
            print("tapped");
          },
         )
      )
     );
   }
}


class EmptyClockinItem extends StatelessWidget{
  

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
        child: DecoratedBox(
          decoration: BoxDecoration(color:Colors.grey[200], borderRadius: BorderRadius.circular(5.0)),
          child: Container(
            width: 500.0,
            height: 50.0,
            child:Icon(Icons.add),
          )
        ),
      ),
      onTap: (){
        print("tapped");
        Navigator.push(context, MaterialPageRoute(builder: (context)=> new CreateTask()));

        /*showModalBottomSheet(
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10.0)),
          context: context,
          builder: (BuildContext context){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(leading: Icon(Icons.check,color:Theme.of(context).primaryColorLight),title:Text("完成打卡"),onTap:(){
                  // TODO:进入到选择今日打卡任务并完成的界面
                  print("finish");
                }),
                Divider(),
                ListTile(leading: Icon(Icons.add,color:Theme.of(context).primaryColorLight),title:Text("新建打卡"),onTap:(){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> new CreateTask()));
                })
              ],
            );
          }
        );*/


      },
    );
  }
}



class ClockIns extends StatelessWidget{
   
   @override
   Widget build(BuildContext context){
     return Container(
       child: Column(children: [
         ClockinItem(item: Clockin(todo: "跑步",icon:Icons.run_circle_outlined,detail:"3.5km", itemColor: Colors.lightGreen[100], finish: true)),
         ClockinItem(item: Clockin(todo: "没喝奶茶",icon:Icons.local_drink_outlined,detail:"-200Kcal", itemColor: Colors.purple[50])),
         EmptyClockinItem(),
       ],),
     );
   }

}