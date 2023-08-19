
import 'dart:math';
import 'package:bikeshared/controllers/StationController.dart';
import 'package:bikeshared/models/station.dart';
import 'package:bikeshared/repositories/station_repository.dart';
import 'package:bikeshared/views/components/station_details.dart';
import 'package:bikeshared/views/screens/screen_about.dart';
import 'package:bikeshared/views/screens/screen_locations.dart';
import 'package:bikeshared/views/screens/screen_login.dart';
import 'package:bikeshared/views/screens/screen_solicitations.dart';
import 'package:bikeshared/views/screens/screen_profile.dart';
import 'package:bikeshared/views/screens/screen_wifi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:image/image.dart' as IMG;

final appKey = GlobalKey();

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

enum DrawerSelectOptions{
    home,
    locations,
    solicitations,
    chat,
    help,
    logout,
}
class _ScreenHomeState extends State<ScreenHome> {
  var currentPage = DrawerSelectOptions.home;

  //variavel que vai controlar o mapa
  late GoogleMapController _mapsController;
  String googleKey = "AIzaSyDFbFxPiczX2GO_iVLeTbzoBGSsw6ma938";//AIzaSyAyutQcGJEDgu1E8uLYIvXxsYjbfIeLdDw
  
  double lat = 0.0;
  double long = 0.0;
  String error = '';

  static const LatLng sourceLocation = LatLng(-8.8905235, 13.2274002);
  static const LatLng destination = LatLng(-8.8649484, 13.2939577);

  //variavel para marcacao de estacoes
  Set<Marker> markers = <Marker>{};

  //variaveis para marcação de coordenadas
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;


  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  //fórmula de Haversine
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    double earthRadius = 6371; // em quilômetros

    double dLat = degreesToRadians(lat2 - lat1);
    double dLon = degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degreesToRadians(lat1)) * cos(degreesToRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;
    return distance;
  }


  void setPolylines() async{

    
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleKey, 
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude), 
      PointLatLng(destination.latitude, destination.longitude),
      
    );
      
      /*print(result.status);
      print(result.points);
      print(result.errorMessage);*/
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(
            LatLng(point.latitude, point.longitude)
          );
        }

        setState(() {
          _polylines.add(
            Polyline(
            width: 3,
            polylineId: const PolylineId('polyLine'),
            color: const Color.fromARGB(255, 9, 67, 82),
            points: polylineCoordinates)
          );
        });
        
      
      }
  }

  Future<Position>_positionCurrent() async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Serviço de localização está desativado');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Acesso a localização com permissão negado');     
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Acesso a localização com permissão negado para sempre, Você precisa autorizar o acesso.');     
    }
    return await Geolocator.getCurrentPosition();
  }

  void getPosition() async{
    try {
      Position position = await _positionCurrent();
      lat = position.latitude;
      long = position.longitude;


      StationController.lat = lat;
      StationController.long = long;

      //await StationController.listStations();
      
      _mapsController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    } catch (e) {
      error = e.toString();
    }
    
  }


  void loadingStation () {
    var stations = StationRepository.list;
    for (var station in stations) {
      markers.add(
        Marker(
          markerId: MarkerId(station.stationId),
          position: LatLng(station.lat,station.long),
          /*icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(),
            'images/bike.png'
          ),//Icon(Icons.pedal_bike_sharp),*/
          onTap: ()=>{
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
            )
          },
        )
      );
    }
  }
  late Future<LatLng> location;
  @override
  void initState(){
    
    super.initState();
    
    polylinePoints = PolylinePoints();

    getPosition();
    loadingStation ();

    StationController.getLocation();
  }

  @override
  
  Widget build(BuildContext context) {
    


    
    //print(StationRepository.list[0].name);
    //print(markers);
    return 
    Scaffold(
      //key: appKey,
      resizeToAvoidBottomInset: false,
      //backgroundColor: const Color(0xff13a962),
      appBar: buildAppBar(),
      body: /*ChangeNotifierProvider<StationController>(
        
        create: (context)=>StationController(),*/
        Builder(builder: (context){
          
          /*final local = context.watch<StationController>();*/
          /*print(lat);
          print(long);*/
          /*print(polylineCoordinates);*/
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: /*sourceLocation*/LatLng(lat, long),
              zoom: 18,
            ),
            zoomControlsEnabled: true,
            mapType: MapType.terrain,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: true,
            //indoorViewEnabled: true,
            //onMapCreated: local.onMapCreated,
            markers: markers,
            onMapCreated: (GoogleMapController gController) async{
              _mapsController = gController;
              /*await */StationController.listStations();
              getPosition();
              loadingStation();
              
            },
            //polylines: _polylines,
            /*polylines: {

              Polyline(
                polylineId: const PolylineId("kPolyline"),
                points: polylineCoordinates,
                color: Colors.black12,
                width: 6
              )
            }*/
          );
          
        }),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width*0.7,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.135,
                child: Container(color: const Color.fromARGB(255, 0, 14, 27),),
              ),
              drawerList(),
            ],
          ),
        ),
      ),
    );
  }

  
  AppBar buildAppBar(){
    return AppBar(
        elevation: 0,
        /*leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black,),
          onPressed: (){},
        ),*/
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 16, right: 15),
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.person),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ScreenProfile(),
                ));
              },
            ),
            
          ),
          
        ],
        foregroundColor: Colors.white,//Colors.black,
        backgroundColor: const Color.fromARGB(255, 0, 14, 27),//Color.fromARGB(255, 2, 130, 250),

      );
  }

  Widget drawerList(){
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItemList(1,"Home",Icons.home_outlined,
          currentPage == DrawerSelectOptions.home ?true:false),
          menuItemList(2,"Localizar estações",Icons.location_pin,
          currentPage == DrawerSelectOptions.locations ?true:false),
          menuItemList(3,"Minhas solicitações",Icons.fact_check,
          currentPage == DrawerSelectOptions.solicitations ?true:false),
          menuItemList(4,"Conexão ",Icons.wifi_find,
          currentPage == DrawerSelectOptions.chat ?true:false),
          menuItemList(5,"Sobre Bike Shared",Icons.help_outlined,
          currentPage == DrawerSelectOptions.help ?true:false),
          menuItemList(6,"Sair",Icons.logout_outlined,
          currentPage == DrawerSelectOptions.logout ?true:false),
        ],
      ),
    );
  }

  Widget menuItemList(int id, String title, IconData icon, bool selected){
    return Material(
      color: selected && id != 5? Colors.grey[300]: Colors.transparent,
      child: InkWell(
        onTap: (){
          
          if (id == 1) {
            //Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const ScreenHome(),
            ));
          }else if (id == 2) {
            //Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const ScreenLocations(),
            ));
          }else if (id == 3) {
            //Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const ScreenSolicitations(),
            ));
          }else if (id == 4) {
            //Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(
              builder: (context) =>  const ScreenWifi(),
            ));
          }else if (id == 5) {
            //Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const ScreenAbout(),
            ));
          }else if(id == 6){
            //currentPage = DrawerSelectOptions.logout;
            showModalBottomSheet(
              backgroundColor: const Color.fromARGB(255, 0, 14, 27),
              context: context, builder: (context)=>confirmLogout(context),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  //bottomRight: Radius.circular(30),
                  //bottomLeft: Radius.circular(30),
                ),
              ),
            );
          }

        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                )
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black
                  ),
                )
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget modalSolicitation(BuildContext context, Station station){
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.40,
      margin: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 10,
      ),
      child: Column(
        children: [
          
          const Text('Estação', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
          const SizedBox(height: 20,),

          SizedBox(
            width: size.width,
            child: Text(
              station.address,
              style: const TextStyle(
                fontSize: 17,
                color: Color.fromARGB(221, 163, 163, 163)
              ),
              textAlign: TextAlign.left,
            )
          ),
          const SizedBox(height: 3,),         
          SizedBox(
            width: size.width,
            child: Row(
              children: [
                const Icon(
                  Icons.location_pin,
                  color: Color.fromARGB(255, 192, 14, 1),
                ),
                Text(
                  station.name,
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                )
              ],
            ) 
          ),
          const SizedBox(height: 25,),
          
          ElevatedButton(
            style: ButtonStyle(                  
              padding: MaterialStateProperty.all(const EdgeInsets.only(left:30, right: 30, top: 5, bottom: 5)),
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 0, 0, 0)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,  
              children: [
                Text(
                  "Solicitar", 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
            onPressed: () async{
              /*SharedPreferences sharedPreference = await SharedPreferences.getInstance();
              await sharedPreference.clear();
              Navigator.of(context).pop();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => const ScreenLogin(),
              ));*/
              showSnackBar(context, "Solicitação efectuada com successo");
              
            },

          ),

        ],
      ),
    );
  }

  void showSnackBar(BuildContext context, String mensagem) {
    final snackBar = SnackBar(
      content: Text(mensagem),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget confirmLogout(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.17,
      margin: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 10,
      ),
      child: Column(
        children: [
          const Text('Confirmar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(                  
                  padding: MaterialStateProperty.all(const EdgeInsets.only(left:30, right: 30, top: 5, bottom: 5)),
                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 14, 117, 117)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,  
                  children: [
                    Icon(Icons.logout_outlined,color: Colors.redAccent,),
                    Text(
                      "Sim", 
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    )
                  ],
                ),
                onPressed: () async{
                  SharedPreferences sharedPreference = await SharedPreferences.getInstance();
                  await sharedPreference.clear();
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => const ScreenLogin(),
                  ));
                },

              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.only(left:30, right: 30, top: 5, bottom: 5)),
                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 14, 117, 117)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,  
                  children: [
                    Icon(Icons.cancel, color: Color.fromARGB(255, 192, 195, 201),),
                    Text(
                      "Não", 
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    )
                  ],
                ),
                onPressed: () async{
                  Navigator.of(context).pop();
                },

              ),
              
              
            ],
          )
        ],
      ),
    );
  }

}

