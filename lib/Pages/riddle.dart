import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:projects/Controllers/music_controller.dart';
import 'package:projects/Widgets/riddle_card.dart';
import 'package:projects/Widgets/exit.dart';

import '../Controllers/sfx_controller.dart';

class Riddle extends StatefulWidget {
  const Riddle({super.key});


  @override
  State<Riddle> createState() => _RiddleState();

}

class _RiddleState extends State<Riddle> {
  @override
  void initState() {
    super.initState();
    MusicController.pause();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }


  @override
  void dispose() {
      MusicController.resume();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var riddle in riddles) {
      for (var path in riddle['options']) {
        precacheImage(AssetImage(path), context);
      }
    }
  }

  int currentRiddleIndex = 0;
  int? selectedIndex;
  bool isAnswered = false;

  final List<Map<String, dynamic>> riddles = [
    {
      "questionKey": "riddleText",
      "options": ["assets/Images/image1.png", "assets/Images/image2.png", "assets/Images/image3.jpg"],
      "correctIndex": 0
    },
    {
      "questionKey": "riddleText2",
      "options": ["assets/Images/image4.jpg", "assets/Images/image5.jpg", "assets/Images/image6.jpg"],
      "correctIndex": 2
    },
    {
      "questionKey": "riddleText3",
      "options": ["assets/Images/image8.jpg", "assets/Images/image7.jpg", "assets/Images/image9.jpg"],
      "correctIndex": 1
    },
    {
      "questionKey": "riddleText4",
      "options": ["assets/Images/image10.jpg", "assets/Images/image11.jpg", "assets/Images/image12.jpg"],
      "correctIndex": 0
    },
    {
      "questionKey": "riddleText5",
      "options": ["assets/Images/image15.jpg", "assets/Images/image14.jpg", "assets/Images/image13.jpg"],
      "correctIndex": 2
    },
  ];
  String _getLocalizedRiddleText(String key) {
    switch (key) {
      case 'riddleText':
        return AppLocalizations.of(context)!.riddleText;
      case 'riddleText2':
        return AppLocalizations.of(context)!.riddleText2;
      case 'riddleText3':
        return AppLocalizations.of(context)!.riddleText3;
      case 'riddleText4':
        return AppLocalizations.of(context)!.riddleText4;
      case 'riddleText5':
        return AppLocalizations.of(context)!.riddleText5;
      default:
        return '';
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      body:SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.7),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    riddles[currentRiddleIndex]['options'].length,
                        (index) => GestureDetector(
                          onTap: () {
                            if (!isAnswered) {
                              setState(() {
                                selectedIndex = index;
                                isAnswered = true;
                              });

                              // Play sound depending on correctness
                              final isCorrect = index == riddles[currentRiddleIndex]['correctIndex'];
                              if (isCorrect) {
                                SfxController.playCorrect();
                              } else {
                                SfxController.playWrong();
                              }
                            }
                          },

                          child: RiddleCard(
                        imagePath: riddles[currentRiddleIndex]['options'][index],
                        isSelected: selectedIndex == index,
                        isCorrect: index == riddles[currentRiddleIndex]['correctIndex'],
                        isAnswered: isAnswered,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 10,
              top: MediaQuery.of(context).size.height / 2.7,
              child: const ExitButton(),
            ),


            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/Images/texture1.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 4),
                    )
                  ],
                ),
                child: Text(
                  isAnswered
                      ? (selectedIndex == riddles[currentRiddleIndex]['correctIndex']
                      ? (currentRiddleIndex == riddles.length - 1
                      ? AppLocalizations.of(context)!.endingMessage
                      : AppLocalizations.of(context)!.correctText)
                      : AppLocalizations.of(context)!.wrongMessage)
                      : _getLocalizedRiddleText(riddles[currentRiddleIndex]['questionKey']),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

              ),
            ),
            if (isAnswered && currentRiddleIndex < riddles.length - 1)
              Positioned(
                right: 20,
                top: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      SfxController.playNext();
                      currentRiddleIndex++;
                      selectedIndex = null;
                      isAnswered = false;
                    });
                  },
                  child: const Icon(Icons.navigate_next, color: Colors.black, size: 28),
                ),
              ),

            if (isAnswered && selectedIndex != riddles[currentRiddleIndex]['correctIndex'])
              Positioned(
                right: 20,
                top: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedIndex = null;
                      isAnswered = false;
                    });
                  },
                  child: const Icon(Icons.restart_alt_rounded, color: Colors.black, size: 28),
                ),
              ),



          ]
        ),
      )

    );
  }
}
