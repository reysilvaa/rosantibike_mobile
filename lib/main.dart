import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rosantibike_mobile/api/booking_api.dart';
import 'package:rosantibike_mobile/api/jenis_motor_api.dart';
import 'package:rosantibike_mobile/api/transaksi_api.dart';
import 'package:rosantibike_mobile/blocs/booking/booking_bloc.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_bloc.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_event.dart';
import 'package:rosantibike_mobile/blocs/transaksi/transaksi_bloc.dart';
import 'package:rosantibike_mobile/screen/splash_screen.dart';
import 'package:rosantibike_mobile/theme/theme_provider.dart';
import 'package:rosantibike_mobile/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DashboardBloc(
              transaksiApi: TransaksiApi(),
              jenisMotorApi: JenisMotorApi(),
              bookingApi: BookingApi(),
            )..add(FetchDashboardData()),
          ),
          BlocProvider(
            create: (context) => BookingBloc(bookingApi: BookingApi()),
          ),
          BlocProvider(
            create: (context) => TransaksiBloc(transaksiApi: TransaksiApi()),
          ),
        ],
        child: MaterialApp(
          title: 'Rosantibike Mobile',
          themeMode: themeProvider.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        ),
      );
    });
  }
}
