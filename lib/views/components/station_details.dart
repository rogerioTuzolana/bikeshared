import 'package:bikeshared/models/station.dart';
import 'package:flutter/material.dart';

class StationDetails extends StatelessWidget {
  Station station;
  StationDetails({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  '3 Bicicletas / 10 Docas',
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
              children: const [
                Text(
                  "Solicitar", 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
            onPressed: () async{
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
}