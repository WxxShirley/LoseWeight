// 周视图中显示的每一天的打卡记录
class DayRecordDetail{
  DateTime date;
  String title;
  String iconTheme;
  String colorTheme;
  String detail;

  DayRecordDetail({this.date, this.title, this.iconTheme, this.colorTheme, this.detail});

  factory DayRecordDetail.fromJson(Map<String, dynamic> json){
    return DayRecordDetail(
      date: DateTime.parse(json["date"]),
      title: json["title"],
      iconTheme: json["icon_theme"],
      colorTheme: json["color_theme"],
      detail: json["detail"]
    );
  }

}

class DayRecords {
  List<DayRecordDetail> records;
   
  DayRecords({this.records});

  factory DayRecords.fromJson(List<dynamic> json){
    List records = new List<DayRecordDetail>();
    return new DayRecords(records: records=json.map((i)=>DayRecordDetail.fromJson(i)).toList() );
  }

}