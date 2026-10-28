#!/bin/bash
# Script to pull screenshots from Android emulator

echo "Checking if emulator is connected..."
adb devices

echo ""
echo "Looking for screenshots in emulator..."
adb shell ls /sdcard/Pictures/Screenshots/ 2>/dev/null

echo ""
echo "Creating folder for screenshots..."
mkdir -p ~/Downloads/emulator_screenshots

echo ""
echo "Pulling screenshots from emulator..."
adb pull /sdcard/Pictures/Screenshots/ ~/Downloads/emulator_screenshots/ 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Screenshots pulled to: ~/Downloads/emulator_screenshots/"
    open ~/Downloads/emulator_screenshots/
else
    echo "❌ No screenshots found or emulator not connected"
    echo "Make sure your emulator is running first!"
fi


