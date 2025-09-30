import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {});
        },
        children: [
          _buildOnboardingPage(
            isFirstPage: true,
            buttonText: 'Next',
            onButtonPressed: () {
              _pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
          _buildOnboardingPage(
            isFirstPage: false,
            buttonText: 'Get Started',
            onButtonPressed: () {
              // Navigate to home or login screen
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage({
    required bool isFirstPage,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    return Stack(
      children: [
        // Background wave
        Positioned.fill(
          child: SvgPicture.asset('assets/images/wave.png', fit: BoxFit.cover),
        ),

        // Content
        SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo
              SvgPicture.asset(
                'assets/icons/logo.svg',
                height: 120,
                width: 120,
              ),

              const SizedBox(height: 40),

              // Welcome text
              const Text(
                'Welcome to',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Axiforma',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              // KalmGhar text with custom styling
              Stack(
                children: [
                  // Stroke effect
                  Text(
                    'KalmGhar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = const Color(0xFF283891),
                    ),
                  ),
                  // Fill text with shadow
                  Text(
                    'KalmGhar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Axiforma',
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.4),
                          offset: const Offset(4, 4),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 1),

              // Bottom white section
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Description text
                      const Text(
                        'Get people to work and make life\neasier!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 16,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIndicator(isFirstPage),
                          const SizedBox(width: 8),
                          _buildIndicator(!isFirstPage),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onButtonPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF283891),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                buttonText,
                                style: const TextStyle(
                                  fontFamily: 'Axiforma',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Container(
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF283891) : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
