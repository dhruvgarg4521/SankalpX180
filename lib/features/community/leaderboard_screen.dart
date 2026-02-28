import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/star_background.dart';
import '../../services/hive_service.dart';
import '../../models/user_model.dart';
import '../../services/streak_service.dart';

/// Leaderboard screen showing top users by streak
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Get all users and sort by streak
    final users = HiveService.userBox.values.toList();
    users.sort((a, b) => b.currentStreak.compareTo(a.currentStreak));
    final topUsers = users.take(100).toList();
    
    return Scaffold(
      body: StarBackground(
        child: Container(
          decoration: AppTheme.gradientBackground,
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Leaderboard',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                
                // Top 3 Podium
                if (topUsers.length >= 3) _TopThreePodium(topUsers: topUsers),
                
                // List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: topUsers.length,
                    itemBuilder: (context, index) {
                      final user = topUsers[index];
                      final rank = index + 1;
                      
                      return _LeaderboardItem(
                        user: user,
                        rank: rank,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopThreePodium extends StatelessWidget {
  final List<UserModel> topUsers;
  
  const _TopThreePodium({required this.topUsers});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          if (topUsers.length >= 2)
            _PodiumItem(
              user: topUsers[1],
              rank: 2,
              height: 80,
              color: AppTheme.textTertiary,
            ),
          // 1st place
          _PodiumItem(
            user: topUsers[0],
            rank: 1,
            height: 120,
            color: AppTheme.gold,
          ),
          // 3rd place
          if (topUsers.length >= 3)
            _PodiumItem(
              user: topUsers[2],
              rank: 3,
              height: 60,
              color: AppTheme.textSecondary,
            ),
        ],
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final UserModel user;
  final int rank;
  final double height;
  final Color color;
  
  const _PodiumItem({
    required this.user,
    required this.rank,
    required this.height,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Text(
              user.username[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user.username,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${user.currentStreak} days',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: height,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  final UserModel user;
  final int rank;
  
  const _LeaderboardItem({
    required this.user,
    required this.rank,
  });
  
  @override
  Widget build(BuildContext context) {
    IconData? medalIcon;
    Color? medalColor;
    
    if (rank == 1) {
      medalIcon = Icons.emoji_events;
      medalColor = AppTheme.gold;
    } else if (rank == 2) {
      medalIcon = Icons.emoji_events;
      medalColor = AppTheme.textTertiary;
    } else if (rank == 3) {
      medalIcon = Icons.emoji_events;
      medalColor = AppTheme.textSecondary;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 40,
            child: medalIcon != null
                ? Icon(medalIcon, color: medalColor, size: 24)
                : Text(
                    '#$rank',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          
          // Avatar
          CircleAvatar(
            backgroundColor: AppTheme.accentBlue,
            child: Text(
              user.username[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'Level ${user.level} • ${user.totalXP} XP',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          
          // Streak
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppTheme.successGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${user.currentStreak} days',
              style: const TextStyle(
                color: AppTheme.successGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
