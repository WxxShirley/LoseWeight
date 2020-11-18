class YearRecord{
  String title;
  List<String> times;
  String color;

  YearRecord({this.title, this.times, this.color});

  factory YearRecord.fromJson(Map<String, dynamic> json){
    return YearRecord(
      title: json["title"],
      times: json["times"].split("\r\n"), 
      color: json["color"],
    );
  }
}


class YearRecords{
  List<YearRecord> recs;
  
  YearRecords({this.recs});
  
  factory YearRecords.fromJson(List<dynamic> json){
    List records = new List<YearRecord>();
    return new YearRecords(recs: records=json.map((i)=>YearRecord.fromJson(i)).toList()  );
  }

}
