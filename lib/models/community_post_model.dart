import 'package:hive/hive.dart';

part 'community_post_model.g.dart';

@HiveType(typeId: 4)
class CommunityPostModel extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String userId;
  
  @HiveField(2)
  String username;
  
  @HiveField(3)
  bool isAnonymous;
  
  @HiveField(4)
  String content;
  
  @HiveField(5)
  DateTime createdAt;
  
  @HiveField(6)
  int upvotes;
  
  @HiveField(7)
  int comments;
  
  @HiveField(8)
  bool isRelapseConfession;
  
  @HiveField(9)
  List<String> upvotedBy;
  
  @HiveField(10)
  int userStreak;
  
  CommunityPostModel({
    required this.id,
    required this.userId,
    required this.username,
    this.isAnonymous = false,
    required this.content,
    DateTime? createdAt,
    this.upvotes = 0,
    this.comments = 0,
    this.isRelapseConfession = false,
    List<String>? upvotedBy,
    this.userStreak = 0,
  })  : createdAt = createdAt ?? DateTime.now(),
        upvotedBy = upvotedBy ?? [];
  
  /// Toggle upvote
  bool toggleUpvote(String userId) {
    if (upvotedBy.contains(userId)) {
      upvotedBy.remove(userId);
      upvotes = (upvotes - 1).clamp(0, double.infinity).toInt();
      return false;
    } else {
      upvotedBy.add(userId);
      upvotes++;
      return true;
    }
  }
  
  /// Check if user has upvoted
  bool hasUpvoted(String userId) {
    return upvotedBy.contains(userId);
  }
  
  CommunityPostModel copyWith({
    String? id,
    String? userId,
    String? username,
    bool? isAnonymous,
    String? content,
    DateTime? createdAt,
    int? upvotes,
    int? comments,
    bool? isRelapseConfession,
    List<String>? upvotedBy,
    int? userStreak,
  }) {
    return CommunityPostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      upvotes: upvotes ?? this.upvotes,
      comments: comments ?? this.comments,
      isRelapseConfession: isRelapseConfession ?? this.isRelapseConfession,
      upvotedBy: upvotedBy ?? this.upvotedBy,
      userStreak: userStreak ?? this.userStreak,
    );
  }
}
