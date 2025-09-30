import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _sectionTitle(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Axiforma',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Row(
                children: [
                  const Text(
                    'see all',
                    style: TextStyle(
                      fontFamily: 'Axiforma',
                      fontSize: 14,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _iconLabel(String assetName, String label, Color bgColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor.withOpacity(0.15),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/$assetName',
              height: 32,
              width: 32,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 65,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontFamily: 'Axiforma',
              fontSize: 11,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _categoryCircle(Color color, String label) {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.3),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Axiforma',
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _popularCard(String title, String subtitle, double rating) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Axiforma',
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Axiforma',
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, size: 14, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0, // Home is selected by default
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Axiforma',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Axiforma',
          fontSize: 12,
        ),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              height: 24,
              color: Colors.deepPurple,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/booking.svg',
              height: 24,
              color: Colors.grey,
            ),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/feed.svg',
              height: 24,
              color: Colors.grey,
            ),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/account.svg',
              height: 24,
              color: Colors.grey,
            ),
            label: 'Account',
          ),
        ],
      ),

      body: SafeArea(
        child: ListView(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Home',
                    style: TextStyle(
                      fontFamily: 'Axiforma',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/noti.svg',
                    height: 26,
                    color: Colors.black, // or any visible color
                  ),
                ],
              ),
            ),

            // Search box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search service',
                  hintStyle: const TextStyle(
                    fontFamily: 'Axiforma',
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Personal Services
            _sectionTitle('Personal Services'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconLabel('cook.svg', 'Need a cook', Colors.blue),
                  _iconLabel('spa.svg', 'Spa', Colors.blue),
                  _iconLabel('helper.svg', 'Household helper', Colors.orange),
                  _iconLabel('cleaning.svg', 'Cleaning', Colors.blue),
                  _iconLabel('garden.svg', 'Gardening', Colors.blue),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Home Services
            _sectionTitle('Home Services'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconLabel(
                    'plumbing.svg',
                    'Electrical Plumbing',
                    Colors.blue,
                  ),
                  _iconLabel('water.svg', 'Water Repairs', Colors.blue),
                  _iconLabel('repairs.svg', 'Home repairs', Colors.orange),
                  _iconLabel('cleanhome.svg', 'Home Cleaning', Colors.green),
                  _iconLabel('washing.svg', 'Washing', Colors.blue),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Top Categories
            _sectionTitle('Top Categories', onSeeAll: () {}),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _categoryCircle(const Color(0xFF6DAFEF), 'Plumbing'),
                  _categoryCircle(const Color(0xFFFFB84D), 'Electrician'),
                  _categoryCircle(const Color(0xFFFF8FAB), 'House Help'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Popular near you
            _sectionTitle('Popular near you', onSeeAll: () {}),
            SizedBox(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _popularCard('Need for a cook', 'Breakfast and Tiffin', 4.1),
                  _popularCard('Electrician', 'Basic Home Service', 4.1),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
