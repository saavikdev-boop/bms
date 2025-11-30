import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_phone_app/screens/bookings.dart';
import 'my_profile_screen.dart';
import 'wallet_screen.dart';
import 'nearbyplayers.dart';
import 'host_game_screen.dart';
import 'ecommerce_home_screen.dart';
import 'my_bookings_screen.dart';
import 'search_screen.dart';

class BmsScreen07Dashboard extends StatefulWidget {
  const BmsScreen07Dashboard({super.key});

  @override
  State<BmsScreen07Dashboard> createState() => _BmsScreen07DashboardState();
}

class _BmsScreen07DashboardState extends State<BmsScreen07Dashboard> {
  int _currentIndex = 0;
  double _balance = 1250.50;
  List<Map<String, dynamic>> _transactions = [
    {'id': 1, 'amount': '+₹50', 'type': 'Recharge', 'date': '2024-01-15'},
    {
      'id': 2,
      'amount': '-₹25',
      'type': 'Booking Payment',
      'date': '2024-01-14'
    },
    {'id': 3, 'amount': '-₹100', 'type': 'Withdrawal', 'date': '2024-01-10'},
    {'id': 4, 'amount': '+₹75', 'type': 'Recharge', 'date': '2024-01-05'},
    {
      'id': 5,
      'amount': '-₹30',
      'type': 'Booking Payment',
      'date': '2023-12-28'
    },
    {'id': 6, 'amount': '-₹50', 'type': 'Withdrawal', 'date': '2023-12-20'},
  ];

  void _updateWalletData(
      double newBalance, List<Map<String, dynamic>> newTransactions) {
    setState(() {
      _balance = newBalance;
      _transactions = newTransactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Status bar and header
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Header with greeting and icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Hello',
                                    style: TextStyle(
                                      color: Color(0x66FFFFFF),
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: ' Sampad',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/location_icon.svg',
                                  width: 12,
                                  height: 12,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Hyderabad',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/search_icon.svg',
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 11),
                            SvgPicture.asset(
                              'assets/icons/notification_icon.svg',
                              width: 20,
                              height: 20,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 11),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MyProfileScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFAB301),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.person,
                                    color: Colors.black, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Search bar with glassmorphism
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                          border: Border.all(
                            width: 1.5,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/search_icon.svg',
                                    width: 20,
                                    height: 20,
                                    colorFilter: ColorFilter.mode(
                                      Colors.white.withOpacity(0.8),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Search sports, venues, events…',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Feature cards grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => MainMapPage()),
                            );
                          },
                          child: _buildFeatureCardWithIcon(
                            'Nearby Players',
                            'See who\'s ready to play around you.',
                            'assets/images/nearby_players_icon.svg',
                            const Color(0xFF1459CF),
                            const Color(0xFF0F439C),
                            const Color(0xFF0A2D69),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HostGameScreen(),
                              ),
                            );
                          },
                          child: _buildFeatureCardWithIcon(
                            'Host a Game',
                            'Create your match and invite players.',
                            'assets/images/host_game_icon.svg',
                            const Color(0xFF7CFE6A),
                            const Color(0xFF5FD954),
                            const Color(0xFF004D40),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => BookingsApp()),
                                );
                              },
                              child: _buildFeatureCardWithIcon(
                                'My Bookings',
                                'All your games in one place.',
                                'assets/images/bookings_icon.svg',
                                const Color(0xFFFFD956),
                                const Color(0xFFE8B820),
                                const Color(0xFFE86F00),
                              ))),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ECommerceHomeScreen(),
                              ),
                            );
                          },
                          child: _buildFeatureCardWithIcon(
                            'Shop Here',
                            'Find everything you need for your next game.',
                            'assets/images/shop_icon.svg',
                            const Color(0xFFFF9AA8),
                            const Color(0xFFE8788A),
                            const Color(0xFF6F00CB),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Carousel section
            _buildCarouselSection(),

            const SizedBox(height: 40),

            // Popular Near You section
            _buildSectionWithTitle('Popular Near You', const Color(0xFF3BE8B0)),

            const SizedBox(height: 40),

            // Nearby Games section
            _buildSectionWithTitle('Nearby Games', const Color(0xFF3BF8D2)),

            const SizedBox(height: 40),

            // Hire Professional section
            _buildHireProfessionalSection(),

            const SizedBox(height: 40),

            // Social feed section
            _buildSocialFeedSection(),

            const SizedBox(height: 40),

            // Community button
            Container(
              width: double.infinity,
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: ShapeDecoration(
                color: const Color(0xFFBFD962),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
              child: const Center(
                child: Text(
                  'Explore our community',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Footer text
            Text(
              'Make with ❤️  in Hyderabad',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 100), // Space for bottom navigation
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildFeatureCardWithIcon(
    String title,
    String description,
    String iconPath,
    Color startColor,
    Color midColor,
    Color endColor,
  ) {
    return SizedBox(
      height: 102,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 3D Icon Image - positioned at top left, overlapping card
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 102,
              height: 102,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SvgPicture.asset(
                  iconPath,
                  fit: BoxFit.cover,
                  placeholderBuilder: (context) => Container(
                    color: startColor.withOpacity(0.3),
                    child: const Icon(
                      Icons.image,
                      color: Colors.white54,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Card - positioned below the icon
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              height: 64.022,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFEBEBEB),
                  width: 0.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.98, 0.91),
                      radius: 2.89,
                      colors: [startColor, midColor, endColor],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Blue blur accent in top-right
                      Positioned(
                        right: 0,
                        top: 8.6,
                        child: Container(
                          width: 60.2,
                          height: 42.044,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0089DA),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 19.016, sigmaY: 19.016),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Text content
                      Positioned(
                        left: 5.73,
                        top: 21.02,
                        right: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              description,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      String title, String description, Color startColor, Color endColor) {
    return Container(
      width: 166.27,
      height: 102,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          width: 1.5,
          color: Colors.white.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: startColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Stack(
            children: [
              // Background gradient accent
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        startColor.withOpacity(0.4),
                        endColor.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSection() {
    return Container(
      height: 203,
      child: PageView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: ShapeDecoration(
              color: Colors.grey.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Center(
              child: Text(
                'CAROUSEL IMAGE\nPLACEHOLDER',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionWithTitle(String title, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 0.5,
                  color: accentColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  title,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 0.5,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 341.22,
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment(0.73, 0.00),
                end: Alignment(0.73, 1.00),
                colors: [Colors.transparent, Colors.black87],
              ),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 0.53, color: Color(0xFF707070)),
                borderRadius: BorderRadius.circular(12.64),
              ),
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: ShapeDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.64)),
                  ),
                  child: const Center(
                    child: Text(
                      'CONTENT IMAGE\nPLACEHOLDER',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                if (title == 'Popular Near You')
                  const Positioned(
                    left: 13.69,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Melbourne Hub Cricket',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.74,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Paramount colony, Hyderabad',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.28,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.12,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (title == 'Nearby Games')
                  const Positioned(
                    left: 15.30,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sampad',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.65,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Host | Cricket',
                          style: TextStyle(
                            color: Color(0xFF94EA01),
                            fontSize: 11.82,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Malakpet, Hydrebad.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.11,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.20,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHireProfessionalSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text(
            'Hire Professional',
            style: TextStyle(
              color: Color(0xFF3BF8D2),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 0.5,
                  color: const Color(0xFF3BE8B0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 319,
            decoration: ShapeDecoration(
              color: Colors.grey.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 0.55, color: Color(0xFF434343)),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Center(
              child: Text(
                'PROFESSIONAL IMAGE\nPLACEHOLDER',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.fitness_center, color: Colors.white, size: 16),
                      SizedBox(width: 2),
                      Text(
                        'Strength training with John',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    '0.7 km away',
                    style: TextStyle(
                      color: Color(0xFF828282),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '4.8',
                    style: TextStyle(
                      color: Color(0xFFFFC403),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.star, color: Color(0xFFFFC403), size: 16),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialFeedSection() {
    return Column(
      children: [
        _buildSocialPost(),
        const SizedBox(height: 20),
        _buildSocialPost(),
      ],
    );
  }

  Widget _buildSocialPost() {
    return Container(
      width: double.infinity,
      height: 462.35,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.62, color: Color(0xFF707070)),
          borderRadius: BorderRadius.circular(4.57),
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: Text(
              'SOCIAL POST\nIMAGE PLACEHOLDER',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 36,
              decoration: const ShapeDecoration(
                color: Color(0xFF0E0E0E),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Like',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500)),
                  Text('Comment',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500)),
                  Text('Share',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          width: 1.5,
          color: Colors.white.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem('Home', 'assets/icons/nav_home.svg', 0),
                _buildNavItem('Play', 'assets/icons/nav_explore.svg', 1),
                _buildCenterButton(),
                _buildNavItem('Hire', 'assets/icons/nav_hire.svg', 3),
                _buildNavItem('More', 'assets/icons/nav_more.svg', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, String iconPath, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                isSelected ? const Color(0xFF94EA01) : Colors.white.withOpacity(0.6),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF94EA01) : Colors.white.withOpacity(0.6),
                fontSize: 10,
                fontFamily: 'Poppins',
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        setState(() {
          _currentIndex = 2;
        });
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF94EA01), Color(0xFF7BC801)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF94EA01).withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
