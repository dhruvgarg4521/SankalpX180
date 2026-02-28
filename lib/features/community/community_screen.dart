import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/star_background.dart';
import '../../models/community_post_model.dart';
import '../../services/hive_service.dart';
import '../../services/user_service.dart';
import '../../core/utils/date_utils.dart';
import 'leaderboard_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Community screen with forum, clans, friends tabs
class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});
  
  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen>
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Community',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.leaderboard),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LeaderboardScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                // Tabs
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Forum'),
                    Tab(text: 'Clans'),
                    Tab(text: 'Friends'),
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
                      _ForumTab(),
                      _ClansTab(),
                      _FriendsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        backgroundColor: AppTheme.accentBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  void _showCreatePostDialog(BuildContext context) {
    final textController = TextEditingController();
    bool isRelapseConfession = false;
    bool isAnonymous = false;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          title: const Text('Create Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Share your thoughts...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Relapse Confession'),
                value: isRelapseConfession,
                onChanged: (value) => setState(() {
                  isRelapseConfession = value ?? false;
                }),
              ),
              CheckboxListTile(
                title: const Text('Post Anonymously'),
                value: isAnonymous,
                onChanged: (value) => setState(() {
                  isAnonymous = value ?? false;
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  _createPost(
                    textController.text,
                    isRelapseConfession,
                    isAnonymous,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _createPost(
    String content,
    bool isRelapseConfession,
    bool isAnonymous,
  ) async {
    final user = UserService.getCurrentUser();
    if (user == null) return;
    
    final post = CommunityPostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: user.id,
      username: isAnonymous ? 'Anonymous' : user.username,
      isAnonymous: isAnonymous,
      content: content,
      isRelapseConfession: isRelapseConfession,
      userStreak: user.currentStreak,
    );
    
    await HiveService.communityBox.put(post.id, post);
    setState(() {});
  }
}

class _ForumTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ForumTab> createState() => _ForumTabState();
}

class _ForumTabState extends ConsumerState<_ForumTab> {
  @override
  Widget build(BuildContext context) {
    final posts = HiveService.communityBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.forum,
              size: 64,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 16),
            const Text(
              'No posts yet',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Be the first to share!',
              style: TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return _PostCard(post: post)
            .animate()
            .fadeIn(duration: 300.ms, delay: (index * 50).ms)
            .slideX(begin: 0.1, end: 0);
      },
    );
  }
}

class _PostCard extends ConsumerStatefulWidget {
  final CommunityPostModel post;
  
  const _PostCard({required this.post});
  
  @override
  ConsumerState<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<_PostCard> {
  @override
  Widget build(BuildContext context) {
    final user = UserService.getCurrentUser();
    final hasUpvoted = user != null && widget.post.hasUpvoted(user.id);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: widget.post.isRelapseConfession
            ? Border.all(color: AppTheme.dangerRed.withOpacity(0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.accentBlue,
                child: Text(
                  widget.post.username[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      DateUtils.timeAgo(widget.post.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.post.isRelapseConfession)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.dangerRed.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Confession',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.dangerRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Content
          Text(
            widget.post.content,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Actions
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (user != null) {
                    setState(() {
                      widget.post.toggleUpvote(user.id);
                      HiveService.communityBox.put(widget.post.id, widget.post);
                    });
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      hasUpvoted ? Icons.arrow_upward : Icons.arrow_upward_outlined,
                      color: hasUpvoted ? AppTheme.accentBlue : AppTheme.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.post.upvotes}',
                      style: TextStyle(
                        color: hasUpvoted ? AppTheme.accentBlue : AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Row(
                children: [
                  const Icon(
                    Icons.comment_outlined,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.post.comments}',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (widget.post.userStreak > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.post.userStreak} days',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.successGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClansTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.groups,
            size: 64,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Clans Coming Soon',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Join groups and support each other',
            style: TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _FriendsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.people,
            size: 64,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Friends Coming Soon',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Connect with others on the journey',
            style: TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
