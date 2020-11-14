class HttpRes{
  String status;
  String type;

  HttpRes({this.status, this.type});

  factory HttpRes.fromJson(Map<String, dynamic> json){
    return HttpRes(
      status: json["status"],
      type: json["type"].toString(),
    );
  }

}