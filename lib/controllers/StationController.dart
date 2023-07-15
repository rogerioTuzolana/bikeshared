import 'package:bikeshared/repositories/station_repository.dart';
import 'package:bikeshared/views/components/station_details.dart';
import 'package:bikeshared/views/screens/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationController extends ChangeNotifier{
  static double lat = 0.0;
  static double long = 0.0;
  String error = '';
  //Marcadores de estacoes
  static Set<Marker> markers = <Marker>{};
  //variavel que vai controlar o mapa
  late GoogleMapController _mapsController;
String googleKey = "AIzaSyAyutQcGJEDgu1E8uLYIvXxsYjbfIeLdDw";
  
  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  /*StationController(){
    getPosition();
  }*/

  get mapsController=> _mapsController;

  onMapCreated(GoogleMapController gController) async{
    _mapsController = gController;
    getPosition();
    loadingStation();
  }

  static loadingStation() {
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
              context: appKey.currentState!.context, builder: (context)=> StationDetails(station: station),
              backgroundColor: const Color.fromARGB(255, 2, 130, 250),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              anchorPoint: const Offset(4, 5),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
            )
          },
        )
      );
    });
  }

  setPolylines() async{
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleKey, 
      const PointLatLng(-8.8905235, 13.2274002), 
      const PointLatLng(-8.8649484, 13.2939577));

      if (result.points.isEmpty) {
        result.points.forEach((point) {
          polylineCoordinates.add(
            LatLng(point.latitude, point.longitude)
          );
        });

        _polylines.add(Polyline(
          width: 10,
          polylineId: const PolylineId('polyLine'),
          color: const Color(0xFF08A5CB),
          points: polylineCoordinates));
      
      }
  }

  getPosition() async{
    try {
      Position position = await _positionCurrent();
      lat = position.latitude;
      long = position.longitude;
      
      _mapsController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  static getLocation() async{
    try {
      Position position = await _positionCurrent();
      lat = position.latitude;
      long = position.longitude;
      
      //_mapsController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
      return LatLng(lat, long);
    } catch (e) {
      //error = e.toString();
      return const LatLng(-1,-1);
    }
    
  }

  static Future<Position>_positionCurrent() async{
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
}