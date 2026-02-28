import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/star_background.dart';
import '../../services/user_service.dart';
import '../../services/hive_service.dart';

/// Settings screen
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _anonymousMode = false;
  
  @override
  Widget build(BuildContext context) {
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
                        'Settings',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                
                // Settings List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Notifications
                      _SettingsSection(
                        title: 'Notifications',
                        children: [
                          SwitchListTile(
                            title: const Text('Daily Reminders'),
                            subtitle: const Text('Get reminded to check in daily'),
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Privacy
                      _SettingsSection(
                        title: 'Privacy',
                        children: [
                          SwitchListTile(
                            title: const Text('Anonymous Mode'),
                            subtitle: const Text('Hide your identity in community'),
                            value: _anonymousMode,
                            onChanged: (value) {
                              setState(() {
                                _anonymousMode = value;
                              });
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Account
                      _SettingsSection(
                        title: 'Account',
                        children: [
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text('Edit Profile'),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // Navigate to edit profile
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.security),
                            title: const Text('Privacy Policy'),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // Show privacy policy
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.description),
                            title: const Text('Terms of Service'),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // Show terms
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // About
                      _SettingsSection(
                        title: 'About',
                        children: [
                          ListTile(
                            leading: const Icon(Icons.info),
                            title: const Text('App Version'),
                            subtitle: const Text('1.0.0'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.feedback),
                            title: const Text('Send Feedback'),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // Open feedback
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.star),
                            title: const Text('Rate App'),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // Open app store
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Danger Zone
                      _SettingsSection(
                        title: 'Danger Zone',
                        children: [
                          ListTile(
                            leading: const Icon(Icons.delete_outline, color: AppTheme.dangerRed),
                            title: const Text(
                              'Reset All Data',
                              style: TextStyle(color: AppTheme.dangerRed),
                            ),
                            onTap: () => _showResetDialog(context),
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout, color: AppTheme.dangerRed),
                            title: const Text(
                              'Log Out',
                              style: TextStyle(color: AppTheme.dangerRed),
                            ),
                            onTap: () => _showLogoutDialog(context),
                          ),
                        ],
                      ),
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
  
  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: const Text('Reset All Data'),
        content: const Text(
          'This will delete all your data including streaks, achievements, and progress. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await HiveService.clearAll();
              Navigator.pop(context);
              Navigator.pop(context);
              // Restart app or show onboarding
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerRed,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
  
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // Handle logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerRed,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  
  const _SettingsSection({
    required this.title,
    required this.children,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
