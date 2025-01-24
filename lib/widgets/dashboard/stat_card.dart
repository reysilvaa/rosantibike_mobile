import 'package:flutter/material.dart';


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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    final Map<String, Map<String, dynamic>> statTypeStyles = {
      'SisaMotor': {
        'backgroundColor': theme.primaryColor,
        'textColor': Colors.white,
        'progressBarColor': theme.colorScheme.primary,
        'icon': Icons.motorcycle,
      },
      'MotorKeluar': {
        'backgroundColor': theme.cardTheme.color,
        'textColor': theme.textTheme.titleMedium?.color,
        'progressBarColor': theme.colorScheme.error,
        'icon': Icons.north_east_rounded,
      },
      'TotalUnit': {
        'backgroundColor': theme.cardTheme.color,
        'textColor': theme.textTheme.titleMedium?.color,
        'progressBarColor': theme.colorScheme.primary,
        'icon': Icons.motorcycle_rounded,
      },
      'TotalBooking': {
        'backgroundColor': theme.cardTheme.color,
        'textColor': theme.textTheme.titleMedium?.color,
        'progressBarColor': theme.colorScheme.primary,
        'icon': Icons.web,
      },
    };

    final style =
        statTypeStyles[widget.statType] ?? statTypeStyles['SisaMotor'];

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
        child: Container(
          padding: EdgeInsets.all(screenWidth < 360 ? 12 : 16),
          decoration: BoxDecoration(
            color: style?['backgroundColor'],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
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
                      style: theme.textTheme.titleMedium?.copyWith(
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
                style: theme.textTheme.headlineMedium!.copyWith(
                  color: style?['textColor'],
                  overflow: TextOverflow.ellipsis,
                ),
                child: widget.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
