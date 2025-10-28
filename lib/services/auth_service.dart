import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// AuthService - Handles Firebase Authentication and Firestore user data
/// 
/// ROOT CAUSE FIX: Replaced phone SMS auth (requires billing) with email/password auth (no billing needed)
/// This eliminates the "billing not enabled" error and allows brand-new users to register
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Check if username is already taken
  Future<bool> isUsernameAvailable(String username) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      print('Error checking username availability: $e');
      // If there's an error, assume username is available to not block signup
      return true;
    }
  }

  /// Check if email is already in use
  /// This is a simple check - actual verification happens during sign-up
  Future<bool> isEmailAvailable(String email) async {
    try {
      // Check Firestore for existing email
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      print('Error checking email availability: $e');
      // If there's an error, assume email is available to not block signup
      return true;
    }
  }

  /// Create user with email and password (NO BILLING REQUIRED)
  /// 
  /// FIX: This replaces phone SMS auth which required billing
  /// Email/password auth works without billing and is more reliable
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Validate email format
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        throw Exception('Invalid email format');
      }

      // Validate password strength
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ User created in Firebase Auth: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      print('Error creating user: $e');
      throw Exception('Failed to create account: $e');
    }
  }

  /// Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ User signed in: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      print('Error signing in: $e');
      throw Exception('Failed to sign in: $e');
    }
  }

  /// Save user data to Firestore under /users/{uid}
  /// 
  /// This is called AFTER successful Firebase Auth registration
  /// If this fails, rollback should delete the Auth user
  Future<void> saveUserData({
    required String username,
    required String fullName,
    required String email,
    String? phoneNumber,
    String? userType,
  }) async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated - UID is null');
      }

      // Validate required fields
      if (username.isEmpty || fullName.isEmpty || email.isEmpty) {
        throw Exception('Username, full name, and email are required');
      }

      // Check username uniqueness
      final isAvailable = await isUsernameAvailable(username);
      if (!isAvailable) {
        throw Exception('Username is already taken');
      }

      // Prepare user data
      Map<String, dynamic> userData = {
        'uid': uid,
        'username': username,
        'name': fullName, // Primary name field
        'fullName': fullName, // Also store as fullName for compatibility
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Add optional fields if provided
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        userData['phoneNumber'] = phoneNumber;
      }

      if (userType != null && userType.isNotEmpty) {
        userData['userType'] = userType;
      }

      print('💾 Saving user data to Firestore...');
      print('   UID: $uid');
      print('   Username: $username');
      print('   Full Name: $fullName');
      print('   Email: $email');

      // Save to Firestore with retry logic
      int retries = 3;
      while (retries > 0) {
        try {
          await _firestore.collection('users').doc(uid).set(
            userData,
            SetOptions(merge: true),
          );
          print('✅ User data saved successfully to Firestore at /users/$uid');
          return;
        } catch (error) {
          retries--;
          if (retries == 0) {
            rethrow;
          }
          print('⚠️  Retry saving user data... (${3 - retries} attempts left)');
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
    } catch (e) {
      print('❌ Error saving user data: $e');
      rethrow;
    }
  }

  /// Update user type (Employer/Employee)
  Future<void> updateUserType(String userType) async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      await _firestore.collection('users').doc(uid).update({
        'userType': userType,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ User type updated to: $userType');
    } catch (e) {
      print('❌ Error updating user type: $e');
      rethrow;
    }
  }

  /// Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) {
        return null;
      }

      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Check if user exists (for login verification)
  /// Checks by username, phone, and userType
  Future<bool> checkUserExists(String username, String phone, String userType) async {
    try {
      // First check by phone number (most reliable)
      final queryByPhone = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phone)
          .get();

      if (queryByPhone.docs.isNotEmpty) {
        // User with this phone exists, verify username and type match
        final userDoc = queryByPhone.docs.first;
        final userData = userDoc.data();
        
        return userData['username'] == username && 
               userData['userType'] == userType;
      }

      return false;
    } catch (e) {
      print('Error checking user: $e');
      return false;
    }
  }

  /// Map Firebase Auth exceptions to user-friendly messages
  Exception _mapAuthException(FirebaseAuthException e) {
    String message;
    
    switch (e.code) {
      case 'email-already-in-use':
        message = 'This email is already registered. Please log in instead.';
        break;
      case 'weak-password':
        message = 'Password is too weak. Please use at least 6 characters.';
        break;
      case 'invalid-email':
        message = 'Invalid email address. Please check and try again.';
        break;
      case 'user-not-found':
        message = 'No account found with this email. Please sign up first.';
        break;
      case 'wrong-password':
        message = 'Incorrect password. Please try again.';
        break;
      case 'invalid-credential':
        message = 'Invalid email or password. Please try again.';
        break;
      case 'user-disabled':
        message = 'This account has been disabled. Please contact support.';
        break;
      case 'operation-not-allowed':
        message = 'Sign up method not allowed. Please contact support.';
        break;
      case 'network-request-failed':
        message = 'Network error. Please check your connection and try again.';
        break;
      default:
        message = e.message ?? 'An error occurred: ${e.code}';
    }
    
    return Exception(message);
  }
}
