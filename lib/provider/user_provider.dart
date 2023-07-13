
import 'package:bikeshared/services/user_services.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  final _service = UserService();
  Map<String, dynamic> _data ={};
  bool isLoading = false;

  //Future<UnmodifiableMapView> get data async => UnmodifiableMapView(_data);
  Map<String, dynamic> get data => _data;
  /*saveAll(Map<String, dynamic> user){
   
    _data = user;
    notifyListeners();
  }*/
  
  Future<void> userSave() async{
    /*isLoading = true;
    notifyListeners();*/
    /*final response = await _service.getUser();
    _data = response;
    //isLoading = false;
    notifyListeners();*/
  }
  
}