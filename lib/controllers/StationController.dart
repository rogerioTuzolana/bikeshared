
import 'package:bikeshared/models/station.dart';
import 'package:bikeshared/repositories/station_repository.dart';
import 'package:bikeshared/views/components/station_details.dart';
import 'package:bikeshared/views/screens/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

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

  static Future<bool> testPing() async{
    //SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    const xmlBody = '''
      
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://ws.bikeshareds.org/">
        <soap:Header/>
        <soap:Body>
          <wsdl:test_ping>
          <input_message>OLA</input_message>
          </wsdl:test_ping>
          <!-- Adicione mais elementos aqui, conforme necessário, para enviar os parâmetros -->
        </soap:Body>
      </soap:Envelope>
    ''';
    try {
      
      final url = Uri.parse("http://192.168.0.118:8989/cliente?wsdl");

      http.Response response = await http.post(
        url,
        /*headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            /*HttpHeaders.authorizationHeader: "...",*/
        },*/
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
        },
        body: xmlBody
      );
      if (response.statusCode == 200) {
        //await sharedPreference.setString('token', "${jsonDecode(response.body)['token']}");
        //print(jsonDecode(response.body)['token']);
        print('Deu certo');
        final xmlString = response.body;
        final document = xml.XmlDocument.parse(xmlString);///XmlDocument.parse(xmlString);
        //document.findAllElements('wsdl:test_ping');
        print(document.findAllElements('return').first.text);
        return true;
      }else if(response.statusCode == 503){
        print('Servidor indisponível');
        print(response.body);
        return false;
      }else if(response.statusCode == 500){
        print('Falha na requisição');
        print(response.body);
        return false;
      }else{
        print('Erro na autenticação');
        print(response.body);
        return false;
      }
    } catch (e) {
      //print('Tempo de execução demorada!');
      //print(e);
      print(e.toString());
      return false;
      //rethrow;
    }
  }

  static Future<bool> listStations() async{
    //SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    final xmlBody = '''
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.bikeshareds.org/">
        <soapenv:Header/>
        <soapenv:Body>
          <ws:listStations>
            <numberOfStations>3</numberOfStations>
            <coordinates>
              <x>$lat</x>
              <y>$long</y>
            </coordinates>
          </ws:listStations>
        </soapenv:Body>
      </soapenv:Envelope>
    ''';
    try {
      
      final url = Uri.parse("http://192.168.0.118:8989/cliente?wsdl");

      http.Response response = await http.post(
        url,
        /*headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            /*HttpHeaders.authorizationHeader: "...",*/
        },*/
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
        },
        body: xmlBody
      );
      if (response.statusCode == 200) {
        //await sharedPreference.setString('token', "${jsonDecode(response.body)['token']}");
        //print(jsonDecode(response.body)['token']);
        print('Deu certo');
        final xmlString = response.body;
        final document = xml.XmlDocument.parse(xmlString);///XmlDocument.parse(xmlString);
        final x = document.findAllElements('stations');
        /*x.map((e) {
          print(e.findAllElements("coordinate").first.text);
        },);*/
        print(x);

        for (var stationElement in x) {
          final id = stationElement.findElements('id');
          final coordinates = stationElement.findAllElements('coordinate');
          
          for (var coordinate in coordinates) {
            final lat = coordinate.findElements('lat').first.text;
            final long = coordinate.findElements('y').first.text;
            print('x: $lat');
            print('y: $long');
          }
          //print('coordinates: $coordinates');
          
          
          final int capacity = int.parse(stationElement.findElements('capacity').first.text);
          final totalGets = int.parse(stationElement.findElements('totalGets').first.text);
          final totalReturns = int.parse(stationElement.findElements('totalReturns').first.text);
          final availableBikeShared = int.parse(stationElement.findElements('availableBikeShared').first.text);
          final freeDocks = int.parse(stationElement.findElements('freeDocks').first.text);

          print('ID: $id');
          print('Capacity: $capacity');
          print('Total Gets: $totalGets');
          print('Total Returns: $totalReturns');
          print('Available Bike Shared: $availableBikeShared');
          print('Free Docks: $freeDocks');
          print('-----------------------');

          StationRepository.list.add(
            Station(
              name: "Station", 
              address: "Camama",
              lat: lat, 
              long: long,
              capacity: capacity, 
              freeDocks: freeDocks, 
              totalGets: totalGets, 
              totalReturns: totalReturns
            )
          );
        }

        //print(StationRepository.list);

        return true;
      }else if(response.statusCode == 503){
        print('Servidor indisponível');
        print(response.body);
        return false;
      }else if(response.statusCode == 500){
        print('Falha na requisição');
        print(response.body);
        return false;
      }else{
        print('Erro na autenticação');
        print(response.body);
        return false;
      }
    } catch (e) {
      //print('Tempo de execução demorada!');
      //print(e);
      print(e.toString());
      return false;
      //rethrow;
    }
  }

  
}