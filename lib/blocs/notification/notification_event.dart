abstract class NotificationEvent {}

class InitializeNotification extends NotificationEvent {}

class NewTransactionNotification extends NotificationEvent {
  final String title;
  final String body;
  final String transactionId;
  final String motorType;

  NewTransactionNotification({
    required this.title,
    required this.body,
    required this.transactionId,
    required this.motorType,
  });
}