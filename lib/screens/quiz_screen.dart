import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui'; // For ImageFilter.blur

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:quiz_app/common/quiz_data.dart'; // User's specified path
import 'package:quiz_app/model/quiz_model.dart'; // User's specified path
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/service/quiz_service.dart';

class QuizScreen extends StatefulWidget {
  final int numberOfQuestions;
  final int questionTimerSeconds;
  final String? category;

  const QuizScreen({super.key, required this.numberOfQuestions, required this.questionTimerSeconds, this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _isAnswerLocked = false;

  Timer? _timer;
  int _currentTimerSeconds = 0;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _startQuestionTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Load questions from the quizData string (from common/quiz_data.dart)
  void _loadQuestions() {
    List<Question> fetchedQuestions;
    if (widget.category != null) {
      // Fetch random questions from the specified category
      fetchedQuestions = QuizService.getRandomQuestionsByCategory(widget.category!, widget.numberOfQuestions);
    } else {
      // If no category specified (e.g., for general 'Quick Quizzes'),
      // get random questions from all available questions.
      final allAvailableQuestions = QuizService.getAllQuestions();
      allAvailableQuestions.shuffle(); // Shuffle all
      fetchedQuestions = allAvailableQuestions.sublist(
        0,
        widget.numberOfQuestions.clamp(0, allAvailableQuestions.length),
      );
    }

    if (fetchedQuestions.isEmpty) {
      // Handle scenario where no questions could be loaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No questions available for this quiz criteria.')));
        Navigator.of(context).pop(); // Go back to the previous screen (Home)
      });
      return; // Exit without setting state if no questions
    }

    setState(() {
      _questions = fetchedQuestions;
      _isDataLoaded = true;
      _currentQuestionIndex = 0;
      _score = 0;
    });
  }

