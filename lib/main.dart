import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/common/theme.dart';
import 'package:quiz_app/firebase_options.dart';
import 'package:quiz_app/screens/all_quize_screen.dart';
import 'package:quiz_app/screens/homescreen.dart';
import 'package:quiz_app/screens/leaderboard_screen.dart';
import 'package:quiz_app/screens/login_screen.dart';

import 'package:quiz_app/service/quiz_service.dart';
import 'package:quiz_app/service/shared_pref_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPrefService.init();
  await QuizService.initializeQuestions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizVeda',
      debugShowCheckedModeBanner: false,

      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          final User? user = snapshot.data;

          if (user == null) {
            return const LoginScreen();
          } else {
            return const HomeScreen();
          }
        },
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/allQuizzes': (context) => const AllQuizzesScreen(),
        '/leaderboard': (context) => const LeaderboardScreen(),
      },
    );
  }
}
