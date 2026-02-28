import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/hive_service.dart';
import '../services/streak_service.dart';
import '../services/achievement_service.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _uuid = Uuid();

/// Service for managing user data
class UserService {
  static const String _currentUserIdKey = 'current_user_id';
  
  /// Get current user ID from preferences
  static Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserIdKey);
  }
  
  /// Set current user ID
  static Future<void> setCurrentUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserIdKey, userId);
  }
  
  /// Get current user
  static UserModel? getCurrentUser() {
    final userId = getCurrentUserId();
    if (userId == null) return null;
    
    return HiveService.userBox.get(userId.toString());
  }
  
  /// Create anonymous user
  static Future<UserModel> createAnonymousUser(String username) async {
    final userId = _uuid.v4();
    final user = UserModel(
      id: userId,
      username: username,
      isAnonymous: true,
      joinDate: DateTime.now(),
    );
    
    await HiveService.userBox.put(userId, user);
    await setCurrentUserId(userId);
    
    // Start initial streak
    StreakService.startStreak(userId);
    
    // Initialize achievements
    await AchievementService.initializeAchievements();
    
    return user;
  }
  
  /// Create user with email
  static Future<UserModel> createUser({
    required String username,
    required String email,
  }) async {
    final userId = _uuid.v4();
    final user = UserModel(
      id: userId,
      username: username,
      email: email,
      isAnonymous: false,
      joinDate: DateTime.now(),
    );
    
    await HiveService.userBox.put(userId, user);
    await setCurrentUserId(userId);
    
    // Start initial streak
    StreakService.startStreak(userId);
    
    // Initialize achievements
    await AchievementService.initializeAchievements();
    
    return user;
  }
  
  /// Update user
  static Future<void> updateUser(UserModel user) async {
    await HiveService.userBox.put(user.id, user);
  }
  
  /// Update streak and check achievements
  static Future<void> updateStreakAndAchievements(String userId) async {
    final user = getCurrentUser();
    if (user == null) return;
    
    // Update streak
    StreakService.updateStreak(userId);
    final streakDays = StreakService.getStreakDays(userId);
    
    // Update user streak
    final updatedUser = user.copyWith(
      currentStreak: streakDays,
      longestStreak: StreakService.getLongestStreak(userId),
    );
    
    // Update brain rewiring progress
    updatedUser.updateBrainRewiringProgress(streakDays);
    
    // Check and unlock achievements
    final unlockedAchievements = AchievementService.checkAndUnlockAchievements(streakDays);
    
    // Add XP for unlocked achievements
    for (final achievement in unlockedAchievements) {
      updatedUser.addXP(achievement.xpReward);
    }
    
    // Add daily XP
    if (!user.hasCheckedInToday()) {
      updatedUser.performCheckIn();
      updatedUser.addXP(10); // Daily streak XP
    }
    
    await updateUser(updatedUser);
  }
  
  /// Handle relapse
  static Future<void> handleRelapse(String userId, {String? notes, String? trigger}) async {
    final user = getCurrentUser();
    if (user == null) return;
    
    // End current streak
    StreakService.endStreak(userId);
    
    // Update user
    final updatedUser = user.copyWith(
      currentStreak: 0,
      totalRelapses: user.totalRelapses + 1,
    );
    
    await updateUser(updatedUser);
    
    // Start new streak
    StreakService.startStreak(userId);
  }
  
  /// Get user by ID
  static UserModel? getUserById(String userId) {
    return HiveService.userBox.get(userId);
  }
  
  /// Check if user exists
  static bool userExists() {
    return HiveService.userBox.isNotEmpty;
  }
}

/// Riverpod provider for user service
final userServiceProvider = Provider<UserService>((ref) => UserService());
