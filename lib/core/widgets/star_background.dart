import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Animated star background widget
class StarBackground extends StatelessWidget {
  final int starCount;
  final Widget child;
  
  const StarBackground({
    super.key,
    this.starCount = 50,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Stars
        ...List.generate(starCount, (index) {
          final random = Random(index);
          final size = random.nextDouble() * 2 + 1;
          final left = random.nextDouble() * MediaQuery.of(context).size.width;
          final top = random.nextDouble() * MediaQuery.of(context).size.height;
          final delay = random.nextDouble() * 2;
          final duration = random.nextDouble() * 3 + 2;
          
          return Positioned(
            left: left,
            top: top,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(duration: duration.ms, delay: delay.ms)
                .then()
                .fadeOut(duration: duration.ms)
                .then(),
          );
        }),
        // Content
        child,
      ],
    );
  }
}
