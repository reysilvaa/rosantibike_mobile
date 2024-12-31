// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import '../widgets/dashboard/stat_card.dart';
import '../widgets/dashboard/line_chart.dart';
import '../widgets/dashboard/period_selector.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
                        ),
                        onPressed: () {
                          themeProvider.toggleTheme();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      statType: 'SisaMotor',
                      value: '120',
                      percentage: '45%',
                      isIncreasing: true,
                      onTap: () {
                        // Add your onTap functionality here for "Total Menus"
                        print('Tapped Total Menus');
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      statType: 'MotorTersewa',
                      value: '180',
                      percentage: '62%',
                      isIncreasing: true,
                      onTap: () {
                        // Add your onTap functionality here for "Total Orders"
                        print('Tapped Total Orders');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      statType: 'TotalUnit',
                      value: '240',
                      percentage: '80%',
                      isIncreasing: true,
                      onTap: () {
                        // Add your onTap functionality here for "Total Clients"
                        print('Tapped Total Clients');
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      statType: 'AksesKeWeb',
                      value: '140',
                      percentage: '85%',
                      isIncreasing: true,
                      onTap: () {
                        // Add your onTap functionality here for "Revenue"
                        print('Tapped Revenue');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const PeriodSelector(),
              const SizedBox(height: 20),
              const Expanded(
                child: RevenueLineChart(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
