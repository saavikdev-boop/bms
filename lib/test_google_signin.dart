import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(const GoogleSignInTestApp());
}

class GoogleSignInTestApp extends StatelessWidget {
  const GoogleSignInTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Sign-In Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GoogleSignInTestScreen(),
    );
  }
}

class GoogleSignInTestScreen extends StatefulWidget {
  const GoogleSignInTestScreen({super.key});

  @override
  State<GoogleSignInTestScreen> createState() => _GoogleSignInTestScreenState();
}

class _GoogleSignInTestScreenState extends State<GoogleSignInTestScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  
  String _status = 'Not signed in';
  String _errorDetails = '';

  Future<void> _handleSignIn() async {
    setState(() {
      _status = 'Signing in...';
      _errorDetails = '';
    });

    try {
      print('Starting Google Sign-In test...');
      
      // Check if already signed in
      final currentUser = _googleSignIn.currentUser;
      if (currentUser != null) {
        print('Already signed in as: ${currentUser.email}');
      }
      
      // Try to sign in
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      
      if (account == null) {
        setState(() {
          _status = 'Sign-in cancelled by user';
          _errorDetails = 'User closed the sign-in dialog';
        });
        print('Sign-in cancelled by user');
        return;
      }
      
      print('Signed in successfully!');
      print('Email: ${account.email}');
      print('Display Name: ${account.displayName}');
      print('ID: ${account.id}');
      
      // Try to get authentication tokens
      try {
        final GoogleSignInAuthentication auth = await account.authentication;
        print('Access Token: ${auth.accessToken?.substring(0, 20)}...');
        print('ID Token: ${auth.idToken?.substring(0, 20)}...');
        
        setState(() {
          _status = 'Signed in as: ${account.email}';
          _errorDetails = '''
Account Details:
- Email: ${account.email}
- Name: ${account.displayName}
- ID: ${account.id}
- Has Access Token: ${auth.accessToken != null ? 'Yes' : 'No'}
- Has ID Token: ${auth.idToken != null ? 'Yes' : 'No'}
          ''';
        });
      } catch (authError) {
        setState(() {
          _status = 'Authentication failed';
          _errorDetails = 'Error getting auth tokens: $authError';
        });
        print('Error getting authentication: $authError');
      }
      
    } catch (error) {
      setState(() {
        _status = 'Sign-in failed';
        _errorDetails = '''
Error Type: ${error.runtimeType}
Error Message: $error

Possible causes:
1. Missing Android OAuth client in google-services.json
2. SHA-1 fingerprint not added to Firebase
3. Google Sign-In not enabled in Firebase Console
4. Package name mismatch
5. No internet connection
        ''';
      });
      print('Sign-in error: $error');
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      setState(() {
        _status = 'Signed out';
        _errorDetails = '';
      });
    } catch (error) {
      setState(() {
        _errorDetails = 'Sign-out error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign-In Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _status,
                      style: TextStyle(
                        fontSize: 16,
                        color: _status.contains('failed') || _status.contains('cancelled')
                            ? Colors.red
                            : _status.contains('Signed in')
                                ? Colors.green
                                : Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            if (_errorDetails.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorDetails,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            ElevatedButton.icon(
              onPressed: _handleSignIn,
              icon: const Icon(Icons.login),
              label: const Text('Test Google Sign-In'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            
            const SizedBox(height: 12),
            
            OutlinedButton.icon(
              onPressed: _handleSignOut,
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Card(
              color: Colors.amber,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  '⚠️ If sign-in fails, check:\n'
                  '1. SHA-1 added to Firebase\n'
                  '2. google-services.json has Android OAuth client\n'
                  '3. Run: dart test/check_firebase_config.dart',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
