import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HeaderDrawer extends StatefulWidget {
  const HeaderDrawer({super.key});

  @override
  State<HeaderDrawer> createState() => _HeaderDrawerState();
}

class _HeaderDrawerState extends State<HeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[700],
      width: double.infinity,
      height: 150,//200,
      padding: const EdgeInsets.only(top: 20.0),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircleAvatar(backgroundImage: AssetImage("images/avatar.png"),),
          ),
          
          /*SizedBox(height: 10,),
          FutureBuilder(
            future: getUser(),
            builder: ((context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                print(":::");
                Map<String, dynamic> userMap = snapshot.data;
                //User user = User.fromJson(snapshot.data);
                print(userMap);
                print(userMap["status"]==false);
                print("----");
                User user = 
                (userMap["status"]!=false)?
                User.fromJson(userMap):
                User.fromJson({"nome":"--","telefone": "--"});
                
                //print(snapshot.data);
                return Text('${user.name}', style: TextStyle(color: Colors.white, fontSize: 20),);
              }
              return CircularProgressIndicator();
          
            }
          )),*/
          
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> getUser() async{
    
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();

    try {
      String? token = sharedPreference.getString('token');
      //print('Bearer $token');

      final url = Uri.parse("https://apibaikaactual-production.up.railway.app/getUser");

      http.Response response = await http.get(
        url,
        headers: /*<String, String>*/{
          'Content-Type': 'application/json; charset=UTF-8',// charset=UTF-8
          'Accept': 'application/json',
          //HttpHeaders.authorizationHeader: 'Bearer $token',
          'Authorization': 'Bearer $token',
          
        },
        /*body: jsonEncode({
          "preco": _amount.text,
        })*/
      );
      if (response.statusCode == 200) {
        
        /*User user = (jsonDecode(response.body)["userExist"]==Null)?
        User.fromJson(jsonDecode(response.body)["userExist"]):
        User.fromJson(jsonDecode("{name:"",contact: ""}"));
        print(user.name);
        print(user.toJson());*/
        return jsonDecode(response.body)["userExist"];
        
      }else if(response.statusCode == 503){
        //print('Servidor indisponível');
        return {"status":false};
      }else if(response.statusCode == 500){
        //print('Falha na requisição');
        return {"status":false};
      }else{
        
        /*print(jsonDecode(response.body));
        print(response.statusCode);*/
        return {"status":false};
      }
    } catch (e) {
      /*print('Tempo de execução demorada!');
      print(e);*/
      return {"status":false};
      //rethrow;
    }

  }

}
