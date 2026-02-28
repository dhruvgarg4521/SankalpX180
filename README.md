# SankalpX180

A production-ready sobriety and dopamine-reset mobile app designed for Indian users, focusing on porn addiction recovery.

## Features

- 🎯 Streak tracking with visual progress indicators
- 🧠 Brain rewiring progress (0-100%)
- 🤖 AI therapy chat interface
- 🆘 Panic button for emergency support
- 👥 Community forum and leaderboard
- 🏆 Achievement system with 11 milestones
- 📚 Educational library (articles, podcasts, relaxation sounds)
- 🧘 Breathing exercises and meditation tools
- 📊 28-day challenge tracker
- 🌳 Life Tree visualization
- 💎 Gamified XP system
- 🔔 Daily check-in reminders
- 💳 Premium subscription tier

## Tech Stack

- Flutter (latest stable)
- Riverpod (state management)
- Hive (local database)
- Clean Architecture
- GoRouter (navigation)

## Getting Started

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Generate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
  core/
    theme/
    constants/
    utils/
  services/
  models/
  features/
    home/
    progress/
    community/
    library/
    profile/
  main.dart
```

## Theme

Dark cosmic theme with:
- Deep navy gradient backgrounds (#0B0F2A)
- Electric blue accents (#2D8CFF)
- Emerald success indicators (#1ED760)
- Deep red danger buttons (#B00020)
- Gold achievements (#FFC857)
