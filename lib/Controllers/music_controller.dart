import 'package:just_audio/just_audio.dart';

class MusicController {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playLoop() async {
    try {
      await _player.setLoopMode(LoopMode.one);
      await _player.setVolume(1.0);
      await _player.setAsset('assets/Audio/bg_music.mp3');
      await _player.play();
      print("🎵 Music started");
    } catch (e) {
      print("⚠️ Error playing music: $e");
    }
  }

  static Future<void> stop() async {
    await _player.stop();
  }

  static Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  static Future<void> pause() async {
    await _player.pause();
  }

  static Future<void> resume() async {
    await _player.play();
  }
}

