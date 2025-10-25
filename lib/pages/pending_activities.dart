import 'package:flutter/material.dart';

class PendingActivitiesPage extends StatefulWidget {
  const PendingActivitiesPage({super.key});

  @override
  State<PendingActivitiesPage> createState() => _PendingActivitiesPageState();
}

class _PendingActivitiesPageState extends State<PendingActivitiesPage> {
  // Sample data for pending activities
  final List<Map<String, dynamic>> _activities = [
    {
      'type': 'job_posted',
      'message': 'A new Job was posted',
      'showButtons': false,
    },
    {
      'type': 'interest_received',
      'message': 'Employee abcdf is interested',
      'showButtons': true,
      'employeeName': 'abcdf',
    },
    {
      'type': 'job_posted',
      'message': 'A new Job was posted',
      'showButtons': false,
    },
    {
      'type': 'job_posted',
      'message': 'A new Job was posted',
      'showButtons': false,
    },
    {
      'type': 'job_posted',
      'message': 'A new Job was posted',
      'showButtons': false,
    },
    {
      'type': 'job_posted',
      'message': 'A new Job was posted',
      'showButtons': false,
    },
    {
      'type': 'job_posted',
      'message': 'A new Job was posted',
      'showButtons': false,
    },
  ];

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            activity['message'],
            style: const TextStyle(
              fontFamily: 'Axiforma',
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          if (activity['showButtons']) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showNegotiationDialog(activity['employeeName']);
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
                      'Accept',
                      style: TextStyle(
                        fontFamily: 'Axiforma',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Interest declined'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C7C9E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Decline',
                      style: TextStyle(
                        fontFamily: 'Axiforma',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showNegotiationDialog(String employeeName) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE3E8F8),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Job Title
                const Text(
                  'Need a Cook',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 20),

                // Price and negotiation text
                const Text(
                  'Estimated price is Rs. 500/-',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Do you want to negotiate?',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 24),

                // Call button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening phone dialer...'),
                          backgroundColor: Color(0xFF283891),
                        ),
                      );
                      // Add phone call functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF283891),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Call +91 XXXXX XXXXX',
                      style: TextStyle(
                        fontFamily: 'Axiforma',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              // Already on this page, do nothing or refresh
            },
          ),
        ],
        title: const Text(
          'Pending Activities',
          style: TextStyle(
            fontFamily: 'Axiforma',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _activities.isEmpty
            ? const Center(
                child: Text(
                  'No pending activities',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  return _buildActivityItem(_activities[index]);
                },
              ),
      ),
    );
  }
}
