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

    // Set up periodic polling every 5 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      add(FetchDashboardData());
    });
  }

  Future<void> _fetchDashboardData(
    FetchDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final transactions = await transaksiApi.getTransaksi();
      final jenisMotors = await jenisMotorApi.getJenisMotors();
      final booking = await bookingApi.getBooking();

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
