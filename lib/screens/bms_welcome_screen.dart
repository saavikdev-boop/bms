import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/google_auth_service.dart';
import 'bms_login_screen.dart';
import 'bms_screen_07_dashboard.dart';

class BMSWelcomeScreen extends StatefulWidget {
  const BMSWelcomeScreen({super.key});

  @override
  State<BMSWelcomeScreen> createState() => _BMSWelcomeScreenState();
}

class _BMSWelcomeScreenState extends State<BMSWelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  final GoogleAuthService _authService = GoogleAuthService();

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 3000),
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
      curve: Curves.easeOutBack,
    ));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black,  // Simple black background
        ),
        child: Stack(
          children: [
            // Main background image - full screen background
            Positioned.fill(
              child: Image.asset(
                'assets/images/screens/main_person.png',
                fit: BoxFit.cover,  // Cover entire screen
                alignment: Alignment.center,  // Center the image
                cacheWidth: 1080,
                cacheHeight: 1920,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF1A1A1A),
                          Color(0xFF2A3A2A),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Subtle overlay for better contrast with UI elements
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            
            // Status bar
            _buildStatusBar(),
            
            // Main content
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    
                    // Logo area
                    _buildLogo(),
                    
                    const SizedBox(height: 40),
                    
                    // Chat bubbles and main content
                    Expanded(
                      child: Stack(
                        children: [
                          // Chat bubbles with profile images
                          _buildChatBubbles(),
                          
                          // Central message
                          _buildCentralMessage(),
                        ],
                      ),
                    ),
                    
                    // Action buttons
                    _buildActionButtons(),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '9:41',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Icon(Icons.wifi, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Container(
                    width: 24,
                    height: 12,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Image.asset(
            'assets/images/screens/logo.png',
            width: 192,
            height: 67,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 192,
                height: 67,
                decoration: BoxDecoration(
                  color: const Color(0xFF94EA01).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF94EA01),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'BOOK MY SPORTZ',
                    style: TextStyle(
                      color: Color(0xFF94EA01),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildChatBubbles() {
    return Stack(
      children: [
        // Top left bubble - Green "Lets play..."
        Positioned(
          left: 30,
          top: 40,
          child: _buildChatBubble(
            message: "Lets play...",
            color: const Color(0xFFA3FF05),
            profileImage: 'assets/images/profile1.png',
            isLeft: true,
            delay: 0,
          ),
        ),
        
        // Top right bubble - Yellow "Lets play..."
        Positioned(
          right: 30,
          top: 80,
          child: _buildChatBubble(
            message: "Lets play...",
            color: const Color(0xFFFFC403),
            profileImage: 'assets/images/profile2.png',
            isLeft: false,
            delay: 300,
          ),
        ),
        
        // Middle left bubble - Orange "I'm in."
        Positioned(
          left: 20,
          top: 170,
          child: _buildChatBubble(
            message: "I'm in.",
            color: const Color(0xFFFF730F),
            profileImage: 'assets/images/profile3.png',
            isLeft: true,
            delay: 600,
          ),
        ),
        
        // Bottom right bubble - Pink "I'm in."
        Positioned(
          right: 20,
          top: 290,
          child: _buildChatBubble(
            message: "I'm in.",
            color: const Color(0xFFFF0F3B),
            profileImage: 'assets/images/profile4.png',
            isLeft: false,
            delay: 900,
          ),
        ),
      ],
    );
  }

  Widget _buildChatBubble({
    required String message,
    required Color color,
    required String profileImage,
    required bool isLeft,
    required int delay,
  }) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 1000 + delay),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Column(
            crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              // Avatar with profile image
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    profileImage,
                    fit: BoxFit.cover,
                    cacheWidth: 100,
                    cacheHeight: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color.withOpacity(0.8),
                              color,
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 25,
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Message bubble
              Container(
                constraints: const BoxConstraints(maxWidth: 100),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: Radius.circular(isLeft ? 2 : 12),
                    bottomRight: Radius.circular(isLeft ? 12 : 2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCentralMessage() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 200,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 60),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF94EA01),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Text(
          'Wanna play today?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          // Get Started Button
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (0.02 * _pulseAnimation.value),
                child: Container(
                  width: double.infinity,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFF94EA01),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF94EA01).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {
                        HapticFeedback.mediumImpact();
                        
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const BmsLoginScreen(),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          // Skip Button
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const BmsScreen07Dashboard(),
                ),
              );
            },
            child: const Text(
              'SKIP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
