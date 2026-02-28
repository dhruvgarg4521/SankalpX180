import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/streak_model.dart';
import '../models/user_model.dart';
import '../services/hive_service.dart';
import '../core/utils/date_utils.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Service for managing user streaks
class StreakService {
  /// Get current active streak
  static StreakModel? getCurrentStreak(String userId) {
    final streaks = HiveService.streakBox.values
        .where((s) => s.isActive)
        .toList();
    
    if (streaks.isEmpty) return null;
    
    // Get the most recent active streak
    streaks.sort((a, b) => b.startDate.compareTo(a.startDate));
    return streaks.first;
  }
  
  /// Start a new streak
  static StreakModel startStreak(String userId) {
    final existingStreak = getCurrentStreak(userId);
    if (existingStreak != null && existingStreak.isActive) {
      return existingStreak;
    }
    
    final newStreak = StreakModel(
      id: _uuid.v4(),
      startDate: DateTime.now(),
      isActive: true,
    );
    
    HiveService.streakBox.put(newStreak.id, newStreak);
    return newStreak;
  }
  
  /// Update streak (call daily)
  static void updateStreak(String userId) {
    final streak = getCurrentStreak(userId);
    if (streak != null) {
      streak.update();
      HiveService.streakBox.put(streak.id, streak);
    }
  }
  
  /// End current streak
  static void endStreak(String userId) {
    final streak = getCurrentStreak(userId);
    if (streak != null) {
      streak.endStreak();
      HiveService.streakBox.put(streak.id, streak);
    }
  }
  
  /// Get streak count in days
  static int getStreakDays(String userId) {
    final streak = getCurrentStreak(userId);
    if (streak == null) return 0;
    return streak.calculateDays();
  }
  
  /// Get longest streak
  static int getLongestStreak(String userId) {
    final allStreaks = HiveService.streakBox.values
        .where((s) => !s.isActive)
        .toList();
    
    if (allStreaks.isEmpty) return 0;
    
    final longest = allStreaks
        .map((s) => s.daysCount)
        .reduce((a, b) => a > b ? a : b);
    
    return longest;
  }
  
  /// Check if streak is still valid (user checked in today)
  static bool isStreakValid(String userId) {
    final streak = getCurrentStreak(userId);
    if (streak == null) return false;
    
    final now = DateTime.now();
    final lastUpdate = streak.lastUpdated;
    
    // Check if streak was updated today
    return lastUpdate.year == now.year &&
        lastUpdate.month == now.month &&
        lastUpdate.day == now.day;
  }
  
  /// Get all streaks for user
  static List<StreakModel> getAllStreaks(String userId) {
    return HiveService.streakBox.values.toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }
}

/// Riverpod provider for streak service
final streakServiceProvider = Provider<StreakService>((ref) => StreakService());
