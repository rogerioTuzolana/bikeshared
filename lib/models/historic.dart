
class Historic{
  late String code;
  late String description;
  late String type;
  late double value;

  Historic({
    required this.code,
    required this.description,
    required this.type,
    required this.value,
  });

  Historic.fromJson(Map<String, dynamic> json){
    code= json["id"].toString();
    description = json["tipo"];
    type = json["tipo"];
    value = double.parse(json["valor"]);
  }
  Map<String, dynamic> toJson()=>{
    "code": code,
    "description": description,
    "type": type,
    "value": value
  };
}