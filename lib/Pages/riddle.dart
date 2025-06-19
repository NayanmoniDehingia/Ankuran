import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:projects/Widgets/riddle_card.dart';
import 'package:projects/Widgets/exit.dart';

class Riddle extends StatefulWidget {
  const Riddle({super.key});

  @override
  State<Riddle> createState() => _RiddleState();
}

class _RiddleState extends State<Riddle> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.dispose();
  }

  int currentRiddleIndex = 0; // keeps track of which riddle we’re on
  int? selectedIndex;         // null means no option has been selected yet
  bool isAnswered = false;    // tracks if user answered the riddle

  final List<Map<String, dynamic>> riddles = [
    {
      "questionKey": "riddleText", // key for localized string
      "options": ["assets/Images/image1.png", "assets/Images/image2.png", "assets/Images/image3.png"],
      "correctIndex": 0
    },
    {
      "questionKey": "riddleText2",
      "options": ["assets/Images/image4.jpg", "assets/Images/image5.jpg", "assets/Images/image6.jpg"],
      "correctIndex": 2
    },

  ];
  String _getLocalizedRiddleText(String key) {
    switch (key) {
      case 'riddleText':
        return AppLocalizations.of(context)!.riddleText;
      case 'riddleText2':
        return AppLocalizations.of(context)!.riddleText2;
      default:
        return '';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4E7E1),
      body:SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, -0.7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  riddles[currentRiddleIndex]['options'].length,
                      (index) => GestureDetector(
                    onTap: () {
                      if (!isAnswered) {
                        setState(() {
                          selectedIndex = index;
                          isAnswered = true;
                        });
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

            Positioned(
              left: 10,
              top: MediaQuery.of(context).size.height / 3,
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
                      ? AppLocalizations.of(context)!.correctText
                      : AppLocalizations.of(context)!.wrongMessage)
                      : _getLocalizedRiddleText(riddles[currentRiddleIndex]['questionKey']),
                  style: TextStyle(
                    fontSize: 25,
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
                top: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      currentRiddleIndex++;
                      selectedIndex = null;
                      isAnswered = false;
                    });
                  },
                  child: const Text("Next", style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ),


          ]
        ),
      )

    );
  }
}
