// lib/constants/navigation_items.dart
import 'package:flutter/material.dart';

class NavigationItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

class NavigationItems {
  static const List<NavigationItem> items = [
    NavigationItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
    ),
    NavigationItem(
      label: 'Analytics',
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
    ),
    NavigationItem(
      label: 'Wallets',
      icon: Icons.wallet_outlined,
      activeIcon: Icons.wallet,
    ),
    NavigationItem(
      label: 'Review',
      icon: Icons.rate_review_outlined,
      activeIcon: Icons.rate_review,
    ),
    NavigationItem(
      label: 'Settings',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
    ),
  ];
}
