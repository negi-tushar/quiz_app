// lib/services/quiz_service.dart
import 'dart:convert';
import 'package:quiz_app/common/quiz_data.dart';
import 'package:quiz_app/model/quiz_model.dart';

class QuizService {
  // A private static list to hold all parsed questions
  static List<Question>? _allQuestions;
  // A private static map to hold questions categorized by their category name
  static Map<String, List<Question>> _categorizedQuestions = {};

  // Initialize and parse questions only once when the app starts
  static Future<void> initializeQuestions() async {
    if (_allQuestions == null) {
      print("QuizService: Initializing questions...");
      try {
        final List<dynamic> jsonList = jsonDecode(quizData); // Decode the raw JSON string
        _allQuestions = jsonList.map((json) => Question.fromJson(json)).toList();

        // Categorize questions into the map
        for (var question in _allQuestions!) {
          if (!_categorizedQuestions.containsKey(question.category)) {
            _categorizedQuestions[question.category] = [];
          }
          _categorizedQuestions[question.category]!.add(question);
        }
        print("QuizService: Questions initialized and categorized. Found ${_allQuestions!.length} questions.");
      } catch (e) {
        print("QuizService ERROR: Failed to parse quiz data: $e");
        // You might want to throw an error or set a flag here
        _allQuestions = []; // Ensure it's not null even on error
        _categorizedQuestions = {};
      }
    } else {
      print("QuizService: Questions already initialized.");
    }
  }

  /// Returns a random list of questions for a given category.
  ///
  /// [categoryName]: The exact name of the category (e.g., "General Knowledge").
  /// [count]: The number of random questions to return. If fewer questions are
  /// available in the category, it returns all available.
  ///
  /// Throws an [Exception] if questions have not been initialized.
  /// Returns an empty list if the category is not found or has no questions.
  static List<Question> getRandomQuestionsByCategory(String categoryName, int count) {
    if (_allQuestions == null) {
      throw Exception("QuizService: Questions not initialized. Call initializeQuestions() first.");
    }

    // Get the list of questions for the specific category
    // We return a copy of the list for category questions to prevent direct modification
    // of the cached categorized list.
    final List<Question> categoryQuestions = List.from(_categorizedQuestions[categoryName] ?? []);

    if (categoryQuestions.isEmpty) {
      print("QuizService: No questions found for category '$categoryName'.");
      return [];
    }

    // Shuffle the list to get random questions
    categoryQuestions.shuffle();

    // Return the specified 'count' of questions, or all if 'count' is too high
    return categoryQuestions.sublist(0, count.clamp(0, categoryQuestions.length));
  }

  /// Returns a list of all available category names.
  /// Throws an [Exception] if questions have not been initialized.
  static List<String> getAvailableCategories() {
    if (_allQuestions == null) {
      throw Exception("QuizService: Questions not initialized. Call initializeQuestions() first.");
    }
    return _categorizedQuestions.keys.toList();
  }

  /// Returns all parsed questions. Use with caution for large datasets.
  static List<Question> getAllQuestions() {
    if (_allQuestions == null) {
      throw Exception("QuizService: Questions not initialized. Call initializeQuestions() first.");
    }
    return List.from(_allQuestions!); // Return a copy
  }
}
