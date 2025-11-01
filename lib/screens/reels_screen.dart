import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({Key? key}) : super(key: key);

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> reels = [
    {
      'username': 'Sampad Dutta',
      'location': 'Melbourne Cricket Ground, Hyderabad',
      'sport': 'Cricket',
      'image': 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=500&h=800&fit=crop',
      'avatar': 'assets/images/person1.png',
      'likes': '2.3k',
      'comments': '145',
      'shares': '89',
      'description': 'Amazing cricket match today! 🏏',
      'isVideo': false,
    },
    {
      'username': 'John Doe',
      'location': 'Gachibowli Indoor Stadium, Hyderabad',
      'sport': 'Badminton',
      'image': 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=500&h=800&fit=crop',
      'avatar': 'assets/images/person2.png',
      'likes': '1.8k',
      'comments': '92',
      'shares': '45',
      'description': 'Intense badminton session 🏸',
      'isVideo': false,
    },
    {
      'username': 'Jane Smith',
      'location': 'YMCA Football Ground, Secunderabad',
      'sport': 'Football',
      'image': 'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=500&h=800&fit=crop',
      'avatar': 'assets/images/person3.png',
      'likes': '3.1k',
      'comments': '201',
      'shares': '120',
      'description': 'Football fever! ⚽️',
      'isVideo': false,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
          HapticFeedback.lightImpact();
        },
        itemBuilder: (context, index) {
          return _buildReelItem(reels[index], index);
        },
      ),
    );
  }

  Widget _buildReelItem(Map<String, dynamic> reel, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image with Blue Tint (matching Figma)
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(reel['image']),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                const Color(0xFF0D47A1).withOpacity(0.3),
                BlendMode.color,
              ),
            ),
          ),
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                Colors.black.withOpacity(0.8),
              ],
              stops: const [0.0, 0.4, 0.9],
            ),
          ),
        ),

        // Top Bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom Content
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Left Side - User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // User Avatar and Name
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(reel['avatar']),
                            backgroundColor: Colors.white10,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reel['username'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.white70,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        reel['location'],
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF7CFED9),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Follow',
                              style: TextStyle(
                                color: Color(0xFF7CFED9),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Description
                      Text(
                        reel['description'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Sport Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '#${reel['sport']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Right Side - Action Buttons
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActionButton(
                      Icons.favorite_border,
                      reel['likes'],
                      () {
                        HapticFeedback.lightImpact();
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildActionButton(
                      Icons.chat_bubble_outline,
                      reel['comments'],
                      () {
                        HapticFeedback.lightImpact();
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildActionButton(
                      Icons.share_outlined,
                      reel['shares'],
                      () {
                        HapticFeedback.lightImpact();
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Page Indicators (Right Side)
        Positioned(
          right: 8,
          top: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            children: List.generate(
              reels.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                width: 3,
                height: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? const Color(0xFF7CFED9)
                      : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String count, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
