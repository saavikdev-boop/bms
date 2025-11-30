import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

/// Phone Authentication Service
/// Handles Firebase phone authentication with OTP verification
class PhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();

  // Verification ID for OTP verification
  String? _verificationId;
  int? _resendToken;

  /// Send OTP to phone number
  /// Returns true if OTP sent successfully
  Future<PhoneAuthResult> sendOTP({
    required String phoneNumber,
    required Function(PhoneAuthCredential) onAutoVerify,
    required Function(String error) onError,
    int? resendToken,
  }) async {
    try {
      _logger.i('📱 Sending OTP to $phoneNumber');

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        forceResendingToken: resendToken,

        // Auto-verification (Android only)
        verificationCompleted: (PhoneAuthCredential credential) async {
          _logger.i('✅ Auto-verification completed');
          onAutoVerify(credential);
        },

        // Verification failed
        verificationFailed: (FirebaseAuthException e) {
          _logger.e('❌ Verification failed: ${e.message}');
          String errorMessage = _getErrorMessage(e);
          onError(errorMessage);
        },

        // OTP sent successfully
        codeSent: (String verificationId, int? resendToken) {
          _logger.i('📨 OTP sent successfully');
          _verificationId = verificationId;
          _resendToken = resendToken;
        },

        // Auto-retrieval timeout
        codeAutoRetrievalTimeout: (String verificationId) {
          _logger.w('⏰ Auto-retrieval timeout');
          _verificationId = verificationId;
        },
      );

      return PhoneAuthResult.success(
        'OTP sent successfully',
        resendToken: _resendToken,
      );
    } catch (e) {
      _logger.e('Error sending OTP: $e');
      return PhoneAuthResult.error('Failed to send OTP: ${e.toString()}');
    }
  }

  /// Verify OTP code
  Future<PhoneAuthResult> verifyOTP({
    required String otpCode,
    String? verificationId,
  }) async {
    try {
      _logger.i('🔐 Verifying OTP code');

      final String vidToUse = verificationId ?? _verificationId ?? '';

      if (vidToUse.isEmpty) {
        return PhoneAuthResult.error('Verification ID not found. Please resend OTP.');
      }

      // Create credential
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: vidToUse,
        smsCode: otpCode,
      );

      // Sign in with credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        _logger.i('✅ OTP verified successfully');
        return PhoneAuthResult.success(
          'Phone number verified successfully',
          user: userCredential.user,
        );
      } else {
        return PhoneAuthResult.error('Verification failed');
      }
    } on FirebaseAuthException catch (e) {
      _logger.e('❌ OTP verification failed: ${e.message}');
      return PhoneAuthResult.error(_getErrorMessage(e));
    } catch (e) {
      _logger.e('Error verifying OTP: $e');
      return PhoneAuthResult.error('Failed to verify OTP: ${e.toString()}');
    }
  }

  /// Sign in with phone credential (for auto-verification)
  Future<PhoneAuthResult> signInWithCredential(PhoneAuthCredential credential) async {
    try {
      _logger.i('🔐 Signing in with phone credential');

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        _logger.i('✅ Sign in successful');
        return PhoneAuthResult.success(
          'Signed in successfully',
          user: userCredential.user,
        );
      } else {
        return PhoneAuthResult.error('Sign in failed');
      }
    } on FirebaseAuthException catch (e) {
      _logger.e('❌ Sign in failed: ${e.message}');
      return PhoneAuthResult.error(_getErrorMessage(e));
    } catch (e) {
      _logger.e('Error signing in: $e');
      return PhoneAuthResult.error('Failed to sign in: ${e.toString()}');
    }
  }

  /// Resend OTP
  Future<PhoneAuthResult> resendOTP({
    required String phoneNumber,
    required Function(PhoneAuthCredential) onAutoVerify,
    required Function(String error) onError,
  }) async {
    if (_resendToken == null) {
      return PhoneAuthResult.error('Cannot resend OTP yet. Please wait.');
    }

    return await sendOTP(
      phoneNumber: phoneNumber,
      onAutoVerify: onAutoVerify,
      onError: onError,
      resendToken: _resendToken,
    );
  }

  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    _verificationId = null;
    _resendToken = null;
    _logger.i('👋 User signed out');
  }

  /// Get user-friendly error messages
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'Invalid phone number format';
      case 'invalid-verification-code':
        return 'Invalid OTP code. Please check and try again.';
      case 'invalid-verification-id':
        return 'Verification session expired. Please resend OTP.';
      case 'session-expired':
        return 'OTP session expired. Please request a new code.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'operation-not-allowed':
        return 'Phone authentication is not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return e.message ?? 'Authentication failed';
    }
  }

  /// Format phone number to E.164 format
  /// Example: +1234567890
  String formatPhoneNumber(String phoneNumber, String countryCode) {
    // Remove any non-digit characters
    String digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Add country code if not present
    if (!digitsOnly.startsWith(countryCode)) {
      digitsOnly = countryCode + digitsOnly;
    }

    // Add + prefix
    if (!digitsOnly.startsWith('+')) {
      digitsOnly = '+$digitsOnly';
    }

    return digitsOnly;
  }

  /// Validate phone number format
  bool isValidPhoneNumber(String phoneNumber) {
    // Basic validation for E.164 format
    // Should start with + and have 10-15 digits
    final regex = RegExp(r'^\+[1-9]\d{1,14}$');
    return regex.hasMatch(phoneNumber);
  }

  /// Get verification ID (for testing/debugging)
  String? get verificationId => _verificationId;
}

/// Phone Auth Result wrapper
class PhoneAuthResult {
  final bool isSuccess;
  final String message;
  final User? user;
  final int? resendToken;

  PhoneAuthResult._({
    required this.isSuccess,
    required this.message,
    this.user,
    this.resendToken,
  });

  factory PhoneAuthResult.success(
    String message, {
    User? user,
    int? resendToken,
  }) {
    return PhoneAuthResult._(
      isSuccess: true,
      message: message,
      user: user,
      resendToken: resendToken,
    );
  }

  factory PhoneAuthResult.error(String message) {
    return PhoneAuthResult._(
      isSuccess: false,
      message: message,
    );
  }
}

/// Country codes for phone authentication
class CountryCodes {
  static const Map<String, String> codes = {
    'US': '+1',      // United States
    'IN': '+91',     // India
    'GB': '+44',     // United Kingdom
    'CA': '+1',      // Canada
    'AU': '+61',     // Australia
    'DE': '+49',     // Germany
    'FR': '+33',     // France
    'IT': '+39',     // Italy
    'ES': '+34',     // Spain
    'BR': '+55',     // Brazil
    'MX': '+52',     // Mexico
    'JP': '+81',     // Japan
    'CN': '+86',     // China
    'KR': '+82',     // South Korea
    'SG': '+65',     // Singapore
    'AE': '+971',    // United Arab Emirates
    'SA': '+966',    // Saudi Arabia
    'ZA': '+27',     // South Africa
    'NG': '+234',    // Nigeria
    'EG': '+20',     // Egypt
  };

  static String getCode(String countryCode) {
    return codes[countryCode.toUpperCase()] ?? '+1';
  }

  static List<CountryCode> getAllCodes() {
    return codes.entries
        .map((e) => CountryCode(code: e.key, dialCode: e.value))
        .toList();
  }
}

/// Country code model
class CountryCode {
  final String code;
  final String dialCode;

  CountryCode({
    required this.code,
    required this.dialCode,
  });

  String get displayText => '$code ($dialCode)';
}
