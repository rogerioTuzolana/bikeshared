import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _currentStep = 0;
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  //final _bi = TextEditingController();
  final _password = TextEditingController();
  final _contact = TextEditingController();
  final _address = TextEditingController();
  final _cpassword = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  final _formkey3 = GlobalKey<FormState>();
  bool isLoading = false;

  List<Step> getSteps()=>[
      Step(
        state: (_currentStep>0)?StepState.complete:StepState.indexed,
        isActive: _currentStep>=0,
        title: const Text('Conta'),
        content:Form(
          key: _formkey,
          child:
            Column(
            children: [
              TextFormField(
                controller: _firstName,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Nome',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 34, 82, 32)),
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                validator: (valor){
                  
                  if (valor!.isEmpty) {
                    return 'Nome é um campo obrigatório';
                  }
                  return null;
                }
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _lastName,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Sobre Nome',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 34, 82, 32)),
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                validator: (valor){
                  
                  if (valor!.isEmpty) {
                    return 'Sobre nome é um campo obrigatório';
                  }
                  return null;
                }
              ),
              
            ],
          ),
        ),
      ),
      Step(
        state: (_currentStep>1)?StepState.complete:StepState.indexed,
        isActive: _currentStep>=1,
        title: const Text('Endereço'),
        content: 
        Form(
          key: _formkey2,
          child:
          Column(
            children: [
              TextFormField(
                controller: _contact,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Contacto',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 34, 82, 32)),
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                validator: (valor){
                  
                  if (valor!.isEmpty) {
                    return 'Contacto é um campo obrigatório';
                  }
                  return null;
                }
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _address,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Morada',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 34, 82, 32)),
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                validator: (valor){
                  
                  if (valor!.isEmpty) {
                    return 'Morada é um campo obrigatório';
                  }
                  return null;
                }
              ),
            ],
          ),
        ),
      ),
      Step(
        state: (_currentStep>2)?StepState.complete:StepState.indexed,
        isActive: _currentStep>=2,
        title: const Text('Finalizar'),
        content: 
        Form(
          key: _formkey3,
          child:
          Column(
            children: [
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Senha',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 34, 82, 32)),
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                validator: (valor){
                  if (valor!.isEmpty) {
                    return 'Senha é um campo obrigatório';
                  }
                  return null;
                }
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _cpassword,
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Confirmar Senha',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 34, 82, 32)),
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                validator: (valor){
                  if (valor!.isEmpty) {
                    return 'Confirmação da senha é um campo obrigatório';
                  }
                  return null;
                }
              ),
            ],
          ),
        ),
      ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 54, 122, 66),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color.fromARGB(255, 54, 122, 66)),
          textTheme: Theme.of(context).textTheme.apply(bodyColor: const Color.fromARGB(255, 0, 0, 0)),

        ),
        child: Stepper(
          type: StepperType.horizontal,
          steps: getSteps(),
          currentStep: _currentStep,
          onStepContinue: (){
            
            setState((){
              if (_currentStep < getSteps().length-1) {
                _currentStep += 1;
              }
            });
          },
          onStepTapped: (step)=> setState(()=> _currentStep = step),
          onStepCancel: (){
            if (_currentStep == 0) {
              return;
            }
            setState(()=>_currentStep -= 1);
          },
          controlsBuilder: (BuildContext context,ControlsDetails controls){
            /*if(_firstName.text != '' && _lastName.text != ''){
              
              print(_firstName.text);
              print(_lastName.text);
              showModalBottomSheet(context: context, builder: (context)=>stepModalMessage(context));
              
            }*/

            return Container(
              margin: const EdgeInsets.only(top: 50),
              child: Row(
                children: [
                  
                  if(_currentStep!=0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controls.onStepCancel,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color.fromARGB(234, 76, 146, 89)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                      child: const Text('Voltar'),
                    ),
                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                
                      onPressed: (_currentStep>=2)?() async{
                        setState(() {
                          isLoading = true;
                        });
                        
                        
                        if (_formkey.currentState!.validate() && _formkey2.currentState!.validate() && _formkey3.currentState!.validate()) {
                          FocusScopeNode keyboardCurrentFocus = FocusScope.of(context);
                          if (_password.text != _cpassword.text) {
                            _password.clear();
                            _cpassword.clear();
                            messageErrorRegist('As confirmação da palavra senha não coincide!');
                            return ;
                          }
                          
                          var success = await regist();
                          //Fechar teclado do registo
                          if (keyboardCurrentFocus.hasPrimaryFocus) {
                              keyboardCurrentFocus.unfocus();
                          }
                          if (success) {

                            Navigator.pushReplacement(
                              context, 
                              MaterialPageRoute(
                              builder: (context) => const Register(),
                            ));

                            messageSuccessRegist("Utilizador cadastrado com sucesso");
                          }
                        }
                        Future.delayed(const Duration(seconds: 0),() {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      }:
                      controls.onStepContinue,
                      child: isLoading? const SizedBox(height:15,width:15,child: CircularProgressIndicator(color: Colors.white,strokeWidth: 5.0,)):Text((_currentStep== getSteps().length-1)? 'Cadastrar':'Avançar')
                    ),
                  ),
                  
                ],
              ),
            );
          },
        ),
      ),
    );

  }

  Widget stepModalMessage(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      //alignment: Alignment.center,
      
      width: double.infinity,
      height: size.height * 0.1,
      
      child: const Center( 
        child: Text(
          "Preencha todos os campos para avançar.",
          style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.redAccent),
        ),
      ),
    );
  }

  Future<bool> regist() async{
    
    //SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    /*print(_contact.text);
    print(_password.text);
    print("${_firstName.text} ${_lastName.text}");
    print(_address.text);*/
    try {
      
      final url = Uri.parse("https://apibaikaactual-production.up.railway.app/inserirClient");

      http.Response response = await http.post(
        url,
        headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            /*HttpHeaders.authorizationHeader: "...",*/
        },
        body: jsonEncode({
          "telefone": _contact.text,
          "password": _password.text,
          "nome": "${_firstName.text} ${_lastName.text}",
          "morada": _address.text,
          //"cod_qr": _bi.text,
        })
      );
      if (response.statusCode == 200) {
        //print(jsonDecode(response.body));
        return true;
      }else if(response.statusCode == 503){
        //print('Servidor indisponível');
        return false;
      }else if(response.statusCode == 500){
        //print('Falha na requisição');
        return false;
      }else if(response.statusCode == 400){

        messageErrorRegist('Este utilizador já existe!');
        
        return false;
      }else{
        /*print('Falha no cadastro');
        print(response.body);*/
        return false;
      }
    } catch (e) {
      /*print('Tempo de execução demorada!');
      print(e);*/
      return false;
      //rethrow;
    }
  }

  messageErrorRegist(msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        backgroundColor: Colors.redAccent,
      )
    );
  }

  messageSuccessRegist(msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        backgroundColor: const Color.fromARGB(255, 105, 177, 46),
      )
    );
  }
}