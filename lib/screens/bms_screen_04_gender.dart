import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sports_interests_screen.dart';
import '../services/onboarding_data.dart';

class BmsScreen04Gender extends StatefulWidget {
  const BmsScreen04Gender({super.key});

  @override
  State<BmsScreen04Gender> createState() => _BmsScreen04GenderState();
}

class _BmsScreen04GenderState extends State<BmsScreen04Gender> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  String? selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
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
            
            SafeArea(
              child: Column(
                children: [
                  // Header with back button and status bar
                  _buildHeader(),
                  
                  // Main content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          
                          // Main heading
                          const SizedBox(
                            width: 340.16,
                            child: Text(
                              'What is \nyour gender?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Subtitle
                          const SizedBox(
                            width: 271.50,
                            child: Opacity(
                              opacity: 0.70,
                              child: Text(
                                'This help us find you more relevant content',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Gender selection cards
                          Expanded(
                            child: Row(
                              children: [
                                // Male option
                                Expanded(
                                  child: _buildGenderCard(
                                    gender: 'Male',
                                    isSelected: selectedGender == 'Male',
                                    onTap: () {
                                      setState(() {
                                        selectedGender = 'Male';
                                      });
                                      HapticFeedback.lightImpact();
                                    },
                                  ),
                                ),
                                
                                const SizedBox(width: 24),
                                
                                // Female option
                                Expanded(
                                  child: _buildGenderCard(
                                    gender: 'Female',
                                    isSelected: selectedGender == 'Female',
                                    onTap: () {
                                      setState(() {
                                        selectedGender = 'Female';
                                      });
                                      HapticFeedback.lightImpact();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 60),
                          
                          // Continue button
                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: ElevatedButton(
                              onPressed: selectedGender != null ? () {
                                HapticFeedback.mediumImpact();

                                // Save gender data to shared state
                                final onboardingData = OnboardingData();
                                onboardingData.gender = selectedGender;

                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => const SportsInterestsScreen(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                    transitionDuration: const Duration(milliseconds: 300),
                                  ),
                                );
                              } : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedGender != null 
                                  ? const Color(0xFFA1FF00) 
                                  : Colors.grey,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          
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
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 104.02,
      child: Stack(
        children: [
          // Status bar removed

          // Back button
          Positioned(
            left: 24.97,
            top: 62.41,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: ShapeDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.48),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderCard({
    required String gender,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 158,
        height: 228,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: isSelected ? 2 : 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: isSelected ? const Color(0xFF94EA01) : const Color(0xFFE0E0E0),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Stack(
          children: [
            // Background image
            Positioned(
              left: gender == 'Male' ? 0 : -18,
              top: gender == 'Male' ? 0 : 44,
              child: Opacity(
                opacity: isSelected ? 1.0 : 0.5,
                child: Image.asset(
                  gender == 'Male'
                      ? 'assets/images/screens/Male_profile_pic.png'
                      : 'assets/images/screens/female_profile_pic.png',
                  width: gender == 'Male' ? 158 : 190,
                  height: gender == 'Male' ? 228 : 256,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: gender == 'Male' ? 158 : 190,
                      height: gender == 'Male' ? 228 : 256,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          gender == 'Male' ? Icons.male : Icons.female,
                          size: 64,
                          color: Colors.white54,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Gender label
            Positioned(
              left: 0,
              right: 0,
              top: 16,
              child: Center(
                child: Text(
                  gender,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF94EA01)
                        : const Color(0xFFBDBDBD),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}