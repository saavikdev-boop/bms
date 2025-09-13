import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/google_auth_service.dart';
import 'clean_auth_screen.dart';

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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000),
              Color(0xFF1A1A1A),
              Color(0xFF94EA01),
            ],
            stops: [0.2, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF000000),
                    Color(0x80000000),
                    Color(0x4094EA01),
                  ],
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
                    const SizedBox(height: 120),
                    
                    // Logo area
                    _buildLogo(),
                    
                    const SizedBox(height: 60),
                    
                    // Chat bubbles and main person
                    Expanded(
                      child: Stack(
                        children: [
                          // Main person silhouette
                          _buildMainPersonSilhouette(),
                          
                          // Chat bubbles
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
          child: Container(
            width: 150,
            height: 52,
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
                'BMS GAMING HUB',
                style: TextStyle(
                  color: Color(0xFF94EA01),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainPersonSilhouette() {
    return Positioned(
      left: -50,
      top: 50,
      child: Container(
        width: 300,
        height: 400,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(200),
        ),
        child: const Center(
          child: Icon(
            Icons.person,
            size: 200,
            color: Color(0xFF94EA01),
          ),
        ),
      ),
    );
  }

  Widget _buildChatBubbles() {
    return Stack(
      children: [
        // Top left bubble - Green
        Positioned(
          left: 60,
          top: 40,
          child: _buildChatBubble(
            message: "Let's play...",
            color: const Color(0xFFA3FF05),
            size: 35,
            isLeft: true,
            delay: 0,
          ),
        ),
        
        // Top right bubble - Yellow
        Positioned(
          right: 40,
          top: 20,
          child: _buildChatBubble(
            message: "Ready to game!",
            color: const Color(0xFFFFC403),
            size: 45,
            isLeft: false,
            delay: 300,
          ),
        ),
        
        // Middle left bubble - Orange
        Positioned(
          left: 30,
          top: 180,
          child: _buildChatBubble(
            message: "I'm in!",
            color: const Color(0xFFFF730F),
            size: 40,
            isLeft: true,
            delay: 600,
          ),
        ),
        
        // Bottom right bubble - Red
        Positioned(
          right: 30,
          top: 250,
          child: _buildChatBubble(
            message: "Count me in",
            color: const Color(0xFFFF0F3B),
            size: 38,
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
    required double size,
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
              // Avatar
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.8),
                      color,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: size * 0.5,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Message bubble
              Container(
                constraints: const BoxConstraints(maxWidth: 100),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                    fontSize: 10,
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
      top: 320,
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
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF94EA01),
                        Color(0xFFA1FF00),
                      ],
                    ),
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
                            builder: (context) => const CleanAuthScreen(),
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
                  builder: (context) => const CleanAuthScreen(),
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