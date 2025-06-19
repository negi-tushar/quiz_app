import 'package:flutter/material.dart';

// Light Theme Configuration
ThemeData lightTheme() {
  return ThemeData(
    // Primary color for the app, used for AppBar, etc.
    primarySwatch: Colors.yellow, // This creates a range of yellow shades
    primaryColor: Colors.yellow.shade700, // A slightly darker yellow for primary elements
    // Background color for the scaffold (main screen background)
    scaffoldBackgroundColor: Colors.white,

    // Color for Card widgets
    cardColor: Colors.grey.shade50, // Very light grey for cards, close to white
    // AppBar theme
    appBarTheme: AppBarTheme(
      color: Colors.yellow.shade600, // Yellow AppBar
      foregroundColor: Colors.black87, // Dark text/icons on AppBar
      elevation: 4, // Shadow beneath AppBar
      titleTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),

    // Text theme for various text styles
    textTheme:
        TextTheme(
          displayLarge: TextStyle(color: Colors.yellow.shade900),
          displayMedium: TextStyle(color: Colors.yellow.shade900),
          displaySmall: TextStyle(color: Colors.yellow.shade900),
          headlineMedium: const TextStyle(color: Colors.black87),
          headlineSmall: const TextStyle(color: Colors.black87),
          titleLarge: const TextStyle(color: Colors.black87),
          bodyLarge: const TextStyle(color: Colors.black87),
          bodyMedium: const TextStyle(color: Colors.black87),
          labelLarge: const TextStyle(color: Colors.white), // Button text color default
        ).apply(
          // Default text color for the entire app body
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow.shade700, // Yellow background for elevated buttons
        foregroundColor: Colors.black, // Dark text on yellow buttons
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
    ),

    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.yellow.shade700, // Yellow text/border for outlined buttons
        side: BorderSide(color: Colors.yellow.shade700, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // Card theme
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      color: Colors.white, // Ensure cards are explicitly white for contrast
    ),

    // Input field theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100, // Light background for input fields
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.yellow.shade700, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.grey),
      hintStyle: const TextStyle(color: Colors.grey),
    ),

    // Icon theme
    iconTheme: const IconThemeData(color: Colors.black87),

    // Color scheme for various UI elements
    colorScheme: ColorScheme.light(
      primary: Colors.yellow.shade700,
      onPrimary: Colors.black87,
      secondary: Colors.yellow.shade400, // Lighter yellow for secondary accents
      onSecondary: Colors.black87,
      surface: Colors.white, // Background for cards, dialogs, etc.
      onSurface: Colors.black87,
      background: Colors.white, // Main background
      onBackground: Colors.black87,
      error: Colors.red.shade700,
      onError: Colors.white,
    ),
  );
}

// Dark Theme Configuration
ThemeData darkTheme() {
  return ThemeData(
    // Primary color for the app in dark mode
    primarySwatch: Colors.yellow,
    primaryColor: Colors.yellow.shade400, // Lighter yellow for visibility on dark background
    // Background color for the scaffold
    scaffoldBackgroundColor: const Color(0xFF1E1E1E), // A light black/very dark grey
    // Color for Card widgets
    cardColor: const Color(0xFF2C2C2C), // Slightly lighter than background for cards
    // AppBar theme
    appBarTheme: AppBarTheme(
      color: const Color(0xFF2C2C2C), // Dark grey AppBar
      foregroundColor: Colors.yellow.shade400, // Yellow text/icons on AppBar
      elevation: 4,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.yellow.shade400,
      ),
    ),

    // Text theme for various text styles
    textTheme:
        TextTheme(
          displayLarge: TextStyle(color: Colors.yellow.shade400),
          displayMedium: TextStyle(color: Colors.yellow.shade400),
          displaySmall: TextStyle(color: Colors.yellow.shade400),
          headlineMedium: const TextStyle(color: Colors.white70), // Corrected: Directly setting TextStyle
          headlineSmall: const TextStyle(color: Colors.white70), // Corrected: Directly setting TextStyle
          titleLarge: const TextStyle(color: Colors.white70), // Corrected: Directly setting TextStyle
          bodyLarge: const TextStyle(color: Colors.white70), // Corrected: Directly setting TextStyle
          bodyMedium: const TextStyle(color: Colors.white70), // Corrected: Directly setting TextStyle
          labelLarge: const TextStyle(color: Colors.white), // Corrected: Directly setting TextStyle for general labels
        ).apply(
          // Default text color for the entire app body
          bodyColor: Colors.white70,
          displayColor: Colors.white70,
        ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow.shade400, // Yellow background for elevated buttons
        foregroundColor: Colors.black, // Dark text on yellow buttons
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
    ),

    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.yellow.shade400, // Yellow text/border for outlined buttons
        side: BorderSide(color: Colors.yellow.shade400, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // Card theme
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      color: const Color(0xFF2C2C2C), // Dark grey for cards
    ),

    // Input field theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF3A3A3A), // Darker background for input fields
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.yellow.shade400, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white54),
    ),

    // Icon theme
    iconTheme: const IconThemeData(color: Colors.white70),

    // Color scheme for various UI elements
    colorScheme: ColorScheme.dark(
      primary: Colors.yellow.shade400,
      onPrimary: Colors.black87,
      secondary: Colors.yellow.shade700, // Slightly darker yellow for secondary accents
      onSecondary: Colors.black87,
      surface: const Color(0xFF2C2C2C), // Background for cards, dialogs, etc.
      onSurface: Colors.white70,
      background: const Color(0xFF1E1E1E), // Main background
      onBackground: Colors.white70,
      error: Colors.red.shade400,
      onError: Colors.black,
    ),
  );
}
