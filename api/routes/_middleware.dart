import 'package:dart_frog/dart_frog.dart';

import '../lib/src/Middleware/chat_repo_provider.dart';

Handler middleware(Handler handler)
{
    return handler.use(requestLogger()).use(ChatRepoProvider());
}