
// lib/widgets/stat_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosantibike_mobile/theme/theme_provider.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String percentage;
  final bool isIncreasing;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.percentage,
    required this.isIncreasing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: title == 'Total Menus' 
            ? Colors.black 
            : (isDark ? Colors.grey[800] : Colors.grey[200]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: title == 'Total Menus' || isDark 
                  ? Colors.white 
                  : Colors.black,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: title == 'Total Menus' || isDark 
                  ? Colors.white 
                  : Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: double.parse(percentage.replaceAll('%', '')) / 100,
            backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              title == 'Revenue' ? Colors.red : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
