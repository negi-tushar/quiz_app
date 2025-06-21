import 'package:flutter/material.dart';

ThemeData lightTheme() {
  const Color primaryYellow = Color.fromARGB(255, 238, 197, 63);
  const Color lightYellow = Color(0xFFFFF9C4);
  const Color darkText = Color(0xFF212121);
  const Color lightSurface = Color(0xFFF5F5F5);

  return ThemeData(
    fontFamily: "Poppins",

    primarySwatch: MaterialColor(primaryYellow.value, const <int, Color>{
      50: Color(0xFFFFFDE7),
      100: Color(0xFFFFF9C4),
      200: Color(0xFFFFF59D),
      300: Color(0xFFFFF176),
      400: Color(0xFFFFEE58),
      500: primaryYellow,
      600: Color(0xFFFDD835),
      700: Color(0xFFFBC02D),
      800: Color(0xFFF9A825),
      900: Color(0xFFF57F17),
    }),
    primaryColor: primaryYellow,

    scaffoldBackgroundColor: lightYellow,

    cardColor: lightSurface,

    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(fontFamily: 'Poppins', fontSize: 26, fontWeight: FontWeight.bold, color: darkText),
      iconTheme: IconThemeData(color: darkText),
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(color: primaryYellow, fontSize: 57, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: primaryYellow, fontSize: 45, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: primaryYellow, fontSize: 36, fontWeight: FontWeight.bold),

      headlineMedium: TextStyle(color: darkText, fontSize: 28, fontWeight: FontWeight.w700),
      headlineSmall: TextStyle(color: darkText, fontSize: 24, fontWeight: FontWeight.w700),

      titleLarge: TextStyle(color: darkText, fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: darkText, fontSize: 18, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: darkText, fontSize: 16, fontWeight: FontWeight.w500),

      bodyLarge: TextStyle(color: darkText, fontSize: 16),
      bodyMedium: TextStyle(color: darkText, fontSize: 14),
      bodySmall: TextStyle(color: Colors.grey.shade600, fontSize: 12),

      labelLarge: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(color: Colors.grey.shade700, fontSize: 12),
      labelSmall: TextStyle(color: Colors.grey.shade500, fontSize: 10),
    ).apply(bodyColor: darkText, displayColor: darkText),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryYellow,
        foregroundColor: darkText,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
        shadowColor: primaryYellow.withOpacity(0.4),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryYellow,
        side: BorderSide(color: primaryYellow, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),

    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      color: lightSurface,
      shadowColor: Colors.black.withOpacity(0.15),
      surfaceTintColor: Colors.transparent,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryYellow, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.grey.shade600),
      hintStyle: TextStyle(color: Colors.grey.shade400),
    ),

    iconTheme: const IconThemeData(color: darkText),

    colorScheme: ColorScheme.light(
      primary: primaryYellow,
      onPrimary: darkText,
      secondary: const Color(0xFF4CAF50),
      onSecondary: Colors.white,
      tertiary: const Color(0xFF2196F3),
      onTertiary: Colors.white,
      surface: lightSurface,
      onSurface: darkText,
      background: lightYellow,
      onBackground: darkText,
      error: Colors.red.shade700,
      onError: Colors.white,
      shadow: Colors.black.withOpacity(0.1),
      surfaceContainerHighest: lightYellow,
      surfaceContainerHigh: Colors.white,
      surfaceContainer: Colors.grey.shade50,
      onSurfaceVariant: Colors.grey.shade700,
    ),
  );
}

ThemeData darkTheme() {
  const Color darkBackground = Color(0xFF1A1A1A);
  const Color darkSurface = Color(0xFF2A2A2A);
  const Color lightAccentYellow = Color(0xFFFFEB3B);
  const Color lightText = Color(0xFFE0E0E0);

  return ThemeData(
    fontFamily: "Poppins",

    primarySwatch: MaterialColor(lightAccentYellow.value, const <int, Color>{
      50: Color(0xFFFFFDE7),
      100: Color(0xFFFFF9C4),
      200: Color(0xFFFFF59D),
      300: Color(0xFFFFF176),
      400: lightAccentYellow,
      500: Color(0xFFFDD835),
      600: Color(0xFFFBC02D),
      700: Color(0xFFF9A825),
      800: Color(0xFFF57F17),
      900: Color(0xFFFDD835),
    }),
    primaryColor: lightAccentYellow,

    scaffoldBackgroundColor: darkBackground,

    cardColor: darkSurface,

    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: lightAccentYellow,
      ),
      iconTheme: IconThemeData(color: lightAccentYellow),
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(color: lightAccentYellow, fontSize: 57, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: lightAccentYellow, fontSize: 45, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: lightAccentYellow, fontSize: 36, fontWeight: FontWeight.bold),

      headlineMedium: TextStyle(color: lightText, fontSize: 28, fontWeight: FontWeight.w700),
      headlineSmall: TextStyle(color: lightText, fontSize: 24, fontWeight: FontWeight.w700),

      titleLarge: TextStyle(color: lightText, fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: lightText, fontSize: 18, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: lightText, fontSize: 16, fontWeight: FontWeight.w500),

      bodyLarge: TextStyle(color: lightText, fontSize: 16),
      bodyMedium: TextStyle(color: lightText, fontSize: 14),
      bodySmall: TextStyle(color: Colors.grey.shade400, fontSize: 12),

      labelLarge: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(color: Colors.grey.shade400, fontSize: 12),
      labelSmall: TextStyle(color: Colors.grey.shade600, fontSize: 10),
    ).apply(bodyColor: lightText, displayColor: lightText),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightAccentYellow,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
        shadowColor: lightAccentYellow.withOpacity(0.4),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightAccentYellow,
        side: BorderSide(color: lightAccentYellow, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),

    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      color: darkSurface,
      shadowColor: Colors.black.withOpacity(0.3),
      surfaceTintColor: Colors.transparent,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF3A3A3A),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: lightAccentYellow, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.grey.shade500),
      hintStyle: TextStyle(color: Colors.grey.shade600),
    ),

    iconTheme: const IconThemeData(color: lightText),

    colorScheme: ColorScheme.dark(
      primary: lightAccentYellow,
      onPrimary: Colors.black,
      secondary: const Color(0xFF66BB6A),
      onSecondary: Colors.black,
      tertiary: const Color(0xFF42A5F5),
      onTertiary: Colors.black,
      surface: darkSurface,
      onSurface: lightText,
      background: darkBackground,
      onBackground: lightText,
      error: Colors.red.shade400,
      onError: Colors.black,
      shadow: Colors.black.withOpacity(0.3),
      surfaceContainerHighest: darkBackground,
      surfaceContainerHigh: darkSurface,
      surfaceContainer: const Color(0xFF3A3A3A),
      onSurfaceVariant: Colors.grey.shade400,
    ),
  );
}
