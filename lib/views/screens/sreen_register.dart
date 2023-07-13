import 'dart:convert';

import 'package:bikeshared/views/components/auth_input.dart';
import 'package:bikeshared/views/components/auth_input_password.dart';
import 'package:bikeshared/views/components/auth_link_footer.dart';
import 'package:bikeshared/views/screens/screen_home.dart';
import 'package:bikeshared/views/screens/screen_login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final _id = TextEditingController();
  final _password = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 0, 59, 114),
        textTheme: Theme.of(context).textTheme.apply(bodyColor: const Color.fromARGB(255, 0, 0, 0)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 14, 27),

        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: MediaQuery.of(context).size.width*0.3,
              child: Image.asset('images/kit/borda3.png')
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.15,
              right: MediaQuery.of(context).size.width*0,
              child: Image.asset('images/kit/borda2.png',height: 100,)
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.7,
              left: MediaQuery.of(context).size.width*0,
              child: Image.asset('images/kit/borda.png',height: 140,)
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.75,
              right: MediaQuery.of(context).size.width*0.65,
              child: Image.asset('images/kit/bolinha.png',height: 140,)
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.001,
              right: MediaQuery.of(context).size.width*0.46,
              child: Image.asset('images/kit/bolinha.png',height: 140,)
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.1,
              left: MediaQuery.of(context).size.width*0.7,
              child: Image.asset('images/kit/bolinha.png',height: 140,)
            ),

            /*Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.085),
                height: 130,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/kit/LOGO_BAIKAPAY.png'),
                    //fit:BoxFit.cover,
                  )
                ),
                
            ),*/
            
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.25),
              width: MediaQuery.of(context).size.width,
              child: const Text(
                "Bike Shared",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.white,),
                textAlign: TextAlign.center,
              ),
            ),


            SingleChildScrollView(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.4,right: 35, left: 35),
              child:Form(
                key: _formkey,
                child: Column(
                  children: [
                    AuthInput(
                      id: _id,
                      hintText: 'Nome',
                      obscureText: false,
                      message: 'Informe o seu nome',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AuthInput(
                      id: _id,
                      hintText: 'Email',
                      obscureText: false,
                      message: 'Informe o seu email',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AuthInputPassword(
                      id: _password,
                      hintText: 'Senha',
                      obscureText: true,
                      message: const [
                        'Informe a sua senha',
                        'Por favor, digite uma senha maior que 6 caracteres',
                      ],
                    ),
                
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.4,
                    child:
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: /*const Color(0xfffccb1b),*/Color.fromARGB(255, 14, 117, 117),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoading?const CircularProgressIndicator(color: Colors.white,strokeWidth: 5.0,):const Text('Cadastrar',style: TextStyle(fontSize: 20,color: Colors.white),),
                        onPressed: () /*async*/{
                          
                          /*Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(
                            builder: (context) => const /*AccountLayout()*/ScreenHome(),
                          ));
                          setState(() {
                            isLoading = true;
                          });

                          FocusScopeNode keyboardCurrentFocus = FocusScope.of(context);
                          if (_formkey.currentState!.validate()) {
                            /*tirar comentario
                            var success = await UserService.login(_id.text, _password.text);*/
                            var success = false;
                            //Fechar o teclado do login
                            if (keyboardCurrentFocus.hasPrimaryFocus) {
                              keyboardCurrentFocus.unfocus();
                            } 
                            
                            if (success) {
                              Navigator.pushReplacement(
                                context, 
                                MaterialPageRoute(
                                builder: (context) => const AccountLayout(), //HomeUser()//Splash(),
                              ));
                            }else{
                              
                              _password.clear();
                              showModalBottomSheet(context: context, builder: (context)=>showMessageAuthError(context: context));
                              
                              /*ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('ID ou Senha inválida!', textAlign: TextAlign.center),
                                  backgroundColor: Colors.redAccent,
                                )
                                
                              );*/
                            }

                            Future.delayed(const Duration(seconds: 1),() {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          }
                          */
                        },
                      
                    ),),
                  ]
                ),
              ),

            ),

            link(),
          ],
        )
      ),
      //color: Colors.red,
    );
  }

  Widget link() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.8,right: 35, left: 35),
      child: Column(
        
        children: [
          const SizedBox(
              height: 55,
          ),
          InkWell(     
            child: 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Já tem uma conta? ", 
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w500,
                    color: Color(0xff002327),
                  ),
                ),
                Text(
                  "Entrar", 
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
                  builder: (context) => const ScreenLogin(),//Splash(),
              ));
            },
          ),

        ],
      ),
    );
  }
}