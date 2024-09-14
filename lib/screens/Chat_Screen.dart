import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:real_time_gemini_ai_chatbot/colors.dart';
import 'package:model/src/message.dart';
import 'package:real_time_gemini_ai_chatbot/main.dart';
import 'package:real_time_gemini_ai_chatbot/screens/widgets/MessageCard.dart';
import 'package:uuid/uuid.dart';
import 'package:model/src/message_source_type.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
{
  final TextEditingController? _textController = TextEditingController();
  List<Message> messages = [];

  @override
  initState(){
    _startWebSocket();
    super.initState();
  }

  _startWebSocket() {
    webSocketClient.connect('ws://localhost:8080/ws', {'Authorization' : 'Bearer ...'});
  }

  _createMessage(Message message) async{
    await chatRepo.createMessage(message);
  }

  @override
  Widget build(BuildContext context)
  {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar
      (
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: RichText(
            text: TextSpan(
                text: 'Chat with ',
                style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                children: [
                  TextSpan(
                    text: 'Gemini',
                    style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: primary),
                  ),
                ]
            ),
        )
        .animate(onComplete: (controller) => controller.repeat)
        .shimmer(duration: const Duration(milliseconds: 3000), delay: const Duration(milliseconds: 1000)),
      ),

      body: ListView.builder
      (
        padding: const EdgeInsets.all(10),
        itemCount: messages.length,
        itemBuilder: (context, index){
          final message = messages[index];
          return MessageCard(message: message);
        }
      ),

      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF030303),
        child: Row
        (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
          [
            Expanded(
              child: TextFormField
              (
                controller: _textController,
                decoration: const InputDecoration
                  (
                    hintText: "Type your message",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(borderSide: BorderSide.none)
                  ),
              ),
            ),
            IconButton
            (
              onPressed: (){
                final message = Message
                (
                  id: const Uuid().v4(),
                  content: _textController!.text,
                  sourceType: MessageSourceType.user,
                  createdAt: DateTime.now(),
                );

                setState(() {
                  messages.add(message);
                });
                _createMessage(message);
                _textController.clear();
              },
              icon: const Icon(Icons.send_rounded, color: Colors.white60,),
            ),
          ],
        ),
      ),
    );
  }
}
