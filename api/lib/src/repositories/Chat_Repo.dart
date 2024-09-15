import 'package:api/src/env/env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:model/src/message.dart';
import 'package:model/src/message_source_type.dart';
import 'package:uuid/uuid.dart';


class ChatRepo
{
  //Store all the messages in a map with the chatroom id as the key
  final Map<String, List<Message>> _chatrooms ={};

  Future<Message> createUserMessage(String chatRoomId, Map<String, dynamic> data) async
  {
    final message = Message.fromJson(data);
    _chatrooms.putIfAbsent(chatRoomId, () => []);
    _chatrooms[chatRoomId]?.add(message);
    return message;
  }

  Stream<(Message, String)> createModelMessage(String chatRoomId, Map<String, dynamic> data)
  {
    final model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: Env.Gemini_API_KEY);
    final messageID = const Uuid().v4();
    List<Content> history = [];

    for(var message in _chatrooms[chatRoomId]!)
    {
      if(message.id == data['id']){
        print("Message Already exist");
        continue;
      }
      if(message.sourceType == MessageSourceType.user) {
          history.add(Content.text(message.content));
      }
      else{
        history.add(Content.model([TextPart(message.content)]));
      }
    }

    final chat = model.startChat(history: history.isEmpty ? null : history);
    final content = Content.text(data['content'] as String);

    return chat.sendMessageStream(content).asyncMap((response)
    {
      final newMessage = Message
      (
        id: messageID,
        content: response.text ?? '',
        sourceType: MessageSourceType.model,
        createdAt: DateTime.now(),
      );
      return _updateMessage(chatRoomId, newMessage.toJson()).then((Message? value)
      {
        if(value != null)
        {
          _chatrooms[chatRoomId]?.removeWhere((e) => e.id == messageID);
          _chatrooms[chatRoomId]?.add(value);
          return (value, 'message.updated');
        }
        else{
          _chatrooms[chatRoomId]?.add(newMessage);
          return (newMessage,'message.created');
        }
      });
    });
  }

  Future<Message?> _updateMessage(String chatRoomId, messageData) async
  {
    if(!_chatrooms.containsKey(chatRoomId)){
      return null;
    }
    final message = _chatrooms[chatRoomId]!;
    final messageIndex = message?.indexWhere((m) => m.id == messageData['id']);

    if(messageIndex != null && messageIndex >= 0)
    {
      final oldMessage = message[messageIndex];
      final updatedMessage = oldMessage.copyWith(content: "${oldMessage.content}$messageData['content']");
      return updatedMessage;
    }
    else{
      return null;
    }
  }
}