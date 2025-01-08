import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rosantibike_mobile/api/booking_api.dart';
import 'package:rosantibike_mobile/api/jenis_motor_api.dart';
import 'package:rosantibike_mobile/api/transaksi_api.dart';
import 'package:rosantibike_mobile/blocs/booking/booking_bloc.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_bloc.dart';
import 'package:rosantibike_mobile/blocs/notification/notification_bloc.dart';
import 'package:rosantibike_mobile/blocs/notification/notification_event.dart';
import 'package:rosantibike_mobile/blocs/transaksi/transaksi_bloc.dart';
import 'package:rosantibike_mobile/screen/splash_screen.dart';
import 'package:rosantibike_mobile/theme/theme_provider.dart';
import 'package:rosantibike_mobile/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rosantibike_mobile/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('id_ID', null);

  final notificationService = NotificationService();
  await notificationService.initialize();

  // Create ThemeProvider instance before running app
  final themeProvider = ThemeProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: MyApp(notificationService: notificationService),
    ),
  );
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;

  const MyApp({Key? key, required this.notificationService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Builder(
          builder: (context) {
            // Update system UI based on current theme
            AppTheme.updateSystemUI(context);

            return MultiBlocProvider(
              providers: [
                BlocProvider<DashboardBloc>(
                  lazy: false,
                  create: (context) => DashboardBloc(
                    transaksiApi: TransaksiApi(),
                    jenisMotorApi: JenisMotorApi(),
                    bookingApi: BookingApi(),
                  ),
                ),
                BlocProvider<BookingBloc>(
                  lazy: false,
                  create: (context) => BookingBloc(
                    bookingApi: BookingApi(),
                    notificationService: notificationService,
                  ),
                ),
                BlocProvider<TransaksiBloc>(
                  lazy: false,
                  create: (context) => TransaksiBloc(
                    transaksiApi: TransaksiApi(),
                    notificationService: notificationService,
                  ),
                ),
                BlocProvider<NotificationBloc>(
                  lazy: false,
                  create: (context) => NotificationBloc(
                    notificationService: notificationService,
                  )..add(InitializeNotification()),
                ),
              ],
              child: MaterialApp(
                title: 'Rosantibike Mobile',
                themeMode: themeProvider.themeMode,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                home: SplashScreen(themeProvider: themeProvider),
                debugShowCheckedModeBanner: false,
              ),
            );
          },
        );
      },
    );
  }
}
