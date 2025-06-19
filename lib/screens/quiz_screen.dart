// lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:quiz_app/common/quiz_data.dart';
import 'package:quiz_app/model/quiz_model.dart';
import 'dart:async'; // For using Timer
import 'dart:convert'; // For JSON decoding
import 'package:quiz_app/screens/result_screen.dart'; // Import ResultScreen

class QuizScreen extends StatefulWidget {
  final int numberOfQuestions; // Number of questions for this quiz session
  final int questionTimerSeconds; // Timer duration for each question

  const QuizScreen({super.key, required this.numberOfQuestions, required this.questionTimerSeconds});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> _questions; // List to hold all quiz questions
  int _currentQuestionIndex = 0; // Index of the current question
  int _score = 0; // User's score
  String? _selectedAnswer; // The answer selected by the user for the current question
  bool _isAnswerLocked = false; // Prevents multiple selections for one question

  Timer? _timer; // Changed to nullable Timer to prevent LateInitializationError
  int _currentTimerSeconds = 0; // Remaining seconds for the current question

  @override
  void initState() {
    super.initState();
    _loadQuestions(); // Load questions when the widget initializes
    _startQuestionTimer(); // Start the timer for the first question
  }

  @override
  void dispose() {
    _timer?.cancel(); // Use null-aware operator to cancel only if _timer is not null
    super.dispose();
  }

  // Decodes the JSON string into a list of Question objects
  void _loadQuestions() {
    final List<dynamic> jsonList = json.decode(quizData); // Use quizData from imported file
    List<Question> allQuestions = jsonList.map((json) => Question.fromJson(json)).toList();
    allQuestions.shuffle(); // Shuffle all available questions
    // Take only the required number of questions for this quiz
    _questions = allQuestions.take(widget.numberOfQuestions).toList();
  }

  // Starts or resets the timer for the current question
  void _startQuestionTimer() {
    _timer?.cancel(); // Use null-aware operator to cancel any existing timer safely
    _currentTimerSeconds = widget.questionTimerSeconds; // Reset timer for new question
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTimerSeconds > 0) {
        setState(() {
          _currentTimerSeconds--; // Decrement timer
        });
      } else {
        // Time ran out
        _timer?.cancel(); // Ensure timer is cancelled even if it just finished naturally
        _handleTimeUp(); // Handle time running out
      }
    });
  }

  // Handles what happens when the timer for a question runs out
  void _handleTimeUp() {
    if (!_isAnswerLocked) {
      // If no answer was selected, mark as incorrect and auto-advance
      setState(() {
        _selectedAnswer = null; // Indicate no answer was chosen
        _isAnswerLocked = true; // Lock answer selection
      });
      Future.delayed(const Duration(seconds: 1), () {
        _nextQuestion();
      });
    }
  }

  // Handles the user selecting an answer
  void _checkAnswer(String selectedAnswer) {
    // Only proceed if an answer hasn't been selected yet for this question and timer hasn't run out
    if (_isAnswerLocked || _currentTimerSeconds == 0) {
      return;
    }

    _timer?.cancel(); // Use null-aware operator to stop the timer safely

    setState(() {
      _selectedAnswer = selectedAnswer; // Store the selected answer
      _isAnswerLocked = true; // Lock further answer selection
      final currentQuestion = _questions[_currentQuestionIndex];
      if (selectedAnswer == currentQuestion.correctAnswer) {
        _score++; // Increment score if correct
      }
    });

    // Automatically move to the next question after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      _nextQuestion();
    });
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
          onRetakeQuiz: () {
            // Navigate back to the home screen to choose a new quiz
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }

  // Helper to determine the color of an option button
  Color _getOptionColor(String option) {
    if (!_isAnswerLocked) {
      // Default color before answer is locked, derived from theme
      return Theme.of(context).colorScheme.surface; // Use surface color for default options
    }
    final currentQuestion = _questions[_currentQuestionIndex];
    if (option == currentQuestion.correctAnswer) {
      return Colors.green.shade300; // Correct answer color
    } else if (option == _selectedAnswer) {
      return Colors.red.shade300; // Incorrect selected answer color
    } else {
      // If answer is locked and this option was not selected and not correct,
      // keep it close to the default theme color for unselected options.
      return Theme.of(context).colorScheme.surface;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure questions are loaded before trying to display them
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Show loading indicator
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return PopScope(
      // Prevents going back using the system back button during a quiz
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Quiz'),
          centerTitle: true,
          automaticallyImplyLeading: false, // Hide back button
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Progress Indicator
                Text(
                  'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground, // Use themed color
                  ),
                ),
                const SizedBox(height: 10),
                // Current Score
                Text(
                  'Score: $_score',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary, // Use themed primary color
                  ),
                ),
                const SizedBox(height: 10),
                // Timer Display
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.7), // Use themed secondary color
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Time: $_currentTimerSeconds s',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary, // Text color on secondary background
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // AnimatedSwitcher for question transition
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500), // Animation duration
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      // Use a slide transition from the right
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(1.0, 0.0), // Start from right
                        end: Offset.zero, // End at current position
                      ).animate(animation);
                      return SlideTransition(position: offsetAnimation, child: child);
                    },
                    child: Card(
                      // Use a Key to make AnimatedSwitcher differentiate between old and new widgets
                      key: ValueKey(currentQuestion.id),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Keep column compact
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              currentQuestion.questionText,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface, // Text color on card surface
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Display options
                            ...currentQuestion.options.map((option) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ElevatedButton(
                                  onPressed: _isAnswerLocked || _currentTimerSeconds == 0
                                      ? null // Disable button if answer is locked or time is up
                                      : () => _checkAnswer(option),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _getOptionColor(option),
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onSurface, // Default text color for options
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                    side: BorderSide(
                                      color: _selectedAnswer == option && _isAnswerLocked
                                          ? (_selectedAnswer == currentQuestion.correctAnswer
                                                ? Colors.green.shade700
                                                : Colors.red.shade700)
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                  child: Text(
                                    option,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      // Ensure option text color contrasts with button background
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            if (_isAnswerLocked) // Show explanation if answer is locked (selected or time out)
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                  currentQuestion.explanation != null && currentQuestion.explanation!.isNotEmpty
                                      ? 'Explanation: ${currentQuestion.explanation}'
                                      : (_selectedAnswer == null && _currentTimerSeconds == 0
                                            ? 'Time\'s up! The correct answer was: ${currentQuestion.correctAnswer}'
                                            : ''),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.7), // Themed grey for explanation
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
