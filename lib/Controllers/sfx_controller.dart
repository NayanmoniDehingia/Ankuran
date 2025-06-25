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
  static Future<void> playCorrect() async {
    try {
      await _player.setAsset('assets/Audio/sparkle.mp3');
      await _player.setVolume(1.0);
      await _player.play();
    } catch (e) {
      print("⚠️ Error playing tap sound: $e");
    }
  }
  static Future<void> playWrong() async {
    try {
      await _player.setAsset('assets/Audio/boing.mp3');
      await _player.setVolume(1.0);
      await _player.play();
    } catch (e) {
      print("⚠️ Error playing tap sound: $e");
    }
  }
  static Future<void> playNext() async {
    try {
      await _player.setAsset('assets/Audio/swoosh.mp3');
      await _player.setSpeed(4.5);
      await _player.play();
    } catch (e) {
      print("⚠️ Error playing tap sound: $e");
    }
  }

}
