// lib/bloc/dashboard_state.dart
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int motorTersewa;
  final int sisaMotor;
  final int totalUnit;
  final int totalBooking;
  
  DashboardLoaded({
    required this.motorTersewa,
    required this.sisaMotor,
    required this.totalUnit,
    required this.totalBooking,
  });
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}
