# SankalpX180 Architecture Overview

## Architecture Pattern

The app follows **Clean Architecture** principles with clear separation of concerns:

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Screens, Widgets, Providers)     │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Domain Layer                 │
│  (Models, Business Logic)           │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Data Layer                   │
│  (Services, Hive, Local Storage)    │
└─────────────────────────────────────┘
```

## State Management

**Riverpod** is used for state management:

- **Providers**: Define reactive state
- **ConsumerWidget/ConsumerStatefulWidget**: Consume providers
- **FutureProvider**: Handle async data
- **StateProvider**: Simple state

### Key Providers

- `currentUserProvider`: Current user data
- `currentStreakProvider`: Current streak days
- `brainRewiringProgressProvider`: Brain rewiring percentage
- `userXPProvider`: User XP points
- `userLevelProvider`: User level

## Data Persistence

**Hive** is used for local storage:

### Hive Boxes

1. **User Box**: User profiles and settings
2. **Achievement Box**: Achievement data
3. **Streak Box**: Streak history
4. **Relapse Box**: Relapse logs
5. **Community Box**: Community posts
6. **Settings Box**: App settings

### Models

All models extend `HiveObject` and use:
- `@HiveType(typeId: X)`: Type identifier
- `@HiveField(Y)`: Field identifier
- Code generation via `build_runner`

## Service Layer

Services handle business logic:

### UserService
- User creation (anonymous/email)
- User updates
- Streak and achievement management
- XP and level calculations

### StreakService
- Streak creation and updates
- Streak validation
- Longest streak calculation

### AchievementService
- Achievement initialization
- Achievement unlocking
- Progress tracking

### RelapseService
- Relapse logging
- Relapse history
- Statistics

### RelapseRiskService
- Risk calculation algorithm
- Risk level determination
- Recommendations

## Feature Modules

Each feature is self-contained:

```
features/
  feature_name/
    ├── feature_name_screen.dart
    ├── widgets/          # Feature-specific widgets
    ├── providers/        # Feature-specific providers
    └── models/          # Feature-specific models (if any)
```

## Navigation

Currently using **Material Navigation**:
- `Navigator.push()` for screen transitions
- `Navigator.pop()` for going back
- Bottom navigation bar for main tabs

**Future**: Can be upgraded to GoRouter for:
- Deep linking
- Route guards
- Better navigation management

## Theme System

Centralized theme in `lib/core/theme/app_theme.dart`:

- **Dark cosmic theme** with gradients
- **Consistent colors** across the app
- **Reusable decorations** (buttons, cards)
- **Custom widgets** for common UI patterns

## Widget Architecture

### Reusable Widgets (`core/widgets/`)

- `StarBackground`: Animated star field
- `RecoveryRing`: Circular progress indicator
- `AchievementBadge`: Achievement display
- `BreathingCircle`: Breathing exercise widget

### Feature Widgets

Each feature can have its own widgets in `features/[feature]/widgets/`

## Data Flow

```
User Action
    ↓
Widget Event Handler
    ↓
Service Method Call
    ↓
Hive Database Update
    ↓
Provider Invalidation/Update
    ↓
UI Rebuild
```

## Key Design Patterns

### 1. Repository Pattern (via Services)
Services act as repositories, abstracting data access

### 2. Provider Pattern (Riverpod)
Reactive state management with dependency injection

### 3. Observer Pattern
Widgets observe providers and rebuild on changes

### 4. Factory Pattern
Model creation methods (e.g., `createDefaultAchievements()`)

## Performance Considerations

1. **Lazy Loading**: Providers load data on demand
2. **Caching**: Hive caches data locally
3. **Efficient Rebuilds**: Riverpod only rebuilds affected widgets
4. **Image Optimization**: Use appropriate image formats
5. **List Optimization**: Consider `ListView.builder` for long lists

## Testing Strategy

### Unit Tests
- Service methods
- Model methods
- Utility functions

### Widget Tests
- Individual widgets
- Screen layouts
- User interactions

### Integration Tests
- User flows
- Navigation
- Data persistence

## Security Considerations

1. **Local Storage**: Hive data is stored locally
2. **Anonymous Mode**: User privacy options
3. **Data Encryption**: Consider encrypting sensitive data
4. **Input Validation**: Validate all user inputs

## Scalability

The architecture supports:

- **Adding New Features**: Create new feature modules
- **Backend Integration**: Services can be extended to call APIs
- **Multi-platform**: Flutter supports iOS, Android, Web
- **Internationalization**: Can add i18n support

## Future Enhancements

1. **Backend API Integration**
   - User sync across devices
   - Cloud storage
   - Real-time community features

2. **Push Notifications**
   - Daily reminders
   - Achievement notifications
   - Community updates

3. **Analytics**
   - User behavior tracking
   - Feature usage metrics
   - Performance monitoring

4. **Premium Features**
   - Subscription management
   - Advanced analytics
   - Premium content

5. **Social Features**
   - Friend system
   - Clans/groups
   - Direct messaging

## Code Generation

Run after model changes:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- Hive adapters (`.g.dart` files)
- Riverpod providers (if using code generation)

## Best Practices

1. **Naming Conventions**
   - Screens: `*_screen.dart`
   - Widgets: `*_widget.dart` or descriptive names
   - Services: `*_service.dart`
   - Models: `*_model.dart`

2. **File Organization**
   - One class per file (except small related classes)
   - Group related files in folders
   - Use barrel exports if needed

3. **Code Comments**
   - Document complex logic
   - Explain business rules
   - Add TODO comments for future work

4. **Error Handling**
   - Use try-catch for async operations
   - Show user-friendly error messages
   - Log errors for debugging

5. **State Management**
   - Keep state close to where it's used
   - Use providers for shared state
   - Avoid prop drilling
