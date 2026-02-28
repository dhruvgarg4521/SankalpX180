import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_haptic_feedback/flutter_haptic_feedback.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/star_background.dart';
import '../../core/constants/app_constants.dart';
import '../../services/user_service.dart';
import '../../services/relapse_service.dart';
import '../../services/streak_service.dart';
import '../library/ai_therapist_screen.dart';
import '../../core/widgets/breathing_circle.dart';
import 'relapse_confirmation_dialog.dart';

/// Panic Button emergency screen
class PanicButtonScreen extends ConsumerStatefulWidget {
  const PanicButtonScreen({super.key});
  
  @override
  ConsumerState<PanicButtonScreen> createState() => _PanicButtonScreenState();
}

class _PanicButtonScreenState extends ConsumerState<PanicButtonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarBackground(
        child: Container(
          decoration: AppTheme.gradientBackground,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header
                  const Icon(
                    Icons.emergency,
                    size: 80,
                    color: AppTheme.dangerRed,
                  )
                      .animate()
                      .scale(duration: 1000.ms)
                      .then()
                      .shake(duration: 500.ms),
                  
                  const SizedBox(height: 24),
                  
                  Text(
                    'Choose Freedom Over Chains',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(duration: 500.ms),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'You are stronger than this moment',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 200.ms),
                  
                  const SizedBox(height: 60),
                  
                  // Options
                  ...AppConstants.panicOptions.map((option) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _PanicOptionButton(
                        text: option,
                        onTap: () => _handleOptionTap(option),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Future<void> _handleOptionTap(String option) async {
    FlutterHapticFeedback.mediumImpact();
    
    switch (option) {
      case 'I relapsed':
        await _handleRelapse();
        break;
      case 'Still strong':
        Navigator.pop(context);
        break;
      case 'Breathe with me':
        _showBreathingExercise();
        break;
      case 'Watch motivation':
        // Show motivational content
        _showMotivation();
        break;
      case 'Talk to AI':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AITherapistScreen(),
          ),
        );
        break;
    }
  }
  
  Future<void> _handleRelapse() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const RelapseConfirmationDialog(),
    );
    
    if (confirmed == true) {
      final userId = await UserService.getCurrentUserId();
      if (userId != null) {
        final streakDays = StreakService.getStreakDays(userId);
        
        await RelapseService.logRelapse(
          userId: userId,
          streakBeforeRelapse: streakDays,
        );
        
        await UserService.handleRelapse(userId);
        
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your journey continues. Every day is a new beginning.'),
              backgroundColor: AppTheme.accentBlue,
            ),
          );
        }
      }
    }
  }
  
  void _showBreathingExercise() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AppTheme.primaryBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: BreathingCircle(durationMinutes: 3),
        ),
      ),
    );
  }
  
  void _showMotivation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: const Text('Stay Strong'),
        content: const Text(
          'Remember why you started. Every moment of resistance is a victory. '
          'You are rewriting your story, one day at a time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('I understand'),
          ),
        ],
      ),
    );
  }
}

class _PanicOptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  
  const _PanicOptionButton({
    required this.text,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: AppTheme.surfaceDark,
          foregroundColor: AppTheme.textPrimary,
          side: const BorderSide(color: AppTheme.accentBlue, width: 2),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
