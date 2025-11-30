# Complete Google Sign-In Fix for Android

## Current Issue
Your app shows "Sign in was cancelled" because the google-services.json file is missing the Android OAuth 2.0 client configuration.

## IMMEDIATE FIX - Follow These Steps

### Step 1: Generate Debug SHA-1 Key
Open PowerShell or Command Prompt **as Administrator** and run:

```powershell
cd "C:\Users\shikhar pulluri\Desktop\flutter_phone_app\android"
.\gradlew signingReport
```

Look for output like this:
```
Variant: debug
Config: debug
Store: C:\Users\shikhar pulluri\.android\debug.keystore
Alias: AndroidDebugKey
MD5: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA256: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

**COPY THE SHA1 VALUE** (it looks like: `5E:8F:16:06:2E:A3:CD:2C:4A:0D:54:78:76:BA:A6:F3:8C:AB:F6:25`)

### Step 2: Add SHA-1 to Firebase Console

1. Open https://console.firebase.google.com/
2. Select your project: **bms-saavik**
3. Click the **gear icon** → **Project settings**
4. Scroll down to **Your apps** section
5. Find your Android app (com.example.flutter_phone_app)
6. Click **Add fingerprint**
7. Paste your SHA-1 fingerprint
8. Click **Save**

### Step 3: Configure OAuth 2.0 in Google Cloud Console

1. Open https://console.cloud.google.com/
2. Make sure **bms-saavik** is selected (top dropdown)
3. Navigate to **APIs & Services** → **Credentials**
4. Click **+ CREATE CREDENTIALS** → **OAuth client ID**
5. Select **Android** as Application type
6. Fill in:
   - **Name**: Android client for BMS Gaming
   - **Package name**: `com.example.flutter_phone_app`
   - **SHA-1 certificate fingerprint**: [Paste your SHA-1 from Step 1]
7. Click **Create**

### Step 4: Enable Google Sign-In in Firebase

1. Go back to Firebase Console
2. Navigate to **Authentication** → **Sign-in method**
3. Click on **Google**
4. Toggle **Enable**
5. Set **Project public-facing name**: BMS Gaming Hub
6. Set **Project support email**: [Your email]
7. Click **Save**

### Step 5: Download New google-services.json

1. In Firebase Console → **Project settings**
2. Under your Android app, click **Download google-services.json**
3. Replace the file at: `android/app/google_services.json`

The new file should contain:
```json
"oauth_client": [
  {
    "client_id": "312328302719-XXXXXXXXXXXXX.apps.googleusercontent.com",
    "client_type": 1,  // ← THIS IS THE ANDROID CLIENT (REQUIRED!)
    "android_info": {
      "package_name": "com.example.flutter_phone_app",
      "certificate_hash": "YOUR_SHA1_HASH"
    }
  },
  {
    "client_id": "312328302719-7anti1sbpjessdvocpg5ge1t2cjpjdfu.apps.googleusercontent.com",
    "client_type": 3  // ← Web client (already exists)
  }
]
```

### Step 6: Clean and Rebuild

```bash
cd "C:\Users\shikhar pulluri\Desktop\flutter_phone_app"
flutter clean
flutter pub get
cd android
.\gradlew clean
cd ..
flutter run
```

## Verification

Run this command to verify your configuration:
```bash
dart test/check_firebase_config.dart
```

You should see:
```
✅ Android OAuth client is configured
✅ Web OAuth client is configured
```

## Testing on Emulator

If testing on Android Emulator:
1. Make sure the emulator has Google Play Services
2. Sign in to a Google account on the emulator first
3. Then try the sign-in in your app

## Common Errors and Solutions

### Error: "Sign in was cancelled"
- **Cause**: User cancelled OR missing Android OAuth client
- **Solution**: Complete Steps 1-6 above

### Error: "12500"
- **Cause**: Missing google-services.json or wrong configuration
- **Solution**: Re-download google-services.json (Step 5)

### Error: "10" 
- **Cause**: SHA-1 mismatch
- **Solution**: Ensure correct SHA-1 is added to Firebase (Step 2)

### Error: "16"
- **Cause**: User cancelled the sign-in flow
- **Solution**: This is normal user behavior

## Debug Output

With the debug version, you'll see output like:
```
=== GOOGLE SIGN-IN DEBUG START ===
Step 1: Initiating Google Sign-In...
Step 2: User selected account: user@gmail.com
Step 3: Getting authentication tokens...
Step 4: Tokens received successfully
Step 5: Signing in to Firebase...
Step 6: SUCCESS! User signed in: user@gmail.com
```

## IMPORTANT NOTES

1. **Package Name Must Match**: Ensure `com.example.flutter_phone_app` is used everywhere
2. **SHA-1 is Critical**: The SHA-1 in Firebase MUST match your debug keystore
3. **Internet Required**: Ensure device/emulator has internet access
4. **Google Play Services**: Required on the device/emulator

## Quick Test

After setup, test with:
1. Run the app
2. Navigate to "Get Started with BM Sportz" screen
3. Click the Google logo
4. Select a Google account
5. Should redirect back to app successfully

## Still Not Working?

Check the debug console output and look for specific error messages. The debug version will show exactly where the process fails.

Contact points for the error will be:
- Step 2: User cancelled (normal)
- ERROR: Missing authentication tokens (OAuth config issue)
- FIREBASE AUTH ERROR (Firebase config issue)
- UNEXPECTED ERROR (Check stack trace)
