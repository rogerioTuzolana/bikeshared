
import 'dart:convert';


import 'package:bikeshared/models/historic.dart';
import 'package:bikeshared/repositories/historic_repository.dart';
import 'package:bikeshared/views/screens/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HistoricUser extends StatefulWidget {
  const HistoricUser({super.key});

  @override
  State<HistoricUser> createState() => _HistoricUserState();
}

class _HistoricUserState extends State<HistoricUser> {
  late Future <List<Historic>> listHistorical;
  @override
  void initState() {

    super.initState();
    listHistorical = getHistorical();
  }
  @override
  Widget build(BuildContext context) {
    final historcal = HistoricRepository.tabela;
    
    return 
    Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(),
      body: buildBody(historcal),
    );
  }

  AppBar buildAppBar(){
    return AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const ScreenHome(), //HomeUser()//Splash(),
            ));
          },
        ),
        backgroundColor: const Color.fromARGB(255, 54, 122, 66),
        title: const Text('BAIKAPAY'),
        //centerTitle: true,
      );
  }


  buildBody(List<Historic> historical){
    Size size = MediaQuery.of(context).size;
    return 
        Stack(children: [
          
          Container(
            color: const Color(0xff89d5b1),
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: size.height*0.04,),
                SizedBox(
                  width: size.width,    
                  child:
                      const Text(
                        'Kamba Paga',style: 
                        TextStyle(fontSize: 21,color: Color.fromARGB(255, 54, 122, 66)),
                        textAlign: TextAlign.center,
                  ),
                ),
                
                SizedBox(height: size.height*0.04,),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text("  14-12-2022",style: TextStyle(fontSize: 13),),
                ),
                FutureBuilder<List<Historic>>(
                  future: listHistorical,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        //scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int nHistoric){
                          Historic historic = snapshot.data![nHistoric];
                          return ListTile(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            //leading: Icon(Icons.arrow_downward),
                            
                            leading: Icon(
                                color: (historic.type=='Pagamento')? Colors.red:null,
                                (historic.type=='Pagamento')?
                                  Icons.arrow_downward:Icons.arrow_upward,
                                    
                            ),
                            title: Text('${historic.value.toString()}0 kz',style: const TextStyle(color: Color.fromARGB(255, 50, 109, 61)),),
                            trailing: Text(historic.description,style: const TextStyle(color: Color.fromARGB(255, 50, 109, 61)),),
                          );
                        },
                        padding: const EdgeInsets.all(16),
                        separatorBuilder: (_,__)=>const Divider(),
                      );
                    }else if(snapshot.hasError){
                      return Text(snapshot.error.toString());
                    }
                    return const Center(child: CircularProgressIndicator());
                  })
                )
                
              ],)
            ,),
          ),
        ]);
  }

  Future<List<Historic>> getHistorical() async{
    return HistoricRepository.tabela;
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();

    try {
      String? token = sharedPreference.getString('token');
      //print('Bearer $token');

      final url = Uri.parse("https://apibaikaactual-production.up.railway.app/historicos");

      http.Response response = await http.get(
        url,
        headers: /*<String, String>*/{
          'Content-Type': 'application/json; charset=UTF-8',// charset=UTF-8
          'Accept': 'application/json',
          //HttpHeaders.authorizationHeader: 'Bearer $token',
          'Authorization': 'Bearer $token',
          
        },
        /*body: jsonEncode({
          "preco": _amount.text,
        })*/
      );
      if (response.statusCode == 200) {
        
        
        List historical = jsonDecode(response.body);
        //print(historical);
        return historical.map((json) => Historic.fromJson(json)).toList();
        
      }else if(response.statusCode == 503){
        //print('Servidor indisponível');
        return [];
      }else if(response.statusCode == 500){
        //print('Falha na requisição');
        return [];
      }else{
        
        /*print(jsonDecode(response.body));
        print(response.statusCode);*/
        return [];
      }
    } catch (e) {
      //print('Tempo de execução demorada!');
      //print(e);
      return [];
      //rethrow;
    }

  }

}