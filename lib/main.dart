import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:quiz_app/common/theme.dart';
import 'package:quiz_app/firebase_options.dart';
import 'package:quiz_app/screens/homescreen.dart';
import 'package:quiz_app/screens/login_screen.dart'; // Import LoginScreen (your AuthScreen)
// Removed import for UsernameScreen as it's not being used
import 'package:quiz_app/service/quiz_service.dart'; // Assuming this initializes your quiz data
import 'package:quiz_app/service/shared_pref_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter widgets are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialize Firebase
  );
  await SharedPrefService.init(); // Initialize SharedPreferences (crucial for username check)
  await QuizService.initializeQuestions(); // Assuming this initializes your quiz data
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizVeda', // Updated app title
      debugShowCheckedModeBanner: false,
      // Apply custom themes from app_themes.dart
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system, // Dynamically switch based on system preference
      // Home widget now determined by Firebase authentication state
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // Listen to authentication state changes
        builder: (context, snapshot) {
          // Show a loading indicator while Firebase is determining the auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          final User? user = snapshot.data; // Get the current Firebase User

          if (user == null) {
            // If there is no authenticated user, show the LoginScreen
            return const LoginScreen();
          } else {
            // If a user is authenticated with Firebase,
            // directly navigate to the HomeScreen.
            // The HomeScreen will be responsible for loading the username
            // from SharedPrefs or defaulting to the Firebase display name.
            return const HomeScreen();
          }
        },
      ),
    );
  }
}
