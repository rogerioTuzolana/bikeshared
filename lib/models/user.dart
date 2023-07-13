//import 'dart:convert';

class User{
  late int id;
  late String name;
  late String email;
  late String password;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  User.fromJson(Map<String, dynamic> json){
    name= json["nome"];
    email = json["email"];
    id = json["id"];
  }
  Map<String, dynamic> toJson()=>{
    "name": name,
    "email": email,
    "id": id
  };
}