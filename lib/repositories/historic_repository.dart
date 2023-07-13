import 'package:bikeshared/models/historic.dart';
class HistoricRepository{
  static List<Historic> tabela = [
    Historic(
      code: '1',
      description: 'Pagamento',
      type: 'Pagamento',
      value: 150.00,
    ),
    Historic(
      code: '2',
      description: 'Carregamento',
      type: 'Carregamento',
      value: 10600.00
    ),
    Historic(
      code: '3',
      description: 'Kamba Paga',
      type: 'Pagamento',
      value: 600.00
    ) 
  ];
}