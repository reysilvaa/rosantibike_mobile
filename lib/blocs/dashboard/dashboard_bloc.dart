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
  String? _lastTransaksiUpdate;
  String? _lastMotorUpdate;
  String? _lastBookingUpdate;

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
    add(FetchDashboardData());
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      add(FetchDashboardData());
    });
  }

  Future<void> _fetchDashboardData(
    FetchDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final transactions = await transaksiApi.getTransaksi(
        lastUpdated: _lastTransaksiUpdate,
      );
      final jenisMotors = await jenisMotorApi.getJenisMotors(
        lastUpdated: _lastMotorUpdate,
      );
      final booking = await bookingApi.getBooking(
        lastUpdated: _lastBookingUpdate,
      );

      _lastTransaksiUpdate = transactions['timestamp'];
      _lastMotorUpdate = jenisMotors['timestamp'];
      _lastBookingUpdate = booking['timestamp'];

      final newState = DashboardLoaded(
        motorTersewa: transactions['motor_tersewa'] ?? 0,
        sisaMotor: transactions['sisa_motor'] ?? 0,
        totalUnit: jenisMotors['count'] ?? 0,
        totalBooking: booking['count'] ?? 0,
        data: transactions['data'] ?? [],
        motorUnits: jenisMotors['data'] ?? [],
      );

      if (_shouldUpdateState(newState)) {
        emit(newState);
        _stateController.add(newState);
      }
    } catch (e) {
      final errorState = DashboardError(e.toString());
      emit(errorState);
      _stateController.add(errorState);
    }
  }

  bool _shouldUpdateState(DashboardLoaded newState) {
    if (state is! DashboardLoaded) return true;

    final currentState = state as DashboardLoaded;
    return currentState.motorTersewa != newState.motorTersewa ||
        currentState.sisaMotor != newState.sisaMotor ||
        currentState.totalUnit != newState.totalUnit ||
        currentState.totalBooking != newState.totalBooking ||
        _hasDataChanged(currentState.data, newState.data) ||
        _hasDataChanged(currentState.motorUnits, newState.motorUnits);
  }

  bool _hasDataChanged(List<dynamic> oldData, List<dynamic> newData) {
    if (oldData.length != newData.length) return true;
    for (int i = 0; i < oldData.length; i++) {
      if (oldData[i].toString() != newData[i].toString()) return true;
    }
    return false;
  }

  void _updateDashboardData(
    UpdateDashboardData event,
    Emitter<DashboardState> emit,
  ) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final newState = DashboardLoaded(
        motorTersewa: event.motorTersewa ?? currentState.motorTersewa,
        sisaMotor: event.sisaMotor ?? currentState.sisaMotor,
        totalUnit: event.totalUnit ?? currentState.totalUnit,
        totalBooking: event.totalBooking ?? currentState.totalBooking,
        data: event.data ?? currentState.data,
        motorUnits: event.motorUnits ?? currentState.motorUnits,
      );

      if (_shouldUpdateState(newState)) {
        emit(newState);
        _stateController.add(newState);
      }
    }
  }

  void refreshDashboard() {
    add(FetchDashboardData());
  }

  @override
  Future<void> close() async {
    _pollingTimer?.cancel();
    await _stateController.close();
    return super.close();
  }
}
