import 'dart:async';
import 'dart:convert';

import 'package:real_time_gemini_ai_chatbot/web_socket_client.dart';
import 'package:model/src/message.dart';

class ChatRepository
{
  // final ApiClient apiClient;
  final WebSocketClient client;
  StreamSubscription? _messageSubscription;

  ChatRepository({required this.client});

  void subscribeToMessageUpdates(void Function(Map<String, dynamic> message) onMessageReceived,)
  {
    _messageSubscription = client.messageUpdate().listen(
            (message){
              onMessageReceived(message);
            });
  }

  void _unsubscribeFromMessageUpdates()
  {
    _messageSubscription?.cancel();
    _messageSubscription = null;
  }

  Future<void> createMessage(Message message) async
  {
    final payload = {'event': 'message.create', 'data': message.toJson()};
    client.send(jsonEncode(payload));

  }
}