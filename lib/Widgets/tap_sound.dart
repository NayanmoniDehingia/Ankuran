import 'package:flutter/material.dart';
import 'package:projects/Controllers/sfx_controller.dart';
class TapSoundWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const TapSoundWrapper({required this.child, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await SfxController.playTap();
        onTap();
      },
      child: child,
    );
  }
}
