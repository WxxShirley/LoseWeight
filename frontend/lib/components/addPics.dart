import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';



class AddPicBox extends StatelessWidget
{
  final ValueChanged<List<File> > chooseImgCallback;

  AddPicBox({this.chooseImgCallback});
   
   @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      child: 
       Container(
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
        print("点击了增加图片");
        List<Media> _listImagePaths = await ImagePickers.pickerPaths(
          galleryMode: GalleryMode.image,
          selectCount: 6,
          showGif: false,
          showCamera: true,
          compressSize: 200,
          uiConfig: UIConfig(uiThemeColor: Color(0xffff0f50)),
          cropConfig: CropConfig(enableCrop: false, width: 2, height: 1)
        );

        List<File> files = new List<File>();
        for(int i=0;i<_listImagePaths.length;i++){
          File file = new File(_listImagePaths[i].path);
          files.add(file);
        }
       
        chooseImgCallback(files);
        
      },
     );
  }
}