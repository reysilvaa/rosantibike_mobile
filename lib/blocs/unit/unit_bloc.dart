import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosantibike_mobile/api/jenis_motor_api.dart';
import 'package:rosantibike_mobile/blocs/unit/unit_events.dart';
import 'package:rosantibike_mobile/blocs/unit/unit_state.dart';
import 'package:rosantibike_mobile/model/jenis_motor.dart';

class JenisMotorBloc extends Bloc<JenisMotorEvent, JenisMotorState> {
  final JenisMotorApi jenisMotorApi;

  JenisMotorBloc({required this.jenisMotorApi}) : super(JenisMotorInitial()) {
    on<FetchJenisMotors>(_onFetchJenisMotors);
    on<FetchJenisMotorDetail>(_onFetchJenisMotorDetail);
    on<CreateJenisMotor>(_onCreateJenisMotor);
    on<UpdateJenisMotor>(_onUpdateJenisMotor);
    on<DeleteJenisMotor>(_onDeleteJenisMotor);
  }

  void _onFetchJenisMotors(
    FetchJenisMotors event,
    Emitter<JenisMotorState> emit,
  ) async {
    emit(JenisMotorLoading());
    try {
      final result = await jenisMotorApi.getJenisMotors();

      // Debugging - Print the response to verify structure
      print('Received response: $result');

      if (result == null) {
        throw Exception('No response data');
      }

      // Ensure we have the 'data' key and it is a valid list
      if (result['data'] == null || result['data'].isEmpty) {
        throw Exception('Data is empty or missing');
      }

      // Ensure 'count' and 'timestamp' exist
      // if (result['count'] == null || result['timestamp'] == null) {
      //   throw Exception('Missing count or timestamp');
      // }

      // Successfully emit the data if all checks pass
      emit(JenisMotorLoaded(
        jenisMotors: List<JenisMotor>.from(
            result['data'].map((json) => JenisMotor.fromJson(json))),
        // count: result['count'],
        // timestamp: result['timestamp'],
      ));

      print('Jenis Motor Loaded');
    } catch (e) {
      print('Error: $e');
      emit(JenisMotorError(e.toString()));
    }
  }

  void _onFetchJenisMotorDetail(
    FetchJenisMotorDetail event,
    Emitter<JenisMotorState> emit,
  ) async {
    emit(JenisMotorLoading());
    try {
      final jenisMotor = await jenisMotorApi.getJenisMotorDetail(event.id);
      emit(JenisMotorDetailLoaded(jenisMotor));
    } catch (e) {
      emit(JenisMotorError(e.toString()));
    }
  }

  void _onCreateJenisMotor(
    CreateJenisMotor event,
    Emitter<JenisMotorState> emit,
  ) async {
    emit(JenisMotorLoading());
    try {
      await jenisMotorApi.createJenisMotor(event.data);
      add(FetchJenisMotors()); // Refresh the list
    } catch (e) {
      emit(JenisMotorError(e.toString()));
    }
  }

  void _onUpdateJenisMotor(
    UpdateJenisMotor event,
    Emitter<JenisMotorState> emit,
  ) async {
    emit(JenisMotorLoading());
    try {
      await jenisMotorApi.updateJenisMotor(event.id, event.data);
      add(FetchJenisMotors()); // Refresh the list
    } catch (e) {
      emit(JenisMotorError(e.toString()));
    }
  }

  void _onDeleteJenisMotor(
    DeleteJenisMotor event,
    Emitter<JenisMotorState> emit,
  ) async {
    emit(JenisMotorLoading());
    try {
      await jenisMotorApi.deleteJenisMotor(event.id);
      add(FetchJenisMotors()); // Refresh the list
    } catch (e) {
      emit(JenisMotorError(e.toString()));
    }
  }
}
