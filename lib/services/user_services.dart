/*import 'dart:convert';

import 'package:bikeshared/models/user.dart';
import 'package:bikeshared/repositories/user_repository.dart';
import 'package:bikeshared/services/shared_preferences_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class UserService {
  /*final _id = TextEditingController();
  final _password = TextEditingController();*/
  /*static final _contact = null;
  static final _password = null;
  static final _firstName = null;
  static final _lastName = null;
  static  final _address = null;*/
  
  static Future<dynamic> initializeUser() async {
    // Buscar dados da base de dados ou de alguma fonte externa
    final data = await getUser();
    print(data);
    if (data['status']== false && data['code'] == 400) {
      SharedPreferencesManager.sharedPreferences.clear();
      return data;
    }

    bool authStatus=false;
    late User userExist;
    final users = UserRepository.tabela;
    for (var user in users) { 
      if (user.id.toString() == SharedPreferencesManager.sharedPreferences.getString('token')) {
        authStatus = true;
        userExist = user;
        continue;
      }
    }
  
    if(authStatus==true){

      await SharedPreferencesManager.sharedPreferences.setString('token', "${userExist.id}");
      await SharedPreferencesManager.sharedPreferences.setString('name', userExist.name);
      await SharedPreferencesManager.sharedPreferences.setString('email', userExist.email);
      await SharedPreferencesManager.sharedPreferences.setInt('point', 10);
      print("yas");
    }

  }
  
  static Future<bool> login(String id, String password) async{
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    try {
      
      final url = Uri.parse("https://");

      http.Response response = await http.post(
        url,
        headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            /*HttpHeaders.authorizationHeader: "...",*/
        },
        body: jsonEncode({
          /*"codigo"*/"email": id,
          "password": password,
        })
      );
      if (response.statusCode == 200) {
        await sharedPreference.setString('token', "${jsonDecode(response.body)['token']}");
        //print(jsonDecode(response.body)['token']);
        return true;
      }else if(response.statusCode == 503){
        //print('Servidor indisponível');
        return false;
      }else if(response.statusCode == 500){
        //print('Falha na requisição');
        return false;
      }else{
        /*print('Erro na autenticação');
        print(response);*/
        return false;
      }
    } catch (e) {
      //print('Tempo de execução demorada!');
      //print(e);
      return false;
      //rethrow;
    }
  }

  static Future<Map<String, dynamic>> getUser() async{
    
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    bool status = false;
    User userExist;
    try {
      String? token = sharedPreference.getString('token');
      print('Bearer $token');

      final users = UserRepository.tabela;
      users.forEach((user) { 
        if (user.id == token) {
          print("Temmmmmmmmmmm");
          status = true;
          userExist = user;
          //return;
          //return {"status":true,'code': 200};
        }
      });

      return {"status":true,'data': ""};
      
    } catch (e) {
      /*print('Tempo de execução demorada!');*/
      print(e);
      return {"status":false,'code': 0};
      //rethrow;
    }

  }

  Future<bool> regist(String firstName, String lastName, String password, String contact, address) async{
    
    //SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    /*print(_contact.text);
    print(_password.text);
    print("${_firstName.text} ${_lastName.text}");
    print(_address.text);*/
    try {
      
      final url = Uri.parse("https://");

      http.Response response = await http.post(
        url,
        headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            /*HttpHeaders.authorizationHeader: "...",*/
        },
        body: jsonEncode({
          "email": contact,
          "password": password,
          "nome": "$firstName $lastName",
          //"cod_qr": _bi.text,
        })
      );
      if (response.statusCode == 200) {
        //print(jsonDecode(response.body));
        return true;
      }else if(response.statusCode == 503){
        //print('Servidor indisponível');
        return false;
      }else if(response.statusCode == 500){
        //print('Falha na requisição');
        return false;
      }else if(response.statusCode == 400){

        //messageErrorRegist('Este utilizador já existe!');
        
        return false;
      }else{
        /*print('Falha no cadastro');
        print(response.body);*/
        return false;
      }
    } catch (e) {
      /*print('Tempo de execução demorada!');
      print(e);*/
      return false;
      //rethrow;
    }
  }

}*/