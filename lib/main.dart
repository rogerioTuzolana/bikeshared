import 'package:bikeshared/env.dart';
import 'package:bikeshared/views/screens/screen_config_ip.dart';
//import 'package:bikeshared/start.dart';
import 'package:flutter/material.dart';

import 'services/shared_preferences_manager.dart';
//import 'package:flutter_config/flutter_config.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager.init();
  if(SharedPreferencesManager.sharedPreferences.getString('token')!=null){
    //UserService.initializeUser();
  }
  if (Env.url == "" && SharedPreferencesManager.sharedPreferences.getString("endpoint") !="") {
    Env.url = SharedPreferencesManager.sharedPreferences.getString("endpoint")!;
  }
  //SharedPreferencesManager.sharedPreferences.clear();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
          primaryColor: const Color.fromARGB(255, 255, 255, 255),
          visualDensity: VisualDensity.adaptivePlatformDensity
          //primarySwatch: Colors.indigo//Color.fromARGB(255, 126, 12, 97)
          //colorScheme: ColorScheme.light(primary: Color.fromARGB(255, 226, 24, 176))
        ),
      home: const ScreenConfigIp()//StartPage()//init
    )
  );
}