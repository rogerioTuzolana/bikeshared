
import 'package:bikeshared/views/splash.dart';
import 'package:flutter/material.dart';

class TransferUser extends StatefulWidget {
  const TransferUser({super.key});

  @override
  State<TransferUser> createState() => _TransferUserState();
}

class _TransferUserState extends State<TransferUser> {
  @override
  Widget build(BuildContext context) {

    return 
    Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar(){
    return AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const Splash(),
            ));
          },
        ),
        backgroundColor: const Color.fromARGB(255, 54, 122, 66),
        //title: Text('Baika Seguro'),
        //centerTitle: true,
      );
  }


  buildBody(){
    Size size = MediaQuery.of(context).size;
    return 
        Container(
          //Fundo total de 20% de altura
          height: size.height,
          color: const Color.fromARGB(255, 54, 122, 66),
          child: Stack(children: [
            Container(
              //height: size.height*0.3-27,
              height: size.height*0.08,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 54, 122, 66),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Column(children: const [ 
                    Text('TRANSFERÊNCIA',style: TextStyle(fontSize: 21,color: Color.fromARGB(255, 255, 255, 255)),),

                  ],),     
                ],
              ),
            ),
            
            Container(
              margin: EdgeInsets.only(top: size.height*0.08),
              //height: size.height*0.3-27,
              height: size.height,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(top: size.height*0.11),
                //height: size.height*0.3-27,
                height: size.height,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: SingleChildScrollView(
                  child: Column(children: [
                    const SizedBox(height: 10,),
                    Container(
                      alignment: Alignment.topLeft,
                    ),
                    SizedBox(
                      width: size.width-30,
                      height: 80.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 255, 255)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                        
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 20,),
                                Image.asset("images/camera leitor qr.png", width: 30.0,height: 30.0,),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                SizedBox(height: 13,),
                                Text(' Transferir os valores do boss rápido',style: TextStyle(fontSize: 12,color: Color.fromARGB(204, 50, 109, 61)),),
                                SizedBox(height: 10,),
                                Text(' NOME: LINO ALBERTO MENGUE',style: TextStyle(fontSize: 12,color: Color.fromARGB(204, 50, 109, 61)),),
                                Text(' CONTA: 107896589',style: TextStyle(fontSize: 12,color: Color.fromARGB(204, 50, 109, 61)),),
                              ]
                            ),
                          ],
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const Splash(),
                        ));
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: size.width-30,
                      height: 80.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 255, 255)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                        
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              const SizedBox(height: 20,),
                              Image.asset("images/transferencia.png", width: 32.0,height: 32.0,),
                            ],),
                            Column( 
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                SizedBox(height: 13,),
                                Text(' Transferir os valores para sua conta',style: TextStyle(fontSize: 12,color: Color.fromARGB(204, 50, 109, 61)),),
                                SizedBox(height: 10,),
                                Text(' NOME: LINO ALBERTO MENGUE',style: TextStyle(fontSize: 12,color: Color.fromARGB(204, 50, 109, 61)),),
                                Text(' CONTA: 107896589',style: TextStyle(fontSize: 12,color: Color.fromARGB(204, 50, 109, 61)),),
                            ],),
                          ],
                        ),
                        onPressed: (){/*print("object");*/},
                      ),
                    )

                  ],)
                ,)   
              ),
            ),
          ]),
        );
  }
}