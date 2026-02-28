import 'package:hive/hive.dart';

part 'relapse_model.g.dart';

@HiveType(typeId: 3)
class RelapseModel extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  DateTime date;
  
  @HiveField(2)
  String? notes;
  
  @HiveField(3)
  String? trigger;
  
  @HiveField(4)
  int streakBeforeRelapse;
  
  @HiveField(5)
  Map<String, dynamic>? metadata;
  
  RelapseModel({
    required this.id,
    required this.date,
    this.notes,
    this.trigger,
    this.streakBeforeRelapse = 0,
    this.metadata,
  });
  
  RelapseModel copyWith({
    String? id,
    DateTime? date,
    String? notes,
    String? trigger,
    int? streakBeforeRelapse,
    Map<String, dynamic>? metadata,
  }) {
    return RelapseModel(
      id: id ?? this.id,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      trigger: trigger ?? this.trigger,
      streakBeforeRelapse: streakBeforeRelapse ?? this.streakBeforeRelapse,
      metadata: metadata ?? this.metadata,
    );
  }
}
