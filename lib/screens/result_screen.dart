// lib/screens/result_screen.dart
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final VoidCallback onRetakeQuiz;

  const ResultScreen({super.key, required this.score, required this.totalQuestions, required this.onRetakeQuiz});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevents going back from results to quiz screen using system back button
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Results'),
          centerTitle: true,
          automaticallyImplyLeading: false, // No back button on app bar
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Text(
                          'Quiz Completed!',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Your Score: $score / $totalQuestions',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: onRetakeQuiz,
                          child: Text(
                            'Go to Home Screen',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 20,
                              color: Theme.of(context).elevatedButtonTheme.style?.foregroundColor?.resolve({}),
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
        ),
      ),
    );
  }
}
