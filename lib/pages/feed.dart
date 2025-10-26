import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/job_details.dart';
import '../pages/pending_activities.dart';

class FeedPage extends StatefulWidget {
  final String? filterCategory;
  const FeedPage({super.key, this.filterCategory});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String _selectedFilter = 'Bestsellers';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = [
    'Bestsellers',
    'Recommended',
    'Offers',
    'Rating 4+',
  ];

  final List<Map<String, String>> _jobs = [
    {
      'title': 'Need Coconut Plucker',
      'date': '01 October 2025',
      'time': '10:00 - 11:30 am',
      'description': 'Job Description',
    },
    {
      'title': 'Need Coconut Plucker',
      'date': '01 October 2025',
      'time': '10:00 - 11:30 am',
      'description': 'Job Description',
    },
    {
      'title': 'Need Coconut Plucker',
      'date': '01 October 2025',
      'time': '10:00 - 11:30 am',
      'description': 'Job Description',
    },
    {
      'title': 'Need Coconut Plucker',
      'date': '01 October 2025',
      'time': '10:00 - 11:30 am',
      'description': 'Job Description',
    },
    {
      'title': 'Need Coconut Plucker',
      'date': '01 October 2025',
      'time': '10:00 - 11:30 am',
      'description': 'Job Description',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Set search text if category is provided
    if (widget.filterCategory != null && widget.filterCategory != 'all') {
      _searchController.text = widget.filterCategory!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildJobCard(Map<String, String> job) {
    return GestureDetector(
      onTap: () {
        // Show job details modal from reusable widget
        showJobDetailsModal(
          context: context,
          jobTitle: job['title'] ?? '',
          jobDescription: job['description'] ?? '',
          location: 'Bicholim, Goa',
          date: job['date'] ?? '',
          time: job['time'] ?? '',
          price: '₹800',
          showInterestedButton: true, // Show Interested button in Feed
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['title']!,
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
                  'Date: ',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  job['date']!,
                  style: const TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Time: ',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  job['time']!,
                  style: const TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              job['description']!,
              style: const TextStyle(
                fontFamily: 'Axiforma',
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search for jobs',
                  hintStyle: const TextStyle(
                    fontFamily: 'Axiforma',
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Job Feed header with Post a Job button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Job Feed',
                    style: TextStyle(
                      fontFamily: 'Axiforma',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PostJobPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline, size: 18),
                    label: const Text('Post a Job'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF283891),
                      side: const BorderSide(
                        color: Color(0xFF283891),
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Filter chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      labelStyle: TextStyle(
                        fontFamily: 'Axiforma',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFF283891),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF283891)
                              : Colors.grey[400]!,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Job list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _jobs.length,
                itemBuilder: (context, index) {
                  return _buildJobCard(_jobs[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Screen 14: Post a Job
class PostJobPage extends StatefulWidget {
  const PostJobPage({super.key});

  @override
  State<PostJobPage> createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
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
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Job Title
                const Text(
                  'Job Title',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter Job Title',
                    hintStyle: const TextStyle(
                      fontFamily: 'Axiforma',
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Job Description
                const Text(
                  'Job Description',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Describe job role and responsibilities',
                    hintStyle: const TextStyle(
                      fontFamily: 'Axiforma',
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Location
                const Text(
                  'Location',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'Enter Location',
                    hintStyle: const TextStyle(
                      fontFamily: 'Axiforma',
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Enter Date and Time
                const Text(
                  'Enter Date and Time',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: 'Enter Date',
                    hintStyle: const TextStyle(
                      fontFamily: 'Axiforma',
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    suffixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFF283891),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2026),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF283891),
                              onPrimary: Colors.white,
                              onSurface: Colors.black87,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF283891),
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                      selectableDayPredicate: (DateTime date) {
                        // Allow only next 30 days to be selected
                        return date.isBefore(
                          DateTime.now().add(const Duration(days: 30)),
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        _dateController.text =
                            '${picked.day.toString().padLeft(2, '0')} ${_getMonthName(picked.month)} ${picked.year}';
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    hintText: 'Enter Time',
                    hintStyle: const TextStyle(
                      fontFamily: 'Axiforma',
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _timeController.text = picked.format(context);
                      });
                    }
                  },
                ),

                const SizedBox(height: 20),

                // Estimated Pay
                const Text(
                  'Estimated Pay',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter Price',
                    hintStyle: const TextStyle(
                      fontFamily: 'Axiforma',
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Post Job button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle post job
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Job posted successfully!'),
                          backgroundColor: Color(0xFF283891),
                        ),
                      );
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
                      'Post Job',
                      style: TextStyle(
                        fontFamily: 'Axiforma',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
