# Google Sign-In Fix Guide

## Problem
The error "Sign in was cancelled or failed" occurs because the google-services.json file is missing the Android OAuth client configuration.

## Required Steps

### 1. Get SHA-1 Fingerprint
```bash
cd android
gradlew signingReport
```
Copy the SHA1 value from the debug variant.

### 2. Add SHA to Firebase
1. Go to Firebase Console → Project Settings
2. Find your Android app
3. Add SHA-1 and SHA-256 fingerprints
4. Save

### 3. Create Android OAuth Client
1. Go to Google Cloud Console → APIs & Services → Credentials
2. Create new OAuth client ID
3. Choose Android type
4. Enter:
   - Package name: `com.example.flutter_phone_app`
   - SHA-1 fingerprint: (from step 1)
5. Create

### 4. Download New google-services.json
1. Go to Firebase Console → Project Settings
2. Download google-services.json
3. Replace file in `android/app/`

### 5. Verify google-services.json
The file should now contain:
```json
"oauth_client": [
  {
    "client_type": 1,  // Android client (THIS IS REQUIRED!)
    ...
  },
  {
    "client_type": 3,  // Web client
    ...
  }
]
```

### 6. Clean and Rebuild
```bash
flutter clean
flutter pub get
flutter run
```

## Common Issues

### Issue 1: PlatformException (sign_in_failed)
**Solution**: Ensure SHA-1 fingerprint is correctly added to Firebase

### Issue 2: API Exception: 10
**Solution**: 
- SHA-1 mismatch
- Wrong package name
- OAuth client not properly configured

### Issue 3: API Exception: 12500
**Solution**: 
- Missing or incorrect google-services.json
- OAuth consent screen not configured

### Issue 4: Network error
**Solution**: 
- Check internet connection
- Ensure INTERNET permission in AndroidManifest.xml

## Testing

1. Run the app on a physical device or emulator
2. Tap "Get Started with Google"
3. Select a Google account
4. Should redirect back to app successfully

## Debug Output
Check logcat for detailed error messages:
```bash
adb logcat | grep -i google
```

## Support Links
- [Firebase Console](https://console.firebase.google.com/)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth/flutter/federated-auth)
