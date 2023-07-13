
import 'dart:convert';

import 'package:bikeshared/models/solicitation.dart';
import 'package:bikeshared/models/station.dart';
import 'package:bikeshared/repositories/solicitation_repository.dart';
import 'package:bikeshared/repositories/station_repository.dart';
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
    final solicitations = StationRepository.list;
    
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
                      
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        //scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int nSolicitation){
                          Solicitation solicitation = snapshot.data![nSolicitation];
                          return ListTile(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            //leading: Icon(Icons.arrow_downward),
                            selected: (solicitation.id==1),
                            selectedTileColor:Colors.blueAccent,               
                            title: Text(solicitation.station,style: const TextStyle(color: Colors.black54),),
                            trailing: Icon(
                                color: (solicitation.id==1)?Colors.blueAccent:Colors.green,
                                  (solicitation.id==1)?Icons.timelapse:Icons.assignment_turned_in_rounded
                            ),
                            onTap: (() {
                              showModalBottomSheet(
                                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                                context: context, builder: (context)=>modalInfo(context, solicitation),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                anchorPoint: Offset(4, 5),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30)
                                  ),
                                ),
                              );
                            }),
                            onLongPress: () {
                              print("press");
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
            child: Text(
              "Estação de Saida:",
              style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 0, 0, 0)),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 10,),

          SizedBox(
            width: size.width,
            child: Text(
              solicitation.address,
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
          if(solicitation.id == 1)
          ElevatedButton(
            style: ButtonStyle(                  
              padding: MaterialStateProperty.all(EdgeInsets.only(left:30, right: 30, top: 5, bottom: 5)),
              backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 248, 36, 36)),
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
                  "Cancelar", 
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

          if(solicitation.id != 1)
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
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width,
                child: Text(
                  solicitation.address,
                  style: TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(221, 139, 139, 139)
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
                      "Departamento da Computação",
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.left,
                    )
                  ],
                ) 
              ),
            ],
          ),
          if(solicitation.id != 1)
            const SizedBox(height: 20,),
          if(solicitation.id != 1)
            SizedBox(
              width: size.width,
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
                  LatLng sourceLocation = LatLng(-8.8649484, 13.2939577);
                  LatLng destination = LatLng(-8.7663581, 13.2482776);
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

}