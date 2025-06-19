// lib/screens/result_screen.dart
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart'; // For the circular progress bar

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final VoidCallback onRetakeQuiz;
  // Optional: A callback to navigate to a screen that reviews answers
  final VoidCallback? onReviewAnswers;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.onRetakeQuiz,
    this.onReviewAnswers, // Make this optional
  });

  String get _resultMessage {
    double percentage = (score / totalQuestions) * 100;
    if (percentage >= 80) {
      return 'Excellent Job!';
    } else if (percentage >= 60) {
      return 'Great Effort!';
    } else if (percentage >= 40) {
      return 'Good Try!';
    } else {
      return 'Keep Practicing!';
    }
  }

  Color _getScoreColor(BuildContext context) {
    double percentage = (score / totalQuestions) * 100;
    if (percentage >= 80) {
      return Theme.of(context).colorScheme.tertiary; // Often a vibrant accent
    } else if (percentage >= 60) {
      return Theme.of(context).colorScheme.primary;
    } else if (percentage >= 40) {
      return Theme.of(context).colorScheme.secondary;
    } else {
      return Theme.of(context).colorScheme.error; // Red for low score
    }
  }

  @override
  Widget build(BuildContext context) {
    final double percentage = (score / totalQuestions);
    final String scoreText = '${(percentage * 100).toStringAsFixed(0)}%';

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(title: const Text('Quiz Results'), centerTitle: true, automaticallyImplyLeading: false),
        body: Center(
          child: SingleChildScrollView(
            // Use SingleChildScrollView for responsiveness on smaller screens
            padding: const EdgeInsets.all(24.0), // Increased padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Score Display (using CircularPercentIndicator)
                CircularPercentIndicator(
                  radius: 100.0, // Size of the circle
                  lineWidth: 18.0, // Thickness of the progress line
                  percent: percentage,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        scoreText,
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: _getScoreColor(context)),
                      ),
                      Text(
                        '$score / $totalQuestions',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  progressColor: _getScoreColor(context),
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                  animationDuration: 1200,
                  curve: Curves.easeInOut,
                ),
                const SizedBox(height: 40),

                // Result Message Card
                Card(
                  elevation: 6, // Increased elevation for a more modern look
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // More rounded corners
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 25.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Keep column size to its children
                      children: [
                        Icon(
                          score >= totalQuestions * 0.8 ? Icons.emoji_events_rounded : Icons.lightbulb_outline_rounded,
                          size: 60,
                          color: _getScoreColor(context),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _resultMessage,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getScoreColor(context),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'You answered $score out of $totalQuestions questions correctly.',
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Action Buttons
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity, // Make button span full width
                      child: ElevatedButton.icon(
                        onPressed: onRetakeQuiz,
                        icon: const Icon(Icons.home_rounded),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Go to Home Screen',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary, // Text color from theme
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary, // Button color from theme
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // Rounded button corners
                          ),
                          elevation: 5,
                        ),
                      ),
                    ),
                    // if (onReviewAnswers != null) ...[
                    //   // Only show if onReviewAnswers callback is provided
                    //   const SizedBox(height: 20),
                    //   SizedBox(
                    //     width: double.infinity,
                    //     child: OutlinedButton.icon(
                    //       onPressed: onReviewAnswers,
                    //       icon: const Icon(Icons.history_edu_rounded),
                    //       label: Padding(
                    //         padding: const EdgeInsets.symmetric(vertical: 12.0),
                    //         child: Text(
                    //           'Review Answers',
                    //           style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    //             fontWeight: FontWeight.bold,
                    //             color: Theme.of(context).colorScheme.primary,
                    //           ),
                    //         ),
                    //       ),
                    //       style: OutlinedButton.styleFrom(
                    //         side: BorderSide(
                    //           color: Theme.of(context).colorScheme.primary,
                    //           width: 2,
                    //         ), // Primary color border
                    //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    //         elevation: 0,
                    //       ),
                    //     ),
                    //   ),
                    //    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
