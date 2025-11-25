@echo off
echo ========================================
echo   JAWARA FLUTTER - Installation
echo ========================================
echo.

cd /d "%~dp0"

echo [1/4] Checking Flutter installation...
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Flutter is not installed!
    echo Please install Flutter from https://flutter.dev/
    pause
    exit /b 1
)
flutter --version
echo.

echo [2/4] Cleaning previous builds...
call flutter clean
echo.

echo [3/4] Getting dependencies...
call flutter pub get
if errorlevel 1 (
    echo ERROR: Failed to get dependencies!
    pause
    exit /b 1
)
echo.

echo [4/4] Setup complete!
echo.
echo ========================================
echo   Next Steps:
echo   1. Connect your device or start emulator
echo   2. Run START_FLUTTER.bat to start app
echo ========================================
echo.

pause
