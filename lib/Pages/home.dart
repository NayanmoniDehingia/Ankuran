import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projects/Pages/art_game.dart';
import 'package:projects/Pages/riddle.dart';
import 'package:projects/Pages/settings_screen.dart';
import 'package:projects/Controllers/music_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:projects/Pages/profile.dart';
import '../Controllers/sfx_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;
  int _avatarIndex = 1;
  String _userName = "Jumon!";

  final List<String> avatarPaths = [
    'assets/Images/avatar1.png',
    'assets/Images/avatar2.png',
    'assets/Images/avatar3.png',
    'assets/Images/avatar5.png',
    'assets/Images/avatar6.png',
    'assets/Images/avatar7.png',
    'assets/Images/avatar8.png',
    'assets/Images/avatar9.png',
    'assets/Images/avatar10.png',
    'assets/Images/avatar11.png',
  ];

  @override
  void initState() {
    super.initState();
    MusicController.playLoop();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarIndex = prefs.getInt('avatarIndex') ?? 1;
      _userName = prefs.getString('userName') ?? "Jumon!";
    });
  }

  Widget _buildMainContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(avatarPaths[_avatarIndex]),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.play,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  _userName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildGameCard(
                  icon: Icons.brush,
                  title: AppLocalizations.of(context)!.artGameTitle,
                  color: Colors.blue.shade100,
                  subtitle:AppLocalizations.of(context)!.sub2,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ArtGame()));
                  },
                ),
                _buildGameCard(
                  icon: Icons.question_mark,
                  title: AppLocalizations.of(context)!.riddleGameTitle,
                  color: Colors.orange,
                  subtitle:AppLocalizations.of(context)!.sub3,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const Riddle()));
                  },
                ),
                _buildGameCard(
                  icon: Icons.rowing,
                  title: AppLocalizations.of(context)!.boat,
                  color: Colors.yellow.shade100,
                  subtitle:AppLocalizations.of(context)!.sub1,
                  onTap: () {},
                ),
                _buildGameCard(
                  icon: Icons.remove_red_eye_sharp,
                  title: AppLocalizations.of(context)!.seekGame,
                  subtitle:AppLocalizations.of(context)!.sub1,
                  color: Colors.green.shade100,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 55),
        ],
      ),
    );

  }

  Widget _buildGameCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Opacity(
      opacity: 0.8,
      child: GestureDetector(
        onTap: () async {
          await SfxController.playTap(); // Play the tap sound
          onTap(); // Then navigate
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange[200],
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.orange[700]),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.brown,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/Images/buriai.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: _selectedIndex == 1
                ? _buildMainContent(context)
                : _selectedIndex == 0
                ? const SettingsScreen()
                : const Profile(),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60,
        backgroundColor: Colors.transparent,
        color: Colors.orange,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.settings, size: 30),
          Icon(Icons.home, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) async {
          if (index == 1) {
            _loadProfileData();
          }
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
