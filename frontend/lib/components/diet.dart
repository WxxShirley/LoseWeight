import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/global/host.dart';
import 'package:frontend/global/info.dart';
import 'package:frontend/models/httpRes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:frontend/models/meal.dart';
import 'package:frontend/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return  
   Container(
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
              //Text(meal.timestamp,style:TextStyle(color: Colors.white, fontSize: 10.0))
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
          image: CachedNetworkImageProvider(
            myHost +  "/meal/show?path="+meal.fileName 
          ),
          fit: BoxFit.contain,),
      ),
    );
  }

}

// ignore: must_be_immutable
class DietBox extends StatefulWidget
{
  Meal meal;
  final ValueChanged<String > chooseImgCallback;
  DietBox({this.meal, this.chooseImgCallback,});

  @override
  _DietBox createState() => _DietBox(meal: meal, chooseImgCallback: chooseImgCallback);
}

class _DietBox extends State<DietBox>
{
  final Meal meal;
  final ValueChanged<String > chooseImgCallback;
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
          Uint8List imgStr = await pickedFile.readAsBytes();
          
          String base64Image = base64Encode(imgStr);
          String fileName = pickedFile.path.toString().split("/").last;
          print(fileName);
          
          // 使用HTTP协议上传到服务端
          SharedPreferences _prefs = await SharedPreferences.getInstance();

          int cnt = _prefs.getInt(key());
          if(cnt==null)
          {
            cnt=0;
            _prefs.setInt(key(), cnt);
          }else{
            cnt++;
            _prefs.setInt(key(), cnt);
          }

          http.Response res = await http.post(myHost+"/meal/upload", 
            body: {
              "mobile": userMobile.toString(), 
              "fileName": fileName, 
              "image": base64Image,
              "index": cnt.toString(),
            }
          );
          HttpRes _res = HttpRes.fromJson(json.decode(res.body.toString()));
          String imgPath = _res.type;
          
          // 缓存每一餐的信息 e.g "2020-11-2618933928018-0"早餐
          print("index:"+cnt.toString());
          print("返回结果"+_res.type);
          _prefs.setString(key()+"-"+cnt.toString(), imgPath);

          new Future.delayed(new Duration(microseconds: 1000), ()=>chooseImgCallback(imgPath));
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



  @override 
  void initState()
  {
    super.initState();
     
    fetchMeal();

  }

  fetchMeal() async
  {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    String breakfast = _prefs.getString(key()+"-0");
    String lunch = _prefs.getString(key()+"-1");
    String dinner = _prefs.getString(key()+"-2");

    if(breakfast!=null){
      print("早餐"+ breakfast);
      images.add(Meal(fileName: breakfast, timestamp: "", type: "早餐"));
    }
    if(lunch!=null){
      print("中餐"+ lunch);
      images.add(Meal(fileName: lunch, timestamp: "", type: "中餐"));
    }
    if(dinner!=null){
      print("晚餐"+ dinner);
      images.add(Meal(fileName: dinner, timestamp: "", type: "晚餐"));
    }

    /* _prefs.remove(key());
    _prefs.remove(key()+"-0");
    _prefs.remove(key()+"-1");
    _prefs.remove(key()+"-2");*/
    
   
   
    setState((){
      images = images;
      
    });


  }


  // 子组件上传图片触发
  choseImageCallback(String file){
   
    Meal newMeal = new Meal( fileName: file, type:"",timestamp: formateTime());
    
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
    if(images.length<3&&mealWidget.length>=0){
      //if(mealWidget.length==0 ||(  mealWidget.length>0&&mealWidget.last.toString()!="DietBox"))
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

