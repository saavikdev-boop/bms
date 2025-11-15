import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/google_auth_service.dart';
import 'bms_screen_03_profile.dart';

class BmsLoginScreen extends StatefulWidget {
  const BmsLoginScreen({super.key});

  @override
  State<BmsLoginScreen> createState() => _BmsLoginScreenState();
}

class _BmsLoginScreenState extends State<BmsLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GoogleAuthService _authService = GoogleAuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/screens/starting screens background.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF000000),
                        Color(0xFF0A0A0A),
                        Color(0xFF1A1F1A),
                        Color(0xFF2A3A2A),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Dark overlay for better text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar with back button
                _buildTopBar(),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // Title
                        const Text(
                          'Get Started with\nBM Sportz',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Phone input field
                        _buildPhoneInput(),

                        const SizedBox(height: 25),

                        // Continue button
                        _buildContinueButton(),

                        const SizedBox(height: 32),

                        // OR divider
                        const Center(
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Social login buttons
                        _buildSocialLoginButtons(),

                        const SizedBox(height: 30),

                        // Continue as Guest button (for development)
                        _buildGuestButton(),

                        const SizedBox(height: 120),

                        // Terms and conditions
                        _buildTermsAndConditions(),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Back button
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const Spacer(),
          // Time display removed
        ],
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(
          color: const Color(0xFFE5E6EB),
          width: 1.04,
        ),
        borderRadius: BorderRadius.circular(8.32),
      ),
      child: TextField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: 'PHONE NO',
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9EA3AE),
            letterSpacing: 1.04,
          ),
          hintText: 'Enter your phone number',
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.64,
            vertical: 16,
          ),
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA1FF00),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google button
        InkWell(
          onTap: _signInWithGoogle,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/images/icons/Google.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),

        const SizedBox(width: 30),

        // Apple button
        InkWell(
          onTap: _signInWithApple,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/images/icons/Apple.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestButton() {
    return Center(
      child: TextButton(
        onPressed: _continueAsGuest,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        ),
        child: Text(
          'Continue as Guest',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 15,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            height: 1.4,
          ),
          children: [
            TextSpan(
              text: 'By continuing, you agree to our ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Terms',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF94EA01),
              ),
            ),
            TextSpan(
              text: ' and ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Conditions',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF94EA01),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleContinue() {
    if (_phoneController.text.trim().isEmpty) {
      _showSnackBar('Please enter your phone number');
      return;
    }

    // TODO: Implement phone authentication
    _showSnackBar('Phone authentication coming soon!');
    
    // For now, navigate to next screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BmsScreen03Profile(),
      ),
    );
  }

  void _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authService.signInWithGoogle();

      if (user != null && mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const BmsScreen03Profile(),
          ),
        );
      } else {
        _showSnackBar('Sign in was cancelled');
      }
    } catch (e) {
      _showSnackBar('Failed to sign in with Google: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _signInWithApple() {
    // TODO: Implement Apple sign-in
    _showSnackBar('Apple sign-in coming soon!');
  }

  void _continueAsGuest() {
    // Skip authentication and go to profile screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BmsScreen03Profile(),
      ),
    );
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFF192126),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}
