# Architecture Changes: Firebase Auth + MongoDB Backend

## Summary

Your Flutter BMS app has been successfully restructured to use:
- **Firebase Authentication** for user sign-in (Google Sign-In, email/password, etc.)
- **MongoDB** for all data storage and retrieval
- **Local Storage** as offline fallback

## What Changed

### 1. Dependencies (`pubspec.yaml`)

**Removed:**
- `cloud_firestore: ^6.1.0` ❌

**Added:**
- `http: ^1.2.0` ✅
- `dio: ^5.4.0` ✅

**Kept:**
- `firebase_core: ^4.2.1` (for Firebase initialization)
- `firebase_auth: ^6.1.2` (for authentication)
- `google_sign_in: ^6.2.1` (for Google Sign-In)
- `shared_preferences: ^2.2.2` (for local caching)
- `connectivity_plus: ^6.1.0` (for network status)

### 2. New Files Created

#### `/lib/config/api_config.dart`
- Centralized API configuration
- Manages backend URL (local vs production)
- Configures timeouts and endpoints

#### `/lib/services/mongodb_service.dart`
- Complete MongoDB API client
- Uses Dio for HTTP requests
- Automatic Firebase token injection
- Error handling and logging
- CRUD operations for user data

#### `/MONGODB_BACKEND_SETUP.md`
- Complete backend setup guide
- Node.js/Express/MongoDB code samples
- Firebase Admin SDK integration
- Deployment instructions

### 3. Modified Files

#### `/lib/services/user_service.dart`
**Changes:**
- Replaced all Firestore calls with MongoDB API calls
- Now uses `MongoDBService` instead of `FirebaseFirestore`
- Maintained offline fallback with SharedPreferences
- Uses HTTP requests instead of Firestore SDK

**Before:**
```dart
await _firestore.collection('User Data').doc(uid).set(data);
```

**After:**
```dart
await _mongoDb.createUserProfile(data);
```

#### `/lib/main.dart`
**Changes:**
- Removed Firestore initialization
- Added MongoDB service initialization
- Added connection health check
- Kept Firebase Auth initialization

**Before:**
```dart
await FirestoreService.initializeOfflineSupport();
```

**After:**
```dart
MongoDBService().initialize();
await MongoDBService().testConnection();
```

### 4. Removed/Deprecated Files

#### `/lib/services/firestore_service.dart`
- This file still exists but is no longer used
- Can be deleted or kept as reference
- All functionality moved to `mongodb_service.dart`

## Data Flow

### Authentication Flow
```
User Login → Firebase Auth → Get ID Token → Store in App
```

### Data Operations Flow
```
Flutter App → Firebase Token → HTTP Request → MongoDB Backend → Response
     ↓ (if offline)
Local Storage (SharedPreferences)
```

## How It Works

### 1. User Authentication
- User signs in with Google (or other methods)
- Firebase Auth provides an ID token
- Token is automatically added to all API requests

### 2. Data Storage
- When user creates/updates profile:
  1. App sends HTTP request to MongoDB backend
  2. Backend verifies Firebase token
  3. Backend stores data in MongoDB
  4. Response sent back to app
  5. App caches data locally

### 3. Offline Support
- If MongoDB backend is unreachable:
  1. Data is saved to SharedPreferences
  2. App shows offline message
  3. When connection restored, data syncs automatically

## API Configuration

Update `lib/config/api_config.dart` with your backend URL:

```dart
// For local development
static const String localBaseUrl = 'http://192.168.1.100:3000/api';

// For production
static const String baseUrl = 'https://your-backend.herokuapp.com/api';

// Toggle between local and production
static const bool useLocal = true;
```

## Required Backend Endpoints

Your MongoDB backend must implement these endpoints:

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/users` | Create user profile |
| GET | `/api/users/:uid` | Get user profile |
| PATCH | `/api/users/:uid` | Update user profile |
| DELETE | `/api/users/:uid` | Delete user profile |
| HEAD | `/api/users/:uid` | Check if user exists |
| GET | `/api/users/search` | Search users |
| GET | `/api/health` | Health check |

## Security

### Firebase Token Verification
All API requests include Firebase ID token in the Authorization header:

```
Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI...
```

Your backend MUST verify this token using Firebase Admin SDK:

```javascript
const admin = require('firebase-admin');
const decodedToken = await admin.auth().verifyIdToken(token);
```

### HTTPS
Always use HTTPS in production:
- Firebase Auth tokens are sensitive
- User data should be encrypted in transit
- Prevents man-in-the-middle attacks

## Benefits of This Architecture

### 1. Flexibility
- ✅ Use any database (MongoDB, PostgreSQL, MySQL)
- ✅ Add custom business logic on backend
- ✅ Integrate with other services easily
- ✅ Scale independently

### 2. Cost Effective
- ✅ Only pay for Firebase Auth (cheap/free)
- ✅ Use free MongoDB Atlas tier
- ✅ No Firestore read/write costs
- ✅ Self-host backend if needed

### 3. Performance
- ✅ Direct MongoDB queries (faster)
- ✅ Custom indexes for your queries
- ✅ Backend caching options
- ✅ Aggregation pipelines

### 4. Control
- ✅ Full control over data structure
- ✅ Complex queries and transactions
- ✅ Data migration is easier
- ✅ Backup and restore control

## Next Steps

1. **Set up MongoDB Backend**
   - Follow `MONGODB_BACKEND_SETUP.md`
   - Deploy to Heroku/Railway/Vercel
   - Update `api_config.dart` with URL

2. **Test Authentication**
   - Sign in with Google
   - Check Firebase token generation
   - Verify backend receives token

3. **Test Data Operations**
   - Create user profile
   - Update profile
   - Check MongoDB database

4. **Test Offline Mode**
   - Disable backend
   - Try creating profile
   - Check local storage
   - Re-enable backend and verify sync

5. **Production Deployment**
   - Deploy backend to cloud
   - Enable HTTPS
   - Set up monitoring
   - Configure CORS properly

## Troubleshooting

### Issue: "Connection refused"
**Solution:** Make sure:
- Backend is running
- Using correct IP/URL in `api_config.dart`
- Both devices on same network (for local testing)

### Issue: "Unauthorized" errors
**Solution:** Check:
- Firebase token is being sent
- Backend verifies token correctly
- Firebase Admin SDK is configured

### Issue: Data not saving
**Solution:** Verify:
- Backend endpoints are correct
- MongoDB connection works
- Check backend logs for errors

## Migration from Firestore

If you had existing Firestore data:

1. Export Firestore data:
```bash
firebase firestore:export gs://your-bucket/firestore-export
```

2. Convert to MongoDB format

3. Import to MongoDB:
```bash
mongoimport --uri="mongodb://..." --collection=users --file=users.json
```

## Monitoring

### Backend Logs
```bash
# Check backend logs
tail -f logs/backend.log

# Or in Heroku
heroku logs --tail
```

### Flutter Logs
```dart
// All API calls are logged in console
// Look for:
// 🌐 API Request: POST /users
// ✅ API Response: 201 /users
// ❌ API Error: 500 Internal Server Error
```

## Support

For help:
1. Check `MONGODB_BACKEND_SETUP.md` for backend setup
2. Review this document for architecture questions
3. Check Firebase Console for auth issues
4. Review MongoDB logs for database issues

---

**Version:** 1.0.0
**Last Updated:** November 2025
**Author:** BMS Development Team
