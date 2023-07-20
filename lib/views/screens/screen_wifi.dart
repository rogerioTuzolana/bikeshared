import 'dart:async';
import 'dart:convert';

import 'package:bikeshared/views/screens/screen_chat.dart';
import 'package:bikeshared/views/screens/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_plus/flutter_p2p_plus.dart';
import 'package:flutter_p2p_plus/protos/protos.pb.dart';
//import 'package:flutter_p2p_plus/protos/protos.pbserver.dart';

class ScreenWifi extends StatefulWidget {
  //const ScreenWifi({Key? key}) : super(key: key);
  const ScreenWifi({super.key});
  @override
  _ScreenWifiState createState() => _ScreenWifiState();
}

class _ScreenWifiState extends State<ScreenWifi> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
  int _port = 8888;
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
    bool? status = await FlutterP2pPlus.discoverDevices();
    return status;
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

  void _openPortAndAccept(int port) async {
    if(!_isOpen){
      var socket = await FlutterP2pPlus.openHostPort(port);
      setState(() {
        _socket = socket!;
      });

      var buffer = "";
      socket!.inputStream.listen((data) {
        var msg = String.fromCharCodes(data.data);
        buffer += msg;
        if (data.dataAvailable == 0) {
          print("Data Received from ${_isHost ? "Client" : "Host"}: $buffer");
          snackBar("Data Received from ${_isHost ? "Client" : "Host"}: $buffer");
          socket.writeString("Successfully received: $buffer");
          buffer = "";
        }
      });

      print("_openPort done");
      _isOpen = (await FlutterP2pPlus.acceptPort(port))!;
      print("_accept done: $_isOpen");
    }
  }

  _connectToPort(int port) async {
    var socket = await FlutterP2pPlus.connectToHost(
      _deviceAddress,
      port,
      timeout: 100000,
    );

    setState(() {
      _socket = socket!;
    });

    _socket.inputStream.listen((data) {
      var msg = utf8.decode(data.data);

      print("Received from ${_isHost ? "Host" : "Client"} $msg");
      snackBar("Received from ${_isHost ? "Host" : "Client"} $msg");
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
                  child: Icon(Icons.refresh),
                  onTap: () async {
                    print("object");
                      
                    if(!_isConnected) await FlutterP2pPlus.discoverDevices();
                    //_discover()
                  },
                ),
                Text(" "),
                InkWell(
                  child: Icon(Icons.not_interested_rounded),
                  onTap: () async {
                    print("object");

                    if(_deviceAddress!=''){
                      /*Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ChatPage(typeUser:'client',deviceAddress: _deviceAddress),
                      ));*/
                    }
                    
                  },
                ),
              ],
            ),
          ),

          
        ],
      ),
      body: /*(_peers.length>0)?*/
      SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ListTile(
                title: Text("Estado da Conexão"),
                subtitle: Text(_isConnected ? "Conectado: ${_isHost ? "Servidor" : "Cliente"}" : "Desconectado"),
              ),
      
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Controller",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),

              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: 40.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //shape: const CircleBorder(),
                        primary: const Color.fromARGB(255, 0, 14, 27),
                        shadowColor: const Color.fromARGB(255, 0, 0, 0),
                        //padding: EdgeInsets.all(24)
                        
                      ),
                      
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.search_sharp, size: 25,),
                          Text("Procurar despositivos"),
                        ],
                      ),
                      onPressed: (){ 
                        
                      },
                      
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: 40.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //shape: const CircleBorder(),
                        primary: const Color.fromARGB(255, 0, 14, 27),
                        shadowColor: const Color.fromARGB(255, 0, 0, 0),
                        //padding: EdgeInsets.all(24)
                        
                      ),
                      
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.door_front_door, size: 25,),
                          Text("Abrir a porta de conexão"),
                        ],
                      ),
                      onPressed: (){ 
                        
                      },
                      
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: 40.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //shape: const CircleBorder(),
                        primary: const Color.fromARGB(255, 0, 14, 27),
                        shadowColor: const Color.fromARGB(255, 0, 0, 0),
                        //padding: EdgeInsets.all(24)
                        
                      ),
                      
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.connect_without_contact_sharp, size: 25,),
                          Text("Conectar para porta"),
                        ],
                      ),
                      onPressed: (){ 
                        
                      },
                      
                    ),
                  ),
                ],
              ),
              ListTile(
                title: const Text("Discover Devices"),
                onTap: () async {
                  if (!_isConnected) await FlutterP2pPlus.discoverDevices();
                  else return;
                },
              ),
              Divider(),
              ListTile(
                title: const Text("Open and accept data from port 8888"),
                subtitle: _isConnected ? Text("Active") : Text("Disable"),
                onTap: _isConnected && _isHost ? () => _openPortAndAccept(8888) : null,
              ),
              Divider(),
              ListTile(
                title: const Text("Connect to port 8888"),
                subtitle: const Text("This is able to only Client"),
                onTap: _isConnected &&!_isHost ? () => _connectToPort(8888) : null,
              ),
              Divider(),
              ListTile(
                title: const Text("Enviar hello world"),
                onTap: _isConnected ? () async => await _socket.writeString("Hello World") : null,
              ),
              Divider(),
              ListTile(
                title: const Text("Desconectar"),
                onTap: _isConnected ? () async => await _disconnect() : null,
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Lista de Despositivo",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _peers.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_peers[index].deviceName),
                    subtitle: Text(_peers[index].deviceAddress),
                    trailing: (/*_diviceAddress!="" && _diviceAddress == _peers[index].deviceAddress && */_isConnected == true)?
                    Icon(Icons.wifi_outlined,color: Colors.green,):Icon(Icons.wifi_outlined, color:  Colors.grey,),
                    onTap: () async{
                      print("${_isConnected ? "Disconnect" : "Connect"} to device: $_deviceAddress");
      
                      if (_isConnected) {
                        await FlutterP2pPlus.cancelConnect(_peers[index]);
                          bool _isConnected = false;
                          bool _isHost = false;
                          bool _isOpen = false;
                          String _deviceAddress = "";
                          snack("Conexão desconectada",false);
                      } else {
                        await _connect(_peers[index]);
                        snack("Conexão desconectada",true);
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
      
            ],
          ),
        ),
      )/*:Padding(
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
        duration: Duration(seconds: 7),
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
        duration: Duration(seconds: 2),
      ),
    );
  }
}
