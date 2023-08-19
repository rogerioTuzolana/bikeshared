import 'package:bikeshared/controllers/StationController.dart';
import 'package:bikeshared/services/shared_preferences_manager.dart';
import 'package:flutter/material.dart';


class ScreenProfile extends StatefulWidget {

  const ScreenProfile({super.key});

  @override
  State<ScreenProfile> createState() => _ScreenProfileState();
}

class _ScreenProfileState extends State<ScreenProfile> {
  final String? name = SharedPreferencesManager.sharedPreferences.getString("name");

  final String? email = SharedPreferencesManager.sharedPreferences.getString("email");

  late int? balance = SharedPreferencesManager.sharedPreferences.getInt("credit");

  final bool? hasBikeShared = SharedPreferencesManager.sharedPreferences.getBool("hasBikeShared");
  late Future <bool> credit;
  @override
  void initState(){
    super.initState();
     //SharedPreferencesManager.sharedPreferences.setBool('hasBikeShared',true);
    credit = StationController.getCredit(email);
    //StationController.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(hasBikeShared);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 14, 27),
        title: const Text("Perfil do Utilizador"),
      ),
      body: FutureBuilder<bool>(
        future: credit,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            balance = SharedPreferencesManager.sharedPreferences.getInt("credit");
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nome:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    name!,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Email:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email!,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Saldo:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "$balance Pontos",
                    style: const TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Bina alugada:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),

                  
                  (StationController.globalHasBikeShared==false)?
                  const Text(
                    "Nenhuma",
                    style: TextStyle(fontSize: 18),
                  ):
                  const Text(
                    "Sim",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            );
          }
          return SizedBox(
            width: size.width,
            height: size.height,
            child: const Center(child: CircularProgressIndicator())
          );
        }),
      )
    );
  }
}
