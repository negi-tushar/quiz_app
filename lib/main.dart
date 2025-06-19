import 'package:flutter/material.dart';
import 'package:quiz_app/common/string.dart';
import 'package:quiz_app/screens/homescreen.dart';
import 'package:quiz_app/screens/username_scren.dart';
import 'package:quiz_app/service/quiz_service.dart';
import 'package:quiz_app/service/shared_pref_service.dart';

void main() async {
  await QuizService.initializeQuestions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      initialRoute: ((SharedPrefService.getData(userNameKey) ?? "") as String).isNotEmpty ? '/home' : '/user',
      routes: {'/user': (context) => UserProfileScreen(), '/home': (context) => HomeScreen()},
    );
  }
}
