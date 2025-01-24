import 'package:flutter/material.dart';
import '../../pages/dashboard_page.dart';
import '../../pages/booking_page.dart';
import '../pages/booking_form.dart';
import '../../pages/transaksi_page.dart';
import '../../pages/settings_page.dart';
import '../../bottom_navigation_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const BookingPage(),
    const BookingForm(),
    const TransaksiPage(),
    const SettingsPage(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
