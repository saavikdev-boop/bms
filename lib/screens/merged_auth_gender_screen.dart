import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/google_auth_service.dart';
import 'new_profile_screen.dart';

class MergedAuthGenderScreen extends StatefulWidget {
  const MergedAuthGenderScreen({super.key});

  @override
  State<MergedAuthGenderScreen> createState() => _MergedAuthGenderScreenState();
}

class _MergedAuthGenderScreenState extends State<MergedAuthGenderScreen>
    with TickerProviderStateMixin {
  final GoogleAuthService _authService = GoogleAuthService();
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;
  bool _showGenderSelection = false;
  String? selectedGender = 'Male';
  User? _currentUser;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
    });

    HapticFeedback.lightImpact();

    try {
      final User? user = await _authService.signInWithGoogle();

      if (user != null && mounted) {
        setState(() {
          _currentUser = user;
          _showGenderSelection = true;
        });
        _slideController.forward();
      } else {
        _showErrorSnackBar('Google sign in was cancelled');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to sign in with Google: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithApple() async {
    setState(() {
      _isAppleLoading = true;
    });

    HapticFeedback.lightImpact();

    // Simulate Apple Sign-In delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isAppleLoading = false;
        _showGenderSelection = true;
        // Simulate user data for Apple Sign-In
        _currentUser = _authService.currentUser; // Will be null, but for demo
      });
      _slideController.forward();
      _showErrorSnackBar('Apple Sign-In: Demo mode (not implemented)');
    }
  }

  void _continueWithGender() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const NewProfileScreen(),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Background circle
            Positioned(
              left: -135.23,
              top: -120,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF94EA01).withOpacity(0.3),
                      const Color(0xFF94EA01).withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: !_showGenderSelection
                    ? _buildAuthSection()
                    : _buildGenderSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 80),

        // Title
        const Text(
          'Welcome!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Sign in to continue',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),

        const Spacer(),

        // Google Sign-In Button
        _buildGoogleSignInButton(),

        const SizedBox(height: 16),

        // Apple Sign-In Button
        _buildAppleSignInButton(),

        const SizedBox(height: 32),

        // Continue as Guest Button
        _buildGuestButton(),

        const SizedBox(height: 40),

        // Terms and privacy
        Text(
          'By signing in, you agree to our Terms of Service\nand Privacy Policy',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildGenderSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          // Back button
          IconButton(
            onPressed: () {
              setState(() {
                _showGenderSelection = false;
              });
              _slideController.reset();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),

          const SizedBox(height: 20),

          // Title
          const Text(
            'What\'s your gender?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'This helps us personalize your experience',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 60),

          // Gender options
          _buildGenderOption('Male', Icons.male),
          const SizedBox(height: 16),
          _buildGenderOption('Female', Icons.female),
          const SizedBox(height: 16),
          _buildGenderOption('Other', Icons.people),

          const Spacer(),

          // Continue button
          _buildContinueButton(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isGoogleLoading ? null : _signInWithGoogle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isGoogleLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                )
              else ...[
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.g_mobiledata,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Continue with Google',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppleSignInButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isAppleLoading ? null : _signInWithApple,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isAppleLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else ...[
                const Icon(
                  Icons.apple,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Continue with Apple',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _showGenderSelection = true;
        });
        _slideController.forward();
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      child: Text(
        'Continue as Guest',
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    final isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF94EA01).withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFF94EA01) : Colors.white24,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF94EA01) : Colors.white70,
              size: 28,
            ),
            const SizedBox(width: 16),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? const Color(0xFF94EA01) : Colors.white,
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF94EA01),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF94EA01), Color(0xFFA1FF00)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF94EA01).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _continueWithGender,
          child: const Center(
            child: Text(
              'Continue',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}