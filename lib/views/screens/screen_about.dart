
//import 'dart:convert';

import 'package:bikeshared/views/screens/screen_config_ip.dart';
import 'package:bikeshared/views/screens/screen_home.dart';
import 'package:bikeshared/views/screens/screen_preloading.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;

class ScreenAbout extends StatefulWidget {
  const ScreenAbout({super.key});

  @override
  State<ScreenAbout> createState() => _ScreenAboutState();
}

class _ScreenAboutState extends State<ScreenAbout> {

  @override
  Widget build(BuildContext context) {
    
    return 
    Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar(){
    return AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const ScreenHome(),
            ));
          },
        ),
        backgroundColor: const Color.fromARGB(255, 0, 59, 114),
        title: const Text('Sobre BikeShared'),
        //centerTitle: true,
      );
  }


  buildBody(){
    Size size = MediaQuery.of(context).size;
    /*double lat = StationController.lat;
    double long = StationController.long;
    print("Yesss $long");
    print(SharedPreferencesManager.sharedPreferences.getString("email"));*/
    return 
        Stack(children: [
          
          Container(
            color: Colors.white,//const Color(0xff89d5b1),
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
              child: Column(children: [
                
                const Center(child: Text("Info "),),

                SizedBox(
                  width: size.width*0.8,
                  height: 40.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //shape: const CircleBorder(),
                      backgroundColor: const Color.fromARGB(255, 0, 14, 27),
                      shadowColor: const Color.fromARGB(255, 0, 0, 0),
                      //padding: EdgeInsets.all(24)
                      
                    ),
                    onPressed: () async{
                      //await StationController.testPing();
                      //await StationController.getCredit("rogerio33@gmail.com");
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(
                        builder: (context) => const ScreenConfigIp(),
                      ));
                    },
                    
                    child: const Text("Teste soap"),
                  ),
                ),
              ])      
            ),
          ),
        ]);
  }


}