# Troubleshooting: API Still Blocked (Even When Enabled)

If the Identity Toolkit API is enabled but you're still getting the "blocked" error, check these:

## 🔍 Issue #1: API Key Restrictions (Most Common)

Your API key might be restricted and not allowing Identity Toolkit API access.

### Check & Fix:

1. **Go to Google Cloud Console**: https://console.cloud.google.com/
2. **Select project**: `fchome-472b6`
3. **Navigate to**: APIs & Services > Credentials
4. **Find the API key for the platform you are running**:
   - **Web**: `AIzaSyDQ1STjZxOtk7qarCTYpCt-VAiw6MLLGqs`
   - **Android**: `AIzaSyAJHp7QsdWkG-AgCj8TbJujIiqw3DbYoI8`
   - **iOS**: `AIzaSyDbAtvOeA6rn1eh0HsjAYCKQCCwSEjdBYs`
5. **Click on the API key** to edit it
6. **Check "API restrictions"**:
   - ✅ **Option A (Recommended)**: Select **"Don't restrict key"** temporarily to test
   - ✅ **Option B**: If restricted, make sure **"Identity Toolkit API"** and **"Token Service API"** are in the allowed list
7. **Click "Save"**
8. **Wait 2-3 minutes** for changes to propagate

---

## 🔍 Issue #2: Android Certificate SHA-1 Hash

The app's certificate hash might not match Firebase configuration.

### Check & Fix:

1. **Get your app's SHA-1 fingerprint**:
   ```bash
   cd android
   ./gradlew signingReport
   ```
   
   Look for the SHA-1 fingerprint (looks like: `a3f483d464d1b79913e6ee8c3c07df253e7df6dd`)

2. **Verify in Firebase Console**:
   - Go to Firebase Console > Project Settings > Your Apps > Android App
   - Scroll to "SHA certificate fingerprints"
   - Make sure your debug/release SHA-1 is listed
   - If missing, add it

3. **Re-download google-services.json**:
   - After adding SHA-1, download the updated `google-services.json`
   - Replace the file in `android/app/google-services.json`

---

## 🔍 Issue #3: App Package Name Mismatch

Verify the package name matches exactly.

### Your Current Package:
- Package: `com.mycompany.maps` (from AndroidManifest.xml)
- Firebase App ID: `1:788634060832:android:4ee2899db4543b3f855445`

### Verify:
1. Firebase Console > Project Settings > Your Apps
2. Check Android app package name matches: `com.mycompany.maps`
3. If different, either:
   - Update package name in AndroidManifest.xml to match Firebase, OR
   - Add a new Android app in Firebase with the correct package name

---

## 🔍 Issue #4: Billing Account

Some Firebase features require billing even on free tier.

### Check:
1. Firebase Console > Project Settings
2. Look for billing status
3. If billing not enabled, enable it (free tier is usually fine)

---

## 🔍 Issue #5: Clear Cache & Rebuild

Sometimes cached configurations cause issues.

### Try:
```bash
# Clean Flutter build
flutter clean

# Clear Android build
cd android
./gradlew clean
cd ..

# Rebuild
flutter pub get
flutter run
```

---

## 🔍 Issue #6: Check API Status Directly

Verify the API is actually enabled:

1. Google Cloud Console > APIs & Services > Enabled APIs
2. Search for "Identity Toolkit API"
3. Should show "Enabled" with a green checkmark
4. If not, click "Enable API"

---

## ✅ Quick Test Steps

After making changes:

1. **Wait 2-3 minutes** (API changes take time to propagate)
2. **Clear app data** on your Android device/emulator:
   - Settings > Apps > FCHome > Storage > Clear Data
3. **Rebuild and run**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
4. **Try signing in** again

---

## 🚀 Alternative: Use Anonymous Auth (Quick Test)

To test the app while fixing email auth:

1. Firebase Console > Authentication > Sign-in method
2. Enable **"Anonymous"** provider
3. Use anonymous sign-in in your app

---

## 📋 Your Current Configuration

- **Project ID**: `fchome-472b6`
- **Web API Key**: `AIzaSyDQ1STjZxOtk7qarCTYpCt-VAiw6MLLGqs`
- **Android API Key**: `AIzaSyAJHp7QsdWkG-AgCj8TbJujIiqw3DbYoI8`
- **iOS API Key**: `AIzaSyDbAtvOeA6rn1eh0HsjAYCKQCCwSEjdBYs`
- **Package Name**: `com.mycompany.maps`
- **iOS Bundle ID**: `com.mycompany.maps`
- **Certificate Hash**: `a3f483d464d1b79913e6ee8c3c07df253e7df6dd`

---

**Most likely fix**: Check API key restrictions first (Issue #1)!
