// Reusable Job Details Modal
// Can be used in both Bookings and Feed pages

import 'package:flutter/material.dart';

void showJobDetailsModal({
  required BuildContext context,
  required String jobTitle,
  required String jobDescription,
  required String location,
  required String date,
  required String time,
  required String price,
  bool showInterestedButton = true,
  VoidCallback? onInterested,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE3E8F8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with title and close button
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        jobTitle,
                        style: const TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    GestureDetector(
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
                  ],
                ),
              ),

              // Read-only job details
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailField('Job Title', jobTitle),
                      const SizedBox(height: 12),
                      _buildDetailField(
                        'Job Description',
                        jobDescription,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailField('Location', location),
                      const SizedBox(height: 12),
                      _buildDetailField('Date', date),
                      const SizedBox(height: 12),
                      _buildDetailField('Time', time),
                      const SizedBox(height: 12),
                      _buildDetailField('Estimated Pay', price),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Interested button (only show if enabled)
              if (showInterestedButton)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (onInterested != null) {
                          onInterested();
                        }
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
                        'Interested',
                        style: TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
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

Widget _buildDetailField(String label, String value, {int maxLines = 1}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: const Color(0xFFD6DCEF),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Axiforma',
            fontSize: 11,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: maxLines,
          style: const TextStyle(
            fontFamily: 'Axiforma',
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}
