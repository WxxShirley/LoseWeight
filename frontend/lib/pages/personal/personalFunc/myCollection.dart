import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/returnButton.dart';

import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/collection.dart';
import 'package:frontend/pages/personal/personalFunc/collectionDetail.dart';

class MyCollectionsPage extends StatefulWidget
{
   @override
   _MyCollectionsPage createState() => _MyCollectionsPage();
}



class _MyCollectionsPage extends State<MyCollectionsPage>
{
   
   bool isLoading = true;

   List<Collection> _list = new List<Collection>();

   @override
   void initState(){
     super.initState();
     load();
   }
   
   // 加载用户收藏夹
   load() async{
      Dio _dio = new Dio();
      _dio.options.responseType = ResponseType.plain;
      Response _res = await _dio.get(myHost+"/dynamic/get_collection",queryParameters: {'mobile':userMobile, },options: Options(headers: {'Authorization':myToken}));
   
      Collections _collects = Collections.fromJson(json.decode(_res.data.toString()));
    
    setState((){
      isLoading = false;
       _list = _collects.collects;
    });

   }

   
 
   @override
   Widget build(BuildContext context)
   {
     return Scaffold(
       appBar: AppBar(title: Text("我的收藏"), leading:ReturnButton(),),
       body: 
        isLoading==true?
        Center(child: CircularProgressIndicator())
         :
        
        _list.length==0?

        (
           Container(alignment: Alignment.center,
            child: Column(
            children: [
              Container(height: 80.0,),
              Image.asset("assets/images/non.png"),
              Container(height: 20.0,),
              Text("暂时没有收藏哦")
            ],
           ),
          )
        )
       :
         GridView.builder(
           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.0),
           itemCount: _list.length,
           itemBuilder: (context,index){
             return OneCollectionWidget(collection: _list[index]);
           },
         )
     );
   }

}



// 一个收藏夹组件
// ignore: must_be_immutable
class OneCollectionWidget extends StatelessWidget
{
  Collection collection;
  OneCollectionWidget({this.collection});
   
   @override
   Widget build(BuildContext context)
   {
     return

    GestureDetector(
      child: 

     SizedBox(
        width: 190,
       height: 190,
       child:
      Container(
       margin: EdgeInsets.only(left:15.0, right:5.0, top:10.0,bottom: 10.0),
       child: 
       Align(
         alignment: Alignment.bottomLeft,
         child: 
           Container(
             width: 190,
             height: 40,
             decoration: BoxDecoration(color: Colors.grey[400].withOpacity(0.8)),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
               Text(collection.name, style:TextStyle(color:Colors.black45, fontWeight: FontWeight.w800 ,fontSize: 20.0)),
               Text("数量:"+collection.number.toString(), style: TextStyle(color: Colors.pink)),
             ],)
           )
       ),
       decoration: BoxDecoration(
         image: DecorationImage(
           fit:BoxFit.contain,
           image: CachedNetworkImageProvider(
         myHost+"/dynamic/showpic/"+collection.imagePath
         ))
       ),
     )),
     onTap:(){
       // 跳转到具体的收藏详情界面
       String name = collection.name;
       Navigator.push(context, MaterialPageRoute(builder: (context)=> new CollectionDetailPage(collectionName: name, id: collection.id)));
     }
    
    )
     ;

   }

}

