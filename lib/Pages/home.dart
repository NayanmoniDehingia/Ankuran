import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projects/Pages/art_game.dart';
import 'package:projects/Pages/riddle.dart';
import 'package:projects/Pages/settings_screen.dart';
import 'package:projects/Widgets/game_card.dart';
import 'package:projects/Widgets/tap_sound.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:projects/Controllers/music_controller.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    MusicController.playLoop();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          },
          child: const Icon(Icons.settings,color:Colors.white,size:40,),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/Images/bg3.jpg',
              fit: BoxFit.cover,
            ),
          ),

          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TapSoundWrapper(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ArtGame()),
                    );
                  },
                  child: GameCard(
                    title: AppLocalizations.of(context)!.artGameTitle,
                    imagePath: 'assets/Images/art_cover.jpg',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TapSoundWrapper(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Riddle()),
                    );
                  },
                  child: GameCard(
                    title: AppLocalizations.of(context)!.riddleGameTitle,
                    imagePath: 'assets/Images/questions.png',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
