import 'package:flutter/material.dart';
import 'package:frontend/utils/utils.dart';

/*
    CalendarCard - 显示当日时间卡片 
      主页上方展示
*/
// ignore: must_be_immutable
class CalendarCard extends StatelessWidget {

  // 定时切换motto
  String motto;
  CalendarCard({this.motto});

  final Map<String, String> cardInfo = {
    'title': formatDate(),
    'time': weekdayInfo(),
    'image': 'assets/images/dailyCard.jpg',
  };

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 200.0,
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                this.cardInfo['title']+" "+this.cardInfo['time'],
                style: TextStyle(color: Colors.white, fontSize: 32.0,fontWeight: FontWeight.w900,
                ),
              ),
              Divider(),
              Text(
                motto, 
                //"\"天行健，君子以自强不息\"",
                //"\"每一个不曾起舞的日子，都是对生命的辜负\"",
                style: TextStyle(color: Colors.white,fontSize:14.0)
              )
            ],
          ),
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.grey[400].withOpacity(0.8),
            borderRadius: BorderRadius.all( Radius.circular(20.0),),
          ),
        ),
      ),
      width: size.width, // - 40
      height: (size.width - 100) / 2,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(this.cardInfo['image']),fit: BoxFit.fill,),
        borderRadius: BorderRadius.all( Radius.circular(20.0),),
        color: Colors.white70,
        boxShadow: [
          BoxShadow( color: Colors.black38, blurRadius: 25.0, offset: Offset(8.0, 8.0), ),
        ],
      ),
    );
  }
}