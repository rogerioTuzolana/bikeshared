import 'package:bikeshared/env.dart';
import 'package:bikeshared/services/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;
class UserController extends ChangeNotifier{

  static Future<int> activeUser(email, name, password) async{
    //SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    final xmlBody = '''
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.bikeshareds.org/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:activateUser>
              <!--Optional:-->
              <email>$email</email>
            </ws:activateUser>
        </soapenv:Body>
      </soapenv:Envelope>
    ''';
    try {
      
      final url = Uri.parse(Env.url);

      http.Response response = await http.post(
        url,
        /*headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            /*HttpHeaders.authorizationHeader: "...",*/
        },*/
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
        },
        body: xmlBody
      );
      if (response.statusCode == 200) {
        //await sharedPreference.setString('token', "${jsonDecode(response.body)['token']}");
        //print(jsonDecode(response.body)['token']);
        print('Deu certo');
        final xmlString = response.body;
        final document = xml.XmlDocument.parse(xmlString);///XmlDocument.parse(xmlString);
        final user = document.findAllElements('user').first;
        final email = user.findElements('email');
        final hasBikeShared = user.findElements('hasBikeShared');
        final credit = user.findElements('credit');
        print(email.first.text);
        print(hasBikeShared.first.text);
        print(credit.first.text);
        print(user);

        //SharedPreferencesManager.init();
        SharedPreferences sharedPreference = SharedPreferencesManager.sharedPreferences;
        //await sharedPreference.setString('token', "${userExist.id}");
        await sharedPreference.setString('name', name);
        await sharedPreference.setString('email', email.first.text);
        await sharedPreference.setString('password', password);
        await sharedPreference.setBool('hasBikeShared', bool.fromEnvironment(hasBikeShared.first.text));
        await sharedPreference.setInt('credit', int.parse(credit.first.text));
        
        return 0;
      }else if(response.statusCode == 503){
        print('Servidor indisponível');
        print(response.body);
        return 2;
      }else if(response.statusCode == 500){
        print('Falha na requisição');

        print(response.body);

        final xmlString = response.body;
        final document = xml.XmlDocument.parse(xmlString);///XmlDocument.parse(xmlString);
        final faultstring = document.findAllElements('faultstring').first.text;
        print(faultstring);
        return 1;
      }else{
        print('Erro na autenticação');
        print(response.body);
        return 2;
      }
    } catch (e) {
      //print('Tempo de execução demorada!');
      
      print(e.toString());
      return 2;
      //rethrow;
    }
  }

  
}