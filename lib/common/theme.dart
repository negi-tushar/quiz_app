import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    fontFamily: "Poppins",

    primarySwatch: Colors.yellow,
    primaryColor: Colors.yellow.shade700,

    scaffoldBackgroundColor: Colors.white,

    cardColor: Colors.grey.shade50,

    appBarTheme: AppBarTheme(
      color: Colors.yellow.shade600,
      foregroundColor: Colors.black87,
      elevation: 4,
      titleTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(color: Colors.yellow.shade900),
      displayMedium: TextStyle(color: Colors.yellow.shade900),
      displaySmall: TextStyle(color: Colors.yellow.shade900),
      headlineMedium: const TextStyle(color: Colors.black87),
      headlineSmall: const TextStyle(color: Colors.black87),
      titleLarge: const TextStyle(color: Colors.black87),
      bodyLarge: const TextStyle(color: Colors.black87),
      bodyMedium: const TextStyle(color: Colors.black87),
      labelLarge: const TextStyle(color: Colors.white),
    ).apply(bodyColor: Colors.black87, displayColor: Colors.black87),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow.shade700,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.yellow.shade700,
        side: BorderSide(color: Colors.yellow.shade700, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      color: Colors.white,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.yellow.shade700, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.grey),
      hintStyle: const TextStyle(color: Colors.grey),
    ),

    iconTheme: const IconThemeData(color: Colors.black87),

    colorScheme: ColorScheme.light(
      primary: Colors.yellow.shade700,
      onPrimary: Colors.black87,
      secondary: Colors.yellow.shade400,
      onSecondary: Colors.black87,
      surface: Colors.white,
      onSurface: Colors.black87,
      background: Colors.white,
      onBackground: Colors.black87,
      error: Colors.red.shade700,
      onError: Colors.white,
    ),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    fontFamily: "Poppins",

    primarySwatch: Colors.yellow,
    primaryColor: Colors.yellow.shade400,

    scaffoldBackgroundColor: const Color(0xFF1E1E1E),

    cardColor: const Color(0xFF2C2C2C),

    appBarTheme: AppBarTheme(
      color: const Color(0xFF2C2C2C),
      foregroundColor: Colors.yellow.shade400,
      elevation: 4,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.yellow.shade400,
      ),
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(color: Colors.yellow.shade400),
      displayMedium: TextStyle(color: Colors.yellow.shade400),
      displaySmall: TextStyle(color: Colors.yellow.shade400),
      headlineMedium: const TextStyle(color: Colors.white70),
      headlineSmall: const TextStyle(color: Colors.white70),
      titleLarge: const TextStyle(color: Colors.white70),
      bodyLarge: const TextStyle(color: Colors.white70),
      bodyMedium: const TextStyle(color: Colors.white70),
      labelLarge: const TextStyle(color: Colors.white),
    ).apply(bodyColor: Colors.white70, displayColor: Colors.white70),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow.shade400,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.yellow.shade400,
        side: BorderSide(color: Colors.yellow.shade400, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      color: const Color(0xFF2C2C2C),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF3A3A3A),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.yellow.shade400, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white54),
    ),

    iconTheme: const IconThemeData(color: Colors.white70),

    colorScheme: ColorScheme.dark(
      primary: Colors.yellow.shade400,
      onPrimary: Colors.black87,
      secondary: Colors.yellow.shade700,
      onSecondary: Colors.black87,
      surface: const Color(0xFF2C2C2C),
      onSurface: Colors.white70,
      background: const Color(0xFF1E1E1E),
      onBackground: Colors.white70,
      error: Colors.red.shade400,
      onError: Colors.black,
    ),
  );
}
