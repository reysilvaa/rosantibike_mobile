// lib/blocs/notification/notification_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosantibike_mobile/blocs/notification/notification_event.dart';
import 'package:rosantibike_mobile/blocs/notification/notification_state.dart';
import 'package:rosantibike_mobile/services/notification_service.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _notificationService;

  NotificationBloc({required NotificationService notificationService})
      : _notificationService = notificationService,
        super(NotificationInitial()) {
    on<InitializeNotification>(_onInitializeNotification);
    on<NewTransactionNotification>(_onNewTransactionNotification);
  }

  Future<void> _onInitializeNotification(
    InitializeNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _notificationService.initialize();
      emit(NotificationReady());
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onNewTransactionNotification(
    NewTransactionNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _notificationService.showTransactionNotification(
        title: event.title,
        body: event.body,
        transactionId: event.transactionId,
        motorType: event.motorType,
      );
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
