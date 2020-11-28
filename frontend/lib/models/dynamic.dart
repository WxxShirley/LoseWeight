class Dynamic
{
  String hisAvatar;
  String hisNickname;
  String hisMobile;

  String id;
  DateTime timestamp; 
  String txtContent;
  String imageList;
  List<String> paths;
  String type;

  Dynamic({
    this.hisAvatar,
    this.hisNickname,
    this.hisMobile,
    this.id,
    this.timestamp,
    this.txtContent,
    this.imageList,
    this.paths,
    this.type,
  });

  factory Dynamic.fromJson(Map<String, dynamic> json){
    return Dynamic(
      hisAvatar: json["user_avatar"],
      hisNickname: json["user_nickname"],
      hisMobile: json["user_mobile"].toString(),
      id: json["id"],
      timestamp: DateTime.parse(json["timestamp"]),
      txtContent: json["txt_content"],
      imageList: json["image_list"],
      paths: new List<String>(),
      type: json["type"]
    );
  }
}


class Dynamics {
  List<Dynamic> dys;

   Dynamics({this.dys});

   factory Dynamics.fromJson(List<dynamic> json)
   {
     List<Dynamic> dys;
     return Dynamics(dys: dys=json.map((i)=>Dynamic.fromJson(i)).toList());
   }

}