import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 14, 27),
      body: SizedBox(
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            //SizedBox(height: size.height*0.2,),
            /*Container(
                height: size.height *0.6,
                width: size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/bike2.png'),
                    //fit:BoxFit.cover,
                  )
                ),
            ),*/
            /*Center(
              child: Text('Bike Shared',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Color.fromARGB(255, 255, 255, 255),),),
            ),*/
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Image(image: AssetImage('images/bike2.png')),
            ),
            
            Text('BikeShared',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Color.fromARGB(255, 255, 255, 255),),),
            SizedBox(height: 10,),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color.fromARGB(255, 255, 255, 255)),
              strokeWidth: 8.0,
            )
          ],
        ),
      ),
    );
  }
}