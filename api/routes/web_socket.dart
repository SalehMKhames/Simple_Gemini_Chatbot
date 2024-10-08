import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import '../lib/src/repositories/Chat_Repo.dart';

Future<Response> onRequest(RequestContext context) async {
  final chatRepo = context.read<ChatRepo>();

  final handler = webSocketHandler((channel, protocol) {
    channel.stream.listen((message) {
      if (message is! String) {
        channel.sink.add('Invalid message');
        return;
      }

      try {
        final Map<String, dynamic> messageJson =
            json.decode(message) as Map<String, dynamic>;
        final event = messageJson['event'];
        final data = messageJson['data'];

        switch (event) {
          case 'message.create':
            const chatRoomId = '1';
            chatRepo.createUserMessage(chatRoomId, data as Map<String, dynamic>)
            .then((value) {
              final responseStream = chatRepo.createModelMessage(chatRoomId, data);

              responseStream.listen((data){
                final modelMessage = data.$1;
                final eventType = data.$2;
                //From the server to the client
                channel.sink.add(json.encode({'event': eventType, 'data': modelMessage.toJson()}));
              });
              
              return;
            });
            break;
          default:
        }
      } catch (err) {}
    });
  });
  return handler(context);
}
