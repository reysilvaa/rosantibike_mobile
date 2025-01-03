import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color constants
  static const Color _primaryLight = Color(0xFF2196F3);
  static const Color _primaryDark = Color(0xFF64B5F6);
  static const Color _errorColor = Color(0xFFE57373);

  // New gradient colors
  static const List<Color> _lightGradient = [
    Color(0xFF2196F3),
    Color(0xFF42A5F5),
  ];

  static const List<Color> _darkGradient = [
    Color(0xFF64B5F6),
    Color(0xFF90CAF9),
  ];

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: _primaryLight,
    scaffoldBackgroundColor: Colors.grey[50],
    cardColor: Colors.white,
    shadowColor: Colors.black,
    dividerColor: Colors.grey[300],

    extensions: [
      DetailsCardTheme(
        headerGradient: _lightGradient,
        headerTextColor: Colors.white,
        sectionTitleColor: Colors.grey[700]!,
        iconColor: _primaryLight,
        totalBackgroundColor: _primaryLight.withOpacity(0.1),
        totalTextColor: _primaryLight,
        chipBackgroundColor: Colors.white.withOpacity(0.2),
        chipTextColor: Colors.white,
      ),
    ],

    // Existing text theme
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
    scaffoldBackgroundColor:
        const Color(0xFF121212), // Material dark background
    cardColor: const Color(0xFF1E1E1E), // Slightly lighter than background
    shadowColor: Colors.black,
    dividerColor: Colors.grey[800],

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
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
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
      fillColor: const Color(0xFF2C2C2C),
      hintStyle: TextStyle(color: Colors.grey[400]),
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
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: _primaryDark,
      unselectedItemColor: Colors.grey,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),

    // Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryDark,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );
}

// Custom theme extension for DetailsCard
class DetailsCardTheme extends ThemeExtension<DetailsCardTheme> {
  final List<Color> headerGradient;
  final Color headerTextColor;
  final Color sectionTitleColor;
  final Color iconColor;
  final Color totalBackgroundColor;
  final Color totalTextColor;
  final Color chipBackgroundColor;
  final Color chipTextColor;

  DetailsCardTheme({
    required this.headerGradient,
    required this.headerTextColor,
    required this.sectionTitleColor,
    required this.iconColor,
    required this.totalBackgroundColor,
    required this.totalTextColor,
    required this.chipBackgroundColor,
    required this.chipTextColor,
  });

  @override
  ThemeExtension<DetailsCardTheme> copyWith({
    List<Color>? headerGradient,
    Color? headerTextColor,
    Color? sectionTitleColor,
    Color? iconColor,
    Color? totalBackgroundColor,
    Color? totalTextColor,
    Color? chipBackgroundColor,
    Color? chipTextColor,
  }) {
    return DetailsCardTheme(
      headerGradient: headerGradient ?? this.headerGradient,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      sectionTitleColor: sectionTitleColor ?? this.sectionTitleColor,
      iconColor: iconColor ?? this.iconColor,
      totalBackgroundColor: totalBackgroundColor ?? this.totalBackgroundColor,
      totalTextColor: totalTextColor ?? this.totalTextColor,
      chipBackgroundColor: chipBackgroundColor ?? this.chipBackgroundColor,
      chipTextColor: chipTextColor ?? this.chipTextColor,
    );
  }

  @override
  ThemeExtension<DetailsCardTheme> lerp(
    ThemeExtension<DetailsCardTheme>? other,
    double t,
  ) {
    if (other is! DetailsCardTheme) {
      return this;
    }
    return DetailsCardTheme(
      headerGradient: [
        Color.lerp(headerGradient[0], other.headerGradient[0], t)!,
        Color.lerp(headerGradient[1], other.headerGradient[1], t)!,
      ],
      headerTextColor: Color.lerp(headerTextColor, other.headerTextColor, t)!,
      sectionTitleColor:
          Color.lerp(sectionTitleColor, other.sectionTitleColor, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      totalBackgroundColor:
          Color.lerp(totalBackgroundColor, other.totalBackgroundColor, t)!,
      totalTextColor: Color.lerp(totalTextColor, other.totalTextColor, t)!,
      chipBackgroundColor:
          Color.lerp(chipBackgroundColor, other.chipBackgroundColor, t)!,
      chipTextColor: Color.lerp(chipTextColor, other.chipTextColor, t)!,
    );
  }
}
