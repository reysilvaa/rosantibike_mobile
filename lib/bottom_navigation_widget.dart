import 'package:flutter/material.dart';
import 'package:rosantibike_mobile/pages/transaksi_booking_detail/details_page.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool showLabels;
  final double elevation;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.showLabels = true,
    this.elevation = 8,
  });

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
                color: theme.shadowColor.withValues(alpha: isDarkMode ? 0.3 : 0.1),
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
                    'Dasbor', selectedIndex == 0, selectedColor),
                _buildNavItem(Icons.analytics_outlined, Icons.analytics,
                    'Booking', selectedIndex == 1, selectedColor),
                _buildNavItem(Icons.rate_review_outlined, Icons.rate_review,
                    'Transaksi', selectedIndex == 2, selectedColor),
                _buildNavItem(Icons.settings_outlined, Icons.settings,
                    'Pengaturan', selectedIndex == 3, selectedColor),
              ],
            ),
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

  CustomPageRoute({required this.child, required DetailsPage page})
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
