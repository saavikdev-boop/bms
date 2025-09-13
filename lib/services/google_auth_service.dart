import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GoogleAuthService {
  // For web, we specify the clientId explicitly
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb 
        ? '312328302719-7anti1sbpjessdvocpg5ge1t2cjpjdfu.apps.googleusercontent.com'
        : null, // Android gets it from google-services.json
    scopes: [
      'email',
      'profile',
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      print('Starting Google Sign-In...');
      
      // For web, don't sign out first as it can cause issues
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // User cancelled the sign-in
      if (googleUser == null) {
        print('Google Sign-In: User cancelled');
        return null;
      }

      print('User selected: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Check if we have the required tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print('Google Sign-In: Missing authentication tokens');
        return null;
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      print('Google Sign-In Success: ${userCredential.user?.email}');
      return userCredential.user;
    } catch (e) {
      print('Google Sign-In Error: $e');
      if (e.toString().contains('PlatformException')) {
        print('This is likely a configuration issue:');
        print('1. Check if SHA-1 in Firebase matches your debug keystore');
        print('2. Ensure google-services.json is up to date');
        print('3. Make sure Google Sign-In is enabled in Firebase Console');
      }
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}