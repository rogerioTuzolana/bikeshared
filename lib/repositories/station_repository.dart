
import 'package:bikeshared/models/station.dart';
//import 'package:flutter/widgets.dart';

class StationRepository /*extends ChangeNotifier*/{
    static late List<Station> list = [];
    
    static final List<Station> list1 = [
    Station(
      stationId: "D01_Station2",
      name: 'Escola Nacional de Policia',//'Departamento da Computação',
      address: 'Camama 1',
      lat: -8.8905235,
      long: 13.2274002,
      capacity: 10,
      freeDocks: 3,
      totalGets: 0,
      totalReturns: 0,
      availableBikeShared: 0,
    ),
    Station(
      stationId: "D01_Station2",
      name: 'Espaço Lazer Nandex',//'Departamento de Física',
      address: 'Camama 1',
      lat: -8.8649484,
      long: 13.2939577,
      capacity: 10,
      freeDocks: 3,
      totalGets: 0,
      totalReturns: 0,
      availableBikeShared: 0,
    ),
    Station(
      stationId: "D01_Station2",
      name: 'New CVS',//'Departamento de Química',
      address: 'Camama 1',
      lat: -8.7663581,
      long: 13.2482776,
      capacity: 10,
      freeDocks: 3,
      totalGets: 0,
      totalReturns: 0,
      availableBikeShared: 0,
    ) 
  ];
}