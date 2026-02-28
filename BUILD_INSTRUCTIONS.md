# Building SankalpX180 APK

## Prerequisites

1. **Flutter SDK** must be installed and added to PATH
2. **Android SDK** must be installed (via Android Studio)
3. **Java JDK** (version 11 or higher)

## Quick Build Steps

### Option 1: Using the Build Script (Windows)

1. Open Command Prompt or PowerShell
2. Navigate to the project directory:
   ```cmd
   cd "C:\Users\dhruv\OneDrive\Desktop\SankalpX180"
   ```
3. Run the build script:
   ```cmd
   build_apk.bat
   ```

### Option 2: Manual Build Steps

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate code** (Hive adapters):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Build release APK**:
   ```bash
   flutter build apk --release
   ```

4. **Find your APK**:
   The APK will be located at:
   ```
   build\app\outputs\flutter-apk\app-release.apk
   ```

## Build Variants

### Release APK (Recommended)
```bash
flutter build apk --release
```
- Optimized for production
- Smaller file size
- Better performance

### Debug APK (For Testing)
```bash
flutter build apk --debug
```
- Includes debug symbols
- Larger file size
- Easier to debug

### Split APKs (by ABI)
```bash
flutter build apk --split-per-abi
```
- Creates separate APKs for different architectures
- Smaller individual APK files
- Better for distribution

## Troubleshooting

### Issue: "flutter: command not found"
**Solution**: Add Flutter to your system PATH
1. Find your Flutter installation directory
2. Add `flutter\bin` to your PATH environment variable
3. Restart your terminal

### Issue: "Android SDK not found"
**Solution**: 
1. Install Android Studio
2. Install Android SDK through Android Studio
3. Set ANDROID_HOME environment variable
4. Add platform-tools to PATH

### Issue: Build Runner Errors
**Solution**:
```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Gradle Build Errors
**Solution**:
1. Check `android/gradle/wrapper/gradle-wrapper.properties`
2. Ensure Gradle version is compatible
3. Try: `cd android && ./gradlew clean`

## APK Size Optimization

To reduce APK size:

1. **Enable ProGuard/R8** (already configured in release mode)
2. **Remove unused resources**:
   ```bash
   flutter build apk --release --split-per-abi
   ```
3. **Use App Bundle** instead of APK:
   ```bash
   flutter build appbundle --release
   ```

## Installing the APK

### On Android Device:
1. Transfer `app-release.apk` to your Android device
2. Enable "Install from Unknown Sources" in Settings
3. Open the APK file on your device
4. Follow installation prompts

### Via ADB:
```bash
flutter install
```
or
```bash
adb install build\app\outputs\flutter-apk\app-release.apk
```

## App Bundle (For Play Store)

If you plan to publish on Google Play Store, use App Bundle instead:

```bash
flutter build appbundle --release
```

Output location:
```
build\app\outputs\bundle\release\app-release.aab
```

## File Locations

After building, find your files here:

- **Release APK**: `build\app\outputs\flutter-apk\app-release.apk`
- **Debug APK**: `build\app\outputs\flutter-apk\app-debug.apk`
- **App Bundle**: `build\app\outputs\bundle\release\app-release.aab`

## Notes

- First build may take 5-10 minutes (downloading dependencies)
- Subsequent builds are faster
- Ensure you have at least 2GB free disk space
- Internet connection required for first build

## Need Help?

If you encounter issues:
1. Run `flutter doctor` to check your setup
2. Check Flutter documentation: https://flutter.dev/docs
3. Ensure all prerequisites are installed
