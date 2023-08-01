
//import 'package:flutter/widgets.dart';

import 'package:bikeshared/models/solicitation.dart';

class SolicitationRepository /*extends ChangeNotifier*/{
    static final List<Solicitation> list = [];
    static final List<Solicitation> list1 = [
    Solicitation(
      id: 1,
      station: 'D01_station',
      address: 'Camama 1',
      lat: -8.8662708,
      long: 13.284566,
      hasBikeShared: false,
      stationReturn: ""
    ),
    Solicitation(
      id: 2,
      station: 'D02_station',
      address: 'Camama 1',
      lat: -8.8662710,
      long: 13.284544,
      hasBikeShared: false,
      stationReturn: ""
    ),
    Solicitation(
      id: 3,
      station: 'D01_station',
      address: 'Camama 1',
      lat: -8.8662708,
      long: 13.284556,
      hasBikeShared: false,
      stationReturn: ""
    ) 
  ];
}