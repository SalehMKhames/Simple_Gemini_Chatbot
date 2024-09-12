import 'package:model/src/message.dart';

class ChatRepo
{
  //Store all the messages in a map with the chatroom id as the key
  final Map<String, List<Message>> _chatrooms ={};

  Future<Message> createUserMessage(String chatRoomId, Map<String, dynamic> data) async
  {
    throw UnimplementedError();
  }

  Stream<Message> createModelMessage(String chatRoomId, Map<String, dynamic> data)
  {
    throw UnimplementedError();
  }


}