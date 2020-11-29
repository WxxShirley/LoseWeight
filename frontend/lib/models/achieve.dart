class Achieve
{
  String taskTitle;
  String taskIcon;
  String taskColor;
  String timestamp;
  String weekNum;

  Achieve({
    this.taskTitle,
    this.taskIcon,
    this.taskColor,
    this.timestamp,
    this.weekNum
  });

  factory Achieve.fromJson(Map<String, dynamic> json){
    return Achieve(
      taskTitle: json["task_title"],
      taskIcon: json["task_icon"],
      taskColor: json["task_color"],
      timestamp: json["timestamp"],
      weekNum: json["week_num"],
    );
  }

}

class Achieves 
{
   List<Achieve> acs;
   Achieves({this.acs});

   factory Achieves.fromJson(List<dynamic> json){
     List<Achieve> acs = new List<Achieve>();
     return Achieves(acs: acs=json.map((i)=> Achieve.fromJson(i)).toList());
   }
}