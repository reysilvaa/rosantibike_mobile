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
  String? _lastUpdated; // Timestamp for tracking the last update

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

  // Starts polling the API every 10 seconds
  void _startPolling() {
    // Initial data fetch
    add(FetchDashboardData());

    // Poll data every 10 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      add(FetchDashboardData());
    });
  }

  // Fetch the dashboard data from API
  Future<void> _fetchDashboardData(
    FetchDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final transactions =
          await transaksiApi.getTransaksi(lastUpdated: _lastUpdated);
      final jenisMotors =
          await jenisMotorApi.getJenisMotors(lastUpdated: _lastUpdated);
      final booking = await bookingApi.getBooking(lastUpdated: _lastUpdated);

      // Update the timestamp to track last fetched data
      _lastUpdated = transactions['timestamp'];

      // Create the new state for the loaded data
      final newState = DashboardLoaded(
        motorTersewa: transactions['motor_tersewa'] ?? 0,
        sisaMotor: transactions['sisa_motor'] ?? 0,
        totalUnit: jenisMotors['count'] ?? 0,
        totalBooking: booking['count'] ?? 0,
        data: transactions['data'] ?? [],
        motorUnits: jenisMotors['data'] ?? [],
      );

      // Only emit if there is a change in state
      if (state is! DashboardLoaded ||
          (state as DashboardLoaded).data != newState.data) {
        emit(newState);
        _stateController.add(newState);
      }
    } catch (e) {
      final errorState = DashboardError(e.toString());
      emit(errorState);
      _stateController.add(errorState);
    }
  }

  // Update the state when dashboard data changes
  void _updateDashboardData(
    UpdateDashboardData event,
    Emitter<DashboardState> emit,
  ) {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      final newState = DashboardLoaded(
        motorTersewa: event.motorTersewa ?? currentState.motorTersewa,
        sisaMotor: event.sisaMotor ?? currentState.sisaMotor,
        totalUnit: event.totalUnit ?? currentState.totalUnit,
        totalBooking: event.totalBooking ?? currentState.totalBooking,
        data: event.data as List<dynamic>? ?? currentState.data,
        motorUnits:
            event.motorUnits as List<dynamic>? ?? currentState.motorUnits,
      );

      // Only emit the updated state if there's a change
      if (newState != currentState) {
        emit(newState);
        _stateController.add(newState);
      }
    }
  }

  // Close the bloc and cancel polling when the bloc is closed
  @override
  Future<void> close() async {
    _pollingTimer?.cancel();
    await _stateController.close();
    return super.close();
  }
}
