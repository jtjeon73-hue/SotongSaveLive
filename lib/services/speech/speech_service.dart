import 'speech_service_stub.dart'
    if (dart.library.js_interop) 'speech_service_web.dart'
    as impl;

abstract class SpeechService {
  static void speak(String text, {String lang = 'ko-KR'}) =>
      impl.speakImpl(text, lang: lang);
}
