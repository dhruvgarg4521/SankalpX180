import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Relapse confirmation dialog
class RelapseConfirmationDialog extends StatelessWidget {
  const RelapseConfirmationDialog({super.key});
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surfaceDark,
      title: const Text(
        'Confirm Relapse',
        style: TextStyle(color: AppTheme.textPrimary),
      ),
      content: const Text(
        'Are you sure you want to log a relapse? This will reset your current streak, but your progress is not lost. Every day is a new beginning.',
        style: TextStyle(color: AppTheme.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.dangerRed,
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
