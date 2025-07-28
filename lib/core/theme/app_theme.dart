import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    // Core colors and Background
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color(0xFFB91C1C),
    brightness: Brightness.light,
    fontFamily: 'Poppins',

    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFB91C1C),
      secondary: Colors.orange,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black87,
      error: Colors.red,
      onError: Colors.white,
    ),

    appBarTheme: AppBarTheme(
      color: Color(0xFFB91C1C),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 4,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFB91C1C),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(50),
        ),
      ),
    ),

    // Text Theme (Typography)
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 96.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 60.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        fontSize: 48.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineLarge: TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontSize: 34.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineSmall: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      titleMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      titleSmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black87),
      bodySmall: TextStyle(fontSize: 12.0, color: Colors.black54),
      labelLarge: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      labelMedium: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      labelSmall: TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
    ),

    // InputDecoration Theme (for TextField/TextFormField)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100], // Background color for input fields
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none, // No border by default
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Color(0xFFB91C1C),
          width: 2.0,
        ), // Focused border color
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.grey[300]!,
          width: 1.0,
        ), // Enabled border color
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2.0,
        ), // Error border color
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2.0,
        ), // Focused error border color
      ),
      labelStyle: const TextStyle(color: Colors.black54),
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 2, // Shadow for cards
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners for cards
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: Colors.black87, // Default icon color
      size: 24,
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners for dialogs
      ),
      backgroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      contentTextStyle: const TextStyle(fontSize: 16, color: Colors.black87),
    ),
  );
}
