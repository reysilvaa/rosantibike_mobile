import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_event.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_state.dart';
import 'package:rosantibike_mobile/api/transaksi_api.dart';
import 'package:rosantibike_mobile/api/jenis_motor_api.dart';
import 'package:rosantibike_mobile/api/booking_api.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final TransaksiApi transaksiApi;
  final JenisMotorApi jenisMotorApi;
  final BookingApi bookingApi;
  final _stateController = StreamController<DashboardState>.broadcast();
  Timer? _pollingTimer;
  String? _lastUpdated; // To store last updated time

  Stream<DashboardState> get stateStream => _stateController.stream;

  DashboardBloc({
    required this.transaksiApi,
    required this.jenisMotorApi,
    required this.bookingApi,
  }) : super(DashboardInitial()) {
    on<FetchDashboardData>(_fetchDashboardData);
    on<UpdateDashboardData>(_updateDashboardData);
    _startPolling();
  }

  void _startPolling() {
    // Initial fetch
    add(FetchDashboardData());

    // Set up periodic polling every 2 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      add(FetchDashboardData());
    });
  }

  Future<void> _fetchDashboardData(
    FetchDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      // Use lastUpdated for polling the latest data
      final transactions =
          await transaksiApi.getTransaksi(lastUpdated: _lastUpdated);
      _lastUpdated =
          transactions['timestamp']; // Update lastUpdated after fetch

      final jenisMotors =
          await jenisMotorApi.getJenisMotors(lastUpdated: _lastUpdated);
      final booking = await bookingApi.getBooking(lastUpdated: _lastUpdated);

      final newState = DashboardLoaded(
        motorTersewa: transactions['motor_tersewa'] ?? 0,
        sisaMotor: transactions['sisa_motor'] ?? 0,
        totalUnit: jenisMotors['count'] ?? 0,
        totalBooking: booking['count'] ?? 0,
      );

      emit(newState);
      _stateController.add(newState);
    } catch (e) {
      final errorState = DashboardError(e.toString());
      emit(errorState);
      _stateController.add(errorState);
    }
  }

  void _updateDashboardData(
    UpdateDashboardData event,
    Emitter<DashboardState> emit,
  ) {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      final newState = DashboardLoaded(
        motorTersewa: event.motorTersewa,
        sisaMotor: event.sisaMotor,
        totalUnit: currentState.totalUnit,
        totalBooking: currentState.totalBooking,
      );

      emit(newState);
      _stateController.add(newState);
    }
  }

  @override
  Future<void> close() async {
    _pollingTimer?.cancel();
    await _stateController.close();
    return super.close();
  }
}
