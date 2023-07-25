import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
class UserController extends ChangeNotifier{

  static Future<bool> activeUser(email) async{
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
      
      final url = Uri.parse("http://192.168.0.118:8989/cliente?wsdl");

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
        final x = document.findAllElements('stations');
        /*x.map((e) {
          print(e.findAllElements("coordinate").first.text);
        },);*/
        print(document);

        //User(id: id, name: name, email: email, password: password)
        /*for (var stationElement in x) {
          final id = stationElement.findElements('id');
          final coordinates = stationElement.findAllElements('coordinate');
          print('coordinates: $coordinates');
          /*for (var coordinate in coordinates) {
            final x = stationElement.findElements('x');
            final y = stationElement.findElements('y');
            
            print('X: $x');
            print('Y: $y');
          }*/
          
          final capacity = stationElement.findElements('capacity');
          final totalGets = stationElement.findElements('totalGets');
          final totalReturns = stationElement.findElements('totalReturns');
          final availableBikeShared = stationElement.findElements('availableBikeShared');
          final freeDocks = stationElement.findElements('freeDocks');

          print('ID: $id');
          print('Capacity: $capacity');
          print('Total Gets: $totalGets');
          print('Total Returns: $totalReturns');
          print('Available Bike Shared: $availableBikeShared');
          print('Free Docks: $freeDocks');
          print('-----------------------');
        }

        */
        return true;
      }else if(response.statusCode == 503){
        print('Servidor indisponível');
        print(response.body);
        return false;
      }else if(response.statusCode == 500){
        print('Falha na requisição');
        print(response.body);
        return false;
      }else{
        print('Erro na autenticação');
        print(response.body);
        return false;
      }
    } catch (e) {
      //print('Tempo de execução demorada!');
      //print(e);
      print(e.toString());
      return false;
      //rethrow;
    }
  }
}