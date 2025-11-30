import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration class for accessing environment variables
class EnvConfig {
  /// Get Google Maps API Key
  static String get googleMapsApiKey {
    return dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  }

  /// Get Firebase API Key
  static String get firebaseApiKey {
    return dotenv.env['FIREBASE_API_KEY'] ?? '';
  }

  /// Check if environment variables are loaded
  static bool get isLoaded {
    return dotenv.env.isNotEmpty;
  }
}
