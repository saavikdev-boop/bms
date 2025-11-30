class ApiConfig {
  // MongoDB Backend API URL
  // TODO: Replace with your actual MongoDB backend URL
  static const String baseUrl = 'http://your-mongodb-backend-url.com/api';

  // For local development (use your computer's IP address, not localhost)
  // Example: 'http://192.168.1.100:3000/api'
  static const String localBaseUrl = 'http://localhost:3000/api';

  // Use this flag to switch between production and local
  static const bool useLocal = true;

  static String get apiUrl => useLocal ? localBaseUrl : baseUrl;

  // API Endpoints
  static const String users = '/users';
  static const String auth = '/auth';
  static const String profile = '/profile';

  // Timeout settings
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
