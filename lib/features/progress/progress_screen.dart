import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/star_background.dart';
import '../../core/providers/user_provider.dart';
import '../../core/widgets/achievement_badge.dart';
import '../../services/achievement_service.dart';
import '../../services/streak_service.dart';
import '../../services/user_service.dart';
import '../../core/constants/app_constants.dart';
import '../../models/challenge_day_model.dart';
import '../../services/hive_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Progress screen showing brain rewiring, challenges, achievements
class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});
  
  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final brainProgressAsync = ref.watch(brainRewiringProgressProvider);
    final streakAsync = ref.watch(currentStreakProvider);
    
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
                      Text(
                        'Your Progress',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                
                // Tabs
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Brain Rewiring'),
                    Tab(text: '28-Day Challenge'),
                    Tab(text: 'Achievements'),
                  ],
                  indicatorColor: AppTheme.accentBlue,
                  labelColor: AppTheme.textPrimary,
                  unselectedLabelColor: AppTheme.textSecondary,
                ),
                
                // Tab Views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _BrainRewiringTab(brainProgress: brainProgressAsync),
                      _ChallengeTab(streak: streakAsync),
                      _AchievementsTab(),
                    ],
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

class _BrainRewiringTab extends StatelessWidget {
  final AsyncValue<double> brainProgress;
  
  const _BrainRewiringTab({required this.brainProgress});
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          brainProgress.when(
            data: (progress) => Column(
              children: [
                // Progress Circle
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress / 100,
                        strokeWidth: 20,
                        backgroundColor: AppTheme.surfaceLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.successGreen,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${progress.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const Text(
                            'Rewired',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Info
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About Brain Rewiring',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Your brain needs approximately 90 days to rewire neural pathways. '
                        'Each day clean brings you closer to complete recovery. '
                        'Stay consistent and watch your progress grow!',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Target: ${AppConstants.brainRewiringDays} days',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.accentBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('Error')),
          ),
        ],
      ),
    );
  }
}

class _ChallengeTab extends ConsumerWidget {
  final AsyncValue<int> streak;
  
  const _ChallengeTab({required this.streak});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '28-Day Challenge',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          
          // Challenge days grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: AppConstants.challengeDays,
            itemBuilder: (context, index) {
              final dayNumber = index + 1;
              final isCompleted = streak.maybeWhen(
                data: (s) => s >= dayNumber,
                orElse: () => false,
              );
              
              return Container(
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.successGreen
                      : AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCompleted
                        ? AppTheme.successGreen
                        : AppTheme.surfaceLight,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNumber',
                        style: TextStyle(
                          color: isCompleted
                              ? Colors.white
                              : AppTheme.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isCompleted)
                        const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                    ],
                  ),
                ),
              )
                  .animate(target: isCompleted ? 1 : 0)
                  .scale(duration: 300.ms)
                  .then()
                  .shimmer(duration: 1000.ms);
            },
          ),
          
          const SizedBox(height: 20),
          
          // Life Tree visualization
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Life Tree',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                streak.when(
                  data: (s) => _LifeTreeWidget(streakDays: s),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Text('Error'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LifeTreeWidget extends StatelessWidget {
  final int streakDays;
  
  const _LifeTreeWidget({required this.streakDays});
  
  @override
  Widget build(BuildContext context) {
    // Simple tree visualization based on streak
    final treeHeight = (streakDays / 10).clamp(1.0, 10.0);
    
    return Column(
      children: [
        // Tree trunk
        Container(
          width: 40,
          height: treeHeight * 20,
          decoration: BoxDecoration(
            color: const Color(0xFF8B4513),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        // Tree leaves
        if (streakDays > 0)
          Container(
            width: 100,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.successGreen,
              shape: BoxShape.circle,
            ),
          ),
        const SizedBox(height: 20),
        Text(
          'Your tree grows with each day clean',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _AchievementsTab extends ConsumerWidget {
  const _AchievementsTab();
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = AchievementService.getAllAchievements();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Achievements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          
          // Achievement grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return Column(
                children: [
                  AchievementBadge(
                    achievement: achievement,
                    size: 80,
                    onTap: () {
                      _showAchievementDetails(context, achievement);
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    achievement.name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${achievement.requiredDays} days',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
  
  void _showAchievementDetails(
    BuildContext context,
    AchievementModel achievement,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: Text(achievement.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              achievement.icon,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 16),
            Text(
              achievement.description,
              style: const TextStyle(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Required: ${achievement.requiredDays} days',
              style: const TextStyle(
                color: AppTheme.accentBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (achievement.isUnlocked && achievement.unlockedDate != null)
              Text(
                'Unlocked: ${achievement.unlockedDate!.toString().split(' ')[0]}',
                style: const TextStyle(
                  color: AppTheme.successGreen,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
