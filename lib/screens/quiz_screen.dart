import 'dart:async';
import 'dart:convert';
import 'dart:ui'; // For ImageFilter.blur

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:quiz_app/common/quiz_data.dart'; // User's specified path
import 'package:quiz_app/model/quiz_model.dart'; // User's specified path
import 'package:quiz_app/screens/result_screen.dart';

class QuizScreen extends StatefulWidget {
  final int numberOfQuestions;
  final int questionTimerSeconds;

  const QuizScreen({super.key, required this.numberOfQuestions, required this.questionTimerSeconds});

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
    final List<dynamic> jsonList = json.decode(quizData);
    List<Question> allQuestions = jsonList.map((json) => Question.fromJson(json)).toList();
    allQuestions.shuffle(); // Shuffle questions for randomness
    _questions = allQuestions.take(widget.numberOfQuestions).toList();
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
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: _score,
          totalQuestions: _questions.length,
          // Pop all routes until the first one (HomeScreen)
          onRetakeQuiz: () => Navigator.of(context).popUntil((route) => route.isFirst),
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
                  ? [Colors.yellow.shade100, Colors.white, Colors.yellow.shade50] // Light gradient
                  : [Colors.grey.shade900, Colors.black, Colors.grey.shade800], // Dark gradient
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40), // Top padding for status bar/safe area
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
              const SizedBox(height: 10),
              // Custom Header: App Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft, // Align title to left
                  child: Text(
                    'Flutter Quiz',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                      fontSize: 30, // Larger title
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Header Stats Section: Question, Score, Timer
              _buildHeaderStats(theme, colorScheme, textTheme),
              const SizedBox(height: 20),
              Expanded(
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
                  child: _buildQuestionContainer(currentQuestion, textTheme, colorScheme),
                  // The key is essential for AnimatedSwitcher to recognize a content change
                  key: ValueKey(currentQuestion.id),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(18),
        // decoration: BoxDecoration(
        //   // Frosted glass effect for the header container
        //   color: colorScheme.surface.withOpacity(0.25),
        //   borderRadius: BorderRadius.circular(25),
        //   border: Border.all(color: colorScheme.surface.withOpacity(0.3)),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black.withOpacity(0.08),
        //       spreadRadius: 1,
        //       blurRadius: 10,/
        //       offset: const Offset(0, 4),
        //     ),
        //   ],
        // ),
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
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  // Helper widget for the main question and options container
  Widget _buildQuestionContainer(Question question, TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(28), // Increased padding
      decoration: BoxDecoration(
        // Modern gradient for the question container
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surface.withOpacity(0.15), // Very subtle transparent base
            colorScheme.surface.withOpacity(0.05), // More transparent end
          ],
        ),
        borderRadius: BorderRadius.circular(30), // More rounded corners
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
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Frosted glass effect
        child: SingleChildScrollView(
          // Allows content to scroll if it overflows
          child: Column(
            mainAxisSize: MainAxisSize.min, // Keep column compact
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                question.questionText,
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  fontSize: 24, // Slightly larger question text
                  shadows: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(1, 1)),
                  ],
                ),
              ),
              const SizedBox(height: 35), // Increased spacing after question
              // Display options as custom-styled interactive containers
              ...question.options
                  .map(
                    (option) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8), // Adjusted vertical padding
                      child: Material(
                        // Provides Material Design visual responses (splash, highlight)
                        color: _getOptionContainerColor(option, colorScheme), // Background color
                        borderRadius: BorderRadius.circular(18), // Match inner container/InkWell
                        elevation: 4, // Subtle elevation for the button effect
                        shadowColor: Colors.black.withOpacity(0.2), // Shadow for the button effect
                        child: InkWell(
                          onTap: _isAnswerLocked || _currentTimerSeconds == 0
                              ? null // Disable tap if answer is locked or time is up
                              : () => _checkAnswer(option),
                          borderRadius: BorderRadius.circular(18), // Match Material's border radius
                          splashColor: colorScheme.primary.withOpacity(0.3), // Splash effect color
                          highlightColor: Colors.transparent, // Avoid default highlight color
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 10,
                            ), // Padding for text inside
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: _selectedAnswer == option && _isAnswerLocked
                                    ? (_selectedAnswer == question.correctAnswer
                                          ? Colors.green.shade700
                                          : Colors.red.shade700)
                                    : colorScheme.surface.withOpacity(0.4), // Default border for options
                                width: _selectedAnswer == option && _isAnswerLocked
                                    ? 3
                                    : 1.0, // Thicker border on selected/feedback
                              ),
                            ),
                            child: Text(
                              option,
                              textAlign: TextAlign.center,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              const SizedBox(height: 25), // Spacing before explanation
              // Explanation text shown only when an answer is locked
              if (_isAnswerLocked)
                Text(
                  _selectedAnswer == null && _currentTimerSeconds == 0
                      ? 'Time\'s up! The correct answer was: ${question.correctAnswer}'
                      : (question.explanation?.isNotEmpty == true ? 'Explanation: ${question.explanation}' : ''),
                  style: textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: colorScheme.onSurface.withOpacity(0.8),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
