import 'package:bikeshared/controllers/StationController.dart';
import 'package:bikeshared/views/screens/screen_home.dart';
import 'package:flutter/material.dart';

class ScreenPreloading extends StatefulWidget {
  const ScreenPreloading({super.key});

  @override
  State<ScreenPreloading> createState() => _ScreenPreloadingState();
}

class _ScreenPreloadingState extends State<ScreenPreloading> {
  late Future<bool>listStations;
  late Future<void>getLocation;

  @override
  void initState() {
    
    super.initState();
    getLocation = StationController.getLocation();
    listStations = StationController.listStations();
  }
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 0, 59, 114),
        textTheme: Theme.of(context).textTheme.apply(bodyColor: const Color.fromARGB(255, 0, 0, 0)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 14, 27),

        body: FutureBuilder<dynamic>(
          future: Future.wait([getLocation, listStations]),
          builder: ((context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return const ScreenHome();
            }
//return ScreenHome();
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Image(image: AssetImage('images/bike2.png')),
                ),
                SizedBox(height: 30,),                    
                /*SizedBox(
                  width: size.width,
                  //height: size.height,
                  child: const Center(child: CircularProgressIndicator())
                ),*/
                
            ]);
          }),
        ),
      ),
      //color: Colors.red,
    );
  }
}
