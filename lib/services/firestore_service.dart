import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import 'connectivity_service.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _usersCollection = 'users';
  static final ConnectivityService _connectivityService = ConnectivityService();

  // Local storage keys
  static const String _localUserPrefix = 'user_cache_';
  static const String _pendingOperationsKey = 'pending_operations';

  // Create or update user document with offline support
  static Future<void> createUserDocument(User firebaseUser) async {
    try {
      final userData = UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName,
        photoURL: firebaseUser.photoURL,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Check connectivity
      final isOnline = await _connectivityService.checkConnection();

      if (!isOnline) {
        print('⚠️ Offline - Caching user document locally');
        await _cacheUserLocally(firebaseUser.uid, userData);
        await _queueOperation('create', firebaseUser.uid, userData.toFirestore());
        return;
      }

      final userDoc = _firestore.collection(_usersCollection).doc(firebaseUser.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        await userDoc.set(userData.toFirestore());
        print('✅ User document created for: ${firebaseUser.email}');
      } else {
        await userDoc.update({
          'displayName': firebaseUser.displayName,
          'photoURL': firebaseUser.photoURL,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });
        print('✅ User document updated for: ${firebaseUser.email}');
      }

      // Cache locally as backup
      await _cacheUserLocally(firebaseUser.uid, userData);
    } catch (e) {
      print('❌ Error creating/updating user document: $e');
      // Fallback to local cache
      final userData = UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName,
        photoURL: firebaseUser.photoURL,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _cacheUserLocally(firebaseUser.uid, userData);
      rethrow;
    }
  }

  // Get user document with offline support
  static Future<UserModel?> getUserDocument(String uid) async {
    try {
      // Check connectivity
      final isOnline = await _connectivityService.checkConnection();

      if (isOnline) {
        try {
          final userDoc = await _firestore.collection(_usersCollection).doc(uid).get();

          if (userDoc.exists) {
            final userData = UserModel.fromFirestore(userDoc);
            // Update local cache
            await _cacheUserLocally(uid, userData);
            return userData;
          }
        } catch (e) {
          print('⚠️ Firestore error: $e, trying local cache');
        }
      } else {
        print('📱 Offline - Using local cache');
      }

      // Fallback to local cache
      return await _getUserFromCache(uid);
    } catch (e) {
      print('❌ Error getting user document: $e');
      return null;
    }
  }

  // Update user profile information with offline support
  static Future<void> updateUserProfile({
    required String uid,
    String? name,
    int? age,
    String? gender,
    List<String>? sports,
    List<String>? interests,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      if (name != null) updateData['name'] = name;
      if (age != null) updateData['age'] = age;
      if (gender != null) updateData['gender'] = gender;
      if (sports != null) updateData['sports'] = sports;
      if (interests != null) updateData['interests'] = interests;

      // Check connectivity
      final isOnline = await _connectivityService.checkConnection();

      if (!isOnline) {
        print('⚠️ Offline - Queueing update operation');
        await _queueOperation('update', uid, updateData);
        // Update local cache
        final cachedUser = await _getUserFromCache(uid);
        if (cachedUser != null) {
          final updatedData = cachedUser.toFirestore()..addAll(updateData);
          await _cacheUserLocally(uid, UserModel.fromMap(updatedData));
        }
        return;
      }

      final userDoc = _firestore.collection(_usersCollection).doc(uid);
      await userDoc.update(updateData);
      print('✅ User profile updated for: $uid');

      // Update local cache
      final userData = await getUserDocument(uid);
      if (userData != null) {
        await _cacheUserLocally(uid, userData);
      }
    } catch (e) {
      print('❌ Error updating user profile: $e');
      // Queue for later sync
      Map<String, dynamic> updateData = {'updatedAt': Timestamp.fromDate(DateTime.now())};
      if (name != null) updateData['name'] = name;
      if (age != null) updateData['age'] = age;
      if (gender != null) updateData['gender'] = gender;
      if (sports != null) updateData['sports'] = sports;
      if (interests != null) updateData['interests'] = interests;
      await _queueOperation('update', uid, updateData);
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

  // ========== OFFLINE SUPPORT HELPER METHODS ==========

  // Cache user data locally
  static Future<void> _cacheUserLocally(String uid, UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = json.encode(user.toFirestore());
      await prefs.setString('$_localUserPrefix$uid', userJson);
    } catch (e) {
      print('❌ Error caching user locally: $e');
    }
  }

  // Get user from local cache
  static Future<UserModel?> _getUserFromCache(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('$_localUserPrefix$uid');

      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromMap(userMap);
      }
      return null;
    } catch (e) {
      print('❌ Error getting user from cache: $e');
      return null;
    }
  }

  // Queue operation for later sync
  static Future<void> _queueOperation(String operation, String uid, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingOpsJson = prefs.getString(_pendingOperationsKey);

      List<Map<String, dynamic>> pendingOps = [];
      if (pendingOpsJson != null) {
        pendingOps = List<Map<String, dynamic>>.from(json.decode(pendingOpsJson));
      }

      pendingOps.add({
        'operation': operation,
        'uid': uid,
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await prefs.setString(_pendingOperationsKey, json.encode(pendingOps));
      print('📝 Operation queued for sync: $operation for uid: $uid');
    } catch (e) {
      print('❌ Error queueing operation: $e');
    }
  }

  // Sync pending operations when back online
  static Future<void> syncPendingOperations() async {
    try {
      final isOnline = await _connectivityService.checkConnection();
      if (!isOnline) {
        print('⚠️ Still offline - Cannot sync pending operations');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final pendingOpsJson = prefs.getString(_pendingOperationsKey);

      if (pendingOpsJson == null) {
        print('✅ No pending operations to sync');
        return;
      }

      final pendingOps = List<Map<String, dynamic>>.from(json.decode(pendingOpsJson));

      for (final op in pendingOps) {
        try {
          final operation = op['operation'] as String;
          final uid = op['uid'] as String;
          final data = op['data'] as Map<String, dynamic>;

          switch (operation) {
            case 'create':
              await _firestore.collection(_usersCollection).doc(uid).set(data);
              break;
            case 'update':
              await _firestore.collection(_usersCollection).doc(uid).update(data);
              break;
          }
          print('✅ Synced $operation operation for uid: $uid');
        } catch (e) {
          print('❌ Error syncing operation: $e');
        }
      }

      // Clear pending operations
      await prefs.remove(_pendingOperationsKey);
      print('✅ All pending operations synced');
    } catch (e) {
      print('❌ Error syncing pending operations: $e');
    }
  }

  // Initialize connectivity monitoring and sync
  static Future<void> initializeOfflineSupport() async {
    await _connectivityService.initialize();

    // Listen for connectivity changes and sync when online
    _connectivityService.connectionStatus.listen((isConnected) {
      if (isConnected) {
        print('🔄 Connection restored - Starting sync...');
        syncPendingOperations();
      }
    });
  }
}