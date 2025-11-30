# 📱 Flutter App - Backend Connection Guide

## ✅ Backend Status
- **Server:** Running on http://0.0.0.0:8000
- **Local IP:** 192.168.0.73
- **Status:** ✅ Healthy and Ready

---

## 🔗 Connection URLs for Different Devices

### 1. **iOS Simulator** (Recommended: Use localhost)
```dart
// lib/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:8000/api/v1';
}
```

**Why it works:** iOS Simulator runs on the same machine as your Mac, so `localhost` directly accesses your backend.

---

### 2. **Android Emulator** (Use 10.0.2.2)
```dart
// lib/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
}
```

**Why it works:** Android Emulator uses `10.0.2.2` as an alias for your computer's `localhost`.

---

### 3. **Physical Device** (iPhone/Android)
```dart
// lib/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'http://192.168.0.73:8000/api/v1';
}
```

**Requirements:**
- Your phone and Mac must be on the **same WiFi network**
- Use your Mac's local IP: **192.168.0.73**

---

## 🎯 Universal Configuration (Auto-detect Platform)

Create a smart config that works everywhere:

```dart
// lib/config/api_config.dart
import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    // Web
    if (kIsWeb) {
      return 'http://localhost:8000/api/v1';
    }

    // Android Emulator
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/v1';
    }

    // iOS Simulator (localhost works)
    // Physical devices (you'll need to change this to your IP)
    if (Platform.isIOS) {
      return 'http://localhost:8000/api/v1';
      // For physical iOS device, use:
      // return 'http://192.168.0.73:8000/api/v1';
    }

    return 'http://localhost:8000/api/v1';
  }

  // Alternative: Use environment variable
  static const String devUrl = 'http://localhost:8000/api/v1';
  static const String androidEmulatorUrl = 'http://10.0.2.2:8000/api/v1';
  static const String physicalDeviceUrl = 'http://192.168.0.73:8000/api/v1';
}
```

---

## 📝 Step-by-Step Integration

### Step 1: Add HTTP Package
```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
```

Run:
```bash
flutter pub get
```

### Step 2: Create API Service
```dart
// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  final String baseUrl = ApiConfig.baseUrl;

  // Test connection
  Future<bool> testConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/../health'));
      return response.statusCode == 200;
    } catch (e) {
      print('Connection error: $e');
      return false;
    }
  }

  // Get all users
  Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users/'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Get all venues
  Future<List<dynamic>> getVenues() async {
    final response = await http.get(Uri.parse('$baseUrl/venues/'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load venues');
    }
  }

  // Get all games
  Future<List<dynamic>> getGames() async {
    final response = await http.get(Uri.parse('$baseUrl/games/'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load games');
    }
  }

  // Get user bookings
  Future<List<dynamic>> getUserBookings(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/bookings/$userId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  // Get user wallet
  Future<Map<String, dynamic>> getUserWallet(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/wallet/$userId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load wallet');
    }
  }

  // Create user after Firebase auth
  Future<Map<String, dynamic>> createUser({
    required String uid,
    String? email,
    String? phoneNumber,
    String? displayName,
    String? photoUrl,
    String? authProvider,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'uid': uid,
        'email': email,
        'phone_number': phoneNumber,
        'display_name': displayName,
        'photo_url': photoUrl,
        'auth_provider': authProvider ?? 'email',
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create user: ${response.body}');
    }
  }
}
```

### Step 3: Test Connection Screen
```dart
// lib/screens/connection_test_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ConnectionTestScreen extends StatefulWidget {
  @override
  _ConnectionTestScreenState createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  final ApiService _apiService = ApiService();
  String _status = 'Testing connection...';
  bool _isConnected = false;
  List<dynamic>? _venues;

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  Future<void> _testConnection() async {
    setState(() {
      _status = 'Testing connection to backend...';
    });

    try {
      bool connected = await _apiService.testConnection();

      if (connected) {
        // Test fetching venues
        final venues = await _apiService.getVenues();
        setState(() {
          _isConnected = true;
          _venues = venues;
          _status = '✅ Connected! Found ${venues.length} venues';
        });
      } else {
        setState(() {
          _isConnected = false;
          _status = '❌ Connection failed. Check backend URL.';
        });
      }
    } catch (e) {
      setState(() {
        _isConnected = false;
        _status = '❌ Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Backend Connection Test')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Backend URL:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(_apiService.baseUrl),
            SizedBox(height: 24),
            Text(
              'Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _status,
              style: TextStyle(
                color: _isConnected ? Colors.green : Colors.red,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _testConnection,
              child: Text('Test Again'),
            ),
            SizedBox(height: 24),
            if (_venues != null) ...[
              Text(
                'Venues from Backend:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _venues!.length,
                  itemBuilder: (context, index) {
                    final venue = _venues![index];
                    return Card(
                      child: ListTile(
                        title: Text(venue['name'] ?? ''),
                        subtitle: Text(
                          '${venue['city']} - ₹${venue['price_per_hour']}/hr',
                        ),
                        trailing: Text(
                          '${venue['rating']}★',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

## 🧪 Quick Test Commands

### Test from iOS Simulator
1. Open Terminal
2. Run simulator: `open -a Simulator`
3. In Flutter project:
```bash
flutter run -d "iPhone 15 Pro"
```

### Test from Android Emulator
1. Start emulator: `emulator -avd Pixel_9` (or from Android Studio)
2. In Flutter project:
```bash
flutter run -d emulator-5554
```

### Test from Physical Device
1. Connect iPhone/Android via USB
2. Enable Developer Mode
3. Run:
```bash
flutter devices  # See available devices
flutter run -d <device-id>
```

---

## 🔍 Troubleshooting

### Issue 1: Connection Refused on iOS Simulator
**Solution:** Use `localhost:8000` - it works directly!

### Issue 2: Connection Refused on Android Emulator
**Solution:** Use `10.0.2.2:8000` instead of `localhost`

### Issue 3: Connection Refused on Physical Device
**Solutions:**
1. Make sure phone and Mac are on same WiFi
2. Use your Mac's IP: `192.168.0.73`
3. Disable firewall temporarily to test
4. Make sure backend is running on `0.0.0.0` (not `127.0.0.1`)

### Issue 4: CORS Errors
**Solution:** Backend is already configured with `allow_origins=["*"]` - CORS is enabled!

### Issue 5: How to find your Mac's IP?
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```
Current IP: **192.168.0.73**

---

## 📊 Available Endpoints

Test these in your Flutter app:

| Endpoint | Method | Example |
|----------|--------|---------|
| Get Users | GET | `/api/v1/users/` |
| Get Venues | GET | `/api/v1/venues/` |
| Get Games | GET | `/api/v1/games/` |
| Get Reels | GET | `/api/v1/reels/` |
| Get User Bookings | GET | `/api/v1/bookings/{user_id}` |
| Get User Wallet | GET | `/api/v1/wallet/{user_id}` |
| Create User | POST | `/api/v1/users/` |
| Create Booking | POST | `/api/v1/bookings/{user_id}` |

---

## ✅ Verification Checklist

Before running your Flutter app:
- [ ] Backend is running: `curl http://localhost:8000/health`
- [ ] Correct URL configured in Flutter
- [ ] Internet permission added (Android)
- [ ] HTTP package installed: `flutter pub get`
- [ ] Test connection works

---

## 🎯 Example: Integrating with Existing Screens

### Update Venue Screen
```dart
// Replace hardcoded data with API call
class VenueListScreen extends StatelessWidget {
  final ApiService _api = ApiService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _api.getVenues(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final venues = snapshot.data ?? [];

        return ListView.builder(
          itemCount: venues.length,
          itemBuilder: (context, index) {
            final venue = venues[index];
            return VenueCard(venue: venue);
          },
        );
      },
    );
  }
}
```

---

## 🚀 Ready to Go!

Your backend is running and ready to connect from:
- ✅ iOS Simulator (localhost:8000)
- ✅ Android Emulator (10.0.2.2:8000)
- ✅ Physical Devices (192.168.0.73:8000)

**Test URLs:**
- Health: http://localhost:8000/health
- API Docs: http://localhost:8000/docs
- Users: http://localhost:8000/api/v1/users/
- Venues: http://localhost:8000/api/v1/venues/

**Happy Coding! 🎉**
