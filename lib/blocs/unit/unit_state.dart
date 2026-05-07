// jenis_motor_bloc.dart
import 'package:equatable/equatable.dart';
// Events
abstract class JenisMotorEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchJenisMotors extends JenisMotorEvent {}

class FetchJenisMotorDetail extends JenisMotorEvent {
  final int id;
  FetchJenisMotorDetail(this.id);

  @override
  List<Object> get props => [id];
}

class CreateJenisMotor extends JenisMotorEvent {
  final Map<String, dynamic> data;
  CreateJenisMotor(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateJenisMotor extends JenisMotorEvent {
  final int id;
  final Map<String, dynamic> data;
  UpdateJenisMotor(this.id, this.data);

  @override
  List<Object> get props => [id, data];
}

class DeleteJenisMotor extends JenisMotorEvent {
  final int id;
  DeleteJenisMotor(this.id);

  @override
  List<Object> get props => [id];
}