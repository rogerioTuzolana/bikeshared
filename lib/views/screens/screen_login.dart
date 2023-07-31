
import 'package:bikeshared/models/user.dart';
import 'package:bikeshared/repositories/user_repository.dart';
import 'package:bikeshared/services/shared_preferences_manager.dart';
import 'package:bikeshared/views/components/auth_input_password.dart';
import 'package:bikeshared/views/components/auth_link_footer.dart';
import 'package:bikeshared/views/screens/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _id = TextEditingController();
  final _password = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;
  late User userExist;
  bool authStatus = false;

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


            SingleChildScrollView(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.25,right: 35, left: 35),
              child:Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Text(
                        "Bike Shared",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.white,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30,),                    
                    
                    TextFormField(
                      controller: _id,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Email',
                        suffixIcon: const Icon(Icons.email,),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                        contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color.fromARGB(255, 19, 110, 122)),
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                      maxLines: 1,
                      validator: (valor){
                        if (valor!.isEmpty) {
                          return 'Informe o seu email';
                        }
                        return null;
                      }
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
                          backgroundColor: const Color.fromARGB(255, 14, 117, 117),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoading? const SizedBox(width: 30, height: 30, child: CircularProgressIndicator(color: Colors.white,strokeWidth: 5.0,)):const Text('Entrar',style: TextStyle(fontSize: 20,color: Colors.white),),
                        onPressed: () async{
                          setState(() {
                            isLoading = true;
                          });
                          
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(
                            builder: (context) => const ScreenHome(),
                          ));
                          final users = UserRepository.tabela;
                          //print(users[0].email);
                          if (_formkey.currentState!.validate()) {
                            /*UserController.activeUser(_id.text);
                            //activeUser
                            
                            Navigator.pushReplacement(
                              context, 
                              MaterialPageRoute(
                              builder: (context) => const ScreenHome(),
                            ));*/
                            
                            SharedPreferencesManager.init();
                            SharedPreferences sharedPreference = SharedPreferencesManager.sharedPreferences;
                            
                            for (var user in users) { 
                              if (user.email == _id.text && user.password == _password.text) {
                                authStatus = true;
                                userExist = user;
                                //print("Temmmmmmmmmmm");
                                continue;
                              }
                            }

                            if(authStatus==true){

                              await sharedPreference.setString('token', "${userExist.id}");
                              await sharedPreference.setString('name', userExist.name);
                              await sharedPreference.setString('email', userExist.email);
                              await sharedPreference.setInt('credit', 10);
                              await sharedPreference.setBool('hasBikeShared', false);

                              Navigator.pushReplacement(
                                context, 
                                MaterialPageRoute(
                                builder: (context) => const ScreenHome(),
                              ));
                            }
                            
                            
                          }

                          Future.delayed(const Duration(seconds: 1),() {
                            setState(() {
                              isLoading = false;
                            });
                          });
                          /*Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(
                            builder: (context) => const /*AccountLayout()*/ScreenHome(),
                          ));
                          

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

                            
                          }
                          */
                        },
                      
                    ),),
                  ]
                ),
              ),

            ),

            const AuthLinkFooter(),
          ],
        )
      ),
      //color: Colors.red,
    );
  }
}
