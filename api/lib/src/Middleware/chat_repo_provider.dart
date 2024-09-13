import 'package:api/src/repositories/Chat_Repo.dart';
import 'package:dart_frog/dart_frog.dart';

final _chatRepo = ChatRepo();

Middleware ChatRepoProvider()
{
  return provider<ChatRepo>((_) => _chatRepo);
}