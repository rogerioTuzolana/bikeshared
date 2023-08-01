
import 'package:bikeshared/controllers/UserController.dart';
import 'package:bikeshared/views/components/auth_input.dart';
import 'package:bikeshared/views/components/auth_input_email.dart';
import 'package:bikeshared/views/components/auth_input_password.dart';
//import 'package:bikeshared/views/screens/screen_home.dart';
import 'package:bikeshared/views/screens/screen_login.dart';
import 'package:bikeshared/views/screens/screen_preloading.dart';
import 'package:flutter/material.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 0, 59, 114),
        textTheme: Theme.of(context).textTheme.apply(bodyColor: const Color.fromARGB(255, 0, 0, 0)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 14, 27),

        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: size.width*0.3,
              child: Image.asset('images/kit/borda3.png')
            ),
            Positioned(
              top: size.height*0.15,
              right: size.width*0,
              child: Image.asset('images/kit/borda2.png',height: 100,)
            ),
            Positioned(
              top: size.height*0.7,
              left: size.width*0,
              child: Image.asset('images/kit/borda.png',height: 140,)
            ),
            Positioned(
              top: size.height*0.75,
              right: size.width*0.65,
              child: Image.asset('images/kit/bolinha.png',height: 140,)
            ),
            Positioned(
              top: size.height*0.001,
              right: size.width*0.46,
              child: Image.asset('images/kit/bolinha.png',height: 140,)
            ),
            Positioned(
              top: size.height*0.1,
              left: size.width*0.7,
              child: Image.asset('images/kit/bolinha.png',height: 140,)
            ),

            /*Container(
                margin: EdgeInsets.only(top: size.height*0.085),
                height: 130,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/kit/LOGO_BAIKAPAY.png'),
                    //fit:BoxFit.cover,
                  )
                ),
                
            ),*/

            SingleChildScrollView(
              padding: EdgeInsets.only(top: size.height*0.2,right: 35, left: 35),
              child:Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      //margin: EdgeInsets.only(top: size.height*0.25),
                      width: size.width,
                      child: const Text(
                        "Bike Shared",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.white,),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: size.height * 0.05,),

                    AuthInput(
                      id: _name,
                      hintText: 'Nome',
                      obscureText: false,
                      message: 'Informe o seu nome',
                      icon: const Icon(Icons.person),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AuthInputEmail(
                      id: _email,
                      hintText: 'Email',
                      obscureText: false,
                      message: 'Informe o seu email',
                      icon: const Icon(Icons.email)
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
                      width: size.width*0.4,
                    child:
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 14, 117, 117),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoading? const SizedBox(width: 30, height: 30, child: CircularProgressIndicator(color: Colors.white,strokeWidth: 3.0,)):const Text('Cadastrar',style: TextStyle(fontSize: 20,color: Colors.white),),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          print(_email.text);
                          print(_name.text);
                          print(_password.text);
                          
                          if (_formkey.currentState!.validate()) {
                            int status = await UserController.activeUser(_email.text);
                            if(status == 0){

                              Navigator.push/*Replacement*/(
                                context, 
                                MaterialPageRoute(
                                builder: (context) => const ScreenPreloading(),/*ScreenHome()*/
                              ));
                            }else if (status == 1) {
                              //_password.clear();
                              showModal('Este email já existe!', size);
                            }else {
                              showModal('Falha na autenticação! Verifique os dados', size);
                            }
                            
                            Future.delayed(const Duration(seconds: 1),() {
                              setState(() {
                                isLoading = false;
                              });
                            });
                            //final user = UserRepository.tabela;
                            /*limpa SharedPreferencesManager.init();
                            SharedPreferences sharedPreference = SharedPreferencesManager.sharedPreferences;
                            
                            users.forEach((user) { 
                              if (user.email == _id.text && user.password == _password.text) {
                                authStatus = true;
                                userExist = user;
                                print("Temmmmmmmmmmm");
                                return;
                              }
                            });

                            if(authStatus==true){

                              await sharedPreference.setString('token', "${userExist.id}");
                              await sharedPreference.setString('name', userExist.name);
                              await sharedPreference.setString('email', userExist.email);
                              await sharedPreference.setInt('point', 10);
                              print("yas");

                              Navigator.pushReplacement(
                                context, 
                                MaterialPageRoute(
                                builder: (context) => const ScreenHome(),
                              ));
                            }fimlimpa*/
                            
                            
                          }
                          Future.delayed(const Duration(seconds: 1),() {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        },
                      
                    ),),
                  ]
                ),
              ),

            ),

            link(size),
          ],
        )
      ),
      //color: Colors.red,
    );
  }

  showModal(message, size){
    return showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      context: context, 
      builder: (context)=>SizedBox(
        height: size.height * 0.1,
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
  
  Widget link(size) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: size.height*0.8,right: 35, left: 35),
      child: Column(
        
        children: [
          const SizedBox(
              height: 55,
          ),
          InkWell(     
            child: 
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Já tem uma conta? ", 
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 35, 170, 185),
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