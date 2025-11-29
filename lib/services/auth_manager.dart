import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_api_service.dart';
import 'phone_auth_service.dart';
import 'api_service.dart';

/// Unified Authentication Manager
/// Handles all authentication methods: Google Sign-In, Phone Auth, Email/Password
/// Syncs user data with backend PostgreSQL database
class AuthManager {
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final PhoneAuthService _phoneAuthService = PhoneAuthService();
  final UserApiService _userApiService = UserApiService();
  final ApiService _apiService = ApiService();
  final Logger _logger = Logger();

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Is user logged in
  bool get isLoggedIn => _auth.currentUser != null;

  AuthManager._internal() {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _logger.i('👤 User signed in: ${user.uid}');
        _syncUserWithBackend(user);
      } else {
        _logger.i('👋 User signed out');
      }
    });
  }

  /// Google Sign-In
  Future<AuthResult> signInWithGoogle() async {
    try {
      _logger.i('🔐 Starting Google Sign-In');

      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return AuthResult.error('Sign in cancelled');
      }

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        _logger.i('✅ Google Sign-In successful');

        // Sync with backend
        final syncResult = await _syncUserWithBackend(userCredential.user!);

        if (syncResult.isSuccess) {
          return AuthResult.success(
            'Signed in successfully',
            user: userCredential.user,
          );
        } else {
          return AuthResult.error('Failed to sync user data');
        }
      }

      return AuthResult.error('Sign in failed');
    } catch (e) {
      _logger.e('❌ Google Sign-In error: $e');
      return AuthResult.error('Google Sign-In failed: ${e.toString()}');
    }
  }

  /// Phone Authentication - Send OTP
  Future<AuthResult> sendPhoneOTP({
    required String phoneNumber,
    required Function(PhoneAuthCredential) onAutoVerify,
    required Function(String error) onError,
  }) async {
    try {
      _logger.i('📱 Sending OTP to $phoneNumber');

      final result = await _phoneAuthService.sendOTP(
        phoneNumber: phoneNumber,
        onAutoVerify: (credential) async {
          // Auto-verify and sync
          final signInResult = await _signInWithPhoneCredential(credential);
          if (signInResult.isSuccess) {
            onAutoVerify(credential);
          } else {
            onError(signInResult.message);
          }
        },
        onError: onError,
      );

      return AuthResult.success(result.message);
    } catch (e) {
      _logger.e('❌ Send OTP error: $e');
      return AuthResult.error('Failed to send OTP: ${e.toString()}');
    }
  }

  /// Phone Authentication - Verify OTP
  Future<AuthResult> verifyPhoneOTP({
    required String otpCode,
    String? verificationId,
  }) async {
    try {
      _logger.i('🔐 Verifying OTP');

      final result = await _phoneAuthService.verifyOTP(
        otpCode: otpCode,
        verificationId: verificationId,
      );

      if (result.isSuccess && result.user != null) {
        // Sync with backend
        final syncResult = await _syncUserWithBackend(result.user!);

        if (syncResult.isSuccess) {
          return AuthResult.success(
            'Phone verified successfully',
            user: result.user,
          );
        } else {
          return AuthResult.error('Failed to sync user data');
        }
      }

      return AuthResult.error(result.message);
    } catch (e) {
      _logger.e('❌ Verify OTP error: $e');
      return AuthResult.error('Failed to verify OTP: ${e.toString()}');
    }
  }

  /// Sign in with phone credential (internal)
  Future<AuthResult> _signInWithPhoneCredential(PhoneAuthCredential credential) async {
    try {
      final result = await _phoneAuthService.signInWithCredential(credential);

      if (result.isSuccess && result.user != null) {
        // Sync with backend
        await _syncUserWithBackend(result.user!);
        return AuthResult.success('Signed in successfully', user: result.user);
      }

      return AuthResult.error(result.message);
    } catch (e) {
      _logger.e('❌ Sign in with credential error: $e');
      return AuthResult.error('Sign in failed: ${e.toString()}');
    }
  }

  /// Sync Firebase user with PostgreSQL backend
  Future<AuthResult> _syncUserWithBackend(User user) async {
    try {
      _logger.i('🔄 Syncing user with backend: ${user.uid}');

      final response = await _userApiService.syncUser(user);

      if (response.isSuccess) {
        _logger.i('✅ User synced with backend');

        // Save user data to local storage
        await _saveUserLocally(user);

        return AuthResult.success('User synced successfully');
      } else {
        _logger.e('❌ Failed to sync user: ${response.error}');
        return AuthResult.error(response.error ?? 'Sync failed');
      }
    } catch (e) {
      _logger.e('❌ Sync error: $e');
      return AuthResult.error('Sync failed: ${e.toString()}');
    }
  }

  /// Save user data to local storage
  Future<void> _saveUserLocally(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.uid);
    await prefs.setString('user_email', user.email ?? '');
    await prefs.setString('user_phone', user.phoneNumber ?? '');
  }

  /// Get stored user ID
  Future<String?> getStoredUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      _logger.i('👋 Signing out');

      // Sign out from Firebase
      await _auth.signOut();

      // Sign out from Google
      await _googleSignIn.signOut();

      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Clear API cache
      _apiService.clearCache();

      _logger.i('✅ Sign out successful');
    } catch (e) {
      _logger.e('❌ Sign out error: $e');
    }
  }

  /// Delete account
  Future<AuthResult> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) {
        return AuthResult.error('No user logged in');
      }

      _logger.i('🗑️ Deleting account: ${user.uid}');

      // Delete from backend
      final deleteResponse = await _userApiService.deleteUser(user.uid);

      if (!deleteResponse.isSuccess) {
        return AuthResult.error('Failed to delete user from backend');
      }

      // Delete from Firebase
      await user.delete();

      // Clear local data
      await signOut();

      _logger.i('✅ Account deleted successfully');
      return AuthResult.success('Account deleted successfully');
    } catch (e) {
      _logger.e('❌ Delete account error: $e');
      return AuthResult.error('Failed to delete account: ${e.toString()}');
    }
  }

  /// Update user profile
  Future<AuthResult> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        return AuthResult.error('No user logged in');
      }

      _logger.i('🔄 Updating profile');

      // Update Firebase profile
      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoURL);
      await user.reload();

      // Update backend
      final updates = <String, dynamic>{};
      if (displayName != null) updates['display_name'] = displayName;
      if (photoURL != null) updates['photo_url'] = photoURL;

      final response = await _userApiService.updateUser(user.uid, updates);

      if (response.isSuccess) {
        _logger.i('✅ Profile updated successfully');
        return AuthResult.success('Profile updated successfully');
      }

      return AuthResult.error('Failed to update profile');
    } catch (e) {
      _logger.e('❌ Update profile error: $e');
      return AuthResult.error('Failed to update profile: ${e.toString()}');
    }
  }

  /// Reload current user
  Future<void> reloadUser() async {
    await currentUser?.reload();
  }

  /// Get auth provider name
  String getAuthProvider() {
    final user = currentUser;
    if (user == null) return 'none';

    if (user.phoneNumber != null) return 'phone';
    if (user.providerData.any((info) => info.providerId == 'google.com')) return 'google';
    return 'email';
  }
}

/// Authentication Result wrapper
class AuthResult {
  final bool isSuccess;
  final String message;
  final User? user;

  AuthResult._({
    required this.isSuccess,
    required this.message,
    this.user,
  });

  factory AuthResult.success(String message, {User? user}) {
    return AuthResult._(
      isSuccess: true,
      message: message,
      user: user,
    );
  }

  factory AuthResult.error(String message) {
    return AuthResult._(
      isSuccess: false,
      message: message,
    );
  }
}
