// Save this as: lib/pages/login.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'home.dart';
import 'roles.dart';
import 'dart:async';
import '../services/auth_service.dart';

// Main Login Screen (Screen 1) - Updated with Firebase Authentication
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  String _userType = 'Employer'; // Default value
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  // Validate inputs
  bool _validateInputs() {
    if (_usernameController.text.trim().isEmpty) {
      showSnackBar(context, 'Please enter your username');
      return false;
    }

    if (_mobileController.text.trim().isEmpty) {
      showSnackBar(context, 'Please enter your mobile number');
      return false;
    }

    if (_mobileController.text.trim().length != 10) {
      showSnackBar(context, 'Please enter a valid 10-digit mobile number');
      return false;
    }

    return true;
  }

  // Check if user exists in Firestore
  Future<bool> _checkUserExists() async {
    try {
      final exists = await _authService.checkUserExists(
        _usernameController.text.trim(),
        _mobileController.text.trim(),
        _userType,
      );
      return exists;
    } catch (e) {
      showSnackBar(context, 'Error checking user: $e');
      return false;
    }
  }

  // Initiate Firebase Phone Authentication
  Future<void> initiateLoginAuth() async {
    // Validate inputs first
    if (!_validateInputs()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Check if user exists
    bool userExists = await _checkUserExists();

    if (!userExists) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, 'User not found. Please sign up first.');
      return;
    }

    try {
      String phoneNumber = '+91${_mobileController.text.trim()}';

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (Android only)
          try {
            await _auth.signInWithCredential(credential);
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            }
          } catch (e) {
            showSnackBar(context, 'Auto-verification failed: $e');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
          });
          showSnackBar(context, e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isLoading = false;
          });

          // Navigate to OTP screen with verification ID
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPVerificationScreen(
                  phoneNumber: _mobileController.text.trim(),
                ),
              ),
            );
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Auto retrieval timeout');
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, 'Error: $e');
    }
  }

  // Show error/success messages
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Logo
              Image.asset('assets/images/ghar.png', height: 120),

              const SizedBox(height: 30),

              // Welcome text
              const Text(
                'Welcome back to',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'KalmGhar',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF283891),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "You've been missed",
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 24),

              // User Type Selection
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.work_outline, color: Colors.grey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _userType,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Color(0xFF283891),
                          ),
                          style: const TextStyle(
                            fontFamily: 'Axiforma',
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Employer',
                              child: Text('Employer'),
                            ),
                            DropdownMenuItem(
                              value: 'Employee',
                              child: Text('Employee'),
                            ),
                          ],
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _userType = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Username field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                  ),
                  hintText: 'Enter your username',
                  hintStyle: const TextStyle(
                    fontFamily: 'Axiforma',
                    color: Colors.grey,
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

              // Mobile number field with validation
              TextField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    color: Colors.grey,
                  ),
                  hintText: 'Enter your mobile number',
                  counterText: '',
                  hintStyle: const TextStyle(
                    fontFamily: 'Axiforma',
                    color: Colors.grey,
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

              const SizedBox(height: 24),

              // Get OTP button with loading state
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : initiateLoginAuth,
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
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Get OTP',
                          style: TextStyle(
                            fontFamily: 'Axiforma',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const Spacer(),

              // Create account link
              const Text(
                'Are you a new user ?',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF283891),
                    side: const BorderSide(color: Color(0xFF283891), width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create an Account',
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

// OTP Verification Screen (Screen 2)
class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Logo
              Image.asset('assets/images/ghar.png', height: 120),

              const SizedBox(height: 30),

              // Welcome text
              const Text(
                'Welcome back to',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'KalmGhar',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF283891),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "You've been missed",
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                'Verification code',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'A 6 digit code has been sent to +91 ${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 32),

              // OTP Input boxes
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Container(
                      width: MediaQuery.of(context).size.width <= 350 ? 36 : 44,
                      height: 48,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 32),

              // Verify button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to home after verification
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
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
                    'Verify',
                    style: TextStyle(
                      fontFamily: 'Axiforma',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Resend code and timer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Resend Code',
                      style: TextStyle(
                        fontFamily: 'Axiforma',
                        fontSize: 14,
                        color: Color(0xFF283891),
                      ),
                    ),
                  ),
                  const Text(
                    '120 min left',
                    style: TextStyle(
                      fontFamily: 'Axiforma',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// Screen 3 - Sign Up Screen with Phone Authentication

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // NEW SIGN-UP METHOD: Email/Password (No billing required)
  //
  // FIX: Replaced phone SMS auth with email/password to eliminate "billing not enabled" error
  // This allows brand-new users to register without requiring Firebase billing
  Future<void> createAccount() async {
    // Validate inputs
    if (_usernameController.text.trim().isEmpty ||
        _fullNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      showSnackBar(context, 'Please fill all required fields');
      return;
    }

    // Validate email format
    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(_emailController.text.trim())) {
      showSnackBar(context, 'Please enter a valid email address');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get form data
      final email = _emailController.text.trim();
      final username = _usernameController.text.trim();
      final fullName = _fullNameController.text.trim();
      final phoneNumber = _mobileController.text.trim();

      // Check if email is already in use
      final isEmailAvailable = await _authService.isEmailAvailable(email);
      if (!isEmailAvailable) {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(
          context,
          'This email is already registered. Please log in instead.',
        );
        return;
      }

      // Check if username is taken
      final isUsernameAvailable = await _authService.isUsernameAvailable(
        username,
      );
      if (!isUsernameAvailable) {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(
          context,
          'Username is already taken. Please choose another.',
        );
        return;
      }

      // Generate a temporary password (user can change it later)
      // In production, you'd ask user to create a password
      final tempPassword =
          'KalmGhar2024!'; // Temporary - user will set password after first login

      // Create Firebase Auth user with email/password (NO BILLING REQUIRED)
      print(
        '📧 Creating account with email/password auth (no SMS, no billing)...',
      );
      final userCredential = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: tempPassword,
      );

      print('✅ Firebase Auth user created: ${userCredential.user?.uid}');

      // Save user data to Firestore
      try {
        await _authService.saveUserData(
          username: username,
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber.isNotEmpty ? phoneNumber : null,
        );

        print('✅ User data saved to Firestore');

        // Navigate to role selection
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ChooseRoleScreen(userName: fullName),
            ),
            (route) => false,
          );
        }
      } catch (firestoreError) {
        // ROLLBACK: Delete auth user if Firestore save fails
        print('❌ Firestore save failed, rolling back auth user...');
        try {
          await userCredential.user?.delete();
          print('🗑️  Auth user deleted (rollback successful)');
        } catch (deleteError) {
          print('⚠️  Could not rollback auth user: $deleteError');
        }

        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, 'Failed to create account. Please try again.');
      }
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, e.toString());
      print('Sign-up error: $e');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, 'An unexpected error occurred. Please try again.');
      print('Unexpected error: $e');
    }
  }

  Future<void> saveUserData() async {
    User? currentUser = _auth.currentUser;

    try {
      // Wait a bit to ensure authentication is complete
      await Future.delayed(const Duration(milliseconds: 500));

      // Ensure user is authenticated before saving
      if (currentUser == null) {
        throw Exception('User not authenticated - Please try again');
      }

      print('📝 Saving user data for UID: ${currentUser.uid}');

      try {
        await _authService.saveUserData(
          username: _usernameController.text.trim(),
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _mobileController.text.trim(),
        );

        print('✅ User data saved successfully');
      } catch (firestoreError) {
        // Rollback: Delete the authenticated user if Firestore save fails
        print(
          '❌ Firestore save failed, rolling back authentication: $firestoreError',
        );
        try {
          await currentUser.delete();
          print('🗑️  Auth user deleted successfully');
        } catch (deleteError) {
          print('⚠️  Could not delete auth user: $deleteError');
        }

        if (mounted) {
          showSnackBar(context, 'Failed to create account. Please try again.');
        }
        rethrow;
      }
    } catch (e) {
      print('❌ Error saving user data: $e');
      if (mounted) {
        showSnackBar(context, 'Warning: Could not save user data: $e');
      }
      rethrow;
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset('assets/images/ghar.png', height: 120),
                const SizedBox(height: 30),
                const Text(
                  'Welcome to',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'KalmGhar',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF283891),
                  ),
                ),
                const SizedBox(height: 40),

                // Username field
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter your username',
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
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Full name field
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter your full name',
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
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Mobile number field
                TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter your mobile number',
                    counterText: '',
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
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Email field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter your email address',
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
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Terms and conditions checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF283891),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Axiforma',
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                          children: [
                            const TextSpan(
                              text: 'accept terms and conditions\n',
                            ),
                            const TextSpan(
                              text: 'By signing up, you\'re agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: const TextStyle(color: Color(0xFF283891)),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(color: Color(0xFF283891)),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Create account button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_acceptTerms && !_isLoading)
                        ? createAccount
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
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Create an Account',
                            style: TextStyle(
                              fontFamily: 'Axiforma',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Already a user ?',
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF283891),
                      side: const BorderSide(
                        color: Color(0xFF283891),
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Log in',
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

// Screen 4 - Sign Up OTP Verification Screen (6-digit)
class SignUpOTPScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final Map<String, String> userData;

  const SignUpOTPScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    required this.userData,
  });

  @override
  State<SignUpOTPScreen> createState() => _SignUpOTPScreenState();
}

