import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

/// Breathing exercise circle widget
class BreathingCircle extends StatefulWidget {
  final int durationMinutes;
  final VoidCallback? onComplete;
  
  const BreathingCircle({
    super.key,
    this.durationMinutes = 3,
    this.onComplete,
  });
  
  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Timer? _breathingTimer;
  Timer? _sessionTimer;
  
  String _currentPhase = 'Breathe In';
  int _breathingCycle = 0;
  int _totalCycles = 0;
  bool _isPaused = false;
  bool _isRunning = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: AppConstants.breathingInSeconds),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _calculateTotalCycles();
  }
  
  void _calculateTotalCycles() {
    final totalSeconds = widget.durationMinutes * 60;
    final cycleSeconds = AppConstants.breathingInSeconds +
        AppConstants.breathingHoldSeconds +
        AppConstants.breathingOutSeconds;
    _totalCycles = (totalSeconds / cycleSeconds).floor();
  }
  
  void _startBreathing() {
    if (_isRunning) return;
    
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    
    _breathIn();
    
    // Session timer
    _sessionTimer = Timer(
      Duration(minutes: widget.durationMinutes),
      () {
        _stopBreathing();
        widget.onComplete?.call();
      },
    );
  }
  
  void _breathIn() {
    setState(() {
      _currentPhase = 'Breathe In';
    });
    
    _controller.forward().then((_) {
      _hold();
    });
  }
  
  void _hold() {
    setState(() {
      _currentPhase = 'Hold';
    });
    
    _breathingTimer = Timer(
      const Duration(seconds: AppConstants.breathingHoldSeconds),
      () {
        _breathOut();
      },
    );
  }
  
  void _breathOut() {
    setState(() {
      _currentPhase = 'Breathe Out';
      _breathingCycle++;
    });
    
    _controller.reverse().then((_) {
      if (_isRunning && _breathingCycle < _totalCycles) {
        _breathIn();
      } else if (_isRunning) {
        _stopBreathing();
      }
    });
  }
  
  void _stopBreathing() {
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _breathingCycle = 0;
      _currentPhase = 'Ready';
    });
    
    _controller.reset();
    _breathingTimer?.cancel();
    _sessionTimer?.cancel();
  }
  
  void _pauseResume() {
    if (!_isRunning) return;
    
    setState(() {
      _isPaused = !_isPaused;
    });
    
    if (_isPaused) {
      _controller.stop();
      _breathingTimer?.cancel();
    } else {
      _controller.forward();
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _breathingTimer?.cancel();
    _sessionTimer?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Breathing circle
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentBlue.withOpacity(0.3),
                    AppTheme.accentBlue.withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                  color: AppTheme.accentBlue,
                  width: 2,
                ),
              ),
              child: Center(
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.accentBlue.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            );
          },
        )
            .animate(target: _isRunning ? 1 : 0)
            .fadeIn(duration: 300.ms),
        
        const SizedBox(height: 40),
        
        // Phase text
        Text(
          _currentPhase,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        )
            .animate(target: _isRunning ? 1 : 0)
            .fadeIn(duration: 300.ms),
        
        const SizedBox(height: 20),
        
        // Cycle counter
        if (_isRunning)
          Text(
            'Cycle $_breathingCycle / $_totalCycles',
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
        
        const SizedBox(height: 40),
        
        // Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isRunning)
              ElevatedButton(
                onPressed: _startBreathing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text('Start'),
              )
            else
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pauseResume,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.warningYellow,
                    ),
                    child: Text(_isPaused ? 'Resume' : 'Pause'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _stopBreathing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.dangerRed,
                    ),
                    child: const Text('Stop'),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
