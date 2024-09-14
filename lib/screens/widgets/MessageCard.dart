import 'package:flutter/material.dart';
import 'package:model/src/message.dart';
import 'package:model/src/message_source_type.dart';
import 'package:real_time_gemini_ai_chatbot/colors.dart';

class MessageCard extends StatelessWidget
{
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context)
  {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.sizeOf(context);
    final color = message.sourceType == MessageSourceType.user ? primary : secondary;
    final align = message.sourceType == MessageSourceType.user ? MainAxisAlignment.end : MainAxisAlignment.start;
    final avatar = CircleAvatar(
      backgroundColor: color,
      child: Text(
        message.sourceType == MessageSourceType.user ? 'U' : 'G',
        style: textTheme.bodyLarge,
      ),
    );

    return Row
    (
      mainAxisAlignment: align,
      children:
      [
        if(message.sourceType == MessageSourceType.model) avatar,
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
          constraints: BoxConstraints(maxWidth: size.width * 0.6),
          child: Text(message.content),
        ),
        if(message.sourceType == MessageSourceType.user) avatar,
      ],
    );
  }
}
