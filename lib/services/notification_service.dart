import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _transactionChannelId = 'transaction_channel';
  static const String _transactionChannelName = 'Transaction Notifications';
  static const String _transactionChannelDesc =
      'Notifications for new transactions';

  Future<void> initialize() async {

    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidInitializationSettings androidInitialize =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitialize);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        _handleNotificationTap(details);
      },
    );

    await _createNotificationChannel();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(
        NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification,
          payload: message.data['transaction_id'],
        ),
      );
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await _handleForegroundMessage(message);
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _transactionChannelId,
      _transactionChannelName,
      description: _transactionChannelDesc,
      importance: Importance.high,
      playSound: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final transactionId = message.data['transaction_id'];
    final motorType = message.data['motor_type'];

    await showTransactionNotification(
      title: message.notification?.title ?? 'Transaksi Baru',
      body: message.notification?.body ?? 'Ada transaksi baru masuk',
      transactionId: transactionId,
      motorType: motorType,
    );
  }

  Future<void> showTransactionNotification({
    required String title,
    required String body,
    String? transactionId,
    String? motorType,
  }) async {

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      _transactionChannelId,
      _transactionChannelName,
      channelDescription: _transactionChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      styleInformation: BigTextStyleInformation(
        body,
        htmlFormatBigText: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
      ),
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: '$transactionId|$motorType',
    );
  }

  void _handleNotificationTap(NotificationResponse details) {
    if (details.payload != null) {
      final List<String> data = details.payload!.split('|');
      if (data.length == 2) {

        // If you have access to context, you can navigate here:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DetailsCard(
        //       transactionId: transactionId,
        //       motorType: motorType,
        //       bookingId: 'your_booking_id',
        //       customer: 'your_customer',
        //       nopol: 'your_nopol',
        //       dateSewa: 'your_date_sewa',
        //       dateKembali: 'your_date_kembali',
        //       jamSewa: 'your_jam_sewa',
        //       jamKembali: 'your_jam_kembali',
        //       total: 'your_total',
        //     ),
        //   ),
        // );
      }
    }
  }

  Future<String?> getDeviceToken() async {
    final token = await _firebaseMessaging.getToken();
    return token;
  }
}
