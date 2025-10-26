import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../pages/home.dart';
import '../pages/bookings.dart';
import '../pages/feed.dart';
import '../pages/account.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
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
      onTap: (index) {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
            break;
          case 1:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BookingsPage()),
              (route) => false,
            );
            break;
          case 2:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const FeedPage()),
              (route) => false,
            );
            break;
          case 3:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AccountPage()),
              (route) => false,
            );
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/home.svg',
            height: 24,
            colorFilter: ColorFilter.mode(
              currentIndex == 0 ? Colors.deepPurple : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/booking.svg',
            height: 24,
            colorFilter: ColorFilter.mode(
              currentIndex == 1 ? Colors.deepPurple : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/feed.svg',
            height: 24,
            colorFilter: ColorFilter.mode(
              currentIndex == 2 ? Colors.deepPurple : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/account.svg',
            height: 24,
            colorFilter: ColorFilter.mode(
              currentIndex == 3 ? Colors.deepPurple : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
          label: 'Account',
        ),
      ],
    );
  }
}
