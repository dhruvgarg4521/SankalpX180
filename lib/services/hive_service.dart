import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/achievement_model.dart';
import '../models/streak_model.dart';
import '../models/relapse_model.dart';
import '../models/community_post_model.dart';
import '../models/challenge_day_model.dart';

/// Service for managing Hive database initialization and boxes
class HiveService {
  static bool _initialized = false;
  
  /// Initialize Hive and register adapters
  static Future<void> init() async {
    if (_initialized) return;
    
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(AchievementModelAdapter());
    Hive.registerAdapter(StreakModelAdapter());
    Hive.registerAdapter(RelapseModelAdapter());
    Hive.registerAdapter(CommunityPostModelAdapter());
    Hive.registerAdapter(ChallengeDayModelAdapter());
    
    // Open boxes
    await Hive.openBox<UserModel>(AppConstants.userBoxName);
    await Hive.openBox<AchievementModel>(AppConstants.achievementBoxName);
    await Hive.openBox<StreakModel>(AppConstants.streakBoxName);
    await Hive.openBox<RelapseModel>(AppConstants.relapseBoxName);
    await Hive.openBox<CommunityPostModel>(AppConstants.communityBoxName);
    await Hive.openBox(AppConstants.settingsBoxName);
    
    _initialized = true;
  }
  
  /// Get user box
  static Box<UserModel> get userBox => 
      Hive.box<UserModel>(AppConstants.userBoxName);
  
  /// Get achievement box
  static Box<AchievementModel> get achievementBox => 
      Hive.box<AchievementModel>(AppConstants.achievementBoxName);
  
  /// Get streak box
  static Box<StreakModel> get streakBox => 
      Hive.box<StreakModel>(AppConstants.streakBoxName);
  
  /// Get relapse box
  static Box<RelapseModel> get relapseBox => 
      Hive.box<RelapseModel>(AppConstants.relapseBoxName);
  
  /// Get community box
  static Box<CommunityPostModel> get communityBox => 
      Hive.box<CommunityPostModel>(AppConstants.communityBoxName);
  
  /// Get settings box
  static Box get settingsBox => Hive.box(AppConstants.settingsBoxName);
  
  /// Clear all data (for testing/reset)
  static Future<void> clearAll() async {
    await userBox.clear();
    await achievementBox.clear();
    await streakBox.clear();
    await relapseBox.clear();
    await communityBox.clear();
    await settingsBox.clear();
  }
  
  /// Close all boxes
  static Future<void> closeAll() async {
    await Hive.close();
    _initialized = false;
  }
}
