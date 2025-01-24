import 'package:equatable/equatable.dart';
import 'package:rosantibike_mobile/blocs/unit/unit_state.dart';
import 'package:rosantibike_mobile/model/jenis_motor.dart';

abstract class JenisMotorState extends Equatable {
  @override
  List<Object> get props => [];
}

class JenisMotorInitial extends JenisMotorState {}

class JenisMotorLoading extends JenisMotorState {}

class JenisMotorLoaded extends JenisMotorState {
  final List<JenisMotor> jenisMotors;
  // final int count;
  // final String timestamp;

  JenisMotorLoaded({
    required this.jenisMotors,
    // required this.count,
    // required this.timestamp,
  });

  @override
  List<Object> get props => [jenisMotors];
}

class JenisMotorDetailLoaded extends JenisMotorState {
  final JenisMotor jenisMotor;

  JenisMotorDetailLoaded(this.jenisMotor);

  @override
  List<Object> get props => [jenisMotor];
}

class JenisMotorError extends JenisMotorState {
  final String message;

  JenisMotorError(this.message);

  @override
  List<Object> get props => [message];
}
class AddJenisMotor extends JenisMotorEvent {
  final Map<String, dynamic> newMotor;
  
  AddJenisMotor(this.newMotor);
}