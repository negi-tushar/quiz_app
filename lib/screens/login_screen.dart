import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/common/string.dart';
import 'package:quiz_app/screens/homescreen.dart';
import 'package:quiz_app/service/auth_service.dart';
import 'package:quiz_app/service/shared_pref_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _signInError;

  @override
  void initState() {
    super.initState();
    // Listen to auth state changes to automatically navigate if already signed in
    _authService.authStateChanges.listen((User? user) {
      if (user != null && mounted) {
        // User is signed in, navigate to HomeScreen
        _saveUserName(user.displayName); // Save display name to SharedPreferences
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    });
  }

  Future<void> _saveUserName(String? displayName) async {
    await SharedPrefService.saveData(userNameKey, displayName ?? 'Guest');
  }

  Future<void> _handleSignIn() async {
    setState(() {
      _isLoading = true;
      _signInError = null;
    });
    try {
      final UserCredential? userCredential = await _authService.signInWithGoogle();
      if (userCredential != null) {
        // Sign-in successful, the authStateChanges listener will handle navigation
        debugPrint('Signed in as: ${userCredential.user?.displayName}');
      } else {
        // User cancelled the sign-in flow
        setState(() {
          _isLoading = false;
          _signInError = 'Sign in cancelled by user.';
        });
      }
    } catch (e) {
      debugPrint('Sign-in error: $e');
      setState(() {
        _isLoading = false;
        _signInError = 'Failed to sign in. Please try again. ($e)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height,
        color: theme.brightness == Brightness.light ? Colors.white : Colors.black26,

        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Lottie.asset(
                'assets/lottie/registration.json',
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * .4,
                // fit: BoxFit.contain,
              ),
              Text(
                'Welcome Back to QuizVeda',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),
              Text(
                'Your daily dose of knowledge!',
                style: textTheme.titleMedium?.copyWith(color: colorScheme.onBackground.withOpacity(0.7)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: _isLoading ? null : _handleSignIn,
                label: Text(
                  "Login with Google",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.brightness != Brightness.light ? Colors.black : Colors.white,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: theme.brightness != Brightness.light ? Colors.white : Colors.black54,

                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Image.asset('assets/img/google.png', height: 30, width: 30),
              ),
              const SizedBox(height: 20),

              if (_signInError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    _signInError!,
                    style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
