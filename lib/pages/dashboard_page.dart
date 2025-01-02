import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_bloc.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_event.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_state.dart';
import '../widgets/dashboard/stat_card.dart';
import '../widgets/dashboard/menu_grid.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late DashboardBloc _dashboardBloc;
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    _dashboardBloc.add(FetchDashboardData());
    context.read<DashboardBloc>().add(FetchDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, themeProvider),
              const SizedBox(height: 20),
              StreamBuilder<DashboardState>(
                stream: _dashboardBloc.stateStream,
                builder: (context, snapshot) {
                  return BlocConsumer<DashboardBloc, DashboardState>(
                    listenWhen: (previous, current) =>
                        current is DashboardError,
                    listener: (context, state) {
                      if (state is DashboardError) {
                        // Print full error to the console
                        print('Error: ${state.message}');
                        // print(
                        //     'Stack trace: ${state.stackTrace}'); // If stack trace is available

                        // Optionally, you can also show the error message in the SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    builder: (context, state) {
                      final currentState = snapshot.data ?? state;
                      return _buildDashboardStats(context, currentState);
                    },
                  );
                },
              ),
              const SizedBox(height: 30),
              const MenuGrid(),
              // const SizedBox(height: 20),
              // const Expanded(child: MenuGrid()),
            ],
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
              onPressed: () => themeProvider.toggleTheme(),
            ),
            IconButton(
              icon: Icon(Icons.more_horiz, color: theme.iconTheme.color),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDashboardStats(BuildContext context, DashboardState state) {
    final sisaMotor = (state is DashboardLoaded) ? state.sisaMotor : 0;
    final motorTersewa = (state is DashboardLoaded) ? state.motorTersewa : 0;
    final totalMotor = (state is DashboardLoaded) ? state.totalUnit : 0;
    final totalBooking = (state is DashboardLoaded) ? state.totalBooking : 0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                statType: 'SisaMotor',
                value:
                    _buildValueWidget(context, sisaMotor, false, false, true),
                percentage: _calculatePercentage(sisaMotor, totalMotor),
                isIncreasing: true,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                statType: 'MotorTersewa',
                value: _buildValueWidget(
                    context, motorTersewa, false, false, false),
                percentage: _calculatePercentage(motorTersewa, totalMotor),
                isIncreasing: true,
                onTap: () {},
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
                value:
                    _buildValueWidget(context, totalMotor, false, false, false),
                percentage: '100%',
                isIncreasing: true,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                statType: 'TotalBooking',
                value: _buildValueWidget(
                    context, totalBooking, false, false, false),
                percentage: '0%',
                isIncreasing: true,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildValueWidget(BuildContext context, int value, bool isLoading,
      bool isError, bool isSisaMotor) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textColor =
        isDarkMode ? Colors.white : (isSisaMotor ? Colors.white : Colors.black);

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

    return Text(
      isLoading ? '' : value.toString(),
      style: theme.textTheme.bodyLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: isLoading ? Colors.grey : textColor,
      ),
    );
  }

  String _calculatePercentage(int value, int total) {
    if (total <= 0) return '0%';
    return '${((value / total) * 100).toStringAsFixed(0)}%';
  }
}
