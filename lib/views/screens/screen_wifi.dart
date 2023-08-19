import 'dart:async';
import 'dart:convert';

import 'package:bikeshared/controllers/MessageController.dart';
import 'package:bikeshared/repositories/socket.dart';
//import 'package:bikeshared/views/screens/screen_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_plus/flutter_p2p_plus.dart';
import 'package:flutter_p2p_plus/protos/protos.pb.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_p2p_plus/protos/protos.pbserver.dart';

import 'package:chat_bubbles/bubbles/bubble_normal.dart';

//import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';

class ScreenWifi extends StatefulWidget {
  //const ScreenWifi({Key? key}) : super(key: key);
  const ScreenWifi({super.key});
  @override
  _ScreenWifiState createState() => _ScreenWifiState();
}

class _ScreenWifiState extends State<ScreenWifi> with WidgetsBindingObserver {
  /*chat*/
  bool statusMessage = false;
  bool statusDivaces = false;
  Duration duration = new Duration();
  Duration position = new Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;
  //Registo de eventos e lista de dispositivos 
  List<StreamSubscription> _subscriptions = [];
  List<WifiP2pDevice> _peers = [];
  //conexao socket
  late P2pSocket _socket;
  //Conexão wifi direct
  bool _isConnected = false;
  bool _isHost = false;
  bool _isOpen = false;
  String _deviceAddress = "";
  final int _port = 8888;
  String typeUser = '';


  Future<bool> _checkPermission() async{
    var status = await FlutterP2pPlus.isLocationPermissionGranted();
    //print(status);
    print("estado v:$status");
    if (!status!) {
      status = await FlutterP2pPlus.requestLocationPermission();
      print("Sim");
      print(status);
      return false;
    }

    //print("Não");
    return true;
  }

  @override
  void initState() {
    super.initState();
    //_checkPermission();
    _register();
    
    WidgetsBinding.instance.addObserver(this);
    
    _discover();
    
  }
  
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Stop handling events when the app doesn't run to prevent battery draining

    if (state == AppLifecycleState.resumed) {
      _register();
    } else if (state == AppLifecycleState.paused) {
      _unregister();
    }
  }


  void _register() async {
    if (!await _checkPermission()) {
      return;
    }
    _subscriptions.add(FlutterP2pPlus.wifiEvents.stateChange!.listen((change) {
      // Handle wifi state change
      print("stateChange: ${change.isEnabled}");
      print(change);
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.connectionChange!.listen((change) {
      setState(() {
        _isConnected = change.networkInfo.isConnected;
        print(_isConnected);
        _isHost = change.wifiP2pInfo.isGroupOwner;
        print(_isHost);
        _deviceAddress = change.wifiP2pInfo.groupOwnerAddress;
        print(_deviceAddress);
        print("Connection");
        
      });
      print("connectionChange: ${change.wifiP2pInfo.isGroupOwner}, Conexão: ${change.networkInfo.isConnected}");
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.thisDeviceChange!.listen((change) {
      // Handle changes of this device
      print(
        "deviceChange: ${change.deviceName} / ${change.deviceAddress} / ${change.primaryDeviceType} / ${change.secondaryDeviceType} ${change.isGroupOwner ? 'GO' : '-GO'}");
      print(change);
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.peersChange!.listen((change) {
      // Handle discovered peers
      print("peersChange");
      print(change);
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.discoveryChange!.listen((change) {
      // Handle discovery state changes
      print("discoveryStateChange: ${change.isDiscovering}");
      print(change);
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.peersChange!.listen((change) {
      print("peersChange: ${change.devices.length}");
      setState(() {
        _peers = change.devices;
        print(change.devices);
      });
    }));


    print("Entrei");
    

    FlutterP2pPlus.register();  // Register to the native events which are send to the streams above
    
  }

  void _unregister() {
    _subscriptions.forEach((subscription) => subscription.cancel()); // Cancel subscriptions
    FlutterP2pPlus.unregister(); // Unregister from native events
  }

  Future<bool?> _discover() async{
    bool? status;
    try {
      status = await FlutterP2pPlus.discoverDevices();
      return status;
    } catch (e) {
      return false;
    }
    
    
  }

  Future<bool?> _connect(peer) async{
    print("yyy");

    bool? connect =  await FlutterP2pPlus.connect(peer);
    print(connect);
    //print(peers);
    return connect;
  }

  /*void _disconnect() async{

    FlutterP2pPlus.removeGroup();

  }*/

  Future<bool> _disconnect() async{
    bool? result = await FlutterP2pPlus.removeGroup();
    //_socket = ;
    if(result!) _isOpen = false;
    return result;
  }

  void _openPortAndAccept(int port/*, MessageController message*/) async {
    //MessageController messageProvider = Provider.of<MessageController>(context, listen: false);
    
    if(!_isOpen){
      var socket = await FlutterP2pPlus.openHostPort(port);
      setState(() {
        _socket = socket!;
        SocketRepo.socket = _socket;
      });
      snack("Canal de mensagem aberta na porta $_port",true);
      var buffer = "";
      socket!.inputStream.listen((data) {
        var msg = String.fromCharCodes(data.data);
        buffer += msg;
        //message.messages.add([buffer, "1"]);
        setState(() {
          MessageController.setMessage(buffer, "1");
        });
        if (data.dataAvailable == 0) {
          print("Data Received from ${_isHost ? "Client" : "Host"}: $buffer");
          snackBar("Data Received from ${_isHost ? "Client" : "Host"}: $buffer");
          //socket.writeString("Successfully received: $buffer");
          buffer = "";
        }
      });


      print("_openPort done");
      _isOpen = (await FlutterP2pPlus.acceptPort(port))!;
      print("_accept done: $_isOpen");
      
    }
  }

  _connectToPort(int port, MessageController message) async {
    //MessageController messageProvider = Provider.of<MessageController>(context, listen: false);
    
    var socket = await FlutterP2pPlus.connectToHost(
      _deviceAddress,
      port,
      timeout: 100000,
    );

    setState(() {
      _socket = socket!;
      SocketRepo.socket = _socket;
    });

    snack("Conexão na $_port de mensagem efectuada com sucesso",true);

    _socket.inputStream.listen((data) {
      var msg = utf8.decode(data.data);
      //message.messages.add([msg, "1"]);
      setState(() {
        MessageController.setMessage(msg, "1");
      });
      print("Recebido pelo ${_isHost ? "Host" : "Client"} $msg");
      //snackBar("Recebido pelo ${_isHost ? "Host" : "Client"} $msg");
    });
    /*
    var buffer = "";
    socket!.inputStream.listen((data) {
      var msg = String.fromCharCodes(data.data);
      buffer += msg;

      if (data.dataAvailable == 0) {
        _showSnackBar("Received from host: $buffer");
        buffer = "";
      }
    });*/

    print("_connectToPort done");
    
  }

  @override
  Widget build(BuildContext context) {
    //final now = new DateTime.now();
    print(_subscriptions.length);
    
    print("Lista:");
    print(_peers);
    print("Tamanho da Lista:");
    print(_peers.length);
    print("Conexão");
    print(_isConnected);
    print(_isHost);
    //print(_subscriptions[0].isPaused);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,//Colors.black,
        backgroundColor: const Color.fromARGB(255, 0, 14, 27),
        title: const Text('Descobrir Dispositivo'),
        actions: [
          
          Container(
            margin: const EdgeInsets.only(top: 16, right: 15),
            child: Row(
              children: [
                InkWell(
                  child: const Icon(Icons.refresh),
                  onTap: () async {
                    print("object");
                      
                    if(!_isConnected) await FlutterP2pPlus.discoverDevices();
                    //_discover()
                  },
                ),
                const Text(" "),
                InkWell(
                  onTap: _isConnected ? () async => await _disconnect() : null,
                  child: Icon(Icons.not_interested_rounded,color: _isConnected?Colors.white:const Color.fromARGB(255, 134, 132, 132),),
                  /*() async {
                    print("object");

                    if(_deviceAddress!=''){
                      /*Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ChatPage(typeUser:'client',deviceAddress: _deviceAddress),
                      ));*/
                    }
                    
                  },*/
                ),
              ],
            ),
          ),

          
        ],
      ),
      body: ChangeNotifierProvider<MessageController>(
        
        create: (context)=>MessageController(),
        builder:(context, child) {
          final message = Provider.of<MessageController>(context);
          return SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  ListTile(
                    title: const Text("Estado da Conexão"),
                    subtitle: Text(_isConnected ? "Conectado: ${_isHost ? "Servidor" : "Cliente"}" : "Desconectado"),
                  ),
          
                  const Divider(),

                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.2,
                            height: 40.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                //shape: const CircleBorder(),
                                backgroundColor: const Color.fromARGB(255, 0, 14, 27),
                                shadowColor: const Color.fromARGB(255, 0, 0, 0),
                                //padding: EdgeInsets.all(24)
                                
                              ),
                              onPressed: statusDivaces?() async { 
                                if (!_isConnected) await FlutterP2pPlus.discoverDevices();
                              }:null,
                              
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_sharp, size: 25,),
                                  //Text("Procurar despositivos"),
                                ],
                              ),
                              
                            ),
                          ),

                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.2,
                            height: 40.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                //shape: const CircleBorder(),
                                backgroundColor: const Color.fromARGB(255, 0, 14, 27),
                                shadowColor: const Color.fromARGB(255, 0, 0, 0),
                                //padding: EdgeInsets.all(24)
                                
                              ),
                              onPressed: _isConnected && _isHost ? () => _openPortAndAccept(8888/*, message*/) : null,
                              
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.door_front_door, size: 25,),
                                  //Text("Abrir a porta de conexão"),
                                ],
                              ),
                              
                            ),
                          ),

                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.2,
                            height: 40.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                //shape: const CircleBorder(),
                                backgroundColor: const Color.fromARGB(255, 0, 14, 27),
                                shadowColor: const Color.fromARGB(255, 0, 0, 0),
                                //padding: EdgeInsets.all(24)
                                
                              ),
                              onPressed: _isConnected &&!_isHost ? () => _connectToPort(_port, message) : null,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.connect_without_contact_sharp, size: 25,),
                                  //Text("Conectar para porta"),
                                ],
                              ),
                              
                            ),
                          ),

                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.2,
                            height: 40.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                //shape: const CircleBorder(),
                                backgroundColor: const Color.fromARGB(255, 49, 154, 196),
                                shadowColor: const Color.fromARGB(255, 94, 141, 155),
                                //padding: EdgeInsets.all(24)
                                
                              ),
                              onPressed:  statusMessage?/*_isConnected ? () async => await _socket.writeString("Hello World") : null,*/
                              (){
                                setState(() {
                                  statusMessage = false;
                                  statusDivaces = true;
                                });
                                
                                
                              }:()=>{
                                setState(() {
                                  statusMessage = true;
                                  statusDivaces = false;
                                })
                                /*ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Sem conexão! Crie uma conexão wifi direct"),
                                    duration: Duration(seconds: 7),
                                    backgroundColor: Color.fromARGB(255, 0, 14, 27),
                                  )
                                )*/
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.message_rounded, size: 25,),
                                  //Text("Chat"),
                                ],
                              ),
                              
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  
                  
                  const Divider(),
                  if(statusDivaces)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Lista de Despositivo",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  if(statusDivaces)
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _peers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(_peers[index].deviceName),
                        subtitle: Text(_peers[index].deviceAddress),
                        trailing: (/*_diviceAddress!="" && _diviceAddress == _peers[index].deviceAddress && */_isConnected == true)?
                        const Icon(Icons.wifi_outlined,color: Colors.green,):const Icon(Icons.wifi_outlined, color:  Colors.grey,),
                        onTap: () async{
                          print("${_isConnected ? "Disconnect" : "Connect"} to device: $_deviceAddress");
          
                          if (_isConnected) {
                            await FlutterP2pPlus.cancelConnect(_peers[index]);
                              _isConnected = false;
                              _isHost = false;
                              _isOpen = false;
                              _deviceAddress = "";
                              snack("Conexão desconectada",false);
                          } else {
                            await _connect(_peers[index]);
                            snack("Conexão efectuada",true);
                          }
                          
                          //FlutterP2pPlus.cancelConnect(_peers[index]) 
                        },
                        /*onTap: () async{
                          if(_isConnected == false){
                            await _connect(_peers[index]);
                            typeUser = 'server';
                            //await _connectToPort(_port);
                          }else{
          
                            if (_isConnected == true) {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ChatPage(typeUser: typeUser, deviceAddress: '',),
                              ));
                            }else{
                              if(_deviceAddress!=''){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ChatPage(typeUser:'client',deviceAddress: _deviceAddress),
                                ));
                              }
                            }
          
                          }
                        },*/
                      );
                    },
                  ),

                  /************ Chat**********/
                  if(statusMessage)
                  /*ChangeNotifierProvider<MessageController>(
                        
                    create: (context)=>MessageController(),
                    builder:(context, child) {
                      final data = context.watch<MessageController>();
                      print(data.messages);
                      //bubbleMessage(data.messages);
                      return */Column(
                            children: <Widget>[
                              /*BubbleNormalImage(
                                  id: 'id001',
                                  image: _image(),
                                  color: Colors.purpleAccent,
                                  tail: true,
                                  delivered: true,
                              ),*/
                              /*BubbleNormalAudio(
                                color: Color(0xFFE8E8EE),
                                duration: duration.inSeconds.toDouble(),
                                position: position.inSeconds.toDouble(),
                                isPlaying: isPlaying,
                                isLoading: isLoading,
                                isPause: isPause,
                                onSeekChanged: _changeSeek,
                                onPlayPauseButtonClick: _playAudio,
                                sent: true,
                              ),*/
                  
                              /*DateChip(
                                date: new DateTime(now.year, now.month, now.day - 2),
                              ),*/
                              
                              for(List<String> message in MessageController.messages/*data.messages*/)
                                (message[1]=="0")?
                                BubbleNormal(
                                  text: message[0],
                                  isSender: false,
                                  color: const Color(0xFF1B97F3),
                                  tail: false,
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ):
                                BubbleNormal(
                                  text: message[0],
                                  isSender: true,
                                  color: const Color(0xFFE8E8EE),
                                  tail: true,
                                  sent: true,
                                  delivered: true,
                                ),
                              
                              
                              
                          MessageBar(
                            onSend: _isConnected?(message) async{
                              print(message);
                              setState(() {
                                MessageController.setMessage(message, "0");
                              });
                              
                              //data.setMessage(message, "0");
                              
                              await _socket.writeString(message);
                            }: (mesage){
                              snack("Sem permissão para enviar! Crie uma conexão com um dispositivo",false);
                            },
                            actions: const [
                              
                            ],
                          ),
                        ],
                      )/*;
                    },
                  ),*/
          
                ],
              ),
            ),
          );
          },
        )
          /*:Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  //controller: textEditingController,
                  decoration: InputDecoration(
                    labelText: 'Digite uma mensagem',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async{
                    print("object");
                    
                    var status = await _discover();
                    print(status);
                    print("objecttttt");
                    
                    
                  },//sendMessage,
                  child: Text('Enviar Mensagem'),
                ),
                SizedBox(height: 20.0),
                Text('Última mensagem recebida: $message'),
              ],
            ),
          ),*/
        );
    /*return Scaffold(
      appBar: AppBar(
        title: Text('Wi-Fi Direct P2P'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                labelText: 'Digite uma mensagem',
              ),
            ),
            ElevatedButton(
              onPressed: (){},//sendMessage,
              child: Text('Enviar Mensagem'),
            ),
            SizedBox(height: 20.0),
            Text('Última mensagem recebida: $message'),
          ],
        ),
      ),
    );*/
  }

  snack(String text, bool status) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 7),
        backgroundColor: (status)?Colors.green: Colors.red,
      ),
    );
  }
  snackBar(String text) {
    /*_scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: 2),
      ),
    );*/

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
