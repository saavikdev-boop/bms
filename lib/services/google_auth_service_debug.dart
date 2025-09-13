import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  // For Android, the clientId is automatically configured from google-services.json
  // For iOS/Web, you may need to specify it explicitly
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      print('=== GOOGLE SIGN-IN DEBUG START ===');
      print('Step 1: Initiating Google Sign-In...');
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // User cancelled the sign-in
      if (googleUser == null) {
        print('Step 2: User cancelled the sign-in dialog');
        print('=== GOOGLE SIGN-IN DEBUG END ===');
        return null;
      }

      print('Step 2: User selected account: ${googleUser.email}');
      print('Step 3: Getting authentication tokens...');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Check if we have the required tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print('ERROR: Missing authentication tokens');
        print('AccessToken: ${googleAuth.accessToken != null ? "Present" : "Missing"}');
        print('IdToken: ${googleAuth.idToken != null ? "Present" : "Missing"}');
        print('=== GOOGLE SIGN-IN DEBUG END ===');
        return null;
      }

      print('Step 4: Tokens received successfully');
      print('AccessToken: ${googleAuth.accessToken?.substring(0, 20)}...');
      print('IdToken: ${googleAuth.idToken?.substring(0, 20)}...');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Step 5: Signing in to Firebase...');

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      print('Step 6: SUCCESS! User signed in: ${userCredential.user?.email}');
      print('User UID: ${userCredential.user?.uid}');
      print('=== GOOGLE SIGN-IN DEBUG END ===');
      
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('=== FIREBASE AUTH ERROR ===');
      print('Error Code: ${e.code}');
      print('Error Message: ${e.message}');
      print('Error Details: ${e.toString()}');
      print('=== GOOGLE SIGN-IN DEBUG END ===');
      return null;
    } catch (e, stackTrace) {
      print('=== UNEXPECTED ERROR ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Message: $e');
      print('Stack Trace:');
      print(stackTrace.toString().split('\n').take(10).join('\n'));
      print('=== GOOGLE SIGN-IN DEBUG END ===');
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
