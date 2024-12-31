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

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Gunakan BlocProvider.value untuk mempertahankan instance
    return BlocProvider.value(
      value: BlocProvider.of<DashboardBloc>(context)
        ..add(FetchDashboardData()), // Tambahkan hanya saat pertama kali
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, themeProvider),
                const SizedBox(height: 20),
                _buildDashboardStats(),
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
    return Row(
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
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
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
    );
  }

  Widget _buildDashboardStats() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final isLoading = state is DashboardLoading;
        final isError = state is DashboardError;

        final sisaMotor = state is DashboardLoaded ? state.sisaMotor : 0;
        final motorTersewa = state is DashboardLoaded ? state.motorTersewa : 0;
        final totalMotor = state is DashboardLoaded ? state.totalUnit : 0;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    statType: 'SisaMotor',
                    value:
                        _buildValueWidget(sisaMotor, isLoading, isError, true),
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
                        motorTersewa, isLoading, isError, false),
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
                        totalMotor, isLoading, isError, false),
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
                    statType: 'AksesKeWeb',
                    value: _buildValueWidget(0, isLoading, isError, false),
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

  Widget _buildValueWidget(
      int value, bool isLoading, bool isError, bool isSisaMotor) {
    if (isError) {
      return const Text(
        'Error',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      );
    }

    return Text(
      isLoading ? '--' : value.toString(),
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: isLoading
            ? Colors.grey
            : (isSisaMotor ? Colors.white : Colors.black),
      ),
    );
  }

  String _calculatePercentage(int value, int total) {
    if (total <= 0) return '0%';
    return '${((value / total) * 100).toStringAsFixed(0)}%';
  }
}
