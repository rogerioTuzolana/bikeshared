
//import 'dart:convert';

import 'package:bikeshared/models/station.dart';
import 'package:bikeshared/repositories/station_repository.dart';
import 'package:bikeshared/views/screens/screen_home.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;

class ScreenLocations extends StatefulWidget {
  const ScreenLocations({super.key});

  @override
  State<ScreenLocations> createState() => _ScreenLocationsState();
}

class _ScreenLocationsState extends State<ScreenLocations> {
  late Future <List<Station>> listStations;
  @override
  void initState() {

    super.initState();
    listStations = getStations();
  }
  @override
  Widget build(BuildContext context) {
    final stations = StationRepository.list;
    
    return 
    Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(),
      body: buildBody(stations),
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
        backgroundColor: const Color.fromARGB(255, 0, 14, 27),
        title: const Text('Localizar Estação'),
        //centerTitle: true,
      );
  }


  buildBody(List<Station> stations){
    Size size = MediaQuery.of(context).size;
    return 
        Stack(children: [
          
          Container(
            color: Colors.white,//const Color(0xff89d5b1),
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
              child: Column(children: [
                
                FutureBuilder<List<Station>>(
                  future: listStations,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        //scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int nStation){
                          Station station = snapshot.data![nStation];
                          return ListTile(
                            onTap: (() {
                              print("object");
                            }),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            //leading: Icon(Icons.arrow_downward),
                            
                            leading: Icon(
                                color: Colors.blueAccent,
                                  Icons.location_pin,
                            ),
                            title: Text(station.address,style: const TextStyle(color: Colors.black54),),
                            subtitle: Text(station.name,style: const TextStyle(color: Colors.black54,fontSize: 11),),
                            
                          );
                        },
                        padding: const EdgeInsets.all(16),
                        separatorBuilder: (_,__)=>const Divider(),
                        
                      );
                    }else if(snapshot.hasError){
                      return Text(snapshot.error.toString());
                    }
                    return const Center(child: CircularProgressIndicator());
                  })
                )
                
              ],)
            ,),
          ),
        ]);
  }

  Future<List<Station>> getStations() async{
    return StationRepository.list;
    //SharedPreferences sharedPreference = await SharedPreferences.getInstance();

  }

}