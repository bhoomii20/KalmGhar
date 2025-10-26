import 'package:flutter/material.dart';

// Give Feedback Page (for past bookings)
class GiveFeedbackPage extends StatefulWidget {
  final String serviceName;
  final String employeeName;

  const GiveFeedbackPage({
    super.key,
    required this.serviceName,
    required this.employeeName,
  });

  @override
  State<GiveFeedbackPage> createState() => _GiveFeedbackPageState();
}

class _GiveFeedbackPageState extends State<GiveFeedbackPage> {
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
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
        title: const Text(
          'Give Feedback',
          style: TextStyle(
            fontFamily: 'Axiforma',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.serviceName,
                      style: const TextStyle(
                        fontFamily: 'Axiforma',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Employee: ${widget.employeeName}',
                      style: const TextStyle(
                        fontFamily: 'Axiforma',
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Rating Section
              const Text(
                'How would you rate the service?',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              // Star Rating
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _rating = index + 1.0;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          size: 50,
                          color: Colors.amber,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 8),

              if (_rating > 0)
                Center(
                  child: Text(
                    '${_rating.toInt()}/5 Stars',
                    style: const TextStyle(
                      fontFamily: 'Axiforma',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF283891),
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              // Feedback Text
              const Text(
                'Share your experience',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _feedbackController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Write your feedback here...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Axiforma',
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _rating > 0
                      ? () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Feedback submitted successfully!'),
                              backgroundColor: Color(0xFF283891),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF283891),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[400],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Submit Feedback',
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
      ),
    );
  }
}

// View Reviews Page (for employees to see their reviews)
class ViewReviewsPage extends StatelessWidget {
  const ViewReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample reviews data
    final List<Map<String, dynamic>> reviews = [
      {
        'service': 'General Plumbing',
        'rating': 4.5,
        'feedback':
            'Great service! Very professional and completed the work on time. Highly recommended.',
        'date': '28 August 2025',
        'employer': 'John Doe',
      },
      {
        'service': 'Coconut Plucking',
        'rating': 5.0,
        'feedback':
            'Excellent work! Very skilled and efficient. Will hire again.',
        'date': '15 August 2025',
        'employer': 'Jane Smith',
      },
      {
        'service': 'House Cleaning',
        'rating': 4.0,
        'feedback':
            'Good service, could improve punctuality but overall satisfied.',
        'date': '10 August 2025',
        'employer': 'Mike Johnson',
      },
      {
        'service': 'Gardening',
        'rating': 4.8,
        'feedback': 'Amazing attention to detail! Garden looks beautiful now.',
        'date': '05 August 2025',
        'employer': 'Sarah Williams',
      },
    ];

    // Calculate average rating
    double averageRating =
        reviews.fold(0.0, (sum, review) => sum + review['rating']) /
        reviews.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Reviews',
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
            // Average Rating Card
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF283891),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Icon(Icons.star_half, color: Colors.amber, size: 20),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${reviews.length} Total Reviews',
                        style: const TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Keep up the great work!',
                        style: TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Reviews List
            Expanded(
              child: reviews.isEmpty
                  ? const Center(
                      child: Text(
                        'No reviews yet',
                        style: TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];
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
                              // Service and Rating
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      review['service'],
                                      style: const TextStyle(
                                        fontFamily: 'Axiforma',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          review['rating'].toString(),
                                          style: const TextStyle(
                                            fontFamily: 'Axiforma',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Feedback
                              Text(
                                review['feedback'],
                                style: const TextStyle(
                                  fontFamily: 'Axiforma',
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Date and Employer
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    review['date'],
                                    style: TextStyle(
                                      fontFamily: 'Axiforma',
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    review['employer'],
                                    style: TextStyle(
                                      fontFamily: 'Axiforma',
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
