@echo off
echo ========================================
echo   JAWARA FLUTTER - Starting App
echo ========================================
echo.

cd /d "%~dp0"

echo [1/3] Checking Flutter installation...
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Flutter is not installed!
    echo Please install Flutter from https://flutter.dev/
    pause
    exit /b 1
)
echo Flutter: OK
echo.

echo [2/3] Checking dependencies...
if not exist "pubspec.lock" (
    echo Getting dependencies...
    call flutter pub get
    if errorlevel 1 (
        echo ERROR: Failed to get dependencies!
        pause
        exit /b 1
    )
) else (
    echo Dependencies already installed.
)
echo.

echo [3/3] Starting Flutter app...
echo.
echo ========================================
echo   Make sure you have:
echo   - Connected device OR
echo   - Running emulator
echo ========================================
echo.
echo Press Ctrl+C to stop the app
echo.

call flutter run

pause