class _SignUpOTPScreenState extends State<SignUpOTPScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isVerifying = false;
  int _remainingSeconds = 120;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String getOTP() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> verifyOTP() async {
    setState(() {
      _isVerifying = true;
    });

    try {
      String smsCode = getOTP();

      if (smsCode.length != 6) {
        showSnackBar(context, 'Please enter complete 6-digit OTP');
        setState(() {
          _isVerifying = false;
        });
        return;
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);

      // Save user data after successful authentication
      await saveUserData();

      if (mounted) {
        // Pass the actual userName from userData
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ChooseRoleScreen(
              userName: widget.userData['fullName'] ?? 'User',
            ),
          ),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getOTPErrorMessage(e.code);
      showSnackBar(context, errorMessage);
      setState(() {
        _isVerifying = false;
      });
    } catch (e) {
      showSnackBar(context, 'Error during sign up: $e');
      setState(() {
        _isVerifying = false;
      });
    }
  }

  String _getOTPErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-verification-code':
        return 'Invalid OTP code. Please try again.';
      case 'code-expired':
        return 'Verification code has expired. Please request a new one.';
      case 'session-expired':
        return 'Verification session expired. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Verification failed. Please try again.';
    }
  }

  Future<void> saveUserData() async {
    User? currentUser = _auth.currentUser;

    try {
      // Wait a bit to ensure authentication is complete
      await Future.delayed(const Duration(milliseconds: 500));

      // Ensure user is authenticated
      if (currentUser == null) {
        throw Exception('User not authenticated - Please try again');
      }

      print('📝 Saving user data for UID: ${currentUser.uid}');

      final AuthService authService = AuthService();

      try {
        await authService.saveUserData(
          username: widget.userData['username'] ?? '',
          fullName: widget.userData['fullName'] ?? '',
          email: widget.userData['email'] ?? '',
          phoneNumber: widget.userData['phoneNumber'] ?? '',
        );

        print('✅ User data saved successfully');
      } catch (firestoreError) {
        // Rollback: Delete the authenticated user if Firestore save fails
        print(
          '❌ Firestore save failed, rolling back authentication: $firestoreError',
        );
        try {
          await currentUser.delete();
          print('🗑️  Auth user deleted successfully');
        } catch (deleteError) {
          print('⚠️  Could not delete auth user: $deleteError');
        }
        rethrow;
      }
    } catch (e) {
      print('❌ Error saving user data: $e');
      // Re-throw to handle in calling function
      rethrow;
    }
  }

  Future<void> resendOTP() async {
    if (_remainingSeconds > 0) return;

    setState(() {
      _remainingSeconds = 120;
    });
    startTimer();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          showSnackBar(context, e.message ?? 'Failed to resend OTP');
        },
        codeSent: (String verificationId, int? resendToken) {
          showSnackBar(context, 'OTP sent successfully');
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      showSnackBar(context, 'Error resending OTP');
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
              Image.asset('assets/images/ghar.png', height: 120),
              const SizedBox(height: 30),
              const Text(
                'Welcome back to',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'KalmGhar',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF283891),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Verification code',
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'A 6 digit code has been sent to +91 ${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 32),

              // OTP Input boxes (6 digits)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 8),

                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontFamily: 'Axiforma',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.grey[300],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Verify button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : verifyOTP,
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
                  child: _isVerifying
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Verify',
                          style: TextStyle(
                            fontFamily: 'Axiforma',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Resend code and timer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _remainingSeconds == 0 ? resendOTP : null,
                    child: Text(
                      'Resend Code',
                      style: TextStyle(
                        fontFamily: 'Axiforma',
                        fontSize: 14,
                        color: _remainingSeconds == 0
                            ? const Color(0xFF283891)
                            : Colors.grey,
                      ),
                    ),
                  ),
                  Text(
                    '${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')} left',
                    style: const TextStyle(
                      fontFamily: 'Axiforma',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
