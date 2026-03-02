import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/star_background.dart';
import '../../core/widgets/recovery_ring.dart';
import '../../core/providers/user_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_utils.dart';
import '../../services/user_service.dart';
import '../../services/streak_service.dart';
import '../../services/relapse_risk_service.dart';
import '../panic_button/panic_button_screen.dart';
import 'package:go_router/go_router.dart';

/// Home dashboard screen
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _motivationalQuote;
  double? _relapseRisk;
  
  @override
  void initState() {
    super.initState();
    _loadQuote();
    _loadRelapseRisk();
    _updateStreak();
  }
  
  void _loadQuote() {
    final random = DateTime.now().millisecondsSinceEpoch %
        AppConstants.motivationalQuotes.length;
    setState(() {
      _motivationalQuote = AppConstants.motivationalQuotes[random];
    });
  }
  
  Future<void> _loadRelapseRisk() async {
    final userId = await UserService.getCurrentUserId();
    if (userId != null) {
      final risk = RelapseRiskService.calculateRelapseRisk(userId);
      setState(() {
        _relapseRisk = risk;
      });
    }
  }
  
  Future<void> _updateStreak() async {
    final userId = await UserService.getCurrentUserId();
    if (userId != null) {
      await UserService.updateStreakAndAchievements(userId);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final streakAsync = ref.watch(currentStreakProvider);
    final brainProgressAsync = ref.watch(brainRewiringProgressProvider);
    
    return Scaffold(
      body: StarBackground(
        child: Container(
          decoration: AppTheme.gradientBackground,
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await _updateStreak();
                await _loadRelapseRisk();
                ref.invalidate(currentUserProvider);
                ref.invalidate(currentStreakProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            userAsync.when(
                              data: (user) => Text(
                                user?.username ?? 'User',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              loading: () => const SizedBox(
                                height: 24,
                                width: 100,
                                child: LinearProgressIndicator(),
                              ),
                              error: (_, __) => const Text('Error'),
                            ),
                          ],
                        ),
                        // Relapse risk indicator
                        if (_relapseRisk != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Color(RelapseRiskService.getRiskColor(_relapseRisk!))
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color(
                                  RelapseRiskService.getRiskColor(_relapseRisk!),
                                ),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(
                                      RelapseRiskService.getRiskColor(_relapseRisk!),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  RelapseRiskService.getRiskLevel(_relapseRisk!),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Recovery Ring
                    Center(
                      child: streakAsync.when(
                        data: (streak) => RecoveryRing(
                          currentStreak: streak,
                          targetDays: 180,
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => const Text('Error loading streak'),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Target date
                    Center(
                      child: userAsync.when(
                        data: (user) {
                          if (user == null) return const SizedBox();
                          final targetDate = AppDateUtils.getTargetQuitDate(user.joinDate);
                          final daysLeft = AppDateUtils.daysUntil(targetDate);
                          return Column(
                            children: [
                              Text(
                                'You\'re on track to quit by',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppDateUtils.formatDate(targetDate),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppTheme.accentBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (daysLeft > 0)
                                Text(
                                  '$daysLeft days to go',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          );
                        },
                        loading: () => const SizedBox(),
                        error: (_, __) => const SizedBox(),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Brain Rewiring Progress
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Brain Rewiring',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              brainProgressAsync.when(
                                data: (progress) => Text(
                                  '${progress.toStringAsFixed(1)}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                    color: AppTheme.successGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                loading: () => const SizedBox(
                                  width: 50,
                                  child: LinearProgressIndicator(),
                                ),
                                error: (_, __) => const Text('Error'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          brainProgressAsync.when(
                            data: (progress) => LinearProgressIndicator(
                              value: progress / 100,
                              backgroundColor: AppTheme.surfaceLight,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTheme.successGreen,
                              ),
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            loading: () => const LinearProgressIndicator(),
                            error: (_, __) => const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Temptation Indicator
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _relapseRisk != null && _relapseRisk! < 0.3
                                  ? AppTheme.notTempted
                                  : AppTheme.tempted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _relapseRisk != null && _relapseRisk! < 0.3
                                  ? 'Not tempted - Keep going!'
                                  : 'Feeling tempted? Use the Panic Button',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Motivational Quote
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.accentBlue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.format_quote,
                                color: AppTheme.accentBlue,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Daily Inspiration',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (_motivationalQuote != null)
                            Text(
                              _motivationalQuote!,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Primary CTA
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          // Navigate to progress or start journey
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: AppTheme.accentBlue,
                        ),
                        child: const Text(
                          'Start Journey',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Panic Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PanicButtonScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: AppTheme.dangerRed,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.emergency, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Panic Button',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 28-Day Challenge Preview
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '28-Day Challenge',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to progress tab
                                },
                                child: const Text('View All'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Challenge days preview
                          Row(
                            children: List.generate(
                              7,
                              (index) => Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: index < 3
                                        ? AppTheme.successGreen
                                        : AppTheme.surfaceLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: index < 3
                                            ? Colors.white
                                            : AppTheme.textSecondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
