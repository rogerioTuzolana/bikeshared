import 'package:bikeshared/models/user.dart';


class UserRepository{
  
  static List<User> tabela = [
    User(
      id: 1,
      name: 'Elizabeth Mateus',
      email: 'elizabeth@gmail.com',
      password: '12345678',
    ),
    User(
      id: 2,
      name: 'Edson Xauvunge',
      email: 'edson@gmail.com',
      password: '12345678',
    ),
    User(
      id: 3,
      name: 'Rogério Tuzolana',
      email: 'rogerio@gmail.com',
      password: '12345678',
    ),
    User(
      id: 4,
      name: 'Yuri Rego',
      email: 'yuri@gmail.com',
      password: '12345678',
    ),
  ];
}