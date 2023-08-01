import 'package:bikeshared/views/start.dart';
//import 'package:bikeshared/start.dart';
import 'package:flutter/material.dart';

import 'services/shared_preferences_manager.dart';
//import 'package:flutter_config/flutter_config.dart';

void main() async{
  /*WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();*/
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager.init();
  if(SharedPreferencesManager.sharedPreferences.getString('token')!=null){
    //UserService.initializeUser();
  }
  SharedPreferencesManager.sharedPreferences.clear();
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
      home: const StartPage()//Splash() //Login()
    )
  );
}