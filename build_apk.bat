@echo off
echo ========================================
echo Building SankalpX180 APK
echo ========================================
echo.

echo Step 1: Installing dependencies...
flutter pub get
if errorlevel 1 (
    echo ERROR: Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo Step 2: Generating code (Hive adapters)...
flutter pub run build_runner build --delete-conflicting-outputs
if errorlevel 1 (
    echo WARNING: Code generation may have issues, but continuing...
)

echo.
echo Step 3: Building release APK...
flutter build apk --release
if errorlevel 1 (
    echo ERROR: Failed to build APK
    pause
    exit /b 1
)

echo.
echo ========================================
echo APK Build Complete!
echo ========================================
echo.
echo Your APK is located at:
echo build\app\outputs\flutter-apk\app-release.apk
echo.
pause
