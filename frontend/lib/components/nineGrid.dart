import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/global/host.dart';

// ignore: must_be_immutable
class OnePics extends StatefulWidget
{
  String path;
  double width;
  OnePics({this.path, this.width});
  @override
  _OnePics createState() => _OnePics(path: path, width:width);
}

class _OnePics extends State<OnePics>
{
  String path;
  double width;
  _OnePics({this.path, this.width});
  CachedNetworkImage _img;

  @override
  void initState(){
    super.initState();
    loadImg();
    setState((){
      path = path;
    });
  }

  loadImg()async{
    //_img = await ExtendedImage.network(myHost+"/dynamic/showpic/"+path, cache: false,);
    _img = await CachedNetworkImage(
          imageUrl: myHost+"/dynamic/showpic/"+path, width: width,height: width,fit:BoxFit.cover,
          errorWidget: (context, str, dy){
            return Center(child:Text("发生错误"));
          },
        );
    setState((){
      _img = _img;
    });
  }


   Widget build(BuildContext context){
     return this.path==null||this.path.length==0 || _img==null?
      Container(height: width, width: width, 
        decoration: BoxDecoration(color:Colors.grey),
      ):
      Container(
        margin: EdgeInsets.only(left:5.0, right:5.0, top:10.0,bottom: 10.0,),
        child: _img,
        width: width,
        height: width,
      );
   }

}


// ignore: must_be_immutable
class NineGrid extends StatelessWidget 
{
   List<String> paths;
   NineGrid({this.paths});

  
  buildWidget(){
    List<Widget> _widget = new List<Widget>();
    if(paths.length<=3){
      // 1*n
      for(int i=0;i<paths.length;i++){
        _widget.add(
          OnePics(path: paths[i], width: 100,),
        );
      }
      return Row(
        children: _widget,
      );
    }
    if(paths.length==4){
      // 2*2
      _widget = [OnePics(path: paths[0], width: 140,), OnePics(path: paths[1], width: 140,)];
      List<Widget> _widget2 = new List<Widget>();
      _widget2 = [OnePics(path: paths[2], width: 140,), OnePics(path: paths[3], width: 140,)];
      return Column(children: [
        Row(children: _widget,),
        Row(children: _widget2,)
      ],);
    }
    // 2*3
     _widget = [OnePics(path: paths[0], width: 100,), OnePics(path: paths[1], width: 100,), OnePics(path:paths[2],width: 100,)];
      List<Widget> _widget2 = new List<Widget>();
      for(int i=3;i<paths.length;i++){
        _widget2.add(OnePics(path:paths[i], width: 100,));
      }
     return Column(children: [
       Row(children: _widget),
       Row(children: _widget2),
     ],) ;
  }

   @override
  Widget build(BuildContext context)
  {
     

    return buildWidget();

  }


}



