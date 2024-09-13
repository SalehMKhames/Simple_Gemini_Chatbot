import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketClient
{
  IOWebSocketChannel? channel;
  late StreamController<Map<String, dynamic>> messageController;

  WebSocketClient(){initializeController();}

  initializeController(){
    messageController = StreamController<Map<String, dynamic>>.broadcast();
  }

  void disconnent()
  {
    if(channel != null && channel!.closeCode == null)
    {
      debugPrint('Already connect');
      return;
    }
    channel!.sink.close();
    messageController.close();
    initializeController();
  }

  void connect(String url, Map<String, String> headers){
    if(channel != null && channel!.closeCode == null)
      {
        debugPrint('Already connected');
        return;
      }
    channel = IOWebSocketChannel.connect(Uri.parse(url), headers: headers);
    channel!.stream.listen((e) {
      Map<String, dynamic> message = jsonDecode(e);

      if(message['event'] == 'message.created'){
        messageController.add(message);
      }
      if(message['event'] == 'message.updated'){
        messageController.add(message);
      }
    },
    onDone: (){debugPrint('Disconnected');},
    onError: (e){debugPrint('Error: $e');}
    );
  }

  void send(String data)
  {
    if(channel == null && channel!.closeCode != null)
    {
      debugPrint('Not connected');
      return;
    }

    channel!.sink.add(data);
  }

  Stream<Map<String, dynamic>> messageUpdate()
  {
    return messageController.stream;
  }
}