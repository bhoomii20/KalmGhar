import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/onboarding.dart';
import 'pages/home.dart';
import 'firebase_options.dart';
import 'pages/login.dart';
import 'pages/roles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

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
        '/login': (context) => const LoginScreen(),
        '/roles': (context) => const ChooseRoleScreen(userName: 'User'),
      },
    );
  }
}
