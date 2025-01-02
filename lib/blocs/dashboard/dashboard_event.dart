import 'package:equatable/equatable.dart';

/// Abstract class for dashboard events
abstract class DashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event for fetching dashboard data
class FetchDashboardData extends DashboardEvent {}

/// Event for updating dashboard data manually
class UpdateDashboardData extends DashboardEvent {
  final int? motorTersewa;
  final int? sisaMotor;
  final int? totalUnit;
  final int? totalBooking;
  final List<dynamic>? data;
  final List<dynamic>? motorUnits;

  UpdateDashboardData({
    this.motorTersewa,
    this.sisaMotor,
    this.totalUnit,
    this.totalBooking,
    this.data,
    this.motorUnits,
  });

  @override
  List<Object?> get props =>
      [motorTersewa, sisaMotor, totalUnit, totalBooking, data, motorUnits];
}
