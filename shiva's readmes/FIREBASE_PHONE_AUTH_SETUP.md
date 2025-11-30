# Firebase Phone Authentication Setup Guide

## Overview

This guide will help you enable and configure Phone Authentication (OTP) in your BMS application using Firebase.

---

## Prerequisites

- Firebase project already created
- Firebase CLI installed
- Flutter app connected to Firebase
- Google Sign-In already configured

---

## Step 1: Enable Phone Authentication in Firebase Console

### 1.1 Navigate to Authentication

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (BMS)
3. Click on **Authentication** in the left sidebar
4. Click on **Sign-in method** tab

### 1.2 Enable Phone Provider

1. Click on **Phone** in the list of providers
2. Toggle **Enable** to ON
3. Click **Save**

![Phone Authentication Enable](https://firebase.google.com/docs/auth/images/phone-auth-1.png)

---

## Step 2: Configure Android for Phone Auth

### 2.1 Update android/app/build.gradle

Ensure you have the following dependencies:

```gradle
dependencies {
    // Firebase
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-auth'

    // Play Services Auth (required for SafetyNet)
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
    implementation 'com.google.android.gms:play-services-safetynet:18.0.1'
}
```

### 2.2 Enable SafetyNet API

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Navigate to **APIs & Services** > **Library**
4. Search for "Android Device Verification"
5. Click on **Android Device Verification API**
6. Click **Enable**

### 2.3 Get SHA-256 Certificate Fingerprint

```bash
# For debug builds
cd android
./gradlew signingReport

# Look for SHA-256 under "Task :app:signingReport"
# Copy the SHA-256 value
```

### 2.4 Add SHA-256 to Firebase

1. Go to Firebase Console > Project Settings
2. Scroll down to "Your apps"
3. Select your Android app
4. Click "Add fingerprint"
5. Paste the SHA-256 certificate fingerprint
6. Click Save

---

## Step 3: Configure iOS for Phone Auth

### 3.1 Enable Push Notifications

Phone Auth on iOS requires Apple Push Notification service (APNs).

1. Open your project in Xcode
2. Select your project in the navigator
3. Select your app target
4. Go to **Signing & Capabilities** tab
5. Click **+ Capability**
6. Add **Push Notifications**
7. Add **Background Modes**
   - Enable "Remote notifications"

### 3.2 Configure APNs in Firebase

1. Get APNs Authentication Key from Apple Developer:
   - Go to [Apple Developer Portal](https://developer.apple.com/account/)
   - Navigate to **Certificates, Identifiers & Profiles**
   - Click **Keys**
   - Click **+** to create a new key
   - Give it a name (e.g., "Firebase APNs Key")
   - Enable **Apple Push Notifications service (APNs)**
   - Click **Continue** and **Register**
   - Download the `.p8` file

2. Upload APNs Key to Firebase:
   - Go to Firebase Console > Project Settings
   - Select **Cloud Messaging** tab
   - Under iOS app configuration, upload APNs Authentication Key:
     - Key ID (from Apple Developer portal)
     - Team ID (from Apple Developer portal)
     - Upload the `.p8` file

### 3.3 Update ios/Runner/Info.plist

Ensure you have the following:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

---

## Step 4: Test Phone Authentication

### 4.1 Add Test Phone Numbers (Optional)

For testing without sending real SMS:

1. Go to Firebase Console > Authentication > Sign-in method
2. Scroll down to **Phone numbers for testing**
3. Click **Add phone number**
4. Enter phone number: `+1 555-123-4567`
5. Enter verification code: `123456`
6. Click **Add**

Now you can test with this number without receiving real SMS.

### 4.2 Test in App

1. Run your Flutter app:
   ```bash
   flutter run
   ```

2. Navigate to Phone Authentication screen
3. Enter test phone number: `+1 555-123-4567`
4. Click "Send OTP"
5. Enter verification code: `123456`
6. Should sign in successfully!

---

## Step 5: Security Configuration (Production)

### 5.1 Enable App Verification (Android)

For production, enable reCAPTCHA verification:

1. Firebase automatically uses SafetyNet on Android
2. On iOS, Firebase uses silent APNs notifications
3. If verification fails, user will see reCAPTCHA challenge

### 5.2 Set SMS Quota Limits

1. Go to Firebase Console > Authentication > Settings
2. Under **SMS Quota**, configure limits:
   - Daily SMS limit
   - Per-number limit
3. Enable monitoring and alerts

### 5.3 Implement Rate Limiting

Already implemented in the app:
- 60-second cooldown between OTP requests
- Maximum 3 retry attempts
- Exponential backoff on failures

---

## Step 6: Country Support

### Supported Countries

Phone authentication works in most countries. Common ones configured:

- 🇺🇸 United States (+1)
- 🇮🇳 India (+91)
- 🇬🇧 United Kingdom (+44)
- 🇦🇺 Australia (+61)
- 🇦🇪 UAE (+971)
- 🇸🇦 Saudi Arabia (+966)
- 🇧🇷 Brazil (+55)
- And 15+ more...

To add more countries, update `lib/services/phone_auth_service.dart`:

```dart
class CountryCodes {
  static const Map<String, String> codes = {
    'US': '+1',
    'IN': '+91',
    // Add your country here
    'XX': '+XXX',
  };
}
```

---

## Step 7: Backend Database Migration

### Run Database Migration

The backend is already updated to support phone authentication. Just need to migrate the database:

```bash
cd backend
source venv/bin/activate

# Drop and recreate tables (WARNING: This will delete all data!)
python -c "from app.main import app; from app.core.database import Base, engine; Base.metadata.drop_all(bind=engine); Base.metadata.create_all(bind=engine); print('✅ Database migrated successfully')"
```

Or for production (preserve data):

```bash
# Install alembic for migrations
pip install alembic

# Create migration
alembic revision --autogenerate -m "Add phone authentication fields"

# Apply migration
alembic upgrade head
```

---

## Step 8: Testing Checklist

### Android Testing

- [ ] Send OTP to real phone number
- [ ] Receive SMS with OTP
- [ ] Verify OTP successfully
- [ ] Auto-verification works (instant verification)
- [ ] Resend OTP works after 60 seconds
- [ ] Invalid OTP shows error
- [ ] User synced with backend

### iOS Testing

- [ ] Send OTP to real phone number
- [ ] Receive SMS with OTP
- [ ] Verify OTP successfully
- [ ] Silent APNs notification works
- [ ] Resend OTP works
- [ ] Invalid OTP shows error
- [ ] User synced with backend

### Backend Testing

- [ ] User created in PostgreSQL with phone_number
- [ ] auth_provider set to 'phone'
- [ ] Wallet auto-created for user
- [ ] User can be retrieved by UID
- [ ] Phone number is unique in database

---

## Troubleshooting

### Issue: "SMS not sent" error

**Solution:**
1. Check Firebase Console quota limits
2. Verify phone number format (must be E.164: +<country code><number>)
3. Check SafetyNet API is enabled (Android)
4. Verify APNs configured correctly (iOS)

### Issue: "quota-exceeded" error

**Solution:**
1. Wait 24 hours (daily quota reset)
2. Increase quota in Firebase Console
3. Use test phone numbers for development

### Issue: Auto-verification not working (Android)

**Solution:**
1. Verify SHA-256 certificate in Firebase
2. Check Google Play Services is up-to-date
3. Ensure app is signed with same certificate

### Issue: "invalid-verification-code"

**Solution:**
1. OTP codes expire after 60 seconds
2. Request a new OTP
3. Ensure user enters exactly 6 digits
4. Check for copy-paste issues (extra spaces)

### Issue: iOS not receiving OTP

**Solution:**
1. Check APNs certificate in Firebase
2. Verify Push Notifications capability enabled
3. Test with real device (not simulator for production)
4. Check device has cellular/wifi connection

---

## Usage in App

### Phone Auth Flow

1. User taps "Sign in with Phone Number"
2. App shows Phone Input Screen
3. User selects country code and enters phone number
4. App sends OTP via Firebase
5. App shows OTP Verification Screen
6. User enters 6-digit OTP
7. Firebase verifies OTP
8. User signed in to Firebase
9. User synced with PostgreSQL backend
10. User redirected to Dashboard

### Code Example

```dart
import 'package:flutter_phone_app/services/auth_manager.dart';

final authManager = AuthManager();

// Send OTP
Future<void> sendOTP(String phoneNumber) async {
  final result = await authManager.sendPhoneOTP(
    phoneNumber: phoneNumber,
    onAutoVerify: (credential) {
      // Auto-verified (Android only)
      print('Auto-verification successful!');
    },
    onError: (error) {
      print('Error: $error');
    },
  );

  if (result.isSuccess) {
    // Navigate to OTP screen
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => OTPVerificationScreen(phoneNumber: phoneNumber),
    ));
  }
}

// Verify OTP
Future<void> verifyOTP(String otpCode) async {
  final result = await authManager.verifyPhoneOTP(otpCode: otpCode);

  if (result.isSuccess) {
    // Success! Navigate to dashboard
    Navigator.pushReplacementNamed(context, '/dashboard');
  } else {
    // Show error
    showError(result.message);
  }
}
```

---

## Security Best Practices

1. **Rate Limiting**: Implemented (60s cooldown, 3 retries)
2. **OTP Expiry**: Firebase OTPs expire after 60 seconds
3. **Unique Phone Numbers**: Backend enforces unique constraint
4. **Secure Storage**: User data encrypted in SharedPreferences
5. **HTTPS Only**: All API calls use HTTPS
6. **Token Management**: Firebase auth tokens auto-refresh
7. **Session Management**: Tokens stored securely
8. **Logout**: Complete cleanup of local data

---

## Cost Considerations

### Firebase Phone Auth Pricing

- **Free Tier**: 10,000 verifications/month
- **Paid**: $0.01 per verification after free tier

For India specifically:
- Rates may vary by carrier
- Consider using test numbers during development

### Optimization Tips

1. Use test phone numbers for development
2. Implement proper error handling to avoid unnecessary retries
3. Cache user sessions to minimize re-authentication
4. Use Google Sign-In as alternative (no SMS costs)

---

## Support

### Firebase Documentation

- [Phone Authentication](https://firebase.google.com/docs/auth/android/phone-auth)
- [iOS Setup](https://firebase.google.com/docs/auth/ios/phone-auth)
- [Android Setup](https://firebase.google.com/docs/auth/android/phone-auth)

### Common Error Codes

| Error Code | Meaning | Solution |
|------------|---------|----------|
| `invalid-phone-number` | Invalid format | Use E.164 format (+country code) |
| `quota-exceeded` | Daily limit reached | Wait 24h or increase quota |
| `invalid-verification-code` | Wrong OTP | Re-enter correct 6-digit code |
| `session-expired` | OTP expired | Request new OTP |
| `too-many-requests` | Rate limited | Wait before retrying |

---

## Checklist

Before going to production:

- [ ] Phone authentication enabled in Firebase Console
- [ ] SafetyNet API enabled (Android)
- [ ] APNs configured (iOS)
- [ ] SHA-256 certificates added
- [ ] Test phone numbers working
- [ ] Real phone numbers tested
- [ ] Backend database migrated
- [ ] Error handling implemented
- [ ] Rate limiting configured
- [ ] Security rules reviewed
- [ ] Quota limits set
- [ ] Monitoring enabled

---

## Next Steps

1. **Enable in Firebase** - Follow Steps 1-3
2. **Test Locally** - Use test phone numbers
3. **Migrate Database** - Run Step 7
4. **Test End-to-End** - Follow Step 8 checklist
5. **Deploy to Production** - After successful testing

**Estimated Setup Time**: 30-45 minutes

---

## Additional Features

### Already Implemented

✅ Auto-verification on Android
✅ Resend OTP functionality
✅ 60-second countdown timer
✅ Beautiful UI/UX
✅ Error handling with user-friendly messages
✅ Backend sync with PostgreSQL
✅ Support for 20+ countries
✅ Unified authentication manager
✅ Session management
✅ Secure token storage

### Future Enhancements

- [ ] SMS template customization
- [ ] Multi-factor authentication (MFA)
- [ ] Social auth linking (link phone to Google account)
- [ ] Phone number verification for existing users
- [ ] Admin dashboard for user management

---

## Summary

You now have a complete phone authentication system with:

- 📱 OTP-based authentication
- 🔐 Secure Firebase integration
- 💾 PostgreSQL backend sync
- 🎨 Beautiful UI screens
- 🚀 Production-ready code
- 🌍 Multi-country support
- ✅ Comprehensive error handling

Just enable phone auth in Firebase Console and you're ready to go!

