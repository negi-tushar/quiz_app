import 'package:flutter/material.dart';

class Question {
  final String id;
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String category;
  final String? explanation;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    required this.category,
  });

  // Factory constructor to create a Question object from a JSON map
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      questionText: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswer: json['correctAnswer'] as String,
      explanation: json['explanation'] as String?,
      category: json['category'] as String,
    );
  }
}

// A simple model for each quiz entry
class QuizEntry {
  final String id;
  final String title;
  final String description;
  final String category; // e.g., "General Knowledge", "Science"
  final int numberOfQuestions;
  final int questionTimerSeconds;
  final IconData icon; // Icon to display for this quiz
  final Color? color; // Optional accent color for the card

  QuizEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.numberOfQuestions,
    required this.questionTimerSeconds,
    required this.icon,
    this.color,
  });
}
