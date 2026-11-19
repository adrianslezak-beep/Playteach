import 'package:flutter_tts/flutter_tts.dart';

/// Czytanie poleceń na głos (dla dzieci, które dopiero uczą się czytać).
class Speaker {
  static final FlutterTts _tts = FlutterTts();
  static bool _ready = false;

  static Future<void> _init() async {
    if (_ready) return;
    _ready = true;
    try {
      await _tts.setLanguage('pl-PL');
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1.05);
    } catch (_) {}
  }

  static Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    try {
      await _init();
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {}
  }

  static Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
