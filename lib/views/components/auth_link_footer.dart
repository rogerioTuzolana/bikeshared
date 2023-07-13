import 'package:bikeshared/views/screens/sreen_register.dart';
import 'package:bikeshared/views/splash.dart';
import 'package:flutter/material.dart';

class AuthLinkFooter extends StatelessWidget {
  const AuthLinkFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.8,right: 35, left: 35),
      child: Column(
        
        children: [
          const SizedBox(
              height: 25,
          ),
          InkWell(     
            child: 
            const Text(
              "Esqueceu a senha?", 
              style: TextStyle(
                fontSize: 16, 
                //fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 35, 170, 185),
                decoration: TextDecoration.underline
              ),
            ),
            onTap: () async{

              //Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const /*Register()*/Splash(),
              ));
            },
          ),
          const SizedBox(
              height: 15,
          ),
          InkWell(     
            child: 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Não tem conta? ", 
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 35, 170, 185),
                  ),
                ),
                Text(
                  "Criar", 
                  style: TextStyle(
                    fontSize: 16, 
                    //fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                    decoration: TextDecoration.underline
                  ),
                ),
              ],
            ),
            onTap: () async{

              //Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const ScreenRegister(),//Splash(),
              ));
            },
          ),

        ],
      ),
    );
  }
}