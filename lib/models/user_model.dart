import 'dart:math';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String username;
  
  @HiveField(2)
  String? email;
  
  @HiveField(3)
  bool isAnonymous;
  
  @HiveField(4)
  DateTime joinDate;
  
  @HiveField(5)
  int totalXP;
  
  @HiveField(6)
  int level;
  
  @HiveField(7)
  bool isPremium;
  
  @HiveField(8)
  DateTime? premiumExpiryDate;
  
  @HiveField(9)
  Map<String, dynamic> preferences;
  
  @HiveField(10)
  int currentStreak;
  
  @HiveField(11)
  int longestStreak;
  
  @HiveField(12)
  DateTime? lastCheckIn;
  
  @HiveField(13)
  int totalRelapses;
  
  @HiveField(14)
  double brainRewiringProgress;
  
  UserModel({
    required this.id,
    required this.username,
    this.email,
    this.isAnonymous = false,
    required this.joinDate,
    this.totalXP = 0,
    this.level = 1,
    this.isPremium = false,
    this.premiumExpiryDate,
    Map<String, dynamic>? preferences,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCheckIn,
    this.totalRelapses = 0,
    this.brainRewiringProgress = 0.0,
  }) : preferences = preferences ?? {};
  
  /// Calculate level from XP
  int calculateLevel() {
    // Level formula: level = sqrt(XP / 100)
    return (sqrt(totalXP / 100)).floor() + 1;
  }
  
  /// Get XP needed for next level
  int getXPForNextLevel() {
    final nextLevel = level + 1;
    return (nextLevel * nextLevel * 100) - totalXP;
  }
  
  /// Add XP and update level
  void addXP(int amount) {
    totalXP += amount;
    final newLevel = calculateLevel();
    if (newLevel > level) {
      level = newLevel;
    }
  }
  
  /// Update brain rewiring progress
  void updateBrainRewiringProgress(int daysClean) {
    brainRewiringProgress = (daysClean / 90 * 100).clamp(0.0, 100.0);
  }
  
  /// Check if user has checked in today
  bool hasCheckedInToday() {
    if (lastCheckIn == null) return false;
    final now = DateTime.now();
    return lastCheckIn!.year == now.year &&
        lastCheckIn!.month == now.month &&
        lastCheckIn!.day == now.day;
  }
  
  /// Perform daily check-in
  void performCheckIn() {
    lastCheckIn = DateTime.now();
    if (!hasCheckedInToday()) {
      addXP(5); // XP for check-in
    }
  }
  
  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    bool? isAnonymous,
    DateTime? joinDate,
    int? totalXP,
    int? level,
    bool? isPremium,
    DateTime? premiumExpiryDate,
    Map<String, dynamic>? preferences,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastCheckIn,
    int? totalRelapses,
    double? brainRewiringProgress,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      joinDate: joinDate ?? this.joinDate,
      totalXP: totalXP ?? this.totalXP,
      level: level ?? this.level,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiryDate: premiumExpiryDate ?? this.premiumExpiryDate,
      preferences: preferences ?? this.preferences,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      totalRelapses: totalRelapses ?? this.totalRelapses,
      brainRewiringProgress: brainRewiringProgress ?? this.brainRewiringProgress,
    );
  }
}
