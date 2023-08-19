
import 'package:bikeshared/env.dart';
import 'package:bikeshared/services/shared_preferences_manager.dart';
import 'package:bikeshared/views/components/auth_link_footer.dart';
import 'package:bikeshared/views/start.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ScreenConfigIp extends StatefulWidget {
  const ScreenConfigIp({super.key});

  @override
  State<ScreenConfigIp> createState() => _ScreenConfigIpState();
}

class _ScreenConfigIpState extends State<ScreenConfigIp> {
  final _ip = TextEditingController();
  final _port = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;

  
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
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

            SingleChildScrollView(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.25,right: 35, left: 35),
              child:Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Text(
                        "Configuração do endereço",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30,),                    
                    
                    TextFormField(
                      controller: _ip,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'IP',
                        prefixIcon: const Icon(Icons.numbers,),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                        contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color.fromARGB(255, 19, 110, 122)),
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                      maxLines: 1,
                      validator: (value){
                        if (value!.isEmpty) {
                          return 'Informe o IP';
                        }
                        return null;
                      }
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _port,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Porta',
                        prefixIcon: const Icon(Icons.door_back_door,),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                        contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color.fromARGB(255, 19, 110, 122)),
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                      maxLines: 1,
                      validator: (value){
                        if (value!.isEmpty) {
                          return 'Informe a porta';
                        }
                        return null;
                      }
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
                        child: isLoading? const SizedBox(width: 30, height: 30, child: CircularProgressIndicator(color: Colors.white,strokeWidth: 5.0,)):const Text('Confirmar',style: TextStyle(fontSize: 18,color: Colors.white),),
                        onPressed: () async{
                          setState(() {
                            isLoading = true;
                          });
                          
                          /*Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(
                            builder: (context) => const ScreenPreloading(),
                          ));*/
                          /*final users = UserRepository.tabela;*/
                          //print(users[0].email);
                          if (_formkey.currentState!.validate()) {
                            SharedPreferences sharedPreference = SharedPreferencesManager.sharedPreferences;
                            Env.url = "http://${_ip.text}:${_port.text}/cliente?wsdl";
                            sharedPreference.setString("endpoint", Env.url);
                            print(Env.url);
                            Future.delayed(const Duration(seconds: 1),() {
                              setState(() {
                                isLoading = false;
                              });
                            });
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                              builder: (context) => const /*AccountLayout()*/StartPage(),
                            ));
                          }

                          
                          Future.delayed(const Duration(seconds: 1),() {
                            setState(() {
                              isLoading = false;
                            });
                          });
                          

                          //FocusScopeNode keyboardCurrentFocus = FocusScope.of(context);
                          
                        },
                      
                    ),),
                  ]
                ),
              ),

            ),

          ],
        )
      ),
      //color: Colors.red,
    );
  }

}
