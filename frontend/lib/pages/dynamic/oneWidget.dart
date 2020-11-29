import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/expandableText.dart';
import 'package:frontend/components/nineGrid.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/models/dynamic.dart';


// ignore: must_be_immutable
class OneWidget extends  StatefulWidget
{
  Dynamic dy;
  OneWidget({this.dy});

  @override
  _OneWidget createState() => _OneWidget(dy: dy);
}


class _OneWidget extends State<OneWidget>
{
  Dynamic dy;
  _OneWidget({this.dy});

  bool isFix = false;
  
  @override
  void initState(){
    super.initState();

    dy.paths = new List<String>();

    List<String> tmp = dy.imageList.split(",");
    
    for(int i=0;i<tmp.length;i++)
    {
      if(tmp[i].length>0)  dy.paths.add(tmp[i]);
    } 
    
    setState(() {
      dy = dy;
      isFix = false;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return 
    isFix==true?
    Container(height: 80.0,):
  Container(
    alignment:Alignment.topLeft,
    margin: EdgeInsets.symmetric(horizontal:15.0, vertical:10.0),
    child:
   Column(
     children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Align(alignment: Alignment.topLeft,
               child: ClipOval(child: 
                 CachedNetworkImage(imageUrl: myHost+"/user/profile?path="+dy.hisAvatar,width: 40.0, height: 40.0,),
               )
             ),
             Container(width: 10.0,),
             Expanded(child:
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Text(dy.hisNickname, style:TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 18.0)),
                 Container(height: 5.0),

                 // 文本内容
                 ExpandableText(text:dy.txtContent, maxLines: 2, ),
                
                 // 宫格显示图片
                  NineGrid(paths: dy.paths),
                 
                 // 时间戳
                 Text(dy.timestamp.toLocal().toString().substring(0,19), style:TextStyle(color: Colors.black38)),
               ],
             ))
           ],
         ),

         Divider(),
       ]
     ));
  }

}



