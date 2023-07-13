
import 'package:bikeshared/models/station.dart';
import 'package:bikeshared/repositories/station_repository.dart';
import 'package:bikeshared/views/components/station_details.dart';
import 'package:bikeshared/views/screens/screen_login.dart';
import 'package:bikeshared/views/screens/ScreenSolicitations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ScreenTrajectory extends StatefulWidget {
  late LatLng sourceLocation;// = LatLng(-8.8905235, 13.2274002);
  late LatLng destination; //= LatLng(-8.8649484, 13.2939577);
  ScreenTrajectory({super.key, required this.sourceLocation, required this.destination});

  @override
  State<ScreenTrajectory> createState() => _ScreenTrajectoryState();
}


class _ScreenTrajectoryState extends State<ScreenTrajectory> {

  //variavel que vai controlar o mapa
  late GoogleMapController _mapsController;
  String googleKey = "AIzaSyAyutQcGJEDgu1E8uLYIvXxsYjbfIeLdDw";
  
  double lat = 0.0;
  double long = 0.0;
  String error = '';

  late LatLng sourceLocation2;// = LatLng(-8.8905235, 13.2274002);
  late LatLng destination2;// = LatLng(-8.8649484, 13.2939577);

  //variavel para marcacao de estacoes
  Set<Marker> markers = Set<Marker>();

  //variaveis para marcação de coordenadas
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  //late PolylinePoints polylinePoints;

  int polylineIdCount = 1;
  
  final Polyline _kPolyline = Polyline(
    polylineId: PolylineId('kPolyline'),
    points: [
      
      /*LatLng(-8.8643581, 13.2932776)
      LatLng(-8.8905235, 13.2274002), 
      LatLng(-8.8649484, 13.2939577)*/
    ],
    width: 2,
    endCap: Cap.squareCap,
    color: Colors.lightBlueAccent,
  );

