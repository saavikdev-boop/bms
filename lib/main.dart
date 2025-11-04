import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'screens/bms_screen_02_fixed.dart';
import 'screens/bms_screen_improved.dart';
import 'screens/bms_welcome_screen.dart';
import 'screens/enhanced_auth_screen.dart';
import 'screens/bms_screen_07_dashboard.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/address_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/payment_success_screen.dart';
import 'services/user_service.dart';
import 'services/onboarding_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Failed to load .env file: $e');
  }

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  runApp(const BmsApp());
}

class BmsApp extends StatelessWidget {
  const BmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMS Gaming Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF94EA01)),
        useMaterial3: true,
        primaryColor: const Color(0xFF94EA01),
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthStateWrapper(),
      routes: {
        '/dashboard': (context) => const BmsScreen07Dashboard(),
        '/product': (context) => const ProductDetailScreen(),
        '/cart': (context) => const CartScreen(),
        '/checkout': (context) => const CartScreen(),
        '/address': (context) => const AddressScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/success': (context) => const PaymentSuccessScreen(),
      },
    );
  }
}

class AuthStateWrapper extends StatelessWidget {
  const AuthStateWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while determining auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF151515),
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF94EA01)),
              ),
            ),
          );
        }

        final User? user = snapshot.data;

        if (user == null) {
          // User not authenticated, show welcome screen
          return const BMSWelcomeScreen();
        }

        // User is authenticated, check if they have completed onboarding
        return FutureBuilder<Map<String, dynamic>?>(
          future: UserService().getUserProfile(),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Color(0xFF151515),
                body: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF94EA01)),
                  ),
                ),
              );
            }

            final userProfile = profileSnapshot.data;

            if (userProfile != null && userProfile.isNotEmpty) {
              // User has completed onboarding, go to dashboard
              return const BmsScreen07Dashboard();
            } else {
              // User is authenticated but hasn't completed onboarding
              // Clear any stale onboarding data from previous sessions
              OnboardingData().clear();
              return const BMSWelcomeScreen();
            }
          },
        );
      },
    );
  }
}

