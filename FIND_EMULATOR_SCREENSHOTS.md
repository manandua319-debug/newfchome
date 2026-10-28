# How to Find Android Emulator Screenshots

When you take screenshots from the Android emulator, they can be saved in different places depending on how you took them:

## Method 1: Screenshots taken via emulator controls

If you used the emulator's built-in screenshot feature:

1. **Open the emulator**
2. Click the **three dots (⋯)** on the right sidebar to open Extended Controls
3. Go to **Camera** or **More** tab
4. Click **Screenshot** - it will show you where it saved

**Common locations:**
- `~/Downloads/` (your Downloads folder)
- Desktop
- The screenshot will usually open automatically after taking it

## Method 2: Screenshots from inside the emulator

If the screenshot was taken from within the Android app (like using the device's screenshot feature):

The screenshot is saved **inside the emulator** at:
- `/sdcard/Pictures/Screenshots/` (within the emulator)

To access it:

### Option A: Pull from emulator using ADB

```bash
# List screenshots in the emulator
adb shell ls /sdcard/Pictures/Screenshots/

# Pull a specific screenshot to your computer
adb pull /sdcard/Pictures/Screenshots/screenshot.png ~/Downloads/

# Pull all screenshots
adb pull /sdcard/Pictures/Screenshots/ ~/Downloads/emulator_screenshots/
```

### Option B: Access via Android Studio

1. Open **Android Studio**
2. Click **Device File Explorer** (bottom right)
3. Navigate to: `sdcard > Pictures > Screenshots`
4. Right-click on the screenshot → **Save As...**

### Option C: Use emulator's extended controls

1. Open emulator → Click **⋯** (three dots)
2. Go to **Phone** tab
3. Scroll to **Pictures** section
4. You can see and export screenshots from there

## Method 3: Quick Find - Check Recent Files

Run this command in terminal to find recent screenshots:

```bash
find ~/Downloads -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) -mtime -1 -ls
```

## Quick Check: Find Screenshots from Today

I can help you find screenshots taken today. Common locations:

1. **Downloads folder**: `~/Downloads/`
2. **Desktop**: `~/Desktop/`
3. **Inside emulator**: Need to pull via ADB (see Method 2)

## Tip: Set a Default Location

You can configure where emulator screenshots are saved:
1. Open emulator → Click **⋯**
2. Go to **Settings** → **Screenshot**
3. Set your preferred save location

---

**Your recent screenshots in Downloads:**
- Check: `/Users/manan/Downloads/` for files with "Screenshot" in the name

