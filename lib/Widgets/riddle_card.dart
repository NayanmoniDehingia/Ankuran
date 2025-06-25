import 'package:flutter/material.dart';
import 'dart:math';

class RiddleCard extends StatefulWidget {
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
  State<RiddleCard> createState() => _RiddleCardState();
}

class _RiddleCardState extends State<RiddleCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0, end: -15)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_controller);

    _shakeAnimation = Tween<double>(begin: -5, end: 5)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_controller);

    if (widget.isAnswered) {
      _controller.forward();
    }
  }


  @override
  void didUpdateWidget(covariant RiddleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnswered && !oldWidget.isAnswered) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth / 5;
    final cardHeight = cardWidth * 1.1;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double translateY = 0;
        double translateX = 0;

        if (widget.isAnswered) {
          if (widget.isSelected && widget.isCorrect) {
            translateY = _bounceAnimation.value;
          } else if (widget.isSelected && !widget.isCorrect) {
            translateX = _shakeAnimation.value * sin(_controller.value * pi * 4);
          }
        }

        return Transform.translate(
          offset: Offset(translateX, translateY),
          child: Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.isAnswered
                    ? widget.isSelected
                    ? (widget.isCorrect ? Colors.yellow : Colors.red)
                    : (widget.isCorrect ? Colors.yellow : Colors.transparent)
                    : Colors.transparent,
                width: widget.isSelected ? 4 : 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow:  [
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
