import 'package:flutter/material.dart';
import 'package:projects/Controllers/music_controller.dart';
import 'package:projects/Pages/colors.dart';
import 'package:projects/main.dart'; //
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isMusicOn = true;
  double _currentVolume = 1.0;
  String _selectedLang = localeNotifier.value.languageCode;

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

  void _changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode);

    setState(() {
      _selectedLang = langCode;
      localeNotifier.value = Locale(langCode);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/Images/buriai.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Opacity(
              opacity: 0.85,
              child: Container(
                height: 540,
                width: 320,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SwitchListTile(
                      title: Text(AppLocalizations.of(context)!.voc),
                      value: isMusicOn,
                      onChanged: _toggleMusic,
                    ),
                    const SizedBox(height: 20),
                    Text(AppLocalizations.of(context)!.vol),
                    Slider(
                      value: _currentVolume,
                      min: 0,
                      max: 1,
                      onChanged: _setVolume,
                    ),
                    const Divider(height: 30),
                    Text("🌐 ${AppLocalizations.of(context)!.language}"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          label: const Text("English"),
                          selected: _selectedLang == 'en',
                          onSelected: (selected) {
                            if (selected) _changeLanguage('en');
                          },
                        ),
                        const SizedBox(width: 10),
                        ChoiceChip(
                          label: const Text("অসমীয়া"),
                          selected: _selectedLang == 'as',
                          onSelected: (selected) {
                            if (selected) _changeLanguage('as');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
