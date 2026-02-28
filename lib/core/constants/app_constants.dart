/// App-wide constants for SankalpX180

class AppConstants {
  // App Info
  static const String appName = 'SankalpX180';
  static const String appTagline = 'Choose Freedom Over Chains';
  
  // Hive Box Names
  static const String userBoxName = 'user_box';
  static const String streakBoxName = 'streak_box';
  static const String achievementBoxName = 'achievement_box';
  static const String relapseBoxName = 'relapse_box';
  static const String settingsBoxName = 'settings_box';
  static const String communityBoxName = 'community_box';
  
  // Achievement Milestones (days)
  static const List<int> achievementMilestones = [
    1,   // Seed
    3,   // Sprout
    5,   // Pioneer
    7,   // Momentum
    10,  // Fortress
    14,  // Guardian
    30,  // Trailblazer
    45,  // Ascendant
    60,  // Enlightenment
    90,  // Nirvana
    180, // 180 Master
  ];
  
  // Achievement Names
  static const List<String> achievementNames = [
    'Seed',
    'Sprout',
    'Pioneer',
    'Momentum',
    'Fortress',
    'Guardian',
    'Trailblazer',
    'Ascendant',
    'Enlightenment',
    'Nirvana',
    '180 Master',
  ];
  
  // Brain Rewiring Calculation
  static const int brainRewiringDays = 90;
  static const double brainRewiringBaseRate = 1.11; // ~1.11% per day
  
  // Challenge Duration
  static const int challengeDays = 28;
  
  // XP System
  static const int xpPerDay = 10;
  static const int xpPerCheckIn = 5;
  static const int xpPerAchievement = 50;
  static const int xpPerCommunityPost = 3;
  static const int xpPerArticleRead = 2;
  
  // Daily Check-in
  static const int checkInReminderHour = 20; // 8 PM
  static const int checkInReminderMinute = 0;
  
  // Panic Button
  static const List<String> panicOptions = [
    'I relapsed',
    'Still strong',
    'Breathe with me',
    'Watch motivation',
    'Talk to AI',
  ];
  
  // Breathing Exercise
  static const List<int> breathingDurations = [1, 3, 5]; // minutes
  static const int breathingInSeconds = 4;
  static const int breathingHoldSeconds = 4;
  static const int breathingOutSeconds = 6;
  
  // Relapse Risk Prediction Factors
  static const double riskFactorTimeOfDay = 0.2;
  static const double riskFactorStreakLength = 0.3;
  static const double riskFactorRecentRelapse = 0.3;
  static const double riskFactorCommunityEngagement = 0.2;
  
  // Premium Features
  static const List<String> premiumFeatures = [
    'Advanced AI Therapy',
    'Unlimited Community Posts',
    'Detailed Analytics',
    'Custom Themes',
    'Priority Support',
    'Ad-free Experience',
  ];
  
  // Motivational Quotes
  static const List<String> motivationalQuotes = [
    'Every moment of resistance to temptation is a victory.',
    'You are stronger than your urges.',
    'Progress, not perfection.',
    'The best time to plant a tree was 20 years ago. The second best time is now.',
    'You don\'t have to be great to start, but you have to start to be great.',
    'Recovery is not a race. You don\'t have to beat anyone but yourself.',
    'Every day is a new beginning.',
    'Small steps lead to big changes.',
    'You are rewriting your story, one day at a time.',
    'Freedom is on the other side of discipline.',
  ];
}
