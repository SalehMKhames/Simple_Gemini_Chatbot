import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
final class Env
{
  @EnviedField(obfuscate: true)
  static String Gemini_API_KEY = _Env.Gemini_API_KEY;
}