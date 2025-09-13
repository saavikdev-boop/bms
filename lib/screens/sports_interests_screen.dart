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

  List<int> selectedIndices = [0, 1]; // Pre-select Cricket and Football

  // 10 Popular Sports with images
  final List<Map<String, dynamic>> sports = [
    {
      'name': 'Cricket',
      'image': 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=400&h=400&fit=crop&crop=center',
      'gradient': [Color(0xFF4CAF50), Color(0xFF2E7D32)],
      'description': 'The gentleman\'s game'
    },
    {
      'name': 'Football',
      'image': 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400&h=400&fit=crop&crop=center',
      'gradient': [Color(0xFF4CAF50), Color(0xFF388E3C)],
      'description': 'The beautiful game'
    },
    {
      'name': 'Basketball',
      'image': 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400&h=400&fit=crop&crop=center',
      'gradient': [Color(0xFFFF9800), Color(0xFFE65100)],
      'description': 'High-flying action'
    },
    {
      'name': 'Tennis',
      'image': 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=400&h=400&fit=crop&crop=center',
      'gradient': [Color(0xFF2196F3), Color(0xFF0D47A1)],
      'description': 'Precision and power'
    },
    {
      'name': 'Volleyball',
      'image': 'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=400&h=400&fit=crop&crop=center',
      'gradient': [Color(0xFFFFC107), Color(0xFFF57F17)],
      'description': 'Spike and serve'
    },
    {
      'name': 'Swimming',
      'image': 'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=400&h=400&fit=crop&crop=center',
      'gradient': [Color(0xFF03A9F4), Color(0xFF01579B)],
      'description': 'Aquatic excellence'
    },
    {
      'name': 'Badminton',
      'image': 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=400&h=400&fit=crop&crop=center',
      'gradient': [Color(0xFF00BCD4), Color(0xFF006064)],
      'description': 'Shuttle sport'
    },
    {
      'name': 'Hockey',
      'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=400&fit=crop&crop=center',
      'gradient': [Color(0xFF607D8B), Color(0xFF263238)],
      'description': 'Ice and field'
    },
    {
      'name': 'Running',
      'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop&crop=center',
      'gradient': [Color(0xFFE91E63), Color(0xFF880E4F)],
      'description': 'Track and field'
    },
    {
      'name': 'Golf',
      'image': 'https://images.unsplash.com/photo-1535131749006-b7f58c99034b?w=400&h=400&fit=crop&crop=center',
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
        if (selectedIndices.length > 2) { // Keep minimum 2 selected
          selectedIndices.remove(index);
        }
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
            opacity: animationValue,
            child: GestureDetector(
              onTap: () => _toggleSelection(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: isSelected
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: sport['gradient'],
                        )
                      : null,
                  color: isSelected ? null : Colors.grey.withOpacity(0.15),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF94EA01)
                        : Colors.grey.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: sport['gradient'][0].withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ] : null,
                ),
                child: Stack(
                  children: [
                    // Background pattern
                    if (isSelected)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                sport['image'],
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.sports,
                                    size: 32,
                                    color: isSelected ? Colors.white : Colors.white70,
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            sport['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            sport['description'],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isSelected ? Colors.white70 : Colors.white54,
                              fontSize: 11,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Selection indicator
                    if (isSelected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF94EA01),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
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
        child: SafeArea(
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
                          color: Colors.white.withOpacity(0.1),
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
                      'Select your favorite sports to get personalized recommendations and find players near you',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
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
                        color: const Color(0xFF94EA01).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF94EA01).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        'Minimum 2 sports required • ${selectedIndices.length} selected',
                        style: const TextStyle(
                          color: Color(0xFF94EA01),
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
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
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
                          : Colors.grey.withOpacity(0.3),
                      foregroundColor: selectedIndices.length >= 2
                          ? Colors.black
                          : Colors.white54,
                      elevation: selectedIndices.length >= 2 ? 6 : 0,
                      shadowColor: const Color(0xFF94EA01).withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Book My Sports',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.sports_soccer,
                          size: 20,
                          color: selectedIndices.length >= 2 ? Colors.black : Colors.white54,
                        ),
                      ],
                    ),
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