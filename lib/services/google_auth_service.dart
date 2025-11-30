import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GoogleAuthService {
  // For web, we specify the clientId explicitly
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      print('🔵 Starting Google Sign-In...');
      
      // For web, don't sign out first as it can cause issues
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // User cancelled the sign-in
      if (googleUser == null) {
        print('❌ Google Sign-In: User cancelled');
        return null;
      }

      print('✅ User selected: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // UPDATED FOR v7.x: Handle nullable tokens explicitly
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      // Check if we have the required tokens
      if (accessToken == null || idToken == null) {
        print('❌ Google Sign-In: Missing authentication tokens');
        print('   Access Token: ${accessToken != null ? "✓" : "✗"}');
        print('   ID Token: ${idToken != null ? "✓" : "✗"}');
        return null;
      }

      print('🔑 Received authentication tokens');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      print('🔐 Signing in to Firebase...');

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      print('✅ Google Sign-In Success: ${userCredential.user?.email}');
      print('   User ID: ${userCredential.user?.uid}');
      print('   Display Name: ${userCredential.user?.displayName}');
      
      return userCredential.user;
    } catch (e) {
      print('❌ Google Sign-In Error: $e');
      if (e.toString().contains('PlatformException')) {
        print('⚠️  This is likely a configuration issue:');
        print('   1. Check if SHA-1 in Firebase matches your debug keystore');
        print('   2. Ensure google-services.json is up to date');
        print('   3. Make sure Google Sign-In is enabled in Firebase Console');
      }
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
        _auth.signOut(),
      ]);
      print('✅ Successfully signed out');
    } catch (e) {
      print('❌ Error during sign out: $e');
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Check if user is signed in
  bool isSignedIn() {
    return _auth.currentUser != null;
  }
  
  // Get current Google user
  Future<GoogleSignInAccount?> getCurrentGoogleUser() async {
    return await _googleSignIn.signInSilently();
  }
}
