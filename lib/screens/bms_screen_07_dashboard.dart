import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_app/screens/bookings.dart';
import 'my_profile_screen.dart';
import 'wallet_screen.dart';
import 'nearbyplayers.dart';
import 'host_game_screen.dart';
import 'ecommerce_home_screen.dart';
import 'my_bookings_screen.dart';

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
                                const Icon(Icons.location_on,
                                    color: Colors.white, size: 12),
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
                            const Icon(Icons.search,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 11),
                            const Icon(Icons.notifications_outlined,
                                color: Colors.white, size: 20),
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

                    // Search bar
                    Container(
                      height: 37,
                      decoration: ShapeDecoration(
                        color: const Color(0x1EA9A9A9),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1, color: Colors.white.withOpacity(0.15)),
                          borderRadius: BorderRadius.circular(48),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Search sports, venues, events…',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
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
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => MainMapPage(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;
                                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                  var offsetAnimation = animation.drive(tween);
                                  return SlideTransition(position: offsetAnimation, child: child);
                                },
                                transitionDuration: const Duration(milliseconds: 300),
                              ),
                            );
                          },
                          child: _buildFeatureCard(
                              'Nearby Players',
                              'See who\'s ready to play around you.',
                              const Color(0xFF1358CF),
                              const Color(0xFF0A2D69)),
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
                          child: _buildFeatureCard(
                              'Host a Game',
                              'Create your match and invite players.',
                              const Color(0xFF7CFE6A),
                              const Color(0xFF004D40)),
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
                              child: _buildFeatureCard(
                                  'My Bookings',
                                  'All your games in one place.',
                                  const Color(0xFFFFD956),
                                  const Color(0xFFE86F00)))),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ECommerceHomeScreen(),
                              ),
                            );
                          },
                          child: _buildFeatureCard(
                              'Shop Here',
                              'Find everything you need for your next game.',
                              const Color(0xFFFF9AA8),
                              const Color(0xFF6F00CB)),
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

  Widget _buildFeatureCard(
      String title, String description, Color startColor, Color endColor) {
    return Container(
      width: 166.27,
      height: 80,
      decoration: ShapeDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.98, 0.91),
          radius: 2.89,
          colors: [startColor, endColor],
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFEAEAEA)),
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: [
          BoxShadow(
            color: startColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
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
      height: 66,
      decoration: const ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.57, 1.72),
          end: Alignment(0.58, -1.53),
          colors: [Colors.black, Color(0xFF151515)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(56.28)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('Home', Icons.home_outlined, 0),
          _buildNavItem('Play', Icons.sports_soccer_outlined, 1),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.black, size: 24),
          ),
          _buildNavItem('Hire', Icons.person_outlined, 3),
          _buildNavItem('More', Icons.menu_outlined, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF94EA01) : Colors.white,
            size: 22.89,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF94EA01) : Colors.white,
              fontSize: 9.54,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