  void setPolyPoints(LatLng origin, LatLng destination) async{
    //final String polylineIdVal = 'polyline_$polylineIdCount';
    
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('kPolyline'),
        points: [
          origin,//LatLng(-8.8645981, 13.2989975),
          destination//LatLng(-8.8643581, 13.2932776)
        ],
        width: 5,
        endCap: Cap.roundCap,
        color: const Color.fromARGB(255, 35, 112, 148),
      )
    );
  }

  /*void setPolylines() async{
    print("Antes");
    
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleKey, 
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude), 
      PointLatLng(destination.latitude, destination.longitude));
      print("Depois");
      print(result.status);
      print(result.points);
      if (result.points.isNotEmpty) {
        result.points.forEach((point) {
          print("Entrou");
          print(point);
          polylineCoordinates.add(
            LatLng(point.latitude, point.longitude)
          );
        });

        setState(() {
          _polylines.add(
            Polyline(
            width: 10,
            polylineId: PolylineId('polyLine'),
            color: Color.fromARGB(255, 9, 67, 82),
            points: polylineCoordinates)
          );
        });
        
      
      }
  }*/

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
      
      _mapsController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    } catch (e) {
      error = e.toString();
    }
    
  }

  void loadingStation () {
    print("thjerhtrjek");
    final stations = StationRepository.list;
    stations.forEach((station) async { 
      markers.add(
        Marker(
          markerId: MarkerId(station.name),
          position: LatLng(station.lat,station.long),
          /*icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(),
            'images/bike.png'
          ),//Icon(Icons.pedal_bike_sharp),*/
          onTap: ()=>{
            showModalBottomSheet(
              context: context, builder: (context)=> modalSolicitation(context, station),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              anchorPoint: Offset(4, 5),
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
    });
  }

  @override
  void initState(){
    
    super.initState();

    sourceLocation2 = widget.sourceLocation;
    destination2 = widget.destination;
    //polylinePoints = PolylinePoints();

    setPolyPoints(sourceLocation2, destination2);

    getPosition();
    loadingStation();

  }

  @override
  Widget build(BuildContext context) {
    
    // ignore: prefer_typing_uninitialized_variables
    /*final container;
    if (currentPage == DrawerSelectOptions.home) {
      container = const HomeUser();
    } else if(currentPage == DrawerSelectOptions.locations){
      container = const HistoricUser();
    }else if(currentPage == DrawerSelectOptions.solicitations){
      container = const Settings();
    }else if(currentPage == DrawerSelectOptions.help){
      container = const Help();
    }*/

    
    print(markers);
    return 
    Scaffold(
      //key: appKey,
      resizeToAvoidBottomInset: false,
      //backgroundColor: const Color(0xff13a962),
      appBar: buildAppBar(),
      body: /*ChangeNotifierProvider<StationController>(
        
        create: (context)=>StationController(),*/
        Container(
        child: Builder(builder: (context){
          
          /*final local = context.watch<StationController>();*/
          print(lat);
          print(long);
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
            //onMapCreated: local.onMapCreated,
            markers: markers,
            onMapCreated: (GoogleMapController gController) async{
              _mapsController = gController;
              getPosition();
              loadingStation();
              //setPolylines();
              setPolyPoints(sourceLocation2, destination2);
            },
            polylines: _polylines,
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
      ),
      
    );
  }

  
  AppBar buildAppBar(){
    return AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const ScreenSolicitations(),
            ));
          },
        ),
        title: const Text("Trajectória"),
        
        foregroundColor: Colors.white,//Colors.black,
        backgroundColor: const Color.fromARGB(255, 0, 14, 27),
        //title: Text('Baika Seguro'),
        //centerTitle: true,
      );
  }

  
  Widget modalSolicitation(BuildContext context, Station station){
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.20,
      margin: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 10,
      ),
      child: Column(
        children: [
          
          const Text('Estação', style: TextStyle(color: Color.fromARGB(255, 19, 19, 19), fontWeight: FontWeight.bold, fontSize: 20),),
          const SizedBox(height: 20,),

          SizedBox(
            width: size.width,
            child: Text(
              station.address,
              style: TextStyle(
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
                Icon(
                  Icons.location_pin,
                  color: Color.fromARGB(255, 192, 14, 1),
                ),
                Text(
                  station.name,
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                )
              ],
            ) 
          ),
          const SizedBox(height: 25,),
          
          
        ],
      ),
    );
  }

  Widget confirmLogout(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.15,
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
                  padding: MaterialStateProperty.all(EdgeInsets.only(left:30, right: 30, top: 5, bottom: 5)),
                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 255, 255)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,  
                  children: const [
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
                  padding: MaterialStateProperty.all(EdgeInsets.only(left:30, right: 30, top: 5, bottom: 5)),
                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 255, 255)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,  
                  children: const [
                    Icon(Icons.cancel, color: Colors.blueAccent,),
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

/*return Scaffold(
      appBar: AppBar(
        title: Text('Baika Seguro'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 126, 12, 97),
      ),
      body: //Stack(
        //children:[
        //],),
        SingleChildScrollView(
            child: Column(
              children:[
                SizedBox(height: 20,),
                Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width-40,
                      height: 70,
                      child:ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 226, 24, 176)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)))
                          ),
                          onPressed: (){
                            /*Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Splash(),
                            ));*/
                          },
                          child: Text('Meus Telemóveis', style: TextStyle(
                              fontSize: 24,
                              decoration: TextDecoration.none,
                              color: Colors.white,
                          ),
                        ),
                      ),
                  ),
                ),
                SizedBox(height: 20,),
                
                Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width-40,
                      height: 70,
                      child:ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 226, 24, 176)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)))
                          ),
                          onPressed: (){
                            /*Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Splash(),
                            ));*/
                          },
                          child: Text('Meus Telemóveis', style: TextStyle(
                              fontSize: 24,
                              decoration: TextDecoration.none,
                              color: Colors.white,
                          ),
                        ),
                      ),
                  ),
                ),
              ]
            )
        )
    );*/