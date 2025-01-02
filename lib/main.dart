// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rosantibike_mobile/api/booking_api.dart';
import 'package:rosantibike_mobile/api/jenis_motor_api.dart';
import 'package:rosantibike_mobile/api/transaksi_api.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_bloc.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_event.dart';
import 'package:rosantibike_mobile/pages/dashboard_page.dart';
import 'package:rosantibike_mobile/pages/transaksi_page.dart';
import 'package:rosantibike_mobile/pages/wallets_page.dart';
import 'package:rosantibike_mobile/pages/review_page.dart';
import 'package:rosantibike_mobile/pages/settings_page.dart';
import 'package:rosantibike_mobile/bottom_navigation_widget.dart';
import 'package:rosantibike_mobile/theme/theme_provider.dart';
import 'package:rosantibike_mobile/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => DashboardBloc(
                transaksiApi: TransaksiApi(),
                jenisMotorApi: JenisMotorApi(),
                bookingApi: BookingApi(),
              )..add(FetchDashboardData()),
            ),
          ],
          child: MaterialApp(
            title: 'Dashboard App',
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const MainScreen(),
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const TransaksiPage(),
    const WalletsPage(),
    const ReviewPage(),
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
