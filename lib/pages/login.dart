// Save this as: lib/pages/login.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'home.dart';
import 'roles.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

// Main Login Screen (Screen 1)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _mobileController.dispose();
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

              // Mobile number field
              TextField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    color: Colors.grey,
                  ),
                  hintText: 'Enter your mobile number',
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

              // Get OTP button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OTPVerificationScreen(
                          phoneNumber: _mobileController.text,
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
                  child: const Text(
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> initiatePhoneAuth() async {
    // Use this only during development/testing.
    await FirebaseAuth.instance.setSettings(
      appVerificationDisabledForTesting: true,
    );

    // Now proceed with verifyPhoneNumber or other auth calls.
    // Validate inputs
    if (_usernameController.text.trim().isEmpty ||
        _fullNameController.text.trim().isEmpty ||
        _mobileController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      showSnackBar(context, 'Please fill all fields');
      return;
    }

    if (_mobileController.text.trim().length != 10) {
      showSnackBar(context, 'Please enter a valid 10-digit mobile number');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String phoneNumber = '+91${_mobileController.text.trim()}';

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (Android only)
          await _auth.signInWithCredential(credential);
          //await saveUserData();
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ChooseRoleScreen(userName: 'User'),
              ),
              (route) => false,
            );
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
          });
          showSnackBar(context, e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) async {
          setState(() {
            _isLoading = false;
          });

          // Navigate to OTP screen
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpOTPScreen(
                  phoneNumber: _mobileController.text.trim(),
                  verificationId: verificationId,
                  userData: {
                    'username': _usernameController.text.trim(),
                    'fullName': _fullNameController.text.trim(),
                    'email': _emailController.text.trim(),
                    'phoneNumber': _mobileController.text.trim(),
                  },
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

  Future<void> saveUserData() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_usernameController.text.trim())
          .set({
            'email': _emailController.text.trim(),
            //'name': _usernameController.text.trim(),
            'phone': _mobileController.text.trim(),
            'fullName': _fullNameController.text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('Error saving user data: $e');
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
                        ? initiatePhoneAuth
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const ChooseRoleScreen(userName: 'User'),
          ),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? 'Invalid OTP');
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  Future<void> saveUserData() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .set({
            'email': widget.userData['email'],
            'username': widget.userData['username'],
            'phoneNumber': widget.userData['phoneNumber'],
            'name': widget.userData['fullName'],
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('Error saving user data: $e');
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
