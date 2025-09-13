import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bms_screen_06_loading.dart';
import '../services/onboarding_data.dart';

class BmsScreen05Interests extends StatefulWidget {
  const BmsScreen05Interests({super.key});

  @override
  State<BmsScreen05Interests> createState() => _BmsScreen05InterestsState();
}

class _BmsScreen05InterestsState extends State<BmsScreen05Interests> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  List<int> selectedIndices = [0, 4]; // Pre-select 2 categories (minimum requirement)
  
  // Categories list (8 categories in 2x4 grid)
  final List<String> categories = [
    'Sports', 'Music', 'Gaming', 'Travel',
    'Food', 'Art', 'Tech', 'Fitness'
  ];

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

  void _toggleSelection(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        if (selectedIndices.length > 2) { // Keep minimum 2 selected
          selectedIndices.remove(index);
        }
      } else {
        selectedIndices.add(index);
      }
    });
    HapticFeedback.lightImpact();
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
              top: -95.70,
              child: Opacity(
                opacity: 0.08,
                child: Container(
                  width: 282.94,
                  height: 282.94,
                  decoration: const ShapeDecoration(
                    color: Color(0xFF94EA01),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(141.47)),
                    ),
                  ),
                ),
              ),
            ),
            
            // Bottom gradient overlay
            Positioned(
              left: 0,
              top: 665,
              child: Container(
                width: 390,
                height: 184,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(0.50, -0.00),
                    end: const Alignment(0.50, 1.00),
                    colors: [
                      Colors.black.withOpacity(0),
                      Colors.black,
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
                              'What are you interested in?',
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
                            width: 290.22,
                            child: Opacity(
                              opacity: 0.70,
                              child: Text(
                                'Choose min. 2 categories you like, you can change them later',
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
                          
                          const SizedBox(height: 55),
                          
                          // Categories grid
                          Expanded(
                            child: _buildCategoriesGrid(),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Continue button
                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: ElevatedButton(
                              onPressed: () async {
                                HapticFeedback.mediumImpact();

                                // Save interests and complete onboarding data to Firebase
                                final onboardingData = OnboardingData();
                                final selectedInterests = selectedIndices.map((index) => categories[index]).toList();
                                onboardingData.interests = selectedInterests;

                                // Debug print
                                onboardingData.printData();

                                // Save to Firebase
                                final success = await onboardingData.saveToFirebase();

                                if (success) {
                                  print('✅ User profile saved to Firebase successfully!');
                                } else {
                                  print('❌ Failed to save user profile to Firebase');
                                }

                                // Navigate to loading screen regardless of save result
                                if (mounted) {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => const BmsScreen06Loading(),
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
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA1FF00),
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
          // Status bar
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 390.09,
              height: 45.77,
              child: Stack(
                children: [
                  // Time
                  Positioned(
                    left: 21.84,
                    top: 13.52,
                    child: Container(
                      width: 56.17,
                      height: 21.84,
                      child: const Center(
                        child: Text(
                          '9:41',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.56,
                            fontFamily: 'SF Pro Text',
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  
                  // Battery and signals
                  Positioned(
                    right: 16,
                    top: 18,
                    child: Row(
                      children: [
                        Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Icon(Icons.wifi, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Container(
                          width: 22.89,
                          height: 11.79,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1.04, color: Colors.white),
                              borderRadius: BorderRadius.circular(2.77),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(1),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(1.39)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Progress indicator (3/3 completed)
                  Positioned(
                    left: 277.74,
                    top: 87.38,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const ShapeDecoration(
                        color: Color(0xFF2A2A2A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.08)),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 29.13,
                            height: 8.32,
                            decoration: const BoxDecoration(color: Color(0xFFA1FF00)),
                          ),
                          Container(
                            width: 29.13,
                            height: 8.32,
                            decoration: const BoxDecoration(color: Color(0xFFA1FF00)),
                          ),
                          Container(
                            width: 29.13,
                            height: 8.32,
                            decoration: const BoxDecoration(color: Color(0xFF2A2A2A)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
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

  Widget _buildCategoriesGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 30,
        mainAxisSpacing: 20,
        childAspectRatio: 143 / 134, // Width / Height ratio from Figma
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _buildCategoryCard(index);
      },
    );
  }

  Widget _buildCategoryCard(int index) {
    bool isSelected = selectedIndices.contains(index);
    
    return GestureDetector(
      onTap: () => _toggleSelection(index),
      child: Container(
        width: 143,
        height: 134,
        decoration: ShapeDecoration(
          gradient: isSelected 
            ? const LinearGradient(
                begin: Alignment(0.50, -0.00),
                end: Alignment(0.50, 1.00),
                colors: [Color(0xFF1C1C1C), Color(0xFF94EA01)],
              )
            : null,
          color: isSelected ? null : Colors.grey.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        child: Stack(
          children: [
            // Background image placeholder
            if (!isSelected)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: ShapeDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            
            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getCategoryIcon(index),
                    color: isSelected ? Colors.white : Colors.white54,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    categories[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white54,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.40,
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

  IconData _getCategoryIcon(int index) {
    switch (index) {
      case 0: return Icons.sports_soccer; // Sports
      case 1: return Icons.music_note; // Music
      case 2: return Icons.games; // Gaming
      case 3: return Icons.flight; // Travel
      case 4: return Icons.restaurant; // Food
      case 5: return Icons.palette; // Art
      case 6: return Icons.computer; // Tech
      case 7: return Icons.fitness_center; // Fitness
      default: return Icons.category;
    }
  }
}