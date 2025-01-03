import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool showLabels;
  final double elevation;

  const BottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.showLabels = true,
    this.elevation = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundColor = theme.bottomNavigationBarTheme.backgroundColor;
    final containerColor = theme.scaffoldBackgroundColor;
    final selectedColor = theme.primaryColor;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main Navigation Container
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(isDarkMode ? 0.3 : 0.1),
                blurRadius: elevation,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: onItemSelected,
              type: BottomNavigationBarType.fixed,
              backgroundColor: backgroundColor,
              selectedItemColor: selectedColor,
              unselectedItemColor:
                  isDarkMode ? Colors.grey[400] : Colors.grey[600],
              showSelectedLabels: showLabels,
              showUnselectedLabels: showLabels,
              elevation: 0,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: selectedColor,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              items: [
                _buildNavItem(Icons.dashboard_outlined, Icons.dashboard,
                    'Dashboard', selectedIndex == 0, selectedColor),
                _buildNavItem(Icons.analytics_outlined, Icons.analytics,
                    'Analytics', selectedIndex == 1, selectedColor),
                const BottomNavigationBarItem(
                  icon: SizedBox(width: 50, height: 30),
                  label: '',
                ),
                _buildNavItem(Icons.rate_review_outlined, Icons.rate_review,
                    'Review', selectedIndex == 3, selectedColor),
                _buildNavItem(Icons.settings_outlined, Icons.settings,
                    'Settings', selectedIndex == 4, selectedColor),
              ],
            ),
          ),
        ),
        // Floating Action Button with Label
        Positioned(
          top: -32,
          left: 0,
          right: 0,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => onItemSelected(2),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedIndex == 2
                        ? selectedColor
                        : theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: selectedColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.add,
                      color: selectedIndex == 2
                          ? Colors.white
                          : theme.iconTheme.color,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Add New',
                style: TextStyle(
                  color: selectedIndex == 2
                      ? selectedColor
                      : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                  fontSize: 12,
                  fontWeight:
                      selectedIndex == 2 ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    IconData activeIcon,
    String label,
    bool isSelected,
    Color selectedColor,
  ) {
    return BottomNavigationBarItem(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Icon(
              isSelected ? activeIcon : icon,
              size: isSelected ? 28 : 24,
            ),
          ),
          if (isSelected)
            Positioned(
              bottom: 0,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: isSelected ? selectedColor : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      label: label,
    );
  }
}

// Custom Page Route untuk transisi halaman
class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({required this.child})
      : super(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
      ),
      child: child,
    );
  }
}
