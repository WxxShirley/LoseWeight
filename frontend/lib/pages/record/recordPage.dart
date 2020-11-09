import 'package:flutter/material.dart';
import 'package:frontend/components/clockinItem.dart';
import 'package:frontend/components/diet.dart';
import 'package:frontend/components/todayCard.dart';
import 'package:animated_background/animated_background.dart';

/*
    每日记录主页
*/

class Record extends StatefulWidget
{
  @override
  _Record createState() => _Record();
}

class _Record extends State<Record>  with TickerProviderStateMixin
{
  bool allFinish = false;
  ParticleOptions particleOptions;
  
  @override
  void initState(){
    super.initState();
    
    particleOptions = ParticleOptions(
    //image: Image.asset('assets/images/celebrate3.jpg'),
    baseColor: allFinish==true? Colors.pink : Colors.white,
    spawnOpacity: 0.0,
    opacityChangeRate: 0.1,
    minOpacity: 0.5,
    maxOpacity: 1,
    spawnMinSpeed: 30.0,
    spawnMaxSpeed: 70.0,
    spawnMinRadius: 7.0,
    spawnMaxRadius: 15.0,
    particleCount: 40,
   );
   setState((){
     particleOptions = particleOptions;
   });
  }

  

  @override
  Widget build(BuildContext context){
    return
    AnimatedBackground(
      behaviour: RandomParticleBehaviour(options: particleOptions ) ,
      vsync: this,
      child: 
       ListView(
      padding: EdgeInsets.only( top: 20.0,left: 20.0,right: 20.0,),
      children:<Widget>[
   
         CalendarCard(),
         Container(height:20.0),
         Diet(),
         ClockIns(),
         
    ])
    );
  }
}