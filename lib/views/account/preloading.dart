import 'package:flutter/material.dart';


class PreLoading extends StatefulWidget {
  const PreLoading({super.key});

  @override
  State<PreLoading> createState() => _PreLoadingState();
}

class _PreLoadingState extends State<PreLoading> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 145, 177, 145),
      body:Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.3,),
            Container(
                margin: const EdgeInsets.only(top: 50),
                height: 70,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/BAIKAPAY.png'),
                    //fit:BoxFit.cover,
                  )
                ),
            ),
            const Text('',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold, 
            ),),
            const SizedBox(height: 5,),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color.fromARGB(255, 255, 255, 255)),
              strokeWidth: 8.0,
            )
          ],
        ),
      ),
    );
  }
}



/*body: /*conainer*/FutureBuilder(
        future: getUser(),
        builder: ((context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
                print(":::");
                Map<String, dynamic> userMap = snapshot.data;
                //User user = User.fromJson(snapshot.data);
                print(userMap);
                print("----");
                User user = 
                (userMap!=Null)?
                User.fromJson(userMap):
                User.fromJson({"nome":"--","telefone": "--"});
                
                //print(snapshot.data);
                return Text('${user.name}', style: TextStyle(color: Colors.white, fontSize: 20),);
              }
              return CircularProgressIndicator();
          
            }
      )),*/