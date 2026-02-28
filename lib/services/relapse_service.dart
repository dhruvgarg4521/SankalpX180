import '../models/relapse_model.dart';
import '../services/hive_service.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Service for managing relapses
class RelapseService {
  /// Log a relapse
  static Future<RelapseModel> logRelapse({
    required String userId,
    String? notes,
    String? trigger,
    int streakBeforeRelapse = 0,
    Map<String, dynamic>? metadata,
  }) async {
    final relapse = RelapseModel(
      id: _uuid.v4(),
      date: DateTime.now(),
      notes: notes,
      trigger: trigger,
      streakBeforeRelapse: streakBeforeRelapse,
      metadata: metadata,
    );
    
    await HiveService.relapseBox.put(relapse.id, relapse);
    return relapse;
  }
  
  /// Get all relapses for user
  static List<RelapseModel> getAllRelapses(String userId) {
    return HiveService.relapseBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
  
  /// Get relapse by ID
  static RelapseModel? getRelapseById(String id) {
    return HiveService.relapseBox.get(id);
  }
  
  /// Get total relapse count
  static int getTotalRelapseCount(String userId) {
    return HiveService.relapseBox.length;
  }
  
  /// Get days since last relapse
  static int? getDaysSinceLastRelapse(String userId) {
    final relapses = getAllRelapses(userId);
    if (relapses.isEmpty) return null;
    
    final lastRelapse = relapses.first;
    final now = DateTime.now();
    return now.difference(lastRelapse.date).inDays;
  }
  
  /// Delete relapse
  static Future<void> deleteRelapse(String id) async {
    await HiveService.relapseBox.delete(id);
  }
}
