class ClockRecord {
  int id;
  String title;
  String startDate;
  String endDate;
  int freq;
  String icon;
  String color;
  String cTime;
  int hasTodayTag;
  int hasWeekTaskFinish;

  ClockRecord(
      {this.id,
      this.title,
      this.startDate,
      this.endDate,
      this.freq,
      this.icon,
      this.color,
      this.cTime,
      this.hasTodayTag,
      this.hasWeekTaskFinish
      });

  factory ClockRecord.fromJson(Map<String, dynamic> json) {
   return ClockRecord(  
    id:json['id'],
    title:json['title'],
    startDate:json['startDate'],
    endDate:json['endDate'],
    freq:json['freq'],
    icon:json['icon'],
    color:json['color'],
    cTime:json['cTime'],
    hasTodayTag:json['hasTodayTag'],
    hasWeekTaskFinish: json['hasWeekTaskFinish']
    );
  }

}


class ClockRecords{
  List<ClockRecord> records;
  ClockRecords({this.records});
  
  factory ClockRecords.fromJson(List<dynamic> json){
    List<ClockRecord> records = new List<ClockRecord>();
    return new ClockRecords(records: records = json.map((i)=>ClockRecord.fromJson(i)).toList());
  }


}