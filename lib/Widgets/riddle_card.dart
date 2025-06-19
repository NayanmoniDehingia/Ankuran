import 'package:flutter/material.dart';

class RiddleCard extends StatelessWidget {
  final String imagePath;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;

  const RiddleCard({
    super.key,
    required this.imagePath,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
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
        border: isAnswered
            ? Border.all(
          color: isCorrect
              ? Colors.green
              : (isSelected ? Colors.red : Colors.transparent),
          width: 4,
        )
            : null,
      ),
    );
  }
}
