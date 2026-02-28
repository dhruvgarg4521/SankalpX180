import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';

part 'achievement_model.g.dart';

@HiveType(typeId: 1)
class AchievementModel extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  String description;
  
  @HiveField(3)
  int requiredDays;
  
  @HiveField(4)
  bool isUnlocked;
  
  @HiveField(5)
  DateTime? unlockedDate;
  
  @HiveField(6)
  String icon;
  
  @HiveField(7)
  int xpReward;
  
  AchievementModel({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredDays,
    this.isUnlocked = false,
    this.unlockedDate,
    this.icon = '🏆',
    this.xpReward = 50,
  });
  
  /// Create all default achievements
  static List<AchievementModel> createDefaultAchievements() {
    return [
      AchievementModel(
        id: 'achievement_1',
        name: AppConstants.achievementNames[0],
        description: 'Your journey begins with a single day',
        requiredDays: AppConstants.achievementMilestones[0],
        icon: '🌱',
      ),
      AchievementModel(
        id: 'achievement_2',
        name: AppConstants.achievementNames[1],
        description: 'Growth starts to show',
        requiredDays: AppConstants.achievementMilestones[1],
        icon: '🌿',
      ),
      AchievementModel(
        id: 'achievement_3',
        name: AppConstants.achievementNames[2],
        description: 'Leading the way forward',
        requiredDays: AppConstants.achievementMilestones[2],
        icon: '🚀',
      ),
      AchievementModel(
        id: 'achievement_4',
        name: AppConstants.achievementNames[3],
        description: 'Building unstoppable momentum',
        requiredDays: AppConstants.achievementMilestones[3],
        icon: '⚡',
      ),
      AchievementModel(
        id: 'achievement_5',
        name: AppConstants.achievementNames[4],
        description: 'Your foundation is strong',
        requiredDays: AppConstants.achievementMilestones[4],
        icon: '🏰',
      ),
      AchievementModel(
        id: 'achievement_6',
        name: AppConstants.achievementNames[5],
        description: 'Protecting your progress',
        requiredDays: AppConstants.achievementMilestones[5],
        icon: '🛡️',
      ),
      AchievementModel(
        id: 'achievement_7',
        name: AppConstants.achievementNames[6],
        description: 'A full month of freedom',
        requiredDays: AppConstants.achievementMilestones[6],
        icon: '🌟',
      ),
      AchievementModel(
        id: 'achievement_8',
        name: AppConstants.achievementNames[7],
        description: 'Rising above challenges',
        requiredDays: AppConstants.achievementMilestones[7],
        icon: '✨',
      ),
      AchievementModel(
        id: 'achievement_9',
        name: AppConstants.achievementNames[8],
        description: 'Deep transformation achieved',
        requiredDays: AppConstants.achievementMilestones[8],
        icon: '💎',
      ),
      AchievementModel(
        id: 'achievement_10',
        name: AppConstants.achievementNames[9],
        description: 'Complete inner peace',
        requiredDays: AppConstants.achievementMilestones[9],
        icon: '🧘',
      ),
      AchievementModel(
        id: 'achievement_11',
        name: AppConstants.achievementNames[10],
        description: 'Master of your destiny',
        requiredDays: AppConstants.achievementMilestones[10],
        icon: '👑',
        xpReward: 200,
      ),
    ];
  }
  
  /// Unlock this achievement
  void unlock() {
    isUnlocked = true;
    unlockedDate = DateTime.now();
  }
  
  AchievementModel copyWith({
    String? id,
    String? name,
    String? description,
    int? requiredDays,
    bool? isUnlocked,
    DateTime? unlockedDate,
    String? icon,
    int? xpReward,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      requiredDays: requiredDays ?? this.requiredDays,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedDate: unlockedDate ?? this.unlockedDate,
      icon: icon ?? this.icon,
      xpReward: xpReward ?? this.xpReward,
    );
  }
}
