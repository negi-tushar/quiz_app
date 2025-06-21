import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:quiz_app/model/quiz_model.dart'; // Your Question model
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/service/quiz_service.dart'; // Assuming QuizService provides question data

class QuizScreen extends StatefulWidget {
  final int numberOfQuestions;
  final int questionTimerSeconds;
  final String? category; // Optional category to filter questions
  final String quizType; // Added: e.g., "Fast Quiz", "Daily Challenge", "General Knowledge Express"

  const QuizScreen({
    super.key,
    required this.numberOfQuestions,
    required this.questionTimerSeconds,
    this.category,
    this.quizType = 'General Quiz', // Default value
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0; // This variable now holds the OPTIMIZED SCORE
  String? _selectedAnswer;
  bool _isAnswerLocked = false;

  Timer? _timer;
  int _currentTimerSeconds = 0;
  // bool _isDataLoaded = false; // Removed as its functionality is covered by _questions.isEmpty check

  final int _basePointsPerCorrectAnswer = 1; // Define base points for a correct answer

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

  void _loadQuestions() {
    List<Question> allAvailableQuestions = QuizService.getAllQuestions();

    // Filter questions by category if a category is provided
    if (widget.category != null && widget.category!.isNotEmpty && widget.category != 'Daily Challenge') {
      allAvailableQuestions = allAvailableQuestions.where((q) => q.category == widget.category).toList();
      // Fallback: If no questions found for a specific category, use general questions.
      if (allAvailableQuestions.isEmpty) {
        debugPrint('No questions found for category: ${widget.category}. Using all questions.');
        allAvailableQuestions = QuizService.getAllQuestions();
      }
    }
    // Note: If widget.category is 'Daily Challenge', it's implied that QuizService
    // or your data source provides unique daily challenge questions.
    // For now, it will just pick random questions from the available pool.

    allAvailableQuestions.shuffle(); // Shuffle for randomness

    // Take only the required number of questions, clamping to available count
    _questions = allAvailableQuestions.take(widget.numberOfQuestions).toList();

    // Final fallback if no questions were loaded at all (e.g., quizData is empty)
    if (_questions.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error: No quiz questions could be loaded. Please try again.')));
        Navigator.of(context).pop(); // Go back to the previous screen (Home)
      });
      return; // Exit without setting state if no questions
    }

    // Initialize state ONLY if questions were successfully loaded
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0; // Ensure optimized score is reset on quiz start
    });
  }

  void _startQuestionTimer() {
    _timer?.cancel();
    _currentTimerSeconds = widget.questionTimerSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTimerSeconds > 0) {
        setState(() => _currentTimerSeconds--);
      } else {
        _timer?.cancel();
        _handleTimeUp(); // Time ran out
      }
    });
  }

  void _handleTimeUp() {
    if (!_isAnswerLocked) {
      setState(() {
        _selectedAnswer = null; // No answer selected
        _isAnswerLocked = true; // Lock interaction
        // Score remains unchanged for timed-out/incorrect answers
      });
      Future.delayed(const Duration(seconds: 2), _nextQuestion); // Auto-advance
    }
  }

  void _checkAnswer(String selectedAnswer) {
    if (_isAnswerLocked || _currentTimerSeconds == 0) return;

    HapticFeedback.selectionClick();
    _timer?.cancel();

    setState(() {
      _selectedAnswer = selectedAnswer;
      _isAnswerLocked = true;
      final currentQuestion = _questions[_currentQuestionIndex];

      if (selectedAnswer == currentQuestion.correctAnswer) {
        // Calculate optimized score for this correct answer
        // Score = Base points + (Remaining Time for Question)
        int timeBonus = _currentTimerSeconds;
        _score += _basePointsPerCorrectAnswer + timeBonus;
      }
      // If incorrect, _score remains unchanged for this question.
    });

    Future.delayed(const Duration(seconds: 2), _nextQuestion); // Auto-advance
  }

  void _nextQuestion() {
    setState(() {
      _selectedAnswer = null;
      _isAnswerLocked = false;
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _startQuestionTimer();
      } else {
        _showResultScreen(); // End of quiz
      }
    });
  }

  void _showResultScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => ResultScreen(
          score: _score, // Pass the calculated OPTIMIZED SCORE
          totalQuestions: _questions.length, // Total questions in this quiz instance
          quizType: widget.quizType, // Pass the quiz type (e.g., 'Fast Quiz')
          category: widget.category, // Pass the specific category (e.g., 'General Knowledge')
          onRetakeQuiz: () {
            Navigator.popUntil(ctx, (route) => route.isFirst); // Go back to Home
          },
          onReviewAnswers: () {
            ScaffoldMessenger.of(
              ctx,
            ).showSnackBar(const SnackBar(content: Text('Review answers functionality coming soon!')));
          },
        ),
      ),
    );
  }

  Color _getOptionContainerColor(String option, ColorScheme colorScheme) {
    if (!_isAnswerLocked) {
      return colorScheme.surface.withOpacity(0.15);
    }
    final currentQuestion = _questions[_currentQuestionIndex];
    if (option == currentQuestion.correctAnswer) {
      return Colors.green.shade300.withOpacity(0.8);
    }
    if (option == _selectedAnswer) {
      return Colors.red.shade300.withOpacity(0.8);
    }
    return colorScheme.surface.withOpacity(0.05);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Quit Quiz?'),
            content: const Text('Are you sure you want to exit the current quiz? Your progress will be lost.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No', style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () {
                  _timer?.cancel();
                  Navigator.of(context).pop(true); // Pop the dialog
                  Navigator.of(context).popUntil((route) => route.isFirst); // Go back to Home
                },
                child: const Text('Yes', style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    if (_questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(colorScheme.primary)),
              const SizedBox(height: 20),
              Text('Loading Quiz...', style: textTheme.titleMedium?.copyWith(color: colorScheme.onBackground)),
            ],
          ),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        _onWillPop(); // Call dialog for confirmation
      },
      child: Scaffold(
        body: Container(
          color: theme.brightness == Brightness.light ? Colors.white : Colors.black38,

          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 70),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _currentTimerSeconds / widget.questionTimerSeconds,
                        minHeight: 8,
                        backgroundColor: colorScheme.surface.withOpacity(0.3),
                        color: colorScheme.secondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  _buildHeaderStats(theme, colorScheme, textTheme),
                  const SizedBox(height: 10),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        final offsetAnimation = Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
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
                      key: ValueKey(currentQuestion.id),
                      child: _buildQuestionContainer(currentQuestion, textTheme, colorScheme),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
              Positioned(
                top: 40 + MediaQuery.of(context).padding.top,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.close_rounded, size: 30, color: colorScheme.onBackground.withOpacity(0.7)),
                  onPressed: () async {
                    _onWillPop();
                  },
                ),
              ),
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
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.25),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: colorScheme.surface.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Question', '${_currentQuestionIndex + 1}/${_questions.length}', textTheme, colorScheme),
            _buildStatItem('Score', '$_score', textTheme, colorScheme), // Displays optimized score
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.secondary.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                '${_currentTimerSeconds}s',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSecondary,
                  fontSize: 20,
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.surface.withOpacity(0.15), colorScheme.surface.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 10)),
        ],
        border: Border.all(color: colorScheme.surface.withOpacity(0.4), width: 1.5),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question.questionText,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                fontSize: 18,
                shadows: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(1, 1))],
              ),
            ),
            const SizedBox(height: 35),
            ...question.options.map(
              (option) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Material(
                  color: _getOptionContainerColor(option, colorScheme),
                  borderRadius: BorderRadius.circular(18),
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.2),
                  child: InkWell(
                    onTap: _isAnswerLocked || _currentTimerSeconds == 0 ? null : () => _checkAnswer(option),
                    borderRadius: BorderRadius.circular(18),
                    splashColor: colorScheme.primary.withOpacity(0.3),
                    highlightColor: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: _selectedAnswer == option && _isAnswerLocked
                              ? (_selectedAnswer == _questions[_currentQuestionIndex].correctAnswer
                                    ? Colors.green.shade700
                                    : Colors.red.shade700)
                              : colorScheme.surface.withOpacity(0.4),
                          width: _selectedAnswer == option && _isAnswerLocked ? 3 : 1.0,
                        ),
                      ),
                      child: Text(
                        option,
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            // if (_isAnswerLocked)
            //   Text(
            //     _selectedAnswer == null && _currentTimerSeconds == 0
            //         ? 'Time\'s up! The correct answer was: ${question.correctAnswer}'
            //         : (question.explanation?.isNotEmpty == true ? 'Explanation: ${question.explanation}' : ''),
            //     style: textTheme.bodyLarge?.copyWith(
            //       fontStyle: FontStyle.italic,
            //       color: colorScheme.onSurface.withOpacity(0.8),
            //       fontSize: 16,
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
          ],
        ),
      ),
    );
  }
}
