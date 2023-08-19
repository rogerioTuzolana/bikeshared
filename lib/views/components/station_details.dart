import 'package:bikeshared/controllers/StationController.dart';
import 'package:bikeshared/models/station.dart';
import 'package:bikeshared/services/shared_preferences_manager.dart';
import 'package:flutter/material.dart';

class StationDetails extends StatefulWidget {
  final Station station;
  const StationDetails({super.key, required this.station});

  @override
  State<StationDetails> createState() => _StationDetailsState();
}

class _StationDetailsState extends State<StationDetails> {
  bool isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //bool? hasBikeShared = SharedPreferencesManager.sharedPreferences.getBool("hasBikeShared");
    //String? stationSelected = SharedPreferencesManager.sharedPreferences.getString("stationSelected");
    
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
              widget.station.stationId,
              style: const TextStyle(
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
                const Icon(
                  Icons.location_pin,
                  color: Color.fromARGB(255, 192, 14, 1),
                ),
                Text(
                  widget.station.address,
                  style: const TextStyle(fontSize: 15),
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
                  '${widget.station.availableBikeShared} Bicicletas / ${widget.station.capacity} Docas',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                )
              ],
            ) 
          ),
          const SizedBox(height: 25,),
          
          ElevatedButton(
            style: ButtonStyle(                  
              padding: MaterialStateProperty.all(const EdgeInsets.only(left:30, right: 30, top: 5, bottom: 5)),
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 0, 0, 0)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            child: isLoading?const CircularProgressIndicator(color: Colors.white,strokeWidth: 3.0,):
            Column(
              mainAxisAlignment: MainAxisAlignment.center,  
              children: [
                StationController.globalHasBikeShared == true /*&& stationSelected == widget.station.stationId*/?
                const Text(
                  "Devolver", 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ):
                 const Text(
                  "Solicitar", 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
            onPressed: () async{
              setState(() {
                isLoading = true;
              });
              String? email = SharedPreferencesManager.sharedPreferences.getString("email");
              
              if(StationController.globalHasBikeShared == false){
                int status = await StationController.solicitation(widget.station.stationId, email);

                if(status == 200){
                  await StationController.listStations();
                  setState(() {
                    widget.station.availableBikeShared--;
                  });
                  showModal('Bina alugada com sucesso!', context);

                }else if (status == 0) {
                  showModal('O utilizador não existe', context);
                }else if (status == 1) {
                  showModal('O seu crédito é insuficiente', context);
                }else if(status == 2){
                  showModal('Utilizador já possui bina', context);
                }else if(status == 3){
                  showModal('Estação não encontrada', context);
                }else if(status == 500){
                  await StationController.listStations();
                  setState(() {
                      widget.station.availableBikeShared--;
                    });
                  showModal('Bina alugada com sucesso!', context);
                }

              }else{
                  bool? status = await StationController.returnedBike(widget.station.stationId, email);
                  if(status == true){
                    setState(() {
                      widget.station.availableBikeShared++;
                    });
                    showModal('Bina devolvida com sucesso!', context);
                  }else if (status == false) {
                    showModal('Bina nao devolvida', context);
                  }
              }
              Future.delayed(const Duration(seconds: 1),() {
                setState(() {
                  isLoading = false;
                });
              });              
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