
import 'package:bikeshared/services/user_services.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  final service = UserService();
  Map<String, dynamic> data ={};
  bool isLoading = false;

  //Future<UnmodifiableMapView> get data async => UnmodifiableMapView(_data);
  Map<String, dynamic> get datas => data;
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