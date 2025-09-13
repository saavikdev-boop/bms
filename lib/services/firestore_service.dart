import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _usersCollection = 'users';

  // Create or update user document
  static Future<void> createUserDocument(User firebaseUser) async {
    try {
      final userDoc = _firestore.collection(_usersCollection).doc(firebaseUser.uid);
      final docSnapshot = await userDoc.get();
      
      if (!docSnapshot.exists) {
        // Create new user document with basic info from Firebase Auth
        final userData = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName,
          photoURL: firebaseUser.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await userDoc.set(userData.toFirestore());
        print('User document created for: ${firebaseUser.email}');
      } else {
        // Update existing user's basic info
        await userDoc.update({
          'displayName': firebaseUser.displayName,
          'photoURL': firebaseUser.photoURL,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });
        print('User document updated for: ${firebaseUser.email}');
      }
    } catch (e) {
      print('Error creating/updating user document: $e');
      rethrow;
    }
  }

  // Get user document
  static Future<UserModel?> getUserDocument(String uid) async {
    try {
      final userDoc = await _firestore.collection(_usersCollection).doc(uid).get();
      
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }
      return null;
    } catch (e) {
      print('Error getting user document: $e');
      return null;
    }
  }

  // Update user profile information
  static Future<void> updateUserProfile({
    required String uid,
    String? name,
    int? age,
    String? gender,
    List<String>? sports,
    List<String>? interests,
  }) async {
    try {
      final userDoc = _firestore.collection(_usersCollection).doc(uid);
      
      Map<String, dynamic> updateData = {
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      if (name != null) updateData['name'] = name;
      if (age != null) updateData['age'] = age;
      if (gender != null) updateData['gender'] = gender;
      if (sports != null) updateData['sports'] = sports;
      if (interests != null) updateData['interests'] = interests;

      await userDoc.update(updateData);
      print('User profile updated for: $uid');
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // Get user stream for real-time updates
  static Stream<UserModel?> getUserStream(String uid) {
    return _firestore
        .collection(_usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  // Delete user document
  static Future<void> deleteUserDocument(String uid) async {
    try {
      await _firestore.collection(_usersCollection).doc(uid).delete();
      print('User document deleted for: $uid');
    } catch (e) {
      print('Error deleting user document: $e');
      rethrow;
    }
  }

  // Check if user profile is complete
  static Future<bool> isUserProfileComplete(String uid) async {
    try {
      final userDoc = await getUserDocument(uid);
      if (userDoc == null) return false;
      
      return userDoc.name != null &&
             userDoc.age != null &&
             userDoc.gender != null &&
             userDoc.sports != null &&
             userDoc.sports!.isNotEmpty;
    } catch (e) {
      print('Error checking profile completeness: $e');
      return false;
    }
  }

  // Get all users (for admin purposes)
  static Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection(_usersCollection).get();
      return querySnapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }
}