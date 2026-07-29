import 'package:web/web.dart' as web;

void speakImpl(String text, {String lang = 'ko-KR'}) {
  final synth = web.window.speechSynthesis;
  final utter = web.SpeechSynthesisUtterance(text);
  utter.lang = lang;
  synth.cancel();
  synth.speak(utter);
}
