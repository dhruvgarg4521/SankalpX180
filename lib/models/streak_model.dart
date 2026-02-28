import 'package:hive/hive.dart';

part 'streak_model.g.dart';

@HiveType(typeId: 2)
class StreakModel extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  DateTime startDate;
  
  @HiveField(2)
  DateTime? endDate;
  
  @HiveField(3)
  int daysCount;
  
  @HiveField(4)
  bool isActive;
  
  @HiveField(5)
  DateTime lastUpdated;
  
  StreakModel({
    required this.id,
    required this.startDate,
    this.endDate,
    this.daysCount = 0,
    this.isActive = true,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();
  
  /// Calculate days in streak
  int calculateDays() {
    if (!isActive) {
      return daysCount;
    }
    final end = endDate ?? DateTime.now();
    return end.difference(startDate).inDays;
  }
  
  /// End the streak
  void endStreak() {
    isActive = false;
    endDate = DateTime.now();
    daysCount = calculateDays();
  }
  
  /// Reset streak
  void reset() {
    startDate = DateTime.now();
    endDate = null;
    daysCount = 0;
    isActive = true;
    lastUpdated = DateTime.now();
  }
  
  /// Update streak
  void update() {
    if (isActive) {
      daysCount = calculateDays();
      lastUpdated = DateTime.now();
    }
  }
  
  StreakModel copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    int? daysCount,
    bool? isActive,
    DateTime? lastUpdated,
  }) {
    return StreakModel(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      daysCount: daysCount ?? this.daysCount,
      isActive: isActive ?? this.isActive,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
