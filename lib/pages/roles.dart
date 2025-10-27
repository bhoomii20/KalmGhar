// Save this as: lib/pages/role_setup.dart
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

// Screen 1: Choose Role
class ChooseRoleScreen extends StatelessWidget {
  final String userName;

  const ChooseRoleScreen({super.key, required this.userName});

  Future<void> _updateUserRole(BuildContext context, String role) async {
    try {
      final authService = AuthService();
      // Update the user's role in Firestore
      await authService.updateUserType(role);

      // Navigate to the appropriate screen based on role
      if (!context.mounted) return;

      if (role == 'employee') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobSeekerProfileScreen(userName: userName),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobProviderProfileScreen(userName: userName),
          ),
        );
      }
    } catch (e) {
      // Handle error
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving role: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Choose your role to continue',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 60),

              // Looking to Hire card
              GestureDetector(
                onTap: () {
                  _updateUserRole(context, 'employer');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          JobProviderProfileScreen(userName: userName),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/images/employee.png', height: 100),
                      const SizedBox(height: 16),
                      const Text(
                        'Looking for Work ?',
                        style: TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Looking for Work card
              GestureDetector(
                onTap: () {
                  _updateUserRole(context, 'employee');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          JobSeekerProfileScreen(userName: userName),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/images/employer.png', height: 100),
                      const SizedBox(height: 16),
                      const Text(
                        'Looking to Hire ?',
                        style: TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
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

// Screen 2: Job Seeker Profile Creation
class JobSeekerProfileScreen extends StatefulWidget {
  final String userName;

  const JobSeekerProfileScreen({super.key, required this.userName});

  @override
  State<JobSeekerProfileScreen> createState() => _JobSeekerProfileScreenState();
}

class _JobSeekerProfileScreenState extends State<JobSeekerProfileScreen> {
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  @override
  void dispose() {
    _employeeIdController.dispose();
    _locationController.dispose();
    _languageController.dispose();
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 20),

                Text(
                  'Welcome ${widget.userName}',
                  style: const TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 40),

                // Illustration
                Image.asset('assets/images/ghar2.png', height: 150),

                const SizedBox(height: 30),

                const Text(
                  'Create your job-seeker profile',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 32),

                // Employee ID field
                TextField(
                  controller: _employeeIdController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.badge_outlined,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter your employee id',
                    hintStyle: const TextStyle(
                      fontFamily: 'Axiforma',
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Location field
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter your Location',
                    hintStyle: const TextStyle(
                      fontFamily: 'Axiforma',
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Preferred Language field
                TextField(
                  controller: _languageController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.language_outlined,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter your preferred language',
                    hintStyle: const TextStyle(
                      fontFamily: 'Axiforma',
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Upload profile picture
                const Text(
                  'Upload profile picture',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Next button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddSkillsScreen(
                            userName: widget.userName,
                            isJobSeeker: true,
                          ),
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'Axiforma',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
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
}

// Screen 3 & 4: Add Skills Screen (with two states)
class AddSkillsScreen extends StatefulWidget {
  final String userName;
  final bool isJobSeeker;

  const AddSkillsScreen({
    super.key,
    required this.userName,
    required this.isJobSeeker,
  });

  @override
  State<AddSkillsScreen> createState() => _AddSkillsScreenState();
}

class _AddSkillsScreenState extends State<AddSkillsScreen> {
  final List<String> _selectedSkills = [];
  final List<String> _availableSkills = [
    'Cooking',
    'Cleaning',
    'Plumbing',
    'Gardening',
    'Add Other...',
  ];
  bool _showDropdown = false;
  bool _showOtherField = false;
  final TextEditingController _otherSkillController = TextEditingController();

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Text(
                'Welcome ${widget.userName}',
                style: const TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 40),

              // Illustration
              Image.asset('assets/images/ghar2.png', height: 150),

              const SizedBox(height: 30),

              const Text(
                'Add your skills',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 24),

              // Selected skills chips
              if (_selectedSkills.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedSkills.map((skill) {
                    return Chip(
                      label: Text(
                        skill,
                        style: const TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 14,
                        ),
                      ),
                      backgroundColor: Colors.grey[200],
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => _toggleSkill(skill),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 16),

              // Skills dropdown button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showDropdown = !_showDropdown;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF283891),
                      width: 2,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Skills',
                        style: TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 16,
                          color: Color(0xFF283891),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Color(0xFF283891)),
                    ],
                  ),
                ),
              ),

              // Dropdown menu
              if (_showDropdown)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      ..._availableSkills.map((skill) {
                        if (skill == 'Add Other...') {
                          return ListTile(
                            title: Text(
                              skill,
                              style: const TextStyle(
                                fontFamily: 'Axiforma',
                                fontSize: 15,
                              ),
                            ),
                            trailing: Icon(
                              Icons.add_circle_outline,
                              color: Colors.grey[700],
                            ),
                            onTap: () {
                              setState(() {
                                _showOtherField = true;
                                _showDropdown = false;
                              });
                            },
                          );
                        } else {
                          return ListTile(
                            title: Text(
                              skill,
                              style: const TextStyle(
                                fontFamily: 'Axiforma',
                                fontSize: 15,
                              ),
                            ),
                            trailing: Icon(
                              Icons.add_circle_outline,
                              color: Colors.grey[700],
                            ),
                            onTap: () {
                              _toggleSkill(skill);
                              setState(() {
                                _showDropdown = false;
                              });
                            },
                          );
                        }
                      }).toList(),
                    ],
                  ),
                ),

              if (_showOtherField)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _otherSkillController,
                        decoration: const InputDecoration(
                          hintText: 'Enter new skill',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final newSkill = _otherSkillController.text.trim();
                        if (newSkill.isNotEmpty &&
                            !_availableSkills.contains(newSkill)) {
                          setState(() {
                            _availableSkills.insert(
                              _availableSkills.length - 1,
                              newSkill,
                            );
                            _toggleSkill(newSkill);
                            _showOtherField = false;
                            _otherSkillController.clear();
                          });
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),

              const Spacer(),

              // Update button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedSkills.isNotEmpty
                      ? () {
                          // Navigate to home
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false,
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
                    'Update',
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
    );
  }
}

// Screen 5: Job Provider Profile Creation
class JobProviderProfileScreen extends StatefulWidget {
  final String userName;

  const JobProviderProfileScreen({super.key, required this.userName});

  @override
  State<JobProviderProfileScreen> createState() =>
      _JobProviderProfileScreenState();
}

class _JobProviderProfileScreenState extends State<JobProviderProfileScreen> {
  final TextEditingController _employerIdController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _employerIdController.dispose();
    _locationController.dispose();
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 20),

                Text(
                  'Welcome ${widget.userName}',
                  style: const TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 40),

                // Illustration
                Image.asset('assets/images/ghar2.png', height: 150),

                const SizedBox(height: 30),

                const Text(
                  'Create your job-provider profile',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 32),

                // Employer ID field
                TextField(
                  controller: _employerIdController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.badge_outlined,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter your employer id',
                    hintStyle: const TextStyle(
                      fontFamily: 'Axiforma',
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Location field
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter your Location',
                    hintStyle: const TextStyle(
                      fontFamily: 'Axiforma',
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 150),

                // Log In button (goes directly to home)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (route) => false,
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
                      'Log In',
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
}
