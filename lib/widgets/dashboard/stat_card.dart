import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosantibike_mobile/theme/theme_provider.dart';

class StatCard extends StatelessWidget {
  final String statType;
  final Widget value; // Ubah value menjadi Widget
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
        'backgroundColor': Colors.black,
        'textColor': Colors.white, // Sesuaikan dengan tema
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
      'AksesKeWeb': {
        'backgroundColor': isDark ? Colors.grey[800] : Colors.grey[200],
        'textColor': isDark ? Colors.white : Colors.black,
        'progressBarColor': Colors.blue,
        'icon': Icons.web,
      },
    };

    // Retrieve styles based on the statType
    final style = statTypeStyles[statType] ??
        statTypeStyles[
            'sisaMotor']; // Default to 'MotorTersewa' style if not found

    // Menentukan warna teks untuk value berdasarkan tema
    final valueTextColor = isDark
        ? (statType == 'SisaMotor' ? Colors.white : Colors.grey[200])
        : (statType == 'SisaMotor' ? Colors.black : Colors.black);

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
                  size: 28, // Set your preferred icon size
                ),
                const SizedBox(width: 8),
                Text(
                  statType.replaceAllMapped(
                    RegExp(r'([a-z])([A-Z])'),
                    (Match m) => '${m[1]} ${m[2]}',
                  ), // Formatting statType for display
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
                color: valueTextColor, // Use dynamic text color for value
              ),
              child: value, // Gunakan widget untuk value
            ),
          ],
        ),
      ),
    );
  }
}
