
// lib/blocs/notification/notification_state.dart
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationReady extends NotificationState {}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}
