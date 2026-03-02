import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/star_background.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// AI Therapist chat interface
class AITherapistScreen extends ConsumerStatefulWidget {
  const AITherapistScreen({super.key});
  
  @override
  ConsumerState<AITherapistScreen> createState() => _AITherapistScreenState();
}

class _AITherapistScreenState extends ConsumerState<AITherapistScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  
  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }
  
  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      text: 'Hello! I\'m Sankalp AI, your supportive companion on this journey. '
          'How are you feeling today?',
      isUser: false,
    ));
  }
  
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    final userMessage = _messageController.text.trim();
    _messageController.clear();
    
    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _isTyping = true;
    });
    
    _scrollToBottom();
    
    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      final response = _generateResponse(userMessage);
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }
  
  String _generateResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    final random = Random();
    
    // Simple response logic based on keywords
    if (lowerMessage.contains('relapse') || lowerMessage.contains('failed')) {
      final responses = [
        'I understand this is difficult. Relapses are part of the recovery journey. '
        'What matters is that you\'re here now, ready to continue.',
        'Every moment of resistance is progress. You\'re not starting over, '
        'you\'re continuing forward with new awareness.',
        'It\'s okay to stumble. What\'s important is that you get back up. '
        'What triggered this, and how can we prevent it next time?',
      ];
      return responses[random.nextInt(responses.length)];
    } else if (lowerMessage.contains('tempted') || lowerMessage.contains('urge')) {
      final responses = [
        'Urges are temporary. They will pass. Try the breathing exercise or '
        'distract yourself with an activity you enjoy.',
        'Remember why you started this journey. You are stronger than this moment. '
        'Would you like to use the panic button?',
        'These feelings are normal. Let\'s work through them together. '
        'What usually helps you when you feel this way?',
      ];
      return responses[random.nextInt(responses.length)];
    } else if (lowerMessage.contains('good') || lowerMessage.contains('great') ||
        lowerMessage.contains('better')) {
      final responses = [
        'That\'s wonderful to hear! Keep up the great work. Every day clean is a victory.',
        'I\'m so glad you\'re feeling better. Remember to celebrate your progress, '
        'no matter how small.',
        'You\'re doing amazing! What\'s been helping you stay strong?',
      ];
      return responses[random.nextInt(responses.length)];
    } else if (lowerMessage.contains('help') || lowerMessage.contains('support')) {
      return 'I\'m here for you. You can also use the panic button, try breathing exercises, '
          'or connect with the community. What would be most helpful right now?';
    } else {
      final responses = [
        'I hear you. Can you tell me more about what you\'re experiencing?',
        'Thank you for sharing. How can I support you right now?',
        'I understand. Remember, you\'re not alone in this journey. '
        'What would help you feel better?',
        'Your feelings are valid. Let\'s work through this together. '
        'What\'s on your mind?',
      ];
      return responses[random.nextInt(responses.length)];
    }
  }
  
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark.withOpacity(0.5),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        backgroundColor: AppTheme.accentBlue,
                        child: Icon(Icons.psychology, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sankalp AI',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              'Always here to help',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Privacy notice
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: AppTheme.accentBlue.withOpacity(0.1),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock,
                        size: 16,
                        color: AppTheme.accentBlue,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Your conversations are private and anonymous',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Messages
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isTyping) {
                        return _TypingIndicator();
                      }
                      return _ChatBubble(message: _messages[index]);
                    },
                  ),
                ),
                
                // Input
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: AppTheme.accentBlue,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: _sendMessage,
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
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  
  ChatMessage({required this.text, required this.isUser});
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  
  const _ChatBubble({required this.message});
  
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isUser
              ? AppTheme.accentBlue
              : AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: message.isUser
                ? const Radius.circular(4)
                : const Radius.circular(20),
            bottomLeft: message.isUser
                ? const Radius.circular(20)
                : const Radius.circular(4),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : AppTheme.textPrimary,
            fontSize: 14,
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .slideX(
            begin: message.isUser ? 0.2 : -0.2,
            end: 0,
            duration: 300.ms,
          ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(delay: 0),
            const SizedBox(width: 4),
            _Dot(delay: 200),
            const SizedBox(width: 4),
            _Dot(delay: 400),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final int delay;
  
  const _Dot({required this.delay});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppTheme.textSecondary,
        shape: BoxShape.circle,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .fadeIn(duration: 400.ms, delay: delay.ms)
        .then()
        .fadeOut(duration: 400.ms);
  }
}
