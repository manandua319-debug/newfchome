# Check API Key Restrictions - Step by Step

## The Problem
Even if the Identity Toolkit API is enabled, your API key might be **restricted** and not allowing access to it.

## Quick Fix (5 minutes)

### Step 1: Open Google Cloud Console
1. Go to: https://console.cloud.google.com/apis/credentials?project=fchome-472b6
2. Or go to: https://console.cloud.google.com/ → Select project `fchome-472b6` → APIs & Services → Credentials

### Step 2: Find the API Key for the Platform You're Running
Look for the API key that matches your target:

- **Web**: `AIzaSyDQ1STjZxOtk7qarCTYpCt-VAiw6MLLGqs`
- **Android**: `AIzaSyAJHp7QsdWkG-AgCj8TbJujIiqw3DbYoI8`
- **iOS**: `AIzaSyDbAtvOeA6rn1eh0HsjAYCKQCCwSEjdBYs`

### Step 3: Click on the API Key
Click on the API key name to open the edit page.

### Step 4: Check "API restrictions"
Look at the "API restrictions" section. You'll see one of:

#### ❌ Problem: "Restrict key" is selected
- If you see a list of APIs, check if **"Identity Toolkit API"** is in the list
- If it's NOT in the list, that's the problem!

#### ✅ Solution Options:

**Option A (Easiest - For Testing):**
1. Select **"Don't restrict key"**
2. Click **"Save"**
3. Wait 2-3 minutes
4. Try your app again

**Option B (More Secure - For Production):**
1. Keep "Restrict key" selected
2. Click on the API list
3. Search for "Identity Toolkit API"
4. Check the box next to it
5. Make sure these are also included:
   - Identity Toolkit API ✅
   - Token Service API ✅
   - Firebase Authentication API (if listed)
6. Click **"Save"**
7. Wait 2-3 minutes

### Step 5: Verify
1. After saving, wait 2-3 minutes for changes to propagate
2. Clear app data:
   - Android: Settings > Apps > FCHome > Clear Data
   - iOS Simulator: delete the app from the simulator
   - Web: hard refresh the page
3. Rebuild and run your app

---

## Direct Links

- **API Key Management**: https://console.cloud.google.com/apis/credentials?project=fchome-472b6
- **Identity Toolkit API Status**: https://console.cloud.google.com/apis/library/identitytoolkit.googleapis.com?project=fchome-472b6
- **Firebase Console**: https://console.firebase.google.com/project/fchome-472b6

---

## Still Not Working?

If you've checked API restrictions and it still doesn't work:

1. Check the troubleshooting guide: `TROUBLESHOOTING_API_BLOCKED.md`
2. Verify your SHA-1 certificate fingerprint matches Firebase
3. Try enabling Anonymous authentication as a temporary workaround
