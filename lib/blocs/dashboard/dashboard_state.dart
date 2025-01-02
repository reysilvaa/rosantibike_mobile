import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

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

  @override
  List<Object?> get props => [motorTersewa, sisaMotor, totalUnit, totalBooking];
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
