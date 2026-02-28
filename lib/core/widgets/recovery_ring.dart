import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

/// Circular recovery ring showing streak progress
class RecoveryRing extends StatelessWidget {
  final int currentStreak;
  final int targetDays;
  final double size;
  
  const RecoveryRing({
    super.key,
    required this.currentStreak,
    this.targetDays = 180,
    this.size = 200,
  });
  
  @override
  Widget build(BuildContext context) {
    final progress = (currentStreak / targetDays).clamp(0.0, 1.0);
    final angle = progress * 2 * 3.14159;
    
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.surfaceDark,
                width: 12,
              ),
            ),
          ),
          // Progress arc
          CustomPaint(
            size: Size(size, size),
            painter: RecoveryRingPainter(
              progress: progress,
              color: AppTheme.accentBlue,
            ),
          ),
          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$currentStreak',
                style: TextStyle(
                  fontSize: size * 0.25,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
              Text(
                'Days Clean',
                style: TextStyle(
                  fontSize: size * 0.08,
                  color: AppTheme.textSecondary,
                ),
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms),
            ],
          ),
        ],
      ),
    );
  }
}

class RecoveryRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  
  RecoveryRingPainter({
    required this.progress,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    
    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // Start from top (-90 degrees)
      progress * 2 * 3.14159,
      false,
      paint,
    );
  }
  
  @override
  bool shouldRepaint(RecoveryRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
