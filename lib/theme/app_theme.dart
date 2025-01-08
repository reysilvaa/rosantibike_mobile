import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart'; // Untuk SystemChrome

class AppTheme {
  // Color constants
  static const Color _primaryLight = Color(0xFF2196F3);
  static const Color _primaryDark = Color(0xFF64B5F6);
  static const Color _darkBackground = Color(0xFF010818);
  static const Color _darkSurface = Color(0xFF0A1625);
  static const Color _errorColor = Color(0xFFE57373);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: _primaryLight,
    scaffoldBackgroundColor: Colors.grey[50], // Lighter background
    cardColor: Colors.white, // Pure white cards
    shadowColor: Colors.black,
    dividerColor: Colors.grey[300],

    // Text colors using Poppins font
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.black87,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
        labelLarge: TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
      actionsIconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Icon theme
    iconTheme: const IconThemeData(
      color: Colors.black87,
      size: 24,
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      hintStyle: TextStyle(color: Colors.grey[600]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryLight, width: 2),
      ),
    ),

    // Card theme
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: _primaryLight,
      unselectedItemColor: Colors.grey[600],
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),

    // Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryLight,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: _primaryDark,
    scaffoldBackgroundColor: _darkBackground,
    cardColor: _darkSurface,
    shadowColor: Colors.black,
    dividerColor: Colors.blue.withOpacity(0.1),

    // Text colors using Poppins font
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
        labelLarge: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // AppBar theme
    appBarTheme: AppBarTheme(
      backgroundColor: _darkSurface,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Icon theme
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 24,
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.blue.withOpacity(0.05),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.withOpacity(0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryDark, width: 2),
      ),
    ),

    // Card theme
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _darkSurface,
      selectedItemColor: _primaryDark,
      unselectedItemColor: Colors.white.withOpacity(0.5),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),

    // Floating action button theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _primaryDark,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );

  // Apply system UI updates for status bar and navigation bar
  static void updateSystemUI(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
    );
  }
}
