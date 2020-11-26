import 'dart:typed_data';

class Meal
{
  final String fileName;
  final String timestamp;
  final String type;
  
  Meal({this.fileName, this.timestamp, this.type});
}


class DayMeal
{
  final DateTime day;
  final String breakfast;
  final String lunch;
  final String dinner;

  DayMeal({this.day, this.breakfast, this.lunch, this.dinner});

  factory DayMeal.fromJson(Map<String, dynamic> json)
  {
    return DayMeal(
      day: DateTime.parse(json["day"]),
      breakfast: json["breakfast"],
      lunch: json["lunch"],
      dinner: json["dinner"],
    );
  }

}


class DayMealList
{
  final List<DayMeal> meals;

  DayMealList({this.meals});

  factory DayMealList.fromJson(List<dynamic> json)
  {
     List<DayMeal> meals = new List<DayMeal>();
     return DayMealList(meals: meals=json.map((i)=>DayMeal.fromJson(i)).toList());
  }

}
