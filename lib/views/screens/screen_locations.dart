
//import 'dart:convert';

import 'dart:math';

import 'package:bikeshared/controllers/StationController.dart';
import 'package:bikeshared/models/station.dart';
import 'package:bikeshared/repositories/station_repository.dart';
import 'package:bikeshared/services/shared_preferences_manager.dart';
import 'package:bikeshared/views/components/station_details.dart';
import 'package:bikeshared/views/screens/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;

class ScreenLocations extends StatefulWidget {
  const ScreenLocations({super.key});

  @override
  State<ScreenLocations> createState() => _ScreenLocationsState();
}

class _ScreenLocationsState extends State<ScreenLocations> {
  late Future <List<Station>> listStations;

  LatLng sourceLocation = const LatLng(-8.8905235, 13.2274002);
  LatLng destination = const LatLng(-8.8649484, 13.2939577);

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    double earthRadius = 6371; // em quilômetros

    double dLat = degreesToRadians(lat2 - lat1);
    double dLon = degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degreesToRadians(lat1)) * cos(degreesToRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;

    double roundedDistance = double.parse(distance.toStringAsFixed(2));
    return roundedDistance;
  }
  
  @override
  void initState() {

    super.initState();
    listStations = getStations();

    /*double distance = calculateDistance(widget.sourceLocation.latitude, widget.sourceLocation.longitude,
     widget.destination.latitude, widget.destination.longitude);

     double roundedDistance = double.parse(distance.toStringAsFixed(2));
    print("Distancia entre pontos $roundedDistance");*/

    print("Distancia entre pontos ${StationController.lat}");
     
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
                      //print("erthjhktr.");
                      if (snapshot.data!.isNotEmpty) {
                        SharedPreferencesManager.sharedPreferences.setBool('hasBikeShared',false);
                        return ListView.separated(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          //scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int nStation){
                            Station station = snapshot.data![nStation];
                            return ListTile(
                              onTap: (() {
                                showModalBottomSheet(
                                  context: context, builder: (context)=> StationDetails(station: station),
                                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  anchorPoint: const Offset(4, 5),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                      //bottomRight: Radius.circular(30),
                                      //bottomLeft: Radius.circular(30),
                                    ),
                                  ),
                                );
                              }),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                              //leading: Icon(Icons.arrow_downward),
                              
                              leading: const Icon(
                                  color: Colors.red,
                                    Icons.location_pin,
                              ),
                              title: Text(station.address,style: const TextStyle(color: Colors.black54),),
                              subtitle: Text(station.stationId,style: const TextStyle(color: Colors.black54,fontSize: 11),),
                              trailing: Text(
                                "${calculateDistance(
                                  StationController.lat, 
                                  StationController.long,
                                  station.lat,
                                  station.long
                                )} Km"
                              ),
                            );
                          },
                          padding: const EdgeInsets.all(16),
                          separatorBuilder: (_,__)=>const Divider(),
                          
                        );
                        
                      }else{
                        return SizedBox(
                          width: size.width,
                          height: size.height,
                          child: const Center(
                           child: Text("Nenhuma estação encontrada", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),)
                              ),
                        );
                      }

                    }else if(snapshot.hasError){
                      return Text(snapshot.error.toString());
                    }
                    return SizedBox(
                      width: size.width,
                      height: size.height,
                      child: const Center(child: CircularProgressIndicator())
                    );
                  })
                )
                
              ],)
            ,),
          ),
        ]);
  }

  Future<List<Station>> getStations() async{

    return StationRepository.list;

  }

}