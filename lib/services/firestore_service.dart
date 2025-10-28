import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save a job posting
  Future<void> saveJob({
    required String title,
    required String description,
    required String location,
    required String date,
    required String time,
    required String price,
  }) async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      // Validate required fields
      if (title.isEmpty ||
          description.isEmpty ||
          location.isEmpty ||
          date.isEmpty ||
          time.isEmpty ||
          price.isEmpty) {
        throw Exception('All fields are required');
      }

      await _firestore.collection('feed').add({
        'title': title,
        'description': description,
        'location': location,
        'date': date,
        'time': time,
        'price': price,
        'userId': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('✅ Job posted successfully');
    } catch (e) {
      print('❌ Error saving job: $e');
      rethrow;
    }
  }

  // Get all jobs (feed)
  Stream<List<Map<String, dynamic>>> getFeedJobs() {
    try {
      return _firestore
          .collection('feed')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id,
                'title': data['title'] ?? '',
                'date': data['date'] ?? '',
                'time': data['time'] ?? '',
                'description': data['description'] ?? '',
                'location': data['location'] ?? '',
                'price': data['price'] ?? '',
                'userId': data['userId'] ?? '',
              };
            }).toList();
          });
    } catch (e) {
      print('Error fetching feed: $e');
      return Stream.value([]);
    }
  }

  // Save a booking
  Future<void> saveBooking({
    required String employerId,
    required String employeeId,
    required String service,
    required String scheduledOn,
    required String time,
    required String amount,
  }) async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      // Validate required fields
      if (service.isEmpty ||
          scheduledOn.isEmpty ||
          time.isEmpty ||
          amount.isEmpty) {
        throw Exception('All booking fields are required');
      }

      await _firestore.collection('bookings').add({
        'employer_id': employerId,
        'employee_id': employeeId,
        'service': service,
        'scheduledOn': scheduledOn,
        'time': time,
        'amount': amount,
        'userId': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('✅ Booking saved successfully');
    } catch (e) {
      print('❌ Error saving booking: $e');
      rethrow;
    }
  }

  // Get bookings for current user
  Stream<List<Map<String, dynamic>>> getBookings(String userType) {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) {
        return Stream.value([]);
      }

      // Determine which field to query based on user type
      String queryField = userType == 'Employer'
          ? 'employer_id'
          : 'employee_id';

      return _firestore
          .collection('bookings')
          .where(queryField, isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();

              // Convert Firestore timestamp to readable date
              String scheduledDate = 'N/A';
              if (data['scheduledOn'] != null) {
                if (data['scheduledOn'] is Timestamp) {
                  scheduledDate = (data['scheduledOn'] as Timestamp)
                      .toDate()
                      .toString()
                      .split(' ')[0];
                } else {
                  scheduledDate = data['scheduledOn'].toString();
                }
              }

              return {
                'booking_id': doc.id,
                'service': data['service'] ?? '',
                'scheduledOn': scheduledDate,
                'time': data['time'] ?? '',
                'amount': data['amount'] ?? '',
                'scheduledTimestamp': data['scheduledOn'],
              };
            }).toList();
          });
    } catch (e) {
      print('Error fetching bookings: $e');
      return Stream.value([]);
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) {
        return null;
      }

      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(uid).update(data);

      print('User profile updated successfully');
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }
}
