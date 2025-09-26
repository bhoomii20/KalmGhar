import 'package:flutter/material.dart';
import 'pages/onboarding.dart';
import 'pages/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Axiforma'),
      // Set onboarding as initial screen
      home: const OnboardingScreen(),
      // Optional: Define named routes for easier navigation
      routes: {
        '/home': (context) => const HomePage(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}
