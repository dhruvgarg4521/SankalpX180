import '../core/constants/app_constants.dart';
import '../services/user_service.dart';
import '../services/streak_service.dart';
import '../services/relapse_service.dart';

/// Service for predicting relapse risk using AI-like logic
class RelapseRiskService {
  /// Calculate relapse risk score (0.0 - 1.0)
  static double calculateRelapseRisk(String userId) {
    double risk = 0.0;
    
    final user = UserService.getCurrentUser();
    if (user == null) return 0.5;
    
    // Factor 1: Time of day (evening/night higher risk)
    final hour = DateTime.now().hour;
    if (hour >= 20 || hour <= 6) {
      risk += AppConstants.riskFactorTimeOfDay;
    }
    
    // Factor 2: Streak length (shorter streak = higher risk)
    final streakDays = StreakService.getStreakDays(userId);
    if (streakDays < 7) {
      risk += AppConstants.riskFactorStreakLength * (1.0 - (streakDays / 7));
    } else {
      risk += AppConstants.riskFactorStreakLength * 0.1;
    }
    
    // Factor 3: Recent relapse (within 7 days = higher risk)
    final daysSinceRelapse = RelapseService.getDaysSinceLastRelapse(userId);
    if (daysSinceRelapse != null && daysSinceRelapse < 7) {
      risk += AppConstants.riskFactorRecentRelapse * (1.0 - (daysSinceRelapse / 7));
    }
    
    // Factor 4: Community engagement (lower engagement = higher risk)
    // This would ideally check user's recent community activity
    // For now, we'll use a default value
    risk += AppConstants.riskFactorCommunityEngagement * 0.3;
    
    return risk.clamp(0.0, 1.0);
  }
  
  /// Get risk level as string
  static String getRiskLevel(double risk) {
    if (risk < 0.3) return 'Low';
    if (risk < 0.6) return 'Medium';
    return 'High';
  }
  
  /// Get risk color
  static int getRiskColor(double risk) {
    if (risk < 0.3) return 0xFF1ED760; // Green
    if (risk < 0.6) return 0xFFFFB800; // Yellow
    return 0xFFB00020; // Red
  }
  
  /// Get recommendations based on risk
  static List<String> getRecommendations(double risk) {
    final recommendations = <String>[];
    
    if (risk >= 0.6) {
      recommendations.add('Use the Panic Button for immediate support');
      recommendations.add('Try a breathing exercise');
      recommendations.add('Read an article from the Library');
      recommendations.add('Talk to Sankalp AI');
    } else if (risk >= 0.3) {
      recommendations.add('Stay engaged with the community');
      recommendations.add('Complete your daily check-in');
      recommendations.add('Review your progress');
    } else {
      recommendations.add('Keep up the great work!');
      recommendations.add('Help others in the community');
    }
    
    return recommendations;
  }
}
