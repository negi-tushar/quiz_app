// lib/data/all_quizzes_data.dart
import 'package:flutter/material.dart';
import 'package:quiz_app/model/quiz_model.dart';

// List of all available quizzes to browse
final List<QuizEntry> allQuizzes = [
  QuizEntry(
    id: 'gko1',
    title: 'General Knowledge Express',
    description: 'Quick questions to test your general awareness.',
    category: 'General Knowledge',
    numberOfQuestions: 10,
    questionTimerSeconds: 10,
    icon: Icons.lightbulb_outline_rounded,
    color: Colors.blue.shade300,
  ),
  QuizEntry(
    id: 'scl1',
    title: 'Science Explorer',
    description: 'Explore the wonders of physics, chemistry, and biology.',
    category: 'Science & Nature',
    numberOfQuestions: 15,
    questionTimerSeconds: 15,
    icon: Icons.science_rounded,
    color: Colors.green.shade300,
  ),
  QuizEntry(
    id: 'hisl1',
    title: 'History Unveiled',
    description: 'Journey through time with historical facts and events.',
    category: 'History',
    numberOfQuestions: 12,
    questionTimerSeconds: 18,
    icon: Icons.history_rounded,
    color: Colors.purple.shade300,
  ),
  QuizEntry(
    id: 'spt1',
    title: 'Sports Fanatic',
    description: 'A challenge for every sports enthusiast!',
    category: 'Sports',
    numberOfQuestions: 10,
    questionTimerSeconds: 10,
    icon: Icons.sports_soccer_rounded,
    color: Colors.orange.shade300,
  ),
  QuizEntry(
    id: 'artl1',
    title: 'Art & Lit Genius',
    description: 'Test your knowledge on art, literature, and culture.',
    category: 'Art & Literature',
    numberOfQuestions: 15,
    questionTimerSeconds: 20,
    icon: Icons.palette_rounded,
    color: Colors.teal.shade300,
  ),
  QuizEntry(
    id: 'geo1',
    title: 'World Geography',
    description: 'How well do you know the world around you?',
    category: 'Geography',
    numberOfQuestions: 10,
    questionTimerSeconds: 12,
    icon: Icons.map_rounded,
    color: Colors.red.shade300,
  ),
  QuizEntry(
    id: 'fmtv1',
    title: 'Film & TV Buff',
    description: 'From classic movies to modern series, how much do you know?',
    category: 'Film & TV',
    numberOfQuestions: 10,
    questionTimerSeconds: 15,
    icon: Icons.movie_rounded,
    color: Colors.cyan.shade300,
  ),
  QuizEntry(
    id: 'mus1',
    title: 'Music Maestro',
    description: 'Identify artists, genres, and famous songs.',
    category: 'Music',
    numberOfQuestions: 10,
    questionTimerSeconds: 10,
    icon: Icons.music_note_rounded,
    color: Colors.indigo.shade300,
  ),
  QuizEntry(
    id: 'inhis1',
    title: 'Indian History Deep Dive',
    description: 'Explore the rich and diverse history of India.',
    category: 'Indian History',
    numberOfQuestions: 15,
    questionTimerSeconds: 20,
    icon: Icons.account_balance_rounded,
    color: Colors.pink.shade300,
  ),
  QuizEntry(
    id: 'incult1',
    title: 'Indian Culture & Heritage',
    description: 'From traditions to festivals, test your cultural IQ.',
    category: 'Indian Culture',
    numberOfQuestions: 12,
    questionTimerSeconds: 18,
    icon: Icons.diversity_3_rounded,
    color: Colors.lime.shade300,
  ),
  QuizEntry(
    id: 'utk1',
    title: 'Uttarakhand Lore',
    description: 'Discover facts about the Devbhumi, Uttarakhand.',
    category: 'Uttarakhand',
    numberOfQuestions: 10,
    questionTimerSeconds: 15,
    icon: Icons.landscape_rounded,
    color: Colors.brown.shade300,
  ),
  // --- NEW CATEGORIES AND QUIZZES ---
  QuizEntry(
    id: 'prog1',
    title: 'Basic Programming',
    description: 'Fundamental concepts of coding and logic.',
    category: 'Programming',
    numberOfQuestions: 10,
    questionTimerSeconds: 15,
    icon: Icons.code_rounded,
    color: Colors.blueAccent.shade200,
  ),
  QuizEntry(
    id: 'comp1',
    title: 'Computer Knowledge',
    description: 'Hardware, software, and internet basics.',
    category: 'Computer Science',
    numberOfQuestions: 12,
    questionTimerSeconds: 18,
    icon: Icons.computer_rounded,
    color: Colors.deepPurple.shade300,
  ),
];
