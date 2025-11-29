import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/phone_auth_service.dart';
import '../services/user_api_service.dart';
import 'otp_verification_screen.dart';

/// Phone Authentication Screen
/// Allows users to enter their phone number for OTP-based authentication
class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final PhoneAuthService _phoneAuthService = PhoneAuthService();
  final UserApiService _userApiService = UserApiService();
  final TextEditingController _phoneController = TextEditingController();

  String _selectedCountryCode = '+91'; // Default to India
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    // Clear previous errors
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    // Validate phone number
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your phone number';
        _isLoading = false;
      });
      return;
    }

    // Format phone number
    final formattedPhone = _phoneAuthService.formatPhoneNumber(
      phoneNumber,
      _selectedCountryCode,
    );

    if (!_phoneAuthService.isValidPhoneNumber(formattedPhone)) {
      setState(() {
        _errorMessage = 'Invalid phone number format';
        _isLoading = false;
      });
      return;
    }

    // Send OTP
    final result = await _phoneAuthService.sendOTP(
      phoneNumber: formattedPhone,
      onAutoVerify: (credential) async {
        // Auto-verification successful (Android only)
        await _handleAutoVerification(credential);
      },
      onError: (error) {
        setState(() {
          _errorMessage = error;
          _isLoading = false;
        });
      },
    );

    if (result.isSuccess) {
      // Navigate to OTP verification screen
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(
              phoneNumber: formattedPhone,
              verificationId: _phoneAuthService.verificationId,
            ),
          ),
        );
      }
    } else {
      setState(() {
        _errorMessage = result.message;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleAutoVerification(PhoneAuthCredential credential) async {
    final result = await _phoneAuthService.signInWithCredential(credential);

    if (result.isSuccess && result.user != null) {
      // Sync with backend
      await _syncUserWithBackend(result.user!);
    } else {
      setState(() {
        _errorMessage = result.message;
        _isLoading = false;
      });
    }
  }

  Future<void> _syncUserWithBackend(User user) async {
    // Sync user with backend
    final userData = {
      'uid': user.uid,
      'phone_number': user.phoneNumber,
      'auth_provider': 'phone',
    };

    final response = await _userApiService.createUser(userData);

    if (response.isSuccess || response.error?.contains('already exists') == true) {
      // Navigate to dashboard or home
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } else {
      setState(() {
        _errorMessage = 'Failed to create user account';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Title
              const Text(
                'Enter your phone number',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We will send you a verification code',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              // Phone icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.phone_android,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Country code + Phone number input
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Country code dropdown
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCountryCode,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        items: [
                          '+1',   // US/Canada
                          '+91',  // India
                          '+44',  // UK
                          '+61',  // Australia
                          '+971', // UAE
                        ].map((code) {
                          return DropdownMenuItem(
                            value: code,
                            child: Text(
                              code,
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCountryCode = value!;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Phone number input
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        hintText: 'Phone number',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Error message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 30),

              // Send OTP button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Send OTP',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Privacy note
              Center(
                child: Text(
                  'By continuing, you agree to our Terms & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
