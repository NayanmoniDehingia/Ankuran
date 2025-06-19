import 'package:just_audio/just_audio.dart';

class SfxController {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playTap() async {
    try {
      await _player.setAsset('assets/Audio/tap.mp3');
      await _player.setVolume(1.0);
      await _player.play();
    } catch (e) {
      print("⚠️ Error playing tap sound: $e");
    }
  }
}
