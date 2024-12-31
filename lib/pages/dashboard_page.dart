import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosantibike_mobile/api/transaksi_api.dart';
import 'package:rosantibike_mobile/api/jenis_motor_api.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_bloc.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_event.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_state.dart';
import '../widgets/dashboard/stat_card.dart';
import '../widgets/dashboard/line_chart.dart';
import '../widgets/dashboard/period_selector.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_theme.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Use BlocProvider to fetch data
    return BlocProvider.value(
      value: BlocProvider.of<DashboardBloc>(context)..add(FetchDashboardData()),
      child: Scaffold(
        backgroundColor: Theme.of(context)
            .scaffoldBackgroundColor, // Set background color based on theme
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, themeProvider),
                const SizedBox(height: 20),
                _buildDashboardStats(context), // Pass context here
                const SizedBox(height: 20),
                const PeriodSelector(),
                const SizedBox(height: 20),
                const Expanded(child: RevenueLineChart()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeProvider themeProvider) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Dashboard',
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: theme.iconTheme.color,
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.more_horiz,
                color: theme.iconTheme.color,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDashboardStats(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final isLoading = state is DashboardLoading;
        final isError = state is DashboardError;

        final sisaMotor = state is DashboardLoaded ? state.sisaMotor : 0;
        final motorTersewa = state is DashboardLoaded ? state.motorTersewa : 0;
        final totalMotor = state is DashboardLoaded ? state.totalUnit : 0;
        final totalBooking = state is DashboardLoaded ? state.totalBooking : 0;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    statType: 'SisaMotor',
                    value: _buildValueWidget(
                        context, sisaMotor, isLoading, isError, true),
                    percentage: _calculatePercentage(sisaMotor, totalMotor),
                    isIncreasing: true,
                    onTap: () {
                      print('Tapped Sisa Motor');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    statType: 'MotorTersewa',
                    value: _buildValueWidget(
                        context, motorTersewa, isLoading, isError, false),
                    percentage: _calculatePercentage(motorTersewa, totalMotor),
                    isIncreasing: true,
                    onTap: () {
                      print('Tapped Motor Tersewa');
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
                    value: _buildValueWidget(
                        context, totalMotor, isLoading, isError, false),
                    percentage: '100%',
                    isIncreasing: true,
                    onTap: () {
                      print('Tapped Total Unit');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    statType: 'TotalBooking',
                    value: _buildValueWidget(
                        context, totalBooking, isLoading, isError, false),
                    percentage: '0%',
                    isIncreasing: true,
                    onTap: () {
                      print('Tapped Akses Ke Web');
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildValueWidget(BuildContext context, int value, bool isLoading,
      bool isError, bool isSisaMotor) {
    final theme = Theme.of(context);

    // Check if the app is in dark mode
    final isDarkMode = theme.brightness == Brightness.dark;

    // Set color directly based on the theme (dark mode)
    Color textColor =
        isDarkMode ? Colors.white : (isSisaMotor ? Colors.white : Colors.black);

    // If there's an error, display in red
    if (isError) {
      return Text(
        'Error',
        style: theme.textTheme.bodyLarge?.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      );
    }

    // Set the value with the correct color, ensuring it stays white in dark mode
    return Text(
      isLoading ? '--' : value.toString(),
      style: theme.textTheme.bodyLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: isLoading ? Colors.grey : textColor, // Apply textColor here
      ),
    );
  }

  String _calculatePercentage(int value, int total) {
    if (total <= 0) return '0%';
    return '${((value / total) * 100).toStringAsFixed(0)}%';
  }
}
