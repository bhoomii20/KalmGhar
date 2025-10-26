// Updated lib/pages/home.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/bottom_nav_bar.dart';
import '../pages/feed.dart';
import '../pages/pending_activities.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _navigateToFeed(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedPage(filterCategory: category),
      ),
    );
  }

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

  Widget _iconLabel(
    String assetName,
    String label, [
    Color? bgColor,
    String? category,
  ]) {
    // bgColor and category are optional to preserve older 2-arg calls.
    final useCategory = category ?? label;
    final isPng =
        assetName.toLowerCase().endsWith('.png') ||
        assetName.contains('assets/images');

    return GestureDetector(
      onTap: () => _navigateToFeed(useCategory),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: ClipOval(
              child: isPng
                  ? Image.asset(
                      assetName.startsWith('assets/')
                          ? assetName
                          : 'assets/images/${assetName.split('/').last}',
                      height: 56,
                      width: 56,
                      fit: BoxFit.cover,
                    )
                  : Center(child: _getIconWidget(assetName)),
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
      ),
    );
  }

  Widget _getIconWidget(String assetName) {
    final fileName = assetName.split('/').last;
    final pngNames = {'cleaning.png', 'washing.png', 'spa.png', 'repair.png'};
    if (assetName.endsWith('.png') || pngNames.contains(fileName)) {
      final path = assetName.startsWith('assets/')
          ? assetName
          : 'assets/images/$fileName';
      return Image.asset(path, height: 32, width: 32);
    }
    return SvgPicture.asset(
      assetName.startsWith('assets/') ? assetName : 'assets/icons/$assetName',
      height: 32,
      width: 32,
    );
  }

  Widget _categoryCircle(Color color, String label, String category) {
    return GestureDetector(
      onTap: () => _navigateToFeed(category),
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.3),
            ),
            child: Icon(
              _getCategoryIcon(category),
              size: 40,
              color: color.withOpacity(0.8),
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
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'plumbing':
        return Icons.plumbing;
      case 'electrician':
        return Icons.electrical_services;
      case 'house help':
        return Icons.cleaning_services;
      default:
        return Icons.work;
    }
  }

  Widget _popularCard(
    String title,
    String subtitle,
    double rating,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () => _navigateToFeed(title),
      child: Container(
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
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PendingActivitiesPage(),
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/icons/noti.svg',
                      height: 26,
                    ),
                  ),
                ],
              ),
            ),

            // Search box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onTap: () => _navigateToFeed('all'),
                readOnly: true,
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
                  _iconLabel('assets/images/cook.png', 'Need a cook'),
                  _iconLabel('assets/images/plumbing.png', 'Spa'),
                  _iconLabel('assets/images/helper.png', 'Household helper'),
                  _iconLabel('assets/images/washing.png', 'Cleaning'),
                  _iconLabel('assets/images/electrician.png', 'Electrician'),
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
                    'assets/images/plumbing.png',
                    'Electrical Plumbing',
                  ),
                  _iconLabel('assets/images/spa.png', 'Spa'),
                  _iconLabel(
                    'assets/images/repair.png',
                    'Home repairs',
                    Colors.orange,
                    'Home Repairs',
                  ),
                  _iconLabel('assets/images/cleaning.png', 'Home Cleaning'),
                  _iconLabel('assets/images/washing.png', 'Washing'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Top Categories
            _sectionTitle(
              'Top Categories',
              onSeeAll: () => _navigateToFeed('all'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _categoryCircle(
                    const Color(0xFF6DAFEF),
                    'Plumbing',
                    'Plumbing',
                  ),
                  _categoryCircle(
                    const Color(0xFFFFB84D),
                    'Electrician',
                    'Electrician',
                  ),
                  _categoryCircle(
                    const Color(0xFFFF8FAB),
                    'House Help',
                    'House Help',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Popular near you
            _sectionTitle(
              'Popular near you',
              onSeeAll: () => _navigateToFeed('all'),
            ),
            SizedBox(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _popularCard(
                    'Need for a cook',
                    'Breakfast and Tiffin',
                    4.1,
                    'assets/images/professional-cook.jpg',
                  ),
                  _popularCard(
                    'Electrician',
                    'Basic Home Service',
                    4.1,
                    'assets/images/electrician_serv.jpg',
                  ),
                  _popularCard(
                    'Plumbing',
                    'Water & Pipe Repairs',
                    4.3,
                    'assets/images/plumbing.png',
                  ),
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
