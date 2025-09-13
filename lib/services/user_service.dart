import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Local storage fallback
  static const String _localProfileKey = 'user_profile_data';

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // User profile data model
  Map<String, dynamic> createUserProfile({
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String gender,
    required List<String> interests,
    String? email,
    String? photoURL,
    String? phoneNumber,
    String? location,
    String? role,
    bool isOnline = true,
    Map<String, dynamic>? settings,
  }) {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'fullName': '$firstName $lastName',
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'interests': interests,
      'favourites': interests, // alias for compatibility
      'email': email ?? _auth.currentUser?.email,
      'phoneNumber': phoneNumber ?? _auth.currentUser?.phoneNumber,
      'profilePhoto': photoURL ?? _auth.currentUser?.photoURL,
      'photoURL': photoURL ?? _auth.currentUser?.photoURL, // alias
      'location': location ?? 'Hyderabad',
      'Role': role ?? 'Executive member',
      'isOnline': isOnline,
      'year': _calculateBirthYear(dateOfBirth),
      'gamesPlayed': 0,
      'stats': {
        'totalGames': 0,
        'wins': 0,
        'losses': 0,
        'draws': 0
      },
      'settings': settings ?? {
        'locationVisibility': 'friends',
        'onlineStatus': true,
        'notifications': true
      },
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Calculate birth year from date of birth
  int _calculateBirthYear(String dateOfBirth) {
    try {
      // Assuming format is DD/MM/YYYY or MM/DD/YYYY
      final parts = dateOfBirth.split('/');
      if (parts.length == 3) {
        return int.parse(parts[2]);
      }
    } catch (e) {
      print('Error parsing birth year: $e');
    }
    return DateTime.now().year - 25; // default to 25 years old
  }

  // Save user profile with fallback to local storage
  Future<bool> saveUserProfile({
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String gender,
    required List<String> interests,
  }) async {
    try {
      if (currentUserId == null) {
        print('❌ No authenticated user found');
        return false;
      }

      final userProfile = createUserProfile(
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        gender: gender,
        interests: interests,
      );

      // Try to save to Firestore first
      try {
        await _firestore
            .collection('User Data')
            .doc(currentUserId)
            .set(userProfile, SetOptions(merge: true));

        print('✅ User profile saved to Firestore successfully');

        // Also save locally as backup
        await _saveProfileLocally(userProfile);
        return true;

      } catch (firestoreError) {
        print('⚠️ Firestore error: $firestoreError');
        print('📱 Falling back to local storage');

        // Fallback to local storage
        await _saveProfileLocally(userProfile);
        print('✅ User profile saved locally as fallback');
        return true;
      }

    } catch (e) {
      print('❌ Error saving user profile: $e');
      return false;
    }
  }

  // Save profile to local storage
  Future<void> _saveProfileLocally(Map<String, dynamic> profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Convert Timestamps to strings for JSON serialization
      final cleanProfile = _cleanProfileForStorage(profile);
      await prefs.setString(_localProfileKey, json.encode(cleanProfile));
    } catch (e) {
      print('❌ Error saving profile locally: $e');
    }
  }

  // Clean profile data for JSON serialization
  Map<String, dynamic> _cleanProfileForStorage(Map<String, dynamic> profile) {
    final cleaned = Map<String, dynamic>.from(profile);
    cleaned['createdAt'] = DateTime.now().toIso8601String();
    cleaned['updatedAt'] = DateTime.now().toIso8601String();
    return cleaned;
  }

  // Get user profile with fallback to local storage
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (currentUserId == null) {
        print('❌ No authenticated user found');
        return null;
      }

      // Try Firestore first
      try {
        final doc = await _firestore
            .collection('User Data')
            .doc(currentUserId)
            .get();

        if (doc.exists) {
          print('✅ User profile retrieved from Firestore successfully');
          return doc.data();
        }
      } catch (firestoreError) {
        print('⚠️ Firestore error: $firestoreError');
        print('📱 Trying local storage fallback');
      }

      // Fallback to local storage
      try {
        final prefs = await SharedPreferences.getInstance();
        final profileJson = prefs.getString(_localProfileKey);

        if (profileJson != null) {
          final profile = json.decode(profileJson) as Map<String, dynamic>;
          print('✅ User profile retrieved from local storage');
          return profile;
        }
      } catch (localError) {
        print('⚠️ Local storage error: $localError');
      }

      print('❌ User profile not found in Firestore or local storage');
      return null;

    } catch (e) {
      print('❌ Error getting user profile: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      if (currentUserId == null) {
        print('No authenticated user found');
        return false;
      }

      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('User Data')
          .doc(currentUserId)
          .update(updates);

      print('User profile updated successfully');
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // Check if user profile exists
  Future<bool> userProfileExists() async {
    try {
      if (currentUserId == null) return false;

      final doc = await _firestore
          .collection('User Data')
          .doc(currentUserId)
          .get();

      return doc.exists;
    } catch (e) {
      print('Error checking if user profile exists: $e');
      return false;
    }
  }

  // Delete user profile
  Future<bool> deleteUserProfile() async {
    try {
      if (currentUserId == null) {
        print('No authenticated user found');
        return false;
      }

      await _firestore
          .collection('User Data')
          .doc(currentUserId)
          .delete();

      print('User profile deleted successfully');
      return true;
    } catch (e) {
      print('Error deleting user profile: $e');
      return false;
    }
  }

  // Save individual field updates
  Future<bool> updateFirstName(String firstName) async {
    return await updateUserProfile({'firstName': firstName});
  }

  Future<bool> updateLastName(String lastName) async {
    return await updateUserProfile({'lastName': lastName});
  }

  Future<bool> updateDateOfBirth(String dateOfBirth) async {
    return await updateUserProfile({'dateOfBirth': dateOfBirth});
  }

  Future<bool> updateGender(String gender) async {
    return await updateUserProfile({'gender': gender});
  }

  Future<bool> updateInterests(List<String> interests) async {
    return await updateUserProfile({'interests': interests});
  }
}