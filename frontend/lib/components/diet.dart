import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/models/meal.dart';
import 'package:frontend/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

/*
    三个组件
    @ShowMeal -> 展示单张饮食图片
    @DietBox  -> 有+按钮的方形，点击后选择图片上传
    @Diet     -> 展示当日饮食图片的组件, 如果三餐都已上传，展示3个ShowMeal；否则展示已上传的ShowMeal组件和一个DietBox组件
*/

// ignore: must_be_immutable
class ShowMeal extends StatelessWidget
{
  Meal meal;
  ShowMeal({this.meal});
  
  Widget build(BuildContext context){
    return  Container(
      margin: EdgeInsets.only(left:5.0, right:5.0, top:10.0,bottom: 10.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child:Container(
          height:30.0,
          width: 100.0,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(meal.type, style:TextStyle( color: Colors.white, fontSize: 14.0)),
              Text(meal.timestamp,style:TextStyle(color: Colors.white, fontSize: 10.0))
            ]
          ),
          decoration: BoxDecoration(
            color: Colors.grey[400].withOpacity(0.8),
          ),
        )
      ),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(meal.fileName),  
          fit: BoxFit.fill,),
      ),
    );
  }

}

// ignore: must_be_immutable
class DietBox extends StatefulWidget
{
  Meal meal;
  final ValueChanged<Uint8List > chooseImgCallback;
  DietBox({this.meal, this.chooseImgCallback});

  @override
  _DietBox createState() => _DietBox(meal: meal, chooseImgCallback: chooseImgCallback);
}

class _DietBox extends State<DietBox>
{
  final Meal meal;
  final ValueChanged<Uint8List > chooseImgCallback;
  _DietBox({ this.meal, this.chooseImgCallback});


  final picker = ImagePicker();
  
  // 如果没有图片，展示“+”按钮，点击后上传图片
  Widget showNull(){
    return GestureDetector( 
      child:Container(
      padding: EdgeInsets.only(left:5.0, right:5.0, top:10.0,bottom: 10.0),
       child: 
        SizedBox(
         width: 100,
         height: 100,
         child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            color:Colors.grey[200],
          ),
          child: Icon(Icons.add,size: 55,color:Colors.grey)
       ),
      )),
      onTap: () async{
        // TODO: 上传图片至服务端
        final pickedFile = await picker.getImage(source: ImageSource.gallery);
        if(pickedFile != null){
          var imgStr = await pickedFile.readAsBytes();
          
          new Future.delayed(new Duration(microseconds: 1000), ()=>chooseImgCallback(imgStr));
        }else{
          print('No image selected');
        }
      },
    );
  }
  
  @override
  Widget build(BuildContext context)
  {
    return showNull();
  }
}


class Diet extends StatefulWidget
{
  @override
  _Diet createState() => _Diet();
}

class _Diet extends State<StatefulWidget>
{
  // 当日饮食图片
  List<Meal> images=new List();

  // 子组件上传图片触发
  choseImageCallback(Uint8List file){
   
    Meal newMeal = new Meal( fileName: file, type:"中餐",timestamp: formateTime());
    
    images.add(newMeal);
    
    this.setState(() {
      images = images;
    });
  }

  // 展示三餐列表组件
  Widget showMeals(){
    List<Widget> mealWidget = new List();
    List<String> types = ["早餐","中餐","晚餐"];
    if(images!=null&& images.length>=1){
    for(int i=0;i<images.length;i++){
      if(images[i]!=null){
        mealWidget.add(new ShowMeal(meal: Meal(fileName: images[i].fileName, timestamp: images[i].timestamp, type: types[i])));
      }
    }}
    if(images.length<3){
      mealWidget.add(new DietBox(meal: Meal(fileName: null,timestamp: null,type:"中餐"),chooseImgCallback: choseImageCallback,));
    }

    return Row(children: mealWidget);
  }

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // “记饮食” 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
             "记饮食",
             style: TextStyle(color:Theme.of(context).primaryColor, fontSize:20.0 , fontWeight: FontWeight.w600),
            ),
            images.length==3?Icon(Icons.check,color:Theme.of(context).primaryColor):Text('')
          ],
        ),
       
       // 至多三个方格展示当日饮食
       showMeals(),
       Divider(),

       // “记打卡”
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Text(
             "记打卡",
             style: TextStyle(color:Theme.of(context).primaryColor, fontSize:20.0 , fontWeight: FontWeight.w600),
           )
         ],
       ),

       
    ],);
  }

}

