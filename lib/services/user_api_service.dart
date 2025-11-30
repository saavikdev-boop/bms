import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'api_service.dart';
import '../models/user_profile.dart';

/// User API Service
/// Handles user-related API operations and syncs with Firebase Auth
class UserApiService {
  final ApiService _apiService = ApiService();

  /// Sync Firebase user with PostgreSQL backend
  /// Should be called after Firebase authentication
  /// Supports both email/Google and phone authentication
  Future<ApiResponse<UserProfile>> syncUser(auth.User firebaseUser) async {
    // Determine auth provider
    String authProvider = 'email';
    if (firebaseUser.phoneNumber != null) {
      authProvider = 'phone';
    } else if (firebaseUser.providerData.any((info) => info.providerId == 'google.com')) {
      authProvider = 'google';
    }

    final userData = {
      'uid': firebaseUser.uid,
      'email': firebaseUser.email,
      'phone_number': firebaseUser.phoneNumber,
      'display_name': firebaseUser.displayName,
      'photo_url': firebaseUser.photoURL,
      'auth_provider': authProvider,
    };

    // Try to get existing user first
    final existingUser = await getUserById(firebaseUser.uid);

    if (existingUser.isSuccess && existingUser.data != null) {
      // User already exists in backend
      return existingUser;
    }

    // Create new user in backend
    return await createUser(userData);
  }

  /// Create a new user
  Future<ApiResponse<UserProfile>> createUser(Map<String, dynamic> userData) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/users/',
      data: userData,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(UserProfile.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to create user');
  }

  /// Get user by UID
  Future<ApiResponse<UserProfile>> getUserById(String uid) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/users/$uid',
      useCache: true,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(UserProfile.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to get user');
  }

  /// Update user profile
  Future<ApiResponse<UserProfile>> updateUser(
    String uid,
    Map<String, dynamic> updates,
  ) async {
    final response = await _apiService.put<Map<String, dynamic>>(
      '/users/$uid',
      data: updates,
    );

    if (response.isSuccess && response.data != null) {
      // Clear cache after update
      _apiService.clearCache();
      return ApiResponse.success(UserProfile.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to update user');
  }

  /// Delete user account
  Future<ApiResponse<void>> deleteUser(String uid) async {
    final response = await _apiService.delete<Map<String, dynamic>>(
      '/users/$uid',
    );

    if (response.isSuccess) {
      _apiService.clearCache();
      return ApiResponse.success(null);
    }

    return ApiResponse.error(response.error ?? 'Failed to delete user');
  }

  /// List all users (with pagination)
  Future<ApiResponse<List<UserProfile>>> listUsers({
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _apiService.get<List<dynamic>>(
      '/users/',
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
      useCache: true,
    );

    if (response.isSuccess && response.data != null) {
      final users = response.data!
          .map((json) => UserProfile.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(users);
    }

    return ApiResponse.error(response.error ?? 'Failed to list users');
  }

  /// Update user profile with file upload
  Future<ApiResponse<UserProfile>> updateUserWithPhoto(
    String uid,
    Map<String, dynamic> updates,
    File? photoFile,
  ) async {
    // Upload photo first if provided
    if (photoFile != null) {
      final uploadResponse = await _apiService.uploadFile<Map<String, dynamic>>(
        '/files/upload',
        photoFile,
        fieldName: 'file',
        additionalData: {
          'bucket': 'profile_images',
          'prefix': uid,
        },
      );

      if (uploadResponse.isSuccess && uploadResponse.data != null) {
        updates['photo_url'] = uploadResponse.data!['file_path'];
      }
    }

    // Update user with new data
    return await updateUser(uid, updates);
  }
}
