class Collection
{
  String name;
  String id;
  int number;
  String imagePath;

  Collection({
    this.name,
    this.id,
    this.number,
    this.imagePath
  });

  factory Collection.fromJson(Map<String, dynamic> json)
  {
    return Collection(
      name: json["name"],
      id: json["id"],
      number: int.parse(json["num"]),
      imagePath: json["image"]
    );
  }

}

class Collections
{
  List<Collection> collects;

  Collections({this.collects});

  factory Collections.fromJson(List<dynamic> json)
  {
    List<Collection> collects=new List<Collection>();
    return Collections(collects: collects=json.map((i)=>Collection.fromJson(i)).toList());
  }

}

