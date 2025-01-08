import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themePreferenceKey = 'theme_mode';

  late ThemeMode _themeMode;
  bool _isSystemTheme = true;

  ThemeProvider() {
    _loadThemePreference();
  }

  // Getter untuk mendapatkan ThemeMode saat ini
  ThemeMode get themeMode => _themeMode;

  // Getter untuk mengecek apakah menggunakan system theme
  bool get isSystemTheme => _isSystemTheme;

  // Getter untuk mengecek apakah dark mode aktif
  bool get isDarkMode {
    if (_isSystemTheme) {
      // Jika menggunakan system theme, cek system brightness
      final window = WidgetsBinding.instance.window;
      return window.platformBrightness == Brightness.dark;
    }
    // Jika manual theme, cek _themeMode
    return _themeMode == ThemeMode.dark;
  }

  // Method untuk toggle theme
  void toggleTheme() {
    _isSystemTheme = false;
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    _saveThemePreference();
    notifyListeners();
  }

  // Method untuk set theme mode spesifik
  void setThemeMode(ThemeMode mode) {
    _isSystemTheme = false;
    _themeMode = mode;
    _saveThemePreference();
    notifyListeners();
  }

  // Method untuk kembali ke system theme
  void useSystemTheme() {
    _isSystemTheme = true;
    _themeMode = ThemeMode.system;
    _saveThemePreference();
    notifyListeners();
  }

  // Load theme preference dari SharedPreferences
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString(_themePreferenceKey);
    _isSystemTheme = savedThemeMode == null || savedThemeMode == 'system';

    if (savedThemeMode == 'light') {
      _themeMode = ThemeMode.light;
    } else if (savedThemeMode == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  // Save theme preference ke SharedPreferences
  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    String themeValue;

    if (_isSystemTheme) {
      themeValue = 'system';
    } else {
      themeValue = _themeMode == ThemeMode.light ? 'light' : 'dark';
    }

    await prefs.setString(_themePreferenceKey, themeValue);
  }
}
