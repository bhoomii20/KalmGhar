import '../pages/feedback_review.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../pages/login.dart';
import '../pages/pending_activities.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Axiforma',
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black54),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Account',
          style: TextStyle(
            fontFamily: 'Axiforma',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // User logged in status
            const Text(
              'You are Logged in as Job Seeker',
              style: TextStyle(
                fontFamily: 'Axiforma',
                fontSize: 13,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 20),

            // Profile section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Name and phone
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Full Name',
                          style: TextStyle(
                            fontFamily: 'Axiforma',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+91 1234567890',
                          style: TextStyle(
                            fontFamily: 'Axiforma',
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF283891),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Pending Activities button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PendingActivitiesPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF283891),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Pending Activities',
                    style: TextStyle(
                      fontFamily: 'Axiforma',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Menu items
            _buildMenuItem(
              icon: Icons.workspace_premium_outlined,
              title: 'Manage Skills',
              onTap: () {},
            ),

            _buildMenuItem(
              icon: Icons.rate_review_outlined,
              title: 'View Reviews',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewReviewsPage(),
                  ),
                );
              },
            ),

            _buildMenuItem(
              icon: Icons.star_outline,
              title: 'Rate us',
              onTap: () {},
            ),

            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'About KalmGhar',
              onTap: () {},
            ),

            _buildMenuItem(
              icon: Icons.logout,
              title: 'Log in as Job Provider',
              onTap: () {},
            ),

            const Spacer(),

            // Log Out button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showLogoutDialog(context);
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
                    'Log Out',
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
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out', style: TextStyle(fontFamily: 'Axiforma')),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(fontFamily: 'Axiforma'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Axiforma'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              'Log Out',
              style: TextStyle(fontFamily: 'Axiforma', color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// Screen 16: Edit Profile
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _fullNameController = TextEditingController(
    text: 'John Kevin',
  );
  final TextEditingController _usernameController = TextEditingController(
    text: 'johnkevin787',
  );
  final TextEditingController _mobileController = TextEditingController(
    text: '+91 1234567890',
  );
  final TextEditingController _languageController = TextEditingController(
    text: 'Konkani, Hindi',
  );
  final TextEditingController _locationController = TextEditingController(
    text: '123, street xyz, Ponda, Goa',
  );

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _mobileController.dispose();
    _languageController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Axiforma',
            fontSize: 13,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          style: const TextStyle(
            fontFamily: 'Axiforma',
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
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
      ],
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // User logged in status
                const Text(
                  'You are Logged in as Job Seeker',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 20),

                // Edit Profile title
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 24),

                // Profile avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Full Name
                _buildTextField(
                  label: 'Full Name',
                  controller: _fullNameController,
                ),

                const SizedBox(height: 20),

                // Username (read-only)
                _buildTextField(
                  label: 'Username',
                  controller: _usernameController,
                  readOnly: true,
                ),

                const SizedBox(height: 20),

                // Mobile Number (read-only)
                _buildTextField(
                  label: 'Mobile Number',
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  readOnly: true,
                ),

                const SizedBox(height: 20),

                // Preferred Language
                _buildTextField(
                  label: 'Preferred Language',
                  controller: _languageController,
                ),

                const SizedBox(height: 20),

                // My Location
                _buildTextField(
                  label: 'My Location',
                  controller: _locationController,
                  maxLines: 2,
                ),

                const SizedBox(height: 32),

                // Save Changes button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully!'),
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
                      'Save Changes',
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
