
import 'package:bikeshared/models/solicitation.dart';
import 'package:bikeshared/models/station.dart';
import 'package:bikeshared/repositories/solicitation_repository.dart';
import 'package:bikeshared/repositories/station_repository.dart';
import 'package:bikeshared/services/shared_preferences_manager.dart';
import 'package:bikeshared/views/screens/screen_home.dart';
import 'package:bikeshared/views/screens/screen_trajectory.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;

class ScreenSolicitations extends StatefulWidget {
  const ScreenSolicitations({super.key});

  @override
  State<ScreenSolicitations> createState() => _ScreenSolicitationsState();
}

class _ScreenSolicitationsState extends State<ScreenSolicitations> {
  late Future <List<Solicitation>> listSolicitations;
  @override
  void initState() {

    super.initState();
    listSolicitations = getSolicitations();
  }
  @override
  Widget build(BuildContext context) {
    //final solicitations = StationRepository.list;
    
    return 
    Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(),
      body: buildBody(/*stations*/),
    );
  }

  AppBar buildAppBar(){
    return AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const ScreenHome(), //HomeUser()//Splash(),
            ));
          },
        ),
        backgroundColor: const Color.fromARGB(255, 0, 14, 27),
        title: const Text('Minhas Solicitações'),
        //centerTitle: true,
      );
  }


  buildBody(/*List<Station> stations*/){
    Size size = MediaQuery.of(context).size;
    final station =SharedPreferencesManager.sharedPreferences.getString('stationSelected');
    return 
        Stack(children: [
          
          Container(
            color: Colors.white,//const Color(0xff89d5b1),
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
              child: Column(children: [
                /*SizedBox(height: size.height*0.04,),
                SizedBox(
                  width: size.width,    
                  child:
                      const Text(
                        'Estações',style: 
                        TextStyle(fontSize: 21,color: Color.fromARGB(255, 54, 122, 66)),
                        textAlign: TextAlign.center,
                  ),
                ),*/
                
                /*SizedBox(height: size.height*0.04,),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text("  14-12-2022",style: TextStyle(fontSize: 13),),
                ),*/
                FutureBuilder<List<Solicitation>>(
                  future: listSolicitations,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      List<Solicitation> list = SolicitationRepository.list;
                      int index = 0;
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        //scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int nSolicitation){
                          Solicitation solicitation = snapshot.data![nSolicitation];
                          index++;
                          print(index);
                          return ListTile(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            //leading: Icon(Icons.arrow_downward),
                            selected: (solicitation.id==1),
                            selectedTileColor:Colors.blueAccent,               
                            title: Text(solicitation.station,style: const TextStyle(color: Colors.black54),),
                            trailing: Icon(
                              color: (solicitation.hasBikeShared==true && solicitation.station==station)?Colors.blueAccent:Colors.green,
                                  (solicitation.hasBikeShared==true && solicitation.station==station && list.length == index/* && */)?Icons.timelapse:Icons.assignment_turned_in_rounded
                            ),
                            onTap: (() {
                              showModalBottomSheet(
                                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                context: context, builder: (context)=>modalInfo(context, solicitation),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                anchorPoint: const Offset(4, 5),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30)
                                  ),
                                ),
                              );
                            }),
                            onLongPress: () {
                              //print("press");
                            },
                          );
                        },
                        padding: const EdgeInsets.all(16),
                        separatorBuilder: (_,__)=>const Divider(),
                      );
                    }else if(snapshot.hasError){
                      return Text(snapshot.error.toString());
                    }
                    return const Center(child: CircularProgressIndicator());
                  })
                )
                
              ],)
            ,),
          ),
        ]);
  }

  Widget modalInfo(BuildContext context, Solicitation solicitation){
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: (solicitation.id != 1)?size.height * 0.50:size.height * 0.40,
      margin: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 10,
      ),
      child: Column(
        children: [
          
          const Text('Solicitação', style: TextStyle(color: Color.fromARGB(255, 19, 19, 19), fontWeight: FontWeight.bold, fontSize: 20),),
          const SizedBox(height: 20,),
          SizedBox(
            width: size.width,
            child: const Text(
              "Estação de Saida:",
              style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 0, 0, 0)),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 10,),

          SizedBox(
            width: size.width,
            child: Text(
              solicitation.station,
              style: const TextStyle(
                fontSize: 17,
                color: Color.fromARGB(221, 163, 163, 163)
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
                  solicitation.station,
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                )
              ],
            ) 
          ),
          const SizedBox(height: 25,),
          /*if(solicitation.hasBikeShared == true)
          ElevatedButton(
            style: ButtonStyle(                  
              padding: MaterialStateProperty.all(const EdgeInsets.only(left:30, right: 30, top: 5, bottom: 5)),
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 248, 36, 36)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,  
              children: [
                Text(
                  "Devolver", 
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
              final String? email = SharedPreferencesManager.sharedPreferences.getString("email");
              bool? status = await StationController.returnedBike(solicitation.station, email);
              if(status == 200){
                showModal('Bina devolvida com sucesso!', context);
              }else if (status == 0) {
                showModal('Bina nao devolvida', context);
              }
            },

          ),*/

          if(solicitation.stationReturn != "")
          Column(
            children: [
              SizedBox(
                width: size.width,
                child: const Text(
                  "Estação de entrega:",
                  style: TextStyle(fontSize: 15, color: Color.fromARGB(221, 0, 0, 0)),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width,
                child: Text(
                  solicitation.stationReturn,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(221, 139, 139, 139)
                  ),
                  textAlign: TextAlign.left,
                )
              ),
              const SizedBox(height: 3,),         
              SizedBox(
                width: size.width,
                child: const Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Color.fromARGB(255, 192, 14, 1),
                    ),
                    Text(
                      "Departamento da Computação",
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.left,
                    )
                  ],
                ) 
              ),
            ],
          ),
          
            const SizedBox(height: 20,),
          if(solicitation.stationReturn != "")
            SizedBox(
              width: size.width,
              child: InkWell(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_sharp,
                      //color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    Text(
                      "Ver trajectória no mapa",
                      style: TextStyle(fontSize: 15, color:Color.fromARGB(255, 2, 106, 138),),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
                onTap: (){
                  
                  Station stationInit = StationRepository.list.where((station) =>
                    station.stationId.contains(solicitation.station)).first;

                  Station stationFinal = StationRepository.list.where((station) =>
                    station.stationId.contains(solicitation.stationReturn)).first;

                  LatLng sourceLocation = LatLng(stationInit.lat, stationInit.long);
                  LatLng destination = LatLng(stationFinal.lat, stationFinal.long);
                  
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ScreenTrajectory(sourceLocation: sourceLocation, destination: destination,),
                  ));
                },
              ) 
            ),
        ],
      ),
    );
  }

  Future<List<Solicitation>> getSolicitations() async{
    return SolicitationRepository.list;
    //SharedPreferences sharedPreference = await SharedPreferences.getInstance();

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