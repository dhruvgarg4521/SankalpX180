import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/achievement_model.dart';
import '../../core/theme/app_theme.dart';

/// Achievement badge widget
class AchievementBadge extends StatelessWidget {
  final AchievementModel achievement;
  final double size;
  final VoidCallback? onTap;
  
  const AchievementBadge({
    super.key,
    required this.achievement,
    this.size = 80,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: achievement.isUnlocked
              ? AppTheme.surfaceDark
              : AppTheme.surfaceDark.withOpacity(0.5),
          border: Border.all(
            color: achievement.isUnlocked
                ? AppTheme.gold
                : AppTheme.textTertiary,
            width: 2,
          ),
          boxShadow: achievement.isUnlocked
              ? [
                  BoxShadow(
                    color: AppTheme.gold.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Icon
            Text(
              achievement.icon,
              style: TextStyle(fontSize: size * 0.4),
            )
                .animate(target: achievement.isUnlocked ? 1 : 0)
                .scale(duration: 600.ms, begin: const Offset(0.5, 0.5))
                .then()
                .shake(duration: 400.ms),
            // Lock overlay
            if (!achievement.isUnlocked)
              Icon(
                Icons.lock,
                size: size * 0.3,
                color: AppTheme.textTertiary,
              ),
          ],
        ),
      ),
    );
  }
}