  // Starts or resets the timer for the current question
  void _startQuestionTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _currentTimerSeconds = widget.questionTimerSeconds; // Reset timer for new question
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTimerSeconds > 0) {
        setState(() => _currentTimerSeconds--);
      } else {
        _timer?.cancel();
        _handleTimeUp(); // Handle time running out
      }
    });
  }

  // Handles logic when the timer for a question runs out
  void _handleTimeUp() {
    if (!_isAnswerLocked) {
      // If no answer was selected, mark as incorrect and auto-advance
      setState(() {
        _selectedAnswer = null; // Indicate no answer was chosen
        _isAnswerLocked = true; // Lock selection
      });
      // Delay before moving to the next question to show feedback
      Future.delayed(const Duration(seconds: 2), _nextQuestion);
    }
  }

  // Handles the user selecting an answer
  void _checkAnswer(String selectedAnswer) {
    // Only proceed if an answer hasn't been selected yet for this question and timer hasn't run out
    if (_isAnswerLocked || _currentTimerSeconds == 0) return;

    // Provide haptic feedback on selection
    HapticFeedback.selectionClick();
    _timer?.cancel(); // Stop the timer as soon as an answer is selected

    setState(() {
      _selectedAnswer = selectedAnswer; // Store the selected answer
      _isAnswerLocked = true; // Lock further answer selection
      final currentQuestion = _questions[_currentQuestionIndex];
      if (selectedAnswer == currentQuestion.correctAnswer) {
        _score++; // Increment score if correct
      }
    });

    // Automatically move to the next question after a short delay
    Future.delayed(const Duration(seconds: 2), _nextQuestion);
  }

  // Moves to the next question or ends the quiz
  void _nextQuestion() {
    setState(() {
      _selectedAnswer = null; // Reset selected answer for the next question
      _isAnswerLocked = false; // Unlock answer selection for the next question
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++; // Move to the next question
        _startQuestionTimer(); // Start timer for the new question
      } else {
        // Quiz ended, show results
        _showResultScreen();
      }
    });
  }

  // Displays the quiz result screen
  void _showResultScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => ResultScreen(
          score: _score,
          totalQuestions: _questions.length,
          onRetakeQuiz: () {
            // Logic to go back to home or restart quiz
            Navigator.popUntil(ctx, (route) => route.isFirst); // Example: Go back to the very first screen
            // Or if you have a specific home screen route:
            // Navigator.pushAndRemoveUntil(ctx, MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
          },
          onReviewAnswers: () {},
        ),
      ),
    );
  }

  // Helper to determine the background color for the answer option containers
  Color _getOptionContainerColor(String option, ColorScheme colorScheme) {
    if (!_isAnswerLocked) {
      // Default state: A subtle transparent frosted look
      return colorScheme.surface.withOpacity(0.15);
    }
    final currentQuestion = _questions[_currentQuestionIndex];
    if (option == currentQuestion.correctAnswer) {
      return Colors.green.shade300.withOpacity(0.8); // Correct answer color
    }
    if (option == _selectedAnswer) {
      return Colors.red.shade300.withOpacity(0.8); // Incorrect selected answer color
    }
    // For other unselected options when an answer is locked, make them very subtle
    return colorScheme.surface.withOpacity(0.05);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Show loading indicator if questions are not yet loaded
    if (_questions.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(colorScheme.primary))),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return PopScope(
      canPop: false, // Prevent going back with system back button during quiz
      child: Scaffold(
        // Main container with a modern gradient background
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
              if (Platform.isIOS) const SizedBox(height: 80) else const SizedBox(height: 20),
              // Linear Progress Indicator for Timer (moved to top)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Rounded corners for progress bar
                  child: LinearProgressIndicator(
                    value: _currentTimerSeconds / widget.questionTimerSeconds,
                    minHeight: 8, // Thicker progress bar
                    backgroundColor: colorScheme.surface.withOpacity(0.3), // Background color of bar
                    color: colorScheme.secondary, // Progress color
                  ),
                ),
              ),

              // Header Stats Section: Question, Score, Timer
              _buildHeaderStats(theme, colorScheme, textTheme),
              Flexible(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600), // Slightly longer animation
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    // Custom slide and fade transition
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(1.0, 0.0), // Starts from right
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
                    final fadeAnimation = Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));
                    return SlideTransition(
                      position: offsetAnimation,
                      child: FadeTransition(opacity: fadeAnimation, child: child),
                    );
                  },
                  // The key is essential for AnimatedSwitcher to recognize a content change
                  key: ValueKey(currentQuestion.id),
                  child: _buildQuestionContainer(currentQuestion, textTheme, colorScheme),
                ),
              ),
              const SizedBox(height: 30), // Increased bottom padding for aesthetic balance
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the header stats (Question, Score, Timer)
  Widget _buildHeaderStats(ThemeData theme, ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          // Frosted glass effect for the header container
          color: colorScheme.surface.withAlpha(100),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Question', '${_currentQuestionIndex + 1}/${_questions.length}', textTheme, colorScheme),
            _buildStatItem('Score', '$_score', textTheme, colorScheme),
            // Timer display as a distinct item
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.secondary, // Emphasized with secondary color
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.secondary.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${_currentTimerSeconds}s',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSecondary, // Text color on secondary
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for individual stat items (Question, Score)
  Widget _buildStatItem(String label, String value, TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  // Helper widget for the main question and options container
  Widget _buildQuestionContainer(Question question, TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(20), // Increased padding
      decoration: BoxDecoration(
        color: colorScheme.surface,

        borderRadius: BorderRadius.circular(15), // More rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Soft shadow
            spreadRadius: 1,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: colorScheme.surface.withOpacity(0.4), // Subtle, light border
          width: 1.5,
        ),
      ),
      child: SingleChildScrollView(
        // Allows content to scroll if it overflows
        child: Column(
          mainAxisSize: MainAxisSize.min, // Keep column compact
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question.questionText,
              textAlign: TextAlign.start,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
                fontSize: 20, // Slightly larger question text
                shadows: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(1, 1))],
              ),
            ),
            const SizedBox(height: 20), // Increased spacing after question
            // Display options as custom-styled interactive containers
            ...question.options.map(
              (option) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8), // Adjusted vertical padding
                child: Material(
                  // Provides Material Design visual responses (splash, highlight)
                  color: _getOptionContainerColor(option, colorScheme), // Background color
                  borderRadius: BorderRadius.circular(18), // Match inner container/InkWell
                  child: InkWell(
                    onTap: _isAnswerLocked || _currentTimerSeconds == 0
                        ? null // Disable tap if answer is locked or time is up
                        : () => _checkAnswer(option),
                    borderRadius: BorderRadius.circular(18), // Match Material's border radius
                    highlightColor: Colors.transparent, // Avoid default highlight color
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding for text inside
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: _selectedAnswer == option && _isAnswerLocked
                              ? (_selectedAnswer == question.correctAnswer
                                    ? Colors.green.shade700
                                    : Colors.red.shade700)
                              : colorScheme.primary.withAlpha(100), // Default border for options
                          width: _selectedAnswer == option && _isAnswerLocked
                              ? 3
                              : 1.0, // Thicker border on selected/feedback
                        ),
                      ),
                      child: Text(
                        option,
                        textAlign: TextAlign.start,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
