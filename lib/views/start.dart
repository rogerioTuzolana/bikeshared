import 'dart:async';

import 'package:bikeshared/views/screens/screen_login.dart';
import 'package:bikeshared/views/screens/screen_preloading.dart';
//import 'package:bikeshared/splash.dart';

import 'package:bikeshared/views/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  //final _id = TextEditingController();
  //final _password = TextEditingController();
  //final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    verifyToken().then((value) {
      //print("antes");
      if (value == true) {
        //print("Não devia");
        Timer(const Duration(seconds: 3),(){
          Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) =>const ScreenPreloading())
          );
        });
      } else {
        /*print("Token");
        print(value);*/
        Timer(const Duration(seconds: 3),(){
          Navigator.pushReplacement(context, 
            MaterialPageRoute(builder: (context) =>const ScreenLogin())
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Splash()/*CircularProgressIndicator()*/,
      ),
    );

  }

  Future<bool> verifyToken() async{
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();

    if (sharedPreference.getString('token') != "" && sharedPreference.getString('email') != null) {
      /*print(sharedPreference.getString('token'));
      print("Nooo");
      print("Null:");
      print(sharedPreference.getString('token')==null);
      print(sharedPreference.getString('token'));
      print("Vazio:");
      print(sharedPreference.getString('token')=="");*/
      return true;
    }else{
      return false;
    }
  }
}