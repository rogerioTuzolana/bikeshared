import 'dart:async';

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
  String message = '';
  //Registo de eventos e lista de dispositivos 
  List<StreamSubscription> _subscriptions = [];
  List<WifiP2pDevice> _peers = [];
  //Conexão wifi direct
  bool _isConnected = false;
  bool _isHost = false;
  String _deviceOwnerAddress = "";
  String _deviceAddress = "";
  int _port = 5000;
  String typeUser = '';

  //conexao socket
  late P2pSocket _socket;

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
      print("stateChange");
      print(change);
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.connectionChange!.listen((change) {
      // Handle changes of the connection
      print("connectionChange");
      print(change);
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.thisDeviceChange!.listen((change) {
      // Handle changes of this device
      print("thisDeviceChange");
      print(change);
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.peersChange!.listen((change) {
      // Handle discovered peers
      print("peersChange");
      print(change);
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.discoveryChange!.listen((change) {
      // Handle discovery state changes
      print("discoveryChange");
      print(change);
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.peersChange!.listen((change) {
      setState(() {
        _peers = change.devices;
        print("object");
        print(change.devices);
      });
    }));

    _subscriptions.add(FlutterP2pPlus.wifiEvents.connectionChange!.listen((change) {
      setState(() {
        _isConnected = change.networkInfo.isConnected;
        print(_isConnected);
        _isHost = change.wifiP2pInfo.isGroupOwner;
        print(_isHost);
        _deviceOwnerAddress = change.wifiP2pInfo.groupOwnerAddress;
        print(_deviceAddress);
        print("Connection");
        
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

  Future<void> _connect(WifiP2pDevice peer) async{
    print("yyy");
    var connect =  await FlutterP2pPlus.connect(peer);
    print(connect);
    if(connect!){
      _deviceAddress = peer.deviceAddress;
      print("Connectado com $_deviceAddress");
    }
    //print(peers);
  }

  void _disconnect() async{

    FlutterP2pPlus.removeGroup();

  }

  void _openPortAndAccept(int port) async {
    var socket = await FlutterP2pPlus.openHostPort(port);
    setState(() {
      _socket = socket!;
    });

    var buffer = "";
    socket!.inputStream.listen((data) {
      var msg = String.fromCharCodes(data.data);
      buffer += msg;

      if (data.dataAvailable == 0) {
        _showSnackBar("Data Received: $buffer");
        buffer = "";
      }
    });

    // Write data to the client using the _socket.write(UInt8List) or `_socket.writeString("Hello")` method

    print("_openPort done");

    // accept a connection on the created socket
    await FlutterP2pPlus.acceptPort(port);
    print("_accept done");
  }

  _connectToPort(int port) async {
    var socket = await FlutterP2pPlus.connectToHost(
      _deviceAddress, // see above `Connect to a device`
      port,
      timeout: 100000, // timeout in milliseconds (default 500)
    );

    setState(() {
      _socket = socket!;
    });

    var buffer = "";
    socket!.inputStream.listen((data) {
      var msg = String.fromCharCodes(data.data);
      buffer += msg;

      if (data.dataAvailable == 0) {
        _showSnackBar("Received from host: $buffer");
        buffer = "";
      }
    });

    // Write data to the host using the _socket.write(UInt8List) or `_socket.writeString("Hello")` method

    print("_connectToPort done");
  }

  void _showSnackBar(message){
    print(message);
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
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const ScreenHome(),
            ));
          },
        ),
        title: const Text('Dispositivos'),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 16, right: 15),
            child: IconButton(
              color: Colors.white,//Colors.black,
              icon: const Icon(Icons.refresh),
              onPressed: ()async {
                print("object");
                  
                var status = await _discover();
                print(status);
                print("objecttttt");
              }
            ),
            
          ),
          /*Text(" "),
          InkWell(
            child: Icon(Icons.not_interested_rounded),
            onTap: () async {
              print("object");

              /*if(_deviceAddress!=''){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ScreenChat(typeUser:'client',deviceAddress: _deviceAddress),
                ));
              }*/
              
            },
          )*/
          
        ],
        foregroundColor: Colors.white,//Colors.black,
        backgroundColor: const Color.fromARGB(255, 0, 14, 27),
        
      ),
      body: /*(_peers.length>0)?*/
      ListView.builder(
        itemCount: _peers.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_peers[index].deviceName),
            subtitle: Text(_peers[index].deviceAddress),
            trailing: (/*_deviceAddress!="" && _deviceAddress == _peers[index].deviceAddress && */_isConnected == true)?
            Icon(Icons.wifi_outlined,color: Colors.green,):Icon(Icons.wifi_outlined, color:  Colors.grey,),
            onTap: () async{
              if(_isConnected == false){
                await _connect(_peers[index]);
                typeUser = 'server';
                //await _connectToPort(_port);
              }else{

                if (_isConnected == true && _peers[index].deviceAddress == _deviceAddress) {
                  /*Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ScreenChat(typeUser: typeUser, deviceAddress: '',),
                  ));*/
                }else{
                  if(_deviceAddress!=''){
                    /*Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ScreenChat(typeUser:'client',deviceAddress: _deviceAddress),
                    ));*/
                  }
                }

              }
            },
          );
        },
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
    
  }
}
