import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosantibike_mobile/theme/theme_provider.dart';

class StatCard extends StatelessWidget {
  final String statType;
  final Widget value;
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
      'SisaMotor': {
        'backgroundColor': isDark
            ? Colors.black
            : const Color(0xFF2196F3), // Primary blue from theme for light mode
        'textColor': Colors.white, // White text for both modes
        'progressBarColor': Colors.blue,
        'icon': Icons.motorcycle,
      },
      'MotorTersewa': {
        'backgroundColor': isDark ? Colors.grey[800] : Colors.grey[200],
        'textColor': isDark ? Colors.white : Colors.black,
        'progressBarColor': Colors.red,
        'icon': Icons.north_east_rounded,
      },
      'TotalUnit': {
        'backgroundColor': isDark ? Colors.grey[800] : Colors.grey[200],
        'textColor': isDark ? Colors.white : Colors.black,
        'progressBarColor': Colors.blue,
        'icon': Icons.motorcycle_rounded,
      },
      'TotalBooking': {
        'backgroundColor': isDark ? Colors.grey[800] : Colors.grey[200],
        'textColor': isDark ? Colors.white : Colors.black,
        'progressBarColor': Colors.blue,
        'icon': Icons.web,
      },
    };

    final style = statTypeStyles[statType] ?? statTypeStyles['SisaMotor'];

    // Update value text color logic
    final valueTextColor = isDark
        ? Colors.white // Dark mode: always white
        : (statType == 'SisaMotor'
            ? Colors.white
            : Colors
                .black); // Light mode: white for SisaMotor, black for others

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: style?['backgroundColor'],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  style?['icon'],
                  color: style?['textColor'],
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  statType.replaceAllMapped(
                    RegExp(r'([a-z])([A-Z])'),
                    (Match m) => '${m[1]} ${m[2]}',
                  ),
                  style: TextStyle(
                    color: style?['textColor'],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DefaultTextStyle(
              style: TextStyle(
                color: valueTextColor,
              ),
              child: value,
            ),
          ],
        ),
      ),
    );
  }
}
