import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _sectionTitle(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Axiforma',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'see all',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 14,
                  color: Colors.deepPurple,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _iconLabel(String assetName, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/icons/$assetName', height: 40),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Axiforma', fontSize: 12),
        ),
      ],
    );
  }

  Widget _categoryCircle(Color color, String label) {
    return Column(
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.4),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontFamily: 'Axiforma', fontSize: 12),
        ),
      ],
    );
  }

  Widget _popularCard(String title, String subtitle) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Axiforma',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Axiforma',
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 2),
          const Row(
            children: [
              Icon(Icons.star, size: 14, color: Colors.amber),
              SizedBox(width: 4),
              Text(
                '4.1',
                style: TextStyle(fontFamily: 'Axiforma', fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- main build ----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/home.svg', height: 22),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/booking.svg', height: 22),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/feed.svg', height: 22),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/account.svg', height: 22),
            label: 'Account',
          ),
        ],
      ),

      body: SafeArea(
        child: ListView(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Home',
                    style: TextStyle(
                      fontFamily: 'Axiforma',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SvgPicture.asset('assets/icons/noti.svg', height: 24),
                ],
              ),
            ),

            // Search box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search service',
                  hintStyle: const TextStyle(fontFamily: 'Axiforma'),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Personal Services
            _sectionTitle('Personal Services'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _iconLabel('cook.svg', 'Need a cook'),
                  _iconLabel('spa.svg', 'Spa for Women'),
                  _iconLabel('helper.svg', 'Household helper'),
                  _iconLabel('cleaning.svg', 'Cleaning'),
                  _iconLabel('garden.svg', 'Gardening'),
                ],
              ),
            ),

            // Home Services
            _sectionTitle('Home Services'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _iconLabel('plumbing.svg', 'Electrical Plumbing'),
                  _iconLabel('water.svg', 'Water Repairs'),
                  _iconLabel('repairs.svg', 'Home repairs'),
                  _iconLabel('cleanhome.svg', 'Home Cleaning'),
                  _iconLabel('washing.svg', 'Washing'),
                ],
              ),
            ),

            // Top Categories
            _sectionTitle('Top Categories', onSeeAll: () {}),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _categoryCircle(Colors.blue, 'Plumbing'),
                  _categoryCircle(Colors.orange, 'Electrician'),
                  _categoryCircle(Colors.pink, 'House Help'),
                ],
              ),
            ),

            // Popular near you
            _sectionTitle('Popular near you', onSeeAll: () {}),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _popularCard('Need for a cook', 'Breakfast and Tiffin'),
                  _popularCard('Electrician', 'Basic Home Service'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
