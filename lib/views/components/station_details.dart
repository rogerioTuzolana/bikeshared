import 'package:bikeshared/controllers/StationController.dart';
import 'package:bikeshared/models/station.dart';
import 'package:bikeshared/services/shared_preferences_manager.dart';
import 'package:flutter/material.dart';

class StationDetails extends StatelessWidget {
  Station station;
  StationDetails({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool? hasBikeShared = SharedPreferencesManager.sharedPreferences.getBool("hasBikeShared");
    return Container(
      width: double.infinity,
      height: size.height * 0.40,
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
                color: Color.fromARGB(221, 78, 78, 78)
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

          const SizedBox(height: 3,),         
          SizedBox(
            width: size.width,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Text(
                  '${station.availableBikeShared} Bicicletas / ${station.capacity} Docas',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                )
              ],
            ) 
          ),
          const SizedBox(height: 25,),
          
          ElevatedButton(
            style: ButtonStyle(                  
              padding: MaterialStateProperty.all(EdgeInsets.only(left:30, right: 30, top: 5, bottom: 5)),
              backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 0, 0, 0)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  
              children: [
                hasBikeShared == false?
                Text(
                  "Solicitar", 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ):
                Text(
                  "Devolver", 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
            onPressed: () async{
              String? email = SharedPreferencesManager.sharedPreferences.getString("email");
              
              if(hasBikeShared == false){
                bool? status = await StationController.solicitation(station.stationId, email);

                if(status){
                  showModal('Bina alugada com sucesso!', context);
                }else{
                  showModal('Erro! Algo de errado aconteceu', context);
                }
              }else{

              }
              
              /*SharedPreferences sharedPreference = await SharedPreferences.getInstance();
              await sharedPreference.clear();
              Navigator.of(context).pop();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => const ScreenLogin(),
              ));*/
            },

          ),

        ],
      ),
    );

    
  }

  showModal(message, context){
    return showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      context: context, 
      builder: (context)=>SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Center(child: Text(message)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      anchorPoint: const Offset(4, 5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30)
        ),
      ),
    );
  }
  
}