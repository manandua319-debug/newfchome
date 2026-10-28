# Fix: Authentication API Blocked Error

If you're seeing an error like:
```
Error: An internal error has occurred. [ Requests to this API identitytoolkit method google.cloud.identitytoolkit.v1.AuthenticationService.SignInWithPassword are blocked.
```

This means the **Identity Toolkit API** is not enabled or is blocked in your Google Cloud Console.

## Quick Fix Steps

### Option 1: Enable via Firebase Console (Easiest)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **fchome-472b6**
3. Click on **Authentication** in the left sidebar
4. If you see a setup screen, click **Get Started**
5. Click on **Sign-in method** tab
6. Enable **Email/Password** provider:
   - Click on **Email/Password**
   - Toggle **Enable** to ON
   - Click **Save**

This automatically enables the Identity Toolkit API in the background.

### Option 2: Enable via Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project: **fchome-472b6**
3. Navigate to **APIs & Services** > **Library** (or search "API Library")
4. Search for **"Identity Toolkit API"**
5. Click on **Identity Toolkit API**
6. Click **Enable**

### Option 3: Check API Restrictions

If the API is enabled but still blocked, check API key restrictions:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to **APIs & Services** > **Credentials**
3. Find the API key for the platform you are running:
   - **Web**: `AIzaSyDQ1STjZxOtk7qarCTYpCt-VAiw6MLLGqs`
   - **Android**: `AIzaSyAJHp7QsdWkG-AgCj8TbJujIiqw3DbYoI8`
   - **iOS**: `AIzaSyDbAtvOeA6rn1eh0HsjAYCKQCCwSEjdBYs`
4. Click on the API key
5. Under **API restrictions**, make sure:
   - Either **Don't restrict key** is selected, OR
   - **Restrict key** includes **Identity Toolkit API**
   - **Restrict key** includes **Token Service API**
   - If listed separately, also allow **Firebase Authentication API**
6. Click **Save**

### Option 4: Check Billing (If Required)

Some Firebase features require billing to be enabled:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click on the gear icon ⚙️ > **Project settings**
4. Check if billing is enabled
5. If not, you may need to enable billing (free tier is usually fine)

## Verify the Fix

After enabling the API:

1. Wait 1-2 minutes for changes to propagate
2. Restart your Android app
3. Try signing in again

## Alternative: Test with Anonymous Auth

If you need to test the app immediately while fixing the API issue, you can use anonymous authentication:

1. In Firebase Console > Authentication > Sign-in method
2. Enable **Anonymous** provider
3. The app should have an anonymous sign-in option

## Still Having Issues?

1. **Check Project ID**: Make sure you're working with project `fchome-472b6`
2. **Check API Key**: Verify the API key in `lib/firebase_options.dart` matches your Firebase project
3. **Clear App Data**:
   - Android: Settings > Apps > Your App > Clear Data
   - iOS Simulator: uninstall the app from the simulator, then run it again
   - Web: hard refresh the page
4. **Re-download platform config if needed**: 
   - Firebase Console > Project Settings > Your Apps > Android App
   - Download the latest `google-services.json`
   - Replace the file in `android/app/google-services.json`
   - For iOS, download the latest `GoogleService-Info.plist`
   - Replace the file in `ios/Runner/GoogleService-Info.plist`

## Project Information

- **Project ID**: fchome-472b6
- **Project Number**: 788634060832
- **Android Package**: com.mycompany.maps
- **iOS Bundle ID**: com.mycompany.maps

---

**Note**: Changes to API settings can take a few minutes to propagate. If you still see errors after enabling, wait 2-3 minutes and try again.
