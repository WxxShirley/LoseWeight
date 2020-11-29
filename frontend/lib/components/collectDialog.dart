import 'package:flutter/material.dart';


// 单独封装一个内部管理选中状态的复选框组件
class DialogCheckbox extends StatefulWidget {
  DialogCheckbox({
    Key key,
    this.value,
    @required this.onChanged,
  });

  final ValueChanged<bool> onChanged;
  final bool value;

  @override
  _DialogCheckboxState createState() => _DialogCheckboxState();
}

class _DialogCheckboxState extends State<DialogCheckbox> {
  bool value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: (v) {
        //将选中状态通过事件的形式抛出
        widget.onChanged(v);
        setState(() {
          //更新自身选中状态
          value = v;
        });
      },
    );
  }
}

class TextInput extends StatefulWidget {
   TextInput({
     Key key, this.value, @required this.onChanged,
   });

    final ValueChanged<String> onChanged;
  final String value;

  @override
  _TextInput createState() => _TextInput();

}

class _TextInput extends State<TextInput>
{
  String value;
  TextEditingController _controller;

   @override
   void initState(){
     value = widget.value;
    super.initState();
   }

   @override
   Widget build(BuildContext context){
     return TextFormField(
       controller: _controller,
       initialValue: null,
       onChanged: (v){
         widget.onChanged(v);
         setState((){
           value=v;
         });
       },
     );
   }
}