import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosantibike_mobile/theme/theme_provider.dart';

class StatCard extends StatelessWidget {
  final String statType;
  final String value;
  final String percentage;
  final bool isIncreasing;
  final VoidCallback onTap;

  const StatCard({
    Key? key,
    required this.statType,
    required this.value,
    required this.percentage,
    required this.isIncreasing,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final Map<String, Map<String, dynamic>> statTypeStyles = {
      'TotalMenus': {
        'backgroundColor': Colors.black,
        'textColor': Colors.white,
        'progressBarColor': Colors.blue,
      },
      'revenue': {
        'backgroundColor': isDark ? Colors.grey[800] : Colors.grey[200],
        'textColor': isDark ? Colors.white : Colors.black,
        'progressBarColor': Colors.red,
      },
      'totalOrders': {
        'backgroundColor': isDark ? Colors.grey[800] : Colors.grey[200],
        'textColor': isDark ? Colors.white : Colors.black,
        'progressBarColor': Colors.blue,
      },
      'totalClients': {
        'backgroundColor': isDark ? Colors.grey[800] : Colors.grey[200],
        'textColor': isDark ? Colors.white : Colors.black,
        'progressBarColor': Colors.blue,
      },
    };

    // Retrieve styles based on the statType
    final style = statTypeStyles[statType] ??
        statTypeStyles[
            'totalOrders']; // Default to 'totalOrders' style if not found

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: style!['backgroundColor'],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              statType.replaceAllMapped(
                  RegExp(r'([a-z])([A-Z])'),
                  (Match m) =>
                      '${m[1]} ${m[2]}'), // Formatting statType for display
              style: TextStyle(
                color: style['textColor'],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: style['textColor'],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: double.parse(percentage.replaceAll('%', '')) / 100,
              backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
              valueColor:
                  AlwaysStoppedAnimation<Color>(style['progressBarColor']),
            ),
          ],
        ),
      ),
    );
  }
}
