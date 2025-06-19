import 'package:flutter/material.dart';
import 'package:projects/Pages/colors.dart';
import 'package:projects/Widgets/exit.dart';
import 'package:projects/Controllers/music_controller.dart'; // Adjust if path differs

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isMusicOn = true;
  double _currentVolume = 1.0;

  @override
  void initState() {
    super.initState();
    // Optional: load from shared preferences
  }

  void _toggleMusic(bool value) {
    setState(() {
      isMusicOn = value;
    });
    if (isMusicOn) {
      MusicController.resume();
    } else {
      MusicController.pause();
    }
  }

  void _setVolume(double value) {
    setState(() {
      _currentVolume = value;
    });
    MusicController.setVolume(_currentVolume);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4E7E1),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Container(
              height: 500,
              width: 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SwitchListTile(
                    title: const Text("🎵 Background Music"),
                    value: isMusicOn,
                    onChanged: _toggleMusic,
                  ),
                  const SizedBox(height: 30),
                  Text("🔊 Volume: ${(_currentVolume * 100).round()}%"),
                  Slider(
                    value: _currentVolume,
                    min: 0,
                    max: 1,
                    onChanged: _setVolume,
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 80,
            child: ExitButton(),
          ),
        ],
      ),
    );
  }
}
