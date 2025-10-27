import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/job_details.dart';
import '../pages/feedback_review.dart';
import '../pages/pending_activities.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
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
      'service': 'House Cleaning',
      'scheduledOn': '28 September 2025',
      'time': '9:00 am to 11:00 am',
      'amount': '₹500',
    },
  ];

  final List<Map<String, dynamic>> _employerPastBookings = [
    {
      'service': 'Coconut Plucking',
      'scheduledOn': '18 August 2025',
      'time': '3:00 pm to 6:00 pm',
      'amount': '₹700',
    },
    {
      'service': 'Garden Maintenance',
      'scheduledOn': '10 August 2025',
      'time': '9:00 am to 12:00 pm',
      'amount': '₹600',
    },
  ];

  final List<Map<String, dynamic>> _employeeUpcomingBookings = [
    {
      'service': 'Electrician Work',
      'scheduledOn': '26 September 2025',
      'time': '3:00 pm to 6:00 pm',
      'amount': '₹1000',
    },
    {
      'service': 'Gardening',
      'scheduledOn': '30 September 2025',
      'time': '9:00 am to 12:00 pm',
      'amount': '₹800',
    },
  ];

  final List<Map<String, dynamic>> _employeePastBookings = [
    {
      'service': 'Furniture Repair',
      'scheduledOn': '20 August 2025',
      'time': '10:00 am to 1:00 pm',
      'amount': '₹900',
    },
  ];

  // ✅ Booking card
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
                      showInterestedButton: false,
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
                                'Employee Name', // Replace with dynamic data if needed
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
      return _selectedTab == 'Upcoming'
          ? _employeeUpcomingBookings
          : _employeePastBookings;
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

            // Booking list or empty message
            Expanded(
              child: showEmptyState
                  ? _buildEmptyState('No bookings available.')
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: currentBookings.length,
                      itemBuilder: (context, index) {
                        return _buildBookingCard(
                          currentBookings[index],
                          _selectedTab == 'Past',
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
