import '../pages/feedback_review.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/job_details.dart';
import '../pages/pending_activities.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBooking({
  required String employerId, // Corresponds to employer_id (FK)
  required String employeeId, // Corresponds to employee_id (FK)
  required DateTime bookingDate, // Corresponds to bdate
  // You might also want to link it to a Job/Task for context:
  String? taskId, 
  String status = 'Confirmed',
}) async {
  try {
    await _firestore.collection('BOOKING').add({ // Use the correct table/collection name
      'employer_id': employerId,
      'employee_id': employeeId,
      'bdate': bookingDate,
      'taskId': taskId, // Optional: for linking to the TASK
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    });
    print("✅ Booking added successfully to BOOKING table!");
  } catch (e) {
    print("❌ Error adding booking: $e");
  }
}

// Function to fetch bookings data from Firestore
Stream<List<Map<String, dynamic>>> fetchBookings() {
  // 1. Get the current user's ID (Placeholder - replace with actual user authentication)
  // For this example, let's assume we have a way to get the current user's ID.
  // const String currentUserId = 'user_abc_123'; 
  
  // 2. Define the field to query based on user type (employer_id or employee_id)
  final String queryField = _userType == 'Employer' ? 'employer_id' : 'employee_id';
  // 3. Define the filter for Upcoming/Past based on date
  final DateTime now = DateTime.now();
  
  // Create a base query on the BOOKING collection
  Query query = _firestore.collection('BOOKING');

  // Filter by the current user's ID (Essential for security and relevance)
  // In a real app, you would pass the *actual* ID of the logged-in user here.
  // Example with a placeholder ID:
  // query = query.where(queryField, isEqualTo: currentUserId);

  // Filter by date for Upcoming/Past tabs
  if (_selectedTab == 'Upcoming') {
    // Bookings scheduled for today or later
    query = query.where('bdate', isGreaterThanOrEqualTo: now);
  } else { // 'Past' tab
    // Bookings that were scheduled before today (and are presumably completed)
    query = query.where('bdate', isLessThan: now);
  }

  // Stream data changes
  return query.snapshots().map((snapshot) {
    // Map Firestore documents to a list of dart maps
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      
      // Combine booking data with the Firestore document ID (which can serve as the booking_id)
      // Note: You would likely need a complex join or nested read to get 'service' and 'time'
      // from JOB_POSTING/TASK, as these fields aren't in the BOOKING table in your schema.
      // For a simplified example, we'll use placeholder/simplified data:
      
      return {
        'booking_id': doc.id, // The Firebase document ID
        'service': 'Service from Task/Job', // Need to fetch this
        'scheduledOn': data['bdate'] != null ? (data['bdate'] as Timestamp).toDate().toString().split(' ')[0] : 'N/A', // Format date
        'time': '3:00 pm to 6:00 pm', // Need to fetch this
        'amount': '₹800', // Need to calculate/fetch this
      };
    }).toList();
  });
}

  String _userType = 'Employer'; // 'Employer' or 'Employee'
  String _selectedTab = 'Upcoming'; // 'Upcoming' or 'Past'

  // Sample booking data
  final List<Map<String, dynamic>> _employerUpcomingBookings = [
    {
      'service': 'General Plumbing',
      'scheduledOn': '26 September 2025',
      'time': '3:00 pm to 6:00 pm',
      'amount': '₹800',
    },
    {
      'service': 'General Plumbing',
      'scheduledOn': '26 September 2025',
      'time': '3:00 pm to 6:00 pm',
      'amount': '₹800',
    },
    {
      'service': 'General Plumbing',
      'scheduledOn': '26 September 2025',
      'time': '3:00 pm to 6:00 pm',
      'amount': '₹800',
    },
  ];

  final List<Map<String, dynamic>> _employerPastBookings = [
    {
      'service': 'General Plumbing',
      'scheduledOn': '28 August 2025',
      'time': '3:00 pm to 6:00 pm',
      'amount': '₹800',
    },
    {
      'service': 'General Plumbing',
      'scheduledOn': '28 August 2025',
      'time': '3:00 pm to 6:00 pm',
      'amount': '₹800',
    },
    {
      'service': 'Coconut Plucking',
      'scheduledOn': '28 August 2025',
      'time': '3:00 pm to 6:00 pm',
      'amount': '₹800',
    },
    {
      'service': 'Coconut Plucking',
      'scheduledOn': '28 August 2025',
      'time': '3:00 pm to 6:00 pm',
      'amount': '₹800',
    },
  ];

  final List<Map<String, dynamic>> _employeeUpcomingBookings = [
    {
      'service': 'Coconut Plucking',
      'scheduledOn': '26 September 2025',
      'time': '3:00 pm to 6:00 pm',
      'amount': '₹800',
    },
    {
      'service': 'Coconut Plucking',
      'scheduledOn': '26 September 2025',
      'time': '3:00 pm to 6:00 pm',
      'amount': '₹800',
    },
    {
      'service': 'Coconut Plucking',
      'scheduledOn': '26 September 2025',
      'time': '3:00 pm to 6:00 pm',
      'amount': '₹800',
    },
    {
      'service': 'Coconut Plucking',
      'scheduledOn': '26 September 2025',
      'time': '3:00 pm to 6:00 pm',
      'amount': '₹800',
    },
  ];

  Widget _buildBookingCard(Map<String, dynamic> booking, bool isPast) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            booking['service'],
            style: const TextStyle(
              fontFamily: 'Axiforma',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Scheduled on: ',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              Text(
                booking['scheduledOn'],
                style: const TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            booking['time'],
            style: const TextStyle(
              fontFamily: 'Axiforma',
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            booking['amount'],
            style: const TextStyle(
              fontFamily: 'Axiforma',
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    showJobDetailsModal(
                      context: context,
                      jobTitle: booking['service'] ?? '',
                      jobDescription:
                          'Service details for ${booking['service']}',
                      location: 'Bicholim, Goa',
                      date: booking['scheduledOn'] ?? '',
                      time: booking['time'] ?? '',
                      price: booking['amount'] ?? '',
                      showInterestedButton:
                          false, // No Interested button in Bookings
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF283891),
                    side: const BorderSide(
                      color: Color(0xFF283891),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'View Order Details',
                    style: TextStyle(
                      fontFamily: 'Axiforma',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (isPast) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GiveFeedbackPage(
                            serviceName: booking['service'],
                            employeeName:
                                'Employee Name', // Replace with actual employee name
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF283891),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'View Feedback',
                      style: TextStyle(
                        fontFamily: 'Axiforma',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Axiforma',
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getCurrentBookings() {
    if (_userType == 'Employer') {
      return _selectedTab == 'Upcoming'
          ? _employerUpcomingBookings
          : _employerPastBookings;
    } else {
      return _selectedTab == 'Upcoming' ? _employeeUpcomingBookings : [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentBookings = _getCurrentBookings();
    final bool showEmptyState = currentBookings.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PendingActivitiesPage(),
                ),
              );
            },
          ),
        ],
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontFamily: 'Axiforma',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // User type toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _userType = 'Employer';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _userType == 'Employer'
                              ? const Color(0xFF283891)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Employer',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Axiforma',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _userType == 'Employer'
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _userType = 'Employee';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _userType == 'Employee'
                              ? const Color(0xFF283891)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Employee',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Axiforma',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _userType == 'Employee'
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Upcoming/Past toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = 'Upcoming';
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            'Upcoming',
                            style: TextStyle(
                              fontFamily: 'Axiforma',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _selectedTab == 'Upcoming'
                                  ? Colors.black87
                                  : Colors.black45,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 2,
                            color: _selectedTab == 'Upcoming'
                                ? const Color(0xFF283891)
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = 'Past';
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            'Past',
                            style: TextStyle(
                              fontFamily: 'Axiforma',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _selectedTab == 'Past'
                                  ? Colors.black87
                                  : Colors.black45,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 2,
                            color: _selectedTab == 'Past'
                                ? const Color(0xFF283891)
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bookings list or empty state
           Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: fetchBookings(), // Calls the function we created above
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while data is being fetched
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF283891)));
                  }

                  if (snapshot.hasError) {
                    // Show error message
                    print('Error fetching bookings: ${snapshot.error}');
                    return _buildEmptyState('Error loading bookings. Please try again.');
                  }

                  final currentBookings = snapshot.data ?? [];
                  final bool showEmptyState = currentBookings.isEmpty;

                  if (showEmptyState) {
                    // Show an appropriate empty state message
                    return _buildEmptyState(
                        _userType == 'Employee' && _selectedTab == 'Past'
                            ? 'No Past Orders Yet!\nas Employee!'
                            : _userType == 'Employee' && _selectedTab == 'Upcoming'
                                ? 'No Upcoming Bookings Found!'
                                : 'No bookings found',
                    );
                  }

                  // Display the list of bookings
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: currentBookings.length,
                    itemBuilder: (context, index) {
                      return _buildBookingCard(
                        currentBookings[index],
                        _selectedTab == 'Past',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
