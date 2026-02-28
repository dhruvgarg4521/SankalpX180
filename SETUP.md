# SankalpX180 Setup Guide

## Prerequisites

1. **Flutter SDK**: Install Flutter (latest stable version)
   - Check installation: `flutter doctor`
   - Ensure Flutter is in your PATH

2. **Dart SDK**: Comes with Flutter

3. **IDE**: VS Code or Android Studio with Flutter plugins

## Installation Steps

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Code

Run the build runner to generate Hive adapters and Riverpod providers:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

If you encounter issues, try:

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── constants/      # App-wide constants
│   ├── providers/       # Riverpod providers
│   ├── theme/          # Theme configuration
│   ├── utils/          # Utility functions
│   └── widgets/        # Reusable widgets
├── features/
│   ├── home/           # Home screen
│   ├── progress/       # Progress tracking
│   ├── community/       # Community features
│   ├── library/        # Library & AI therapist
│   ├── profile/         # Profile & settings
│   ├── panic_button/    # Panic button flow
│   └── onboarding/     # Onboarding screens
├── models/             # Data models
├── services/           # Business logic services
└── main.dart          # App entry point
```

## Features Implemented

✅ **Home Dashboard**
- Circular recovery ring with streak counter
- Brain rewiring progress
- Temptation indicator
- Motivational quotes
- Panic button
- 28-day challenge preview

✅ **Progress Tab**
- Brain rewiring visualization (0-100%)
- 28-day challenge tracker
- Life Tree visualization
- Achievement showcase

✅ **Community Tab**
- Forum with posts
- Upvote system
- Relapse confession posts
- Anonymous mode
- Leaderboard

✅ **Library Tab**
- Articles section
- Podcasts section
- AI Therapist chat interface
- Relaxation sounds

✅ **Profile Tab**
- User statistics
- XP and level system
- Premium upgrade section
- Settings

✅ **Panic Button**
- Emergency support screen
- Relapse logging
- Breathing exercises
- AI therapist access
- Motivational content

✅ **Gamification**
- XP system
- Level progression
- Achievement badges
- Daily check-in rewards
- Streak tracking

## Key Technologies

- **Flutter**: UI framework
- **Riverpod**: State management
- **Hive**: Local database
- **GoRouter**: Navigation (prepared for future use)
- **Flutter Animate**: Animations
- **Audio Players**: Relaxation sounds

## Customization

### Theme Colors

Edit `lib/core/theme/app_theme.dart` to customize:
- Primary background colors
- Accent colors
- Text colors
- Button styles

### Achievement Milestones

Edit `lib/core/constants/app_constants.dart` to modify:
- Achievement milestones (days)
- Achievement names
- XP rewards

### AI Therapist Responses

Edit `lib/features/library/ai_therapist_screen.dart` to customize:
- Response logic
- Conversation flow
- Keywords detection

## Troubleshooting

### Build Runner Issues

If code generation fails:
1. Delete `.dart_tool` folder
2. Run `flutter clean`
3. Run `flutter pub get`
4. Run build_runner again

### Hive Adapter Errors

If you see Hive adapter errors:
1. Ensure all models have `@HiveType` annotations
2. Run build_runner to regenerate adapters
3. Check that adapters are registered in `hive_service.dart`

### Missing Assets

Create placeholder files in:
- `assets/images/`
- `assets/animations/`
- `assets/sounds/`
- `assets/icons/`

## Next Steps

1. **Add Real Audio Files**: Replace placeholder paths in `relaxation_sounds_screen.dart`
2. **Implement Backend**: Connect to Firebase or your backend API
3. **Add Push Notifications**: Implement daily reminder notifications
4. **Premium Features**: Implement subscription logic
5. **Analytics**: Add analytics tracking
6. **Testing**: Add unit and widget tests

## Production Checklist

- [ ] Replace placeholder assets
- [ ] Configure app icons and splash screen
- [ ] Set up app signing for Android/iOS
- [ ] Configure app store listings
- [ ] Add privacy policy and terms of service
- [ ] Implement backend API integration
- [ ] Add error tracking (Sentry, Firebase Crashlytics)
- [ ] Set up analytics
- [ ] Test on multiple devices
- [ ] Performance optimization
- [ ] Security audit

## Support

For issues or questions, refer to:
- Flutter documentation: https://flutter.dev/docs
- Riverpod documentation: https://riverpod.dev
- Hive documentation: https://docs.hivedb.dev
