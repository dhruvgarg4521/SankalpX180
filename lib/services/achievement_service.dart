import '../models/achievement_model.dart';
import '../services/hive_service.dart';
import '../core/constants/app_constants.dart';

/// Service for managing achievements
class AchievementService {
  /// Initialize default achievements if not exists
  static Future<void> initializeAchievements() async {
    if (HiveService.achievementBox.isEmpty) {
      final achievements = AchievementModel.createDefaultAchievements();
      for (final achievement in achievements) {
        await HiveService.achievementBox.put(achievement.id, achievement);
      }
    }
  }
  
  /// Get all achievements
  static List<AchievementModel> getAllAchievements() {
    return HiveService.achievementBox.values.toList()
      ..sort((a, b) => a.requiredDays.compareTo(b.requiredDays));
  }
  
  /// Get unlocked achievements
  static List<AchievementModel> getUnlockedAchievements() {
    return getAllAchievements()
        .where((a) => a.isUnlocked)
        .toList();
  }
  
  /// Get locked achievements
  static List<AchievementModel> getLockedAchievements() {
    return getAllAchievements()
        .where((a) => !a.isUnlocked)
        .toList();
  }
  
  /// Check and unlock achievements based on streak days
  static List<AchievementModel> checkAndUnlockAchievements(int streakDays) {
    final unlocked = <AchievementModel>[];
    final achievements = getAllAchievements();
    
    for (final achievement in achievements) {
      if (!achievement.isUnlocked && streakDays >= achievement.requiredDays) {
        achievement.unlock();
        HiveService.achievementBox.put(achievement.id, achievement);
        unlocked.add(achievement);
      }
    }
    
    return unlocked;
  }
  
  /// Get achievement by ID
  static AchievementModel? getAchievementById(String id) {
    return HiveService.achievementBox.get(id);
  }
  
  /// Get next achievement to unlock
  static AchievementModel? getNextAchievement(int currentStreak) {
    final achievements = getAllAchievements();
    return achievements.firstWhere(
      (a) => !a.isUnlocked && a.requiredDays > currentStreak,
      orElse: () => achievements.last,
    );
  }
  
  /// Get achievement progress percentage
  static double getAchievementProgress(int currentStreak, int requiredDays) {
    if (currentStreak >= requiredDays) return 100.0;
    return (currentStreak / requiredDays * 100).clamp(0.0, 100.0);
  }
}
