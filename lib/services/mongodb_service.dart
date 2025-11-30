import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/api_config.dart';

class MongoDBService {
  static final MongoDBService _instance = MongoDBService._internal();
  factory MongoDBService() => _instance;
  MongoDBService._internal();

  late final Dio _dio;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.apiUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add Firebase Auth token to requests
          final user = _auth.currentUser;
          if (user != null) {
            try {
              final token = await user.getIdToken();
              options.headers['Authorization'] = 'Bearer $token';
            } catch (e) {
              print('❌ Error getting Firebase token: $e');
            }
          }
          print('🌐 API Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ API Response: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ API Error: ${error.response?.statusCode} ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  // ========== USER CRUD OPERATIONS ==========

  // Create user profile in MongoDB
  Future<Map<String, dynamic>?> createUserProfile(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post(
        ApiConfig.users,
        data: userData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } on DioException catch (e) {
      print('❌ Error creating user profile: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
      }
      rethrow;
    }
  }

  // Get user profile from MongoDB
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final response = await _dio.get('${ApiConfig.users}/$uid');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print('⚠️ User profile not found');
        return null;
      }
      print('❌ Error getting user profile: ${e.message}');
      rethrow;
    }
  }

  // Update user profile in MongoDB
  Future<Map<String, dynamic>?> updateUserProfile(
    String uid,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _dio.patch(
        '${ApiConfig.users}/$uid',
        data: updates,
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } on DioException catch (e) {
      print('❌ Error updating user profile: ${e.message}');
      rethrow;
    }
  }

  // Delete user profile from MongoDB
  Future<bool> deleteUserProfile(String uid) async {
    try {
      final response = await _dio.delete('${ApiConfig.users}/$uid');
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      print('❌ Error deleting user profile: ${e.message}');
      return false;
    }
  }

  // ========== QUERY OPERATIONS ==========

  // Search users
  Future<List<Map<String, dynamic>>> searchUsers(Map<String, dynamic> query) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.users}/search',
        queryParameters: query,
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } on DioException catch (e) {
      print('❌ Error searching users: ${e.message}');
      return [];
    }
  }

  // Check if user profile exists
  Future<bool> userProfileExists(String uid) async {
    try {
      final response = await _dio.head('${ApiConfig.users}/$uid');
      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false;
      }
      print('❌ Error checking user existence: ${e.message}');
      return false;
    }
  }

  // ========== HEALTH CHECK ==========

  // Test connection to MongoDB backend
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('❌ Backend connection failed: ${e.message}');
      return false;
    }
  }
}
