
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class MessageController extends ChangeNotifier{
  
  List<String> messages = [
    'Ola',
    'Oi',
    'Tudo bem'
  ];

  
  setMessage(message) async{
    
    messages.add(message);

    notifyListeners();
  }

}