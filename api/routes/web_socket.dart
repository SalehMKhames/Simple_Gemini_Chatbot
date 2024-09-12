import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

Future<Response> onRequest(RequestContext context) async
{
  final handler = webSocketHandler((channel, protocol)
  {
    channel.stream.listen((message){
      print('Received message from the client: $message');
      //TODO: Server sends the data back to the client
      channel.sink.add('Received message: $message');
    });

    try{
      //TODO: Check what is the input from the client and Do something with the input
      //Save it and use the Gemini API (via Chat Repository)
    }
    catch(err){}
  });
  return Response(body: 'Welcome to Dart Frog!');
}
