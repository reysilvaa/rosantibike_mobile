import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosantibike_mobile/api/transaksi_api.dart';
import 'package:rosantibike_mobile/api/jenis_motor_api.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_event.dart';
import 'package:rosantibike_mobile/blocs/dashboard/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final TransaksiApi transaksiApi;
  final JenisMotorApi jenisMotorApi;

  // Properti untuk caching data
  DashboardLoaded? _cachedData;

  DashboardBloc({
    required this.transaksiApi,
    required this.jenisMotorApi,
  }) : super(DashboardInitial()) {
    on<FetchDashboardData>((event, emit) async {
      // Jika sudah ada data dalam cache, langsung gunakan
      if (_cachedData != null) {
        emit(_cachedData!);
        return;
      }

      emit(DashboardLoading());
      try {
        // Fetch data dari API
        final transactions = await transaksiApi.getTransaksi();
        final jenisMotors = await jenisMotorApi.getJenisMotors();

        // Ekstrak data motor tersewa dan sisa motor
        final motorTersewa = transactions['motor_tersewa'] ?? 0;
        final sisaMotor = transactions['sisa_motor'] ?? 0;

        // Hitung total unit dari jenis motors
        final totalUnit = jenisMotors['count'] ?? 0;

        // Cache data yang dimuat
        _cachedData = DashboardLoaded(
          motorTersewa: motorTersewa,
          sisaMotor: sisaMotor,
          totalUnit: totalUnit,
        );

        // Emit state dengan data yang dimuat
        emit(_cachedData!);
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
  }
}
