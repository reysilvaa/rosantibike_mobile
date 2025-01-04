import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuGrid extends StatefulWidget {
  const MenuGrid({Key? key}) : super(key: key);

  @override
  State<MenuGrid> createState() => _MenuGridState();
}

class _MenuGridState extends State<MenuGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Animation<double>> _scaleAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];

  List<Map<String, dynamic>> getMenuItems(bool isDarkMode) {
    final lightGradients = [
      [const Color(0xFF2196F3), const Color(0xFF64B5F6)],
      [const Color(0xFF1E88E5), const Color(0xFF42A5F5)],
      [const Color(0xFF1976D2), const Color(0xFF2196F3)],
      [const Color(0xFF1565C0), const Color(0xFF1E88E5)],
    ];

    final darkGradients = [
      [const Color(0xFF424242), const Color(0xFF616161)],
      [const Color(0xFF484848), const Color(0xFF666666)],
      [const Color(0xFF424242), const Color(0xFF616161)],
      [const Color(0xFF484848), const Color(0xFF666666)],
    ];

    final gradients = isDarkMode ? darkGradients : lightGradients;

    return [
      {
        'icon': Icons.receipt_long,
        'label': 'myTransaksi',
        'gradient': gradients[0],
      },
      {
        'icon': Icons.schedule,
        'label': 'myBooking',
        'gradient': gradients[1],
      },
      {
        'icon': Icons.motorcycle_outlined,
        'label': 'myUnit',
        'gradient': gradients[2],
      },
      {
        'icon': Icons.admin_panel_settings,
        'label': 'myWeb',
        'gradient': gradients[3],
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    for (int i = 0; i < 4; i++) {
      final startDelay = (i / 4) * 0.4;
      _scaleAnimations.add(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            startDelay,
            startDelay + 0.4,
            curve: Curves.easeOutBack,
          ),
        ),
      );
      _fadeAnimations.add(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            startDelay,
            startDelay + 0.2,
            curve: Curves.easeOut,
          ),
        ),
      );
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final menuItems = getMenuItems(isDarkMode);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Adaptive spacing based on screen width
        final spacing = constraints.maxWidth * 0.02; // 2% of screen width
        final padding = constraints.maxWidth * 0.03; // 3% of screen width

        // Calculate item dimensions
        final availableWidth = constraints.maxWidth - (padding * 2);
        final itemWidth = (availableWidth - (spacing * 3)) / 4;
        final itemHeight = itemWidth * 1.1; // Reduced aspect ratio

        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(isDarkMode ? 0.3 : 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 1,
              ),
            ],
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: itemWidth / itemHeight,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return ScaleTransition(
                scale: _scaleAnimations[index],
                child: FadeTransition(
                  opacity: _fadeAnimations[index],
                  child: MenuGridItem(
                    icon: item['icon'] as IconData,
                    label: item['label'] as String,
                    gradient: item['gradient'] as List<Color>,
                    theme: theme,
                    iconSize: itemWidth * 0.4, // Adaptive icon size
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class MenuGridItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final ThemeData theme;
  final double iconSize;

  const MenuGridItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.gradient,
    required this.theme,
    required this.iconSize,
  }) : super(key: key);

  @override
  State<MenuGridItem> createState() => _MenuGridItemState();
}

class _MenuGridItemState extends State<MenuGridItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.theme.brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        HapticFeedback.mediumImpact();
        // Add your onTap functionality here
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: widget.iconSize * 1.8,
              height: widget.iconSize * 1.8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient.first
                        .withOpacity(isDarkMode ? 0.3 : 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: widget.iconSize,
              ),
            ),
            SizedBox(height: widget.iconSize * 0.2),
            Text(
              widget.label,
              style: widget.theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
