import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/star_background.dart';

/// Relaxation sounds screen
class RelaxationSoundsScreen extends StatefulWidget {
  const RelaxationSoundsScreen({super.key});
  
  @override
  State<RelaxationSoundsScreen> createState() => _RelaxationSoundsScreenState();
}

class _RelaxationSoundsScreenState extends State<RelaxationSoundsScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlaying;
  
  final List<SoundItem> _sounds = [
    SoundItem(name: 'Rain', icon: Icons.grain, asset: 'assets/sounds/rain.mp3'),
    SoundItem(name: 'Ocean', icon: Icons.waves, asset: 'assets/sounds/ocean.mp3'),
    SoundItem(name: 'Campfire', icon: Icons.local_fire_department, asset: 'assets/sounds/campfire.mp3'),
    SoundItem(name: 'White Noise', icon: Icons.graphic_eq, asset: 'assets/sounds/whitenoise.mp3'),
  ];
  
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
  
  Future<void> _playSound(String name, String asset) async {
    if (_currentlyPlaying == name) {
      await _audioPlayer.stop();
      setState(() {
        _currentlyPlaying = null;
      });
    } else {
      await _audioPlayer.stop();
      // In a real app, you would load the actual audio file
      // await _audioPlayer.play(AssetSource(asset));
      setState(() {
        _currentlyPlaying = name;
      });
    }
  }
  
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
                        'Relaxation Sounds',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                
                // Sounds list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _sounds.length,
                    itemBuilder: (context, index) {
                      final sound = _sounds[index];
                      final isPlaying = _currentlyPlaying == sound.name;
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isPlaying
                                ? AppTheme.accentBlue
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.accentBlue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                sound.icon,
                                color: AppTheme.accentBlue,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                sound.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: AppTheme.accentBlue,
                                size: 32,
                              ),
                              onPressed: () => _playSound(sound.name, sound.asset),
                            ),
                          ],
                        ),
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

class SoundItem {
  final String name;
  final IconData icon;
  final String asset;
  
  SoundItem({
    required this.name,
    required this.icon,
    required this.asset,
  });
}
