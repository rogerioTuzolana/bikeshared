
import 'package:flutter/material.dart';
import 'package:flutter_p2p_plus/flutter_p2p_plus.dart';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class MessageController extends ChangeNotifier{
  
  List<List<String>> messages = [
    /*['Ola',"0"],
    ['Oi',"1"],
    ['Tudo bem',"0"],
    ['Tudo',"1"]*/
  ];

  late P2pSocket socket;
  
  setMessage(message, level) async{
    
    messages.add([message,level]);

    notifyListeners();
  }

}