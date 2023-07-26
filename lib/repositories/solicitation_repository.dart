
//import 'package:flutter/widgets.dart';

import 'package:bikeshared/models/solicitation.dart';

class SolicitationRepository /*extends ChangeNotifier*/{
  //static final List<Solicitation> list = [];
    static final List<Solicitation> list = [
    Solicitation(
      id: 1,
      station: 'Departamento da Computação',
      address: 'Camama 1',
      lat: -8.8662708,
      long: 13.284566,
    ),
    Solicitation(
      id: 2,
      station: 'Departamento de Física',
      address: 'Camama 1',
      lat: -8.8662710,
      long: 13.284544,
    ),
    Solicitation(
      id: 3,
      station: 'Departamento de Química',
      address: 'Camama 1',
      lat: -8.8662708,
      long: 13.284556,
    ) 
  ];
}