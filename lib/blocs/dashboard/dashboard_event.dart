import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDashboardData extends DashboardEvent {}

class UpdateDashboardData extends DashboardEvent {
  final int motorTersewa;
  final int sisaMotor;

  UpdateDashboardData({
    required this.motorTersewa,
    required this.sisaMotor,
  });

  @override
  List<Object> get props => [motorTersewa, sisaMotor];
}
