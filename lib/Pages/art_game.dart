import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projects/Widgets/exit.dart';
import 'package:projects/Widgets/color_palette.dart';
import 'package:projects/Widgets/art_canvas.dart';
import 'package:projects/Pages/art_gallery.dart';


class ArtGame extends StatefulWidget {
  const ArtGame({super.key});

  @override
  State<ArtGame> createState() => _ArtGameState();
}

class _ArtGameState extends State<ArtGame> {
  Color selectedColor = Colors.red;

  final List<Color> paletteColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.pink,
    Colors.black,
    Colors.white,
  ];

  final List<String> imagePaths = [
    'assets/Images/crab.png',
    'assets/Images/art2.png',
    'assets/Images/owl.png',
    'assets/Images/mandala.png',
    'assets/Images/lizard.png',
  ];
  final GlobalKey<ArtCanvasState> _canvasKey = GlobalKey<ArtCanvasState>();


  int currentIndex = 0;

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

  void goToNextImage() {
    setState(() {
      currentIndex = (currentIndex + 1) % imagePaths.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4E7E1),
      body: Stack(
        children: [
          // Exit button
          Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height / 2.3,
            child: const ExitButton(),
          ),

          // Art canvas
          Positioned(
            left: 180,
            top: 30,
            width: 300,
            height: 300,
            child: ArtCanvas(
              key: _canvasKey,
              selectedColor: selectedColor,
              imagePath: imagePaths[currentIndex],
            ),
          ),

          // Next image button
          Positioned(
            right: 40,
            top: 30,
            child: GestureDetector(
              onTap: goToNextImage,
              child: _roundButton(Icons.navigate_next),
            ),
          ),

          // Save button
          Positioned(
            right: 40,
            top: 100,
            child: GestureDetector(
              onTap: () {
                _canvasKey.currentState?.saveArtwork();
              },
              child: _roundButton(Icons.save),
            ),
          ),
          Positioned(
            right: 110,
            top:30 ,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ArtGallery()),
                  );
                },
                child: _roundButton(Icons.file_copy_outlined),
                
              ),
          ),
          // Color palette
          Positioned(
            right: 30,
            top: 200,
            child: ColorPalette(
              colors: paletteColors,
              selectedColor: selectedColor,
              onColorSelected: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            offset: const Offset(4.0, 4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-4.0, -4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Icon(icon, size: 28),
    );
  }
}
