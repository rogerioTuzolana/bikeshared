
/*import 'package:bikeshared/controllers/MessageController.dart';
import 'package:bikeshared/repositories/socket.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';

import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_plus/flutter_p2p_plus.dart';
import 'package:provider/provider.dart';


class ScreenChat extends StatefulWidget {
  //TextEditingController message;
  late P2pSocket socket;
  ScreenChat({super.key, required this.socket/*required this.typeUser, required this.deviceAddress*/});

  @override
  State<ScreenChat> createState() => _ScreenChatState();
}

class _ScreenChatState extends State<ScreenChat> {
  //TextEditingController textEditingController = TextEditingController();

  String message = '';
  //conexao socket
  Duration duration = new Duration();
  Duration position = new Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;
  
  @override
  void initState() {
    super.initState();
    //_checkPermission();
  }
  
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: ChangeNotifierProvider<MessageController>(
        
        create: (context)=>MessageController(),
        builder:(context, child) {
          final data = context.watch<MessageController>();
          print(data.messages);
          //bubbleMessage(data.messages);
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
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

                    DateChip(
                      date: new DateTime(now.year, now.month, now.day - 2),
                    ),
                    
                    for(List<String> message in data.messages)
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
                    
                    /*BubbleNormal(
                      text: 'bubble normal without tail',
                      color: Color(0xFFE8E8EE),
                      tail: false,
                      sent: true,
                      seen: true,
                      delivered: true,
                    ),
                    BubbleSpecialOne(
                      text: 'bubble special one with tail',
                      isSender: false,
                      color: Color(0xFF1B97F3),
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    DateChip(
                      date: new DateTime(now.year, now.month, now.day - 1),
                    ),
                    BubbleSpecialOne(
                      text: 'bubble special one with tail',
                      color: Color(0xFFE8E8EE),
                      seen: true,
                    ),
                    BubbleSpecialOne(
                      text: 'bubble special one without tail',
                      isSender: false,
                      tail: false,
                      color: Color(0xFF1B97F3),
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    BubbleSpecialOne(
                      text: 'bubble special one without tail',
                      tail: false,
                      color: Color(0xFFE8E8EE),
                      sent: true,
                    ),
                    BubbleSpecialTwo(
                      text: 'bubble special tow with tail',
                      isSender: false,
                      color: Color(0xFF1B97F3),
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    DateChip(
                      date: now,
                    ),
                    BubbleSpecialTwo(
                      text: 'bubble special tow with tail',
                      isSender: true,
                      color: Color(0xFFE8E8EE),
                      sent: true,
                    ),*/
                    
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
              MessageBar(
                onSend: (message) async{
                  print(message);
                  data.setMessage(message, "0");
                  await widget.socket.writeString(message);
                  //await SocketRepo.socket.writeString(message);
                },
                actions: const [
                  
                ],
              ),
            ],
          );
        },
      )
    );
  }
}*/