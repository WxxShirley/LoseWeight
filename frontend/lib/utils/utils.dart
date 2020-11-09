

String formatDate (){
  var date = DateTime.now();
  return date.year.toString()+"-"+date.month.toString()+"-"+date.day.toString();
}

String formateTime() {
  var hour = DateTime.now().hour.toString();
  if(hour.length==1){
    hour = "0"+hour;
  }
  var minute = DateTime.now().minute.toString();
  if(minute.length==1){
    minute = "0"+minute;
  }

  return hour+":"+minute;
}

String weekdayInfo(){
  List weekdayList = ['','周一','周二','周三','周四','周五','周六','周末'];

  return weekdayList[DateTime.now().weekday];
}