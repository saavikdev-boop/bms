import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bms_screen_06_loading.dart';
import '../services/onboarding_data.dart';

class SportsInterestsScreen extends StatefulWidget {
  const SportsInterestsScreen({super.key});

  @override
  State<SportsInterestsScreen> createState() => _SportsInterestsScreenState();
}

class _SportsInterestsScreenState extends State<SportsInterestsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _staggerController;
  late Animation<double> _fadeAnimation;

  List<int> selectedIndices = []; // Start with no sports selected

  // 10 Popular Sports with images
  final List<Map<String, dynamic>> sports = [
    {
      'name': 'Cricket',
      'image': 'assets/images/screens/Cricket.png',
      'gradient': [Color(0xFF4CAF50), Color(0xFF2E7D32)],
      'description': 'The gentleman\'s game'
    },
    {
      'name': 'Football',
      'image': 'assets/images/screens/football.png',
      'gradient': [Color(0xFF4CAF50), Color(0xFF388E3C)],
      'description': 'The beautiful game'
    },
    {
      'name': 'Basketball',
      'image': 'assets/images/screens/BasketBall.png',
      'gradient': [Color(0xFFFF9800), Color(0xFFE65100)],
      'description': 'High-flying action'
    },
    {
      'name': 'Tennis',
      'image': 'assets/images/screens/Tennis.png',
      'gradient': [Color(0xFF2196F3), Color(0xFF0D47A1)],
      'description': 'Precision and power'
    },
    {
      'name': 'Volleyball',
      'image': 'assets/images/screens/VolleyBall.png',
      'gradient': [Color(0xFFFFC107), Color(0xFFF57F17)],
      'description': 'Spike and serve'
    },
    {
      'name': 'Swimming',
      'image': 'assets/images/screens/Swimming.png',
      'gradient': [Color(0xFF03A9F4), Color(0xFF01579B)],
      'description': 'Aquatic excellence'
    },
    {
      'name': 'Badminton',
      'image': 'assets/images/screens/Badminton.png',
      'gradient': [Color(0xFF00BCD4), Color(0xFF006064)],
      'description': 'Shuttle sport'
    },
    {
      'name': 'Hockey',
      'image': 'assets/images/screens/Hockey.png',
      'gradient': [Color(0xFF607D8B), Color(0xFF263238)],
      'description': 'Ice and field'
    },
    {
      'name': 'Running',
      'image': 'assets/images/screens/Running.png',
      'gradient': [Color(0xFFE91E63), Color(0xFF880E4F)],
      'description': 'Track and field'
    },
    {
      'name': 'Golf',
      'image': 'assets/images/screens/Golf.png',
      'gradient': [Color(0xFF4CAF50), Color(0xFF1B5E20)],
      'description': 'Precision sport'
    },
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  void _toggleSelection(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
    });
    HapticFeedback.lightImpact();
  }

  Widget _buildSportCard(int index) {
    final sport = sports[index];
    bool isSelected = selectedIndices.contains(index);

    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, child) {
        final animationValue = Interval(
          (index * 0.1).clamp(0.0, 1.0),
          ((index * 0.1) + 0.3).clamp(0.0, 1.0),
          curve: Curves.easeOutBack,
        ).transform(_staggerController.value);

        return Transform.translate(
          offset: Offset(0, 50 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue.clamp(0.0, 1.0),  // Ensure opacity is always valid
            child: GestureDetector(
              onTap: () => _toggleSelection(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF94EA01)
                        : Colors.transparent,
                    width: isSelected ? 3 : 0,
                  ),
                  boxShadow: isSelected ? [
                    const BoxShadow(
                      color: Color(0x6694EA01),  // Green with 40% opacity
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ] : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Sport image - fills entire card
                      Image.asset(
                        sport['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: sport['gradient'],
                              ),
                            ),
                            child: const Icon(
                              Icons.sports,
                              size: 48,
                              color: Color(0xB3FFFFFF),  // White with 70% opacity
                            ),
                          );
                        },
                      ),

                      // Dark overlay for unselected cards
                      if (!isSelected)
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0x80000000),  // Black with 50% opacity
                          ),
                        ),

                      // Sport name overlay (shown when selected)
                      if (isSelected)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0x00000000),  // Transparent
                                  Color(0xB3000000),  // Black with 70% opacity
                                  Color(0xE6000000),  // Black with 90% opacity
                                ],
                              ),
                            ),
                            child: Text(
                              sport['name'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                      // Selection checkmark (top-right corner)
                      if (isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Color(0xFF94EA01),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x4D000000),  // Black with 30% opacity
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
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
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x4D000000),  // Black with 30% opacity
                      Color(0x80000000),  // Black with 50% opacity
                    ],
                  ),
                ),
              ),
            ),

            // Content
            SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0x1AFFFFFF),  // White with 10% opacity
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Choose Your Sports',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 44), // Balance the back button
                  ],
                ),
              ),

              // Title and subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Book My Sports',
                      style: TextStyle(
                        color: Color(0xFF94EA01),
                        fontSize: 32,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select at least 2 sports to get personalized recommendations and find players near you',
                      style: const TextStyle(
                        color: Color(0xB3FFFFFF),  // White with 70% opacity
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: selectedIndices.length >= 2
                            ? const Color(0x1A94EA01)  // Green with 10% opacity
                            : const Color(0x1AFF0000),  // Red with 10% opacity
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selectedIndices.length >= 2
                              ? const Color(0x4D94EA01)  // Green with 30% opacity
                              : const Color(0x4DFF0000),  // Red with 30% opacity
                        ),
                      ),
                      child: Text(
                        selectedIndices.length >= 2
                            ? '${selectedIndices.length} sports selected ✓'
                            : 'Select at least 2 sports • ${selectedIndices.length} selected',
                        style: TextStyle(
                          color: selectedIndices.length >= 2
                              ? const Color(0xFF94EA01)
                              : const Color(0xFFFF6B6B),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Sports grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: sports.length,
                    itemBuilder: (context, index) => _buildSportCard(index),
                  ),
                ),
              ),

              // Continue button
              Container(
                padding: const EdgeInsets.all(25),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: selectedIndices.length >= 2 ? () async {
                      HapticFeedback.mediumImpact();

                      // Save sports interests
                      final onboardingData = OnboardingData();
                      final selectedSports = selectedIndices
                          .map((index) => sports[index]['name'] as String)
                          .toList();
                      onboardingData.interests = selectedSports;

                      // Debug print
                      onboardingData.printData();

                      // Save to Firebase
                      final success = await onboardingData.saveToFirebase();

                      if (success) {
                        print('✅ User sports profile saved successfully!');
                      } else {
                        print('❌ Failed to save user sports profile');
                      }

                      // Navigate to loading screen
                      if (mounted) {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                const BmsScreen06Loading(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut
                                )),
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(milliseconds: 300),
                          ),
                        );
                      }
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedIndices.length >= 2
                          ? const Color(0xFF94EA01)
                          : const Color(0xFF2A2A2A),
                      foregroundColor: selectedIndices.length >= 2
                          ? Colors.black
                          : Colors.white38,
                      elevation: selectedIndices.length >= 2 ? 6 : 0,
                      shadowColor: const Color(0x4D94EA01),  // Green with 30% opacity
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: selectedIndices.length >= 2
                            ? BorderSide.none
                            : const BorderSide(
                                color: Color(0x1AFFFFFF),  // White with 10% opacity
                                width: 1,
                              ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedIndices.length >= 2 ? 'Continue' : 'Select 2 Sports to Continue',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (selectedIndices.length >= 2) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: Colors.black,
                          ),
                        ],
                      ],
                    ),
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
}