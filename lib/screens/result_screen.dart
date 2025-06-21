// lib/screens/result_screen.dart
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart'; // For the circular progress bar
import 'package:quiz_app/service/auth_service.dart';
import 'package:quiz_app/service/leaderboard_service.dart';
import 'package:quiz_app/common/string.dart'; // For userNameKey
import 'package:quiz_app/service/shared_pref_service.dart'; // For SharedPrefService
import 'package:quiz_app/screens/leaderboard_screen.dart'; // Import new LeaderboardScreen

class ResultScreen extends StatefulWidget {
  final int score; // This is now the optimized score (base points + time bonus)
  final int totalQuestions;
  final String quizType; // Passed from QuizScreen
  final String? category; // Passed from QuizScreen (optional)
  final VoidCallback onRetakeQuiz;
  final VoidCallback? onReviewAnswers; // Optional callback for review

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.onRetakeQuiz,
    this.onReviewAnswers, // Make this optional
    this.quizType = 'General Quiz', // Default value
    this.category,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final LeaderboardService _leaderboardService = LeaderboardService();

  String? _submissionError;

  // Assuming _basePointsPerCorrectAnswer was 100 in QuizScreen
  final int _basePointsPerCorrectAnswer = 10;
  late int _correctAnswersCount; // Will store the count of truly correct answers

  @override
  void initState() {
    super.initState();

    _correctAnswersCount = widget.score ~/ _basePointsPerCorrectAnswer;
    if (_correctAnswersCount > widget.totalQuestions) {
      _correctAnswersCount = widget.totalQuestions;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.score > 0) {
        // Only submit score if it's greater than 0
        await _submitScore();
      }
    });
  }

  String get _resultMessage {
    double percentage = (_correctAnswersCount / widget.totalQuestions) * 100;
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
    double percentage = (_correctAnswersCount / widget.totalQuestions) * 100;
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

  Future<void> _submitScore() async {
    setState(() {
      _submissionError = null;
    });

    final currentUser = AuthService().getCurrentUser();
    if (currentUser == null) {
      setState(() {
        _submissionError = 'You must be logged in to submit scores.';
      });
      return;
    }

    // Get the user's display name (either from SharedPrefs or Firebase Auth)
    String userName = await SharedPrefService.getData(userNameKey) as String? ?? currentUser.displayName ?? 'Anonymous';

    try {
      await _leaderboardService.addOrUpdateUserScore(
        userId: currentUser.uid,
        userName: userName,
        imageUrl: currentUser.photoURL ?? '',
        newOptimizedScore: widget.score, // Submit the optimized score
      );
    } catch (e) {
      debugPrint('Error submitting score: $e');
      setState(() {
        _submissionError = 'Failed to submit score. Please try again later.';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit score')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Percentage for the CircularPercentIndicator (based on correct answers)
    final double accuracyPercentage = (widget.totalQuestions > 0)
        ? (_correctAnswersCount / widget.totalQuestions)
        : 0.0;
    final String accuracyText = '${(accuracyPercentage * 100).toStringAsFixed(0)}%';

    return PopScope(
      canPop: false, // Prevents going back from results using system back button
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: theme.brightness == Brightness.light
                  ? [colorScheme.surfaceContainerHighest, colorScheme.surface]
                  : [colorScheme.surfaceContainerHigh, colorScheme.surface],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 20), // Top padding for status bar/safe area
              Text(
                'Quiz Results',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    // Added SingleChildScrollView
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      // Replaced Card with Container for consistency
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.9), // Use themed surface color
                        borderRadius: BorderRadius.circular(25), // More rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.15),
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Keep column size to its children
                        children: [
                          Text(
                            _resultMessage, // Message based on accuracy
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getScoreColor(context), // Color based on accuracy
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Optimized Score Display
                          Text(
                            'Your Score',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${widget.score}', // Display the calculated optimized score
                            style: textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: colorScheme.primary, // Primary color for optimized score
                              fontSize: 56, // Larger font size
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 5,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25), // Spacing before other stats
                          // Accurate Score (Correct Answers) and Percentage
                          CircularPercentIndicator(
                            radius: 80.0, // Size of the circle
                            lineWidth: 15.0, // Thickness of the progress line
                            percent: accuracyPercentage, // Based on correct answers
                            animation: true,
                            animationDuration: 1200,
                            curve: Curves.easeInOut,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  accuracyText,
                                  style: textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _getScoreColor(context),
                                  ),
                                ),
                                Text(
                                  'Correct: $_correctAnswersCount / ${widget.totalQuestions}',
                                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                            progressColor: _getScoreColor(context), // Color based on accuracy
                            backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                              alpha: 0.5,
                            ), // Background of progress bar
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                          const SizedBox(height: 30),

                          // Quiz Type and Category Display
                          // Text(
                          //   'Quiz Type: ${widget.quizType}',
                          //   style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha:0.8)),
                          // ),
                          // Text(
                          //   'Category: ${widget.category ?? 'Not Specified'}',
                          //   style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha:0.8)),
                          // ),
                          // const SizedBox(height: 30),

                          // Submit Score Button
                          if (_submissionError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                _submissionError!,
                                style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          const SizedBox(height: 20),

                          // Go to Home Screen Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: widget.onRetakeQuiz,
                              icon: const Icon(Icons.home_rounded),
                              label: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text('Back to Home', style: textTheme.labelLarge?.copyWith(fontSize: 16)),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.secondary, // Secondary color for neutral action
                                foregroundColor: colorScheme.onSecondary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                elevation: 5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // View Leaderboard Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).push(MaterialPageRoute(builder: (context) => const LeaderboardScreen()));
                              },
                              icon: const Icon(Icons.leaderboard_rounded),
                              label: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text('View Leaderboard', style: textTheme.labelLarge?.copyWith(fontSize: 16)),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.tertiary, // Tertiary color for another action
                                foregroundColor: colorScheme.onTertiary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                elevation: 5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
