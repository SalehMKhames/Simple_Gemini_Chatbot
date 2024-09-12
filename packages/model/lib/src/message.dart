import 'package:equatable/equatable.dart';
import 'package:model/src/message_source_type.dart';

class Message extends Equatable {
  final String id;
  final String content;
  final MessageSourceType sourceType;
  final DateTime createdAt;

  const Message(
      {required this.id,
      required this.content,
      required this.sourceType,
      required this.createdAt});

  Message copyWith(String? id, String? content, MessageSourceType? sourceType, DateTime? createdAt)
  {
    return Message
      (
        id: id ?? this.id,
        content: content ??  this.content,
        sourceType: sourceType ?? this.sourceType,
        createdAt: createdAt ?? this.createdAt
      );
  }

  factory Message.fromJson(Map<String, dynamic> json, {String? id})
  {
    return Message
    (
        id: id ?? json['id'] ?? '',
        content: json['content'],
        sourceType: MessageSourceType.values[json['sourceType']],
        createdAt: DateTime.parse(json['createdAt'])
    );
  }

  Map<String, dynamic> toJson()
  {
    return {
      'id': id,
      'content': content,
      'sourceType': sourceType,
      'createdAt': createdAt
    };
  }

  @override
  List<Object?> get props => [id, content, sourceType, createdAt];
}
