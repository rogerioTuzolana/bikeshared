
import 'package:flutter/material.dart';
import 'package:flutter_p2p_plus/flutter_p2p_plus.dart';

class ScreenChat extends StatefulWidget {

  late String typeUser;
  late String deviceAddress;
  /*const */ScreenChat({super.key, required this.typeUser, required this.deviceAddress});

  @override
  State<ScreenChat> createState() => _ScreenChatState();
}

class _ScreenChatState extends State<ScreenChat> {
  //TextEditingController textEditingController = TextEditingController();
  String message = '';
  //conexao socket
  late P2pSocket _socket;
  int _port = 5000;

  @override
  void initState() {
    super.initState();
    //_checkPermission();
    print(widget.deviceAddress);
    test();
    if (widget.typeUser == "server") {
      _openPortAndAccept(/*int port*/);
    }else{
      //_openPortAndAccept(/*int port*/);
      _connectToPort();
    }

    
  }

  test(){
    print("dataooo");
  }

  void _openPortAndAccept(/*int port*/) async {
    var socket = await FlutterP2pPlus.openHostPort(_port);
    setState(() {
      _socket = socket!;
    });

    var buffer = "";
    socket!.inputStream.listen((data) {
      var msg = String.fromCharCodes(data.data);
      buffer += msg;
      print("Ouvindo...");
      print(data);
      if (data.dataAvailable == 0) {
        _showSnackBar("Data Received: $buffer");
        buffer = "";
      }
    });

    // Write data to the client using the _socket.write(UInt8List) or `_socket.writeString("Hello")` method

    print("_openPort done");

    // accept a connection on the created socket
    await FlutterP2pPlus.acceptPort(_port);
    print("_accept done");
  }
  
  _connectToPort() async {
    var socket = await FlutterP2pPlus.connectToHost(
      widget.deviceAddress, // see above `Connect to a device`
      _port,
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descobrir Dispositivo'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: /*const Color(0xfffccb1b),*/Color.fromARGB(255, 9, 10, 10),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async{
                print("object");
                
              },//sendMessage,
              child: Text('Ligar servidor'),
            ),

            TextField(
              //controller: textEditingController,
              decoration: InputDecoration(
                labelText: 'Digite uma mensagem',
              ),
            ),
            ElevatedButton(
              onPressed: () async{
                print("object");
                
              },//sendMessage,
              child: Text('Enviar Mensagem'),
            ),
            SizedBox(height: 20.0),
            Text('Última mensagem recebida:'),
          ],
        ),
      ),
    );
  }
}