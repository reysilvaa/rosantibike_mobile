import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosantibike_mobile/theme/theme_provider.dart';

class StatCard extends StatefulWidget {
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
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;

    final Map<String, Map<String, dynamic>> statTypeStyles = {
      'SisaMotor': {
        'backgroundColor': isDark ? Colors.black : const Color(0xFF2196F3),
        'textColor': Colors.white,
        'progressBarColor': Colors.blue,
        'icon': Icons.motorcycle,
      },
      'MotorKeluar': {
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

    final style =
        statTypeStyles[widget.statType] ?? statTypeStyles['SisaMotor'];

    final valueTextColor = isDark
        ? Colors.white
        : (widget.statType == 'SisaMotor' ? Colors.white : Colors.black);

    // Responsive font sizes
    final double titleFontSize = screenWidth < 360 ? 12 : 14;
    final double iconSize = screenWidth < 360 ? 24 : 28;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              padding: EdgeInsets.all(screenWidth < 360 ? 12 : 16),
              decoration: BoxDecoration(
                color: style?['backgroundColor'],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        style?['icon'],
                        color: style?['textColor'],
                        size: iconSize,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.statType.replaceAllMapped(
                            RegExp(r'([a-z])([A-Z])'),
                            (Match m) => '${m[1]} ${m[2]}',
                          ),
                          style: TextStyle(
                            color: style?['textColor'],
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DefaultTextStyle(
                    style: TextStyle(
                      color: valueTextColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                    child: widget.value,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
