import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../services/streak_service.dart';

/// Provider for current user
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final userId = await UserService.getCurrentUserId();
  if (userId == null) return null;
  return UserService.getCurrentUser();
});

/// Provider for current streak days
final currentStreakProvider = FutureProvider<int>((ref) async {
  final userId = await UserService.getCurrentUserId();
  if (userId == null) return 0;
  return StreakService.getStreakDays(userId);
});

/// Provider for brain rewiring progress
final brainRewiringProgressProvider = FutureProvider<double>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  return user?.brainRewiringProgress ?? 0.0;
});

/// Provider for user XP
final userXPProvider = FutureProvider<int>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  return user?.totalXP ?? 0;
});

/// Provider for user level
final userLevelProvider = FutureProvider<int>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  return user?.level ?? 1;
});
