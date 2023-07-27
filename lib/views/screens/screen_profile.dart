import 'package:bikeshared/controllers/StationController.dart';
import 'package:bikeshared/services/shared_preferences_manager.dart';
import 'package:flutter/material.dart';


class ScreenProfile extends StatelessWidget {
  final String? name = SharedPreferencesManager.sharedPreferences.getString("name");
  final String? email = SharedPreferencesManager.sharedPreferences.getString("email");
  final int? saldo = SharedPreferencesManager.sharedPreferences.getInt("credit");
  final bool? hasBikeShared = SharedPreferencesManager.sharedPreferences.getBool("hasBikeShared");

  @override
  void initState(){
    
    StationController.getCredit(email);

    //StationController.getLocation();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 14, 27),
        title: Text("Perfil do Utilizador"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nome:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              name!,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              "Email:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              email!,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              "Saldo:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              "$saldo Pontos",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 20),
            Text(
              "Bina alugada:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),

            
            (hasBikeShared==false)?
            Text(
              "Nenhuma",
              style: TextStyle(fontSize: 18),
            ):
            Text(
              "Sim",
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
