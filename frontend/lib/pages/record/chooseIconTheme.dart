import 'package:flutter/material.dart';
import 'package:frontend/global/iconTheme.dart';
import 'package:frontend/models/iconThemeAttribute.dart';

/*
   选择Icon主题组件
    - OneIcon -> 一个Icon组件
    - IconsPage -> 以GridView展示的所有icon集合，用户选中后将icon返回给上一界面[createTask]
*/


class OneIcon extends StatelessWidget{
   final IconData icon;
   final bool isSelected;
   final int index;
   final ValueChanged<int> onThemeSelected;
   OneIcon({this.icon, this.isSelected, this.index, this.onThemeSelected});

   @override
   Widget build(BuildContext context){
     return 
     GestureDetector(
       child: 
         Container(
           margin: EdgeInsets.all(10.0),
           height: 56.0,
           width: 56.0,
           decoration: BoxDecoration(
             shape: BoxShape.rectangle,
             borderRadius: BorderRadius.circular(28.0),
             color:isSelected==true?Theme.of(context).primaryColorLight : Colors.grey[200],
           ),
           child: ClipOval(child:Icon(icon,
            color:isSelected==true?Colors.white :  Colors.black87,
           size:28.0),)
         ),
        onTap:(){
          onThemeSelected(index);
        } 
     );
   }
}


class IconsPage extends StatefulWidget 
{
  @override
  _IconsPage createState() => _IconsPage();
}

class _IconsPage extends State<IconsPage>
{
  List<IconThemeAttribute> _icons = new List<IconThemeAttribute>(); 
  IconData selected; 
  int selectedIndex=-1;
  
  // 当有icon被选中时回调
  sonThemeSelected(int index){
    for(int i=0;i<_icons.length;++i){
      _icons[i].selected=false;
    }
    _icons[index].selected = true;
    setState(() {
      _icons = _icons;
      selected = _icons[index].icon; 
      selectedIndex = index; 
    });
  }

  @override
  void initState(){
    super.initState();
    
    // 创建_icons 对象
    for(int i=0;i<icons.length;++i){
      IconThemeAttribute _i = new IconThemeAttribute(icon: icons[i], selected: false);
      _icons.add(_i);
    }
    setState(() {
      _icons = _icons;
      selected = null; // 初始化为空
    });
  }


  @override
  Widget build(BuildContext context){
    return
    Scaffold(
      appBar: AppBar(title: Text("选择主题"), leading:Text(""),
        actions: [
          FlatButton(child: Text( selected==null?"取消":"确定",style:TextStyle(color: Colors.white)),onPressed: (){
            Navigator.pop(context, selectedIndex);
          },)
        ],
      ),
      body: 
       GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, childAspectRatio: 1.0),
        itemCount: _icons.length,
        itemBuilder: (context,index){
          return OneIcon(icon: _icons[index].icon,isSelected: _icons[index].selected, index:index, onThemeSelected: sonThemeSelected,);
        },
      )
    );
  }
}