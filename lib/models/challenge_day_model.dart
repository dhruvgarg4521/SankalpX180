import 'package:hive/hive.dart';

part 'challenge_day_model.g.dart';

@HiveType(typeId: 5)
class ChallengeDayModel extends HiveObject {
  @HiveField(0)
  int dayNumber;
  
  @HiveField(1)
  bool isCompleted;
  
  @HiveField(2)
  DateTime? completedDate;
  
  @HiveField(3)
  String? notes;
  
  @HiveField(4)
  int xpEarned;
  
  ChallengeDayModel({
    required this.dayNumber,
    this.isCompleted = false,
    this.completedDate,
    this.notes,
    this.xpEarned = 0,
  });
  
  /// Mark day as completed
  void markCompleted({String? notes}) {
    isCompleted = true;
    completedDate = DateTime.now();
    this.notes = notes;
    xpEarned = 10; // Base XP per day
  }
  
  ChallengeDayModel copyWith({
    int? dayNumber,
    bool? isCompleted,
    DateTime? completedDate,
    String? notes,
    int? xpEarned,
  }) {
    return ChallengeDayModel(
      dayNumber: dayNumber ?? this.dayNumber,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
      notes: notes ?? this.notes,
      xpEarned: xpEarned ?? this.xpEarned,
    );
  }
}
