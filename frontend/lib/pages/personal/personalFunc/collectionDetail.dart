import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/returnButton.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/dynamic.dart';
import 'package:frontend/pages/dynamic/oneWidget.dart';


// ignore: must_be_immutable
class CollectionDetailPage extends StatefulWidget
{
  String collectionName;
  String id;
  CollectionDetailPage({this.collectionName, this.id});
   
   @override
   _CollectionDetailPage createState() => _CollectionDetailPage(collectionName: collectionName, id:id);

}

class _CollectionDetailPage extends State<CollectionDetailPage>
{
  String collectionName;
  String id;
  _CollectionDetailPage({this.collectionName, this.id});
  
  bool isLoading=true;
  List<Dynamic> _list;

  @override
  void initState()
  {
    super.initState();
    load();
  }
  
  // 加载该收藏夹内的动态内容
  load() async{
      Dio _dio = new Dio();
      _dio.options.responseType = ResponseType.plain;
      Response _res = await _dio.get(myHost+"/dynamic/one_collection",queryParameters: {'mobile':userMobile, 'collection_id':id},options: Options(headers: {'Authorization':myToken}));
   
      Dynamics _dys = Dynamics.fromJson(json.decode(_res.data.toString()));
    
      setState((){
        isLoading = false;
        _list = _dys.dys;
      });

  }


   @override
   Widget build(BuildContext context){
     return Scaffold(
       appBar: AppBar(title:Text('收藏-'+collectionName), leading: ReturnButton(),),
       body: 
        isLoading==true?
        Center(child: CircularProgressIndicator())
        :
        ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index){
            return OneWidget(dy: _list[index]);
          }
        )

     );
   }

}

