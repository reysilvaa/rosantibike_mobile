// lib/services/services.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rosantibike_mobile/api/api_service.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _transactionChannelId = 'transaction_channel';
  static const String _transactionChannelName = 'Transaction Notifications';
  static const String _transactionChannelDesc =
      'Notifications for new transactions';

  Future<void> initialize() async {
    print("Initializing Notification Service...");

    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print("Notification permission granted: ${settings.authorizationStatus}");

    const AndroidInitializationSettings androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitialize);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        print("Notification tapped: ${details.payload}");
        _handleNotificationTap(details);
      },
    );
    print("token: ${await getDeviceToken()}");
    print("Local notifications initialized.");

    await _createNotificationChannel();
    print("Notification channel created.");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.messageId}");
      _handleForegroundMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    print("Background message handler registered.");
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
    print("Showing transaction notification...");
    print(
        "Title: $title, Body: $body, Transaction ID: $transactionId, Motor Type: $motorType");

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
    print("Notification shown.");
  }

  void _handleNotificationTap(NotificationResponse details) {
    if (details.payload != null) {
      final List<String> data = details.payload!.split('|');
      if (data.length == 2) {
        final String transactionId = data[0];
        final String motorType = data[1];
        // TODO: Navigate to transaction detail page
        // Navigator.pushNamed(context, '/transaction-detail', arguments: transactionId);
      }
    }
  }

  Future<String?> getDeviceToken() async {
    final token = await _firebaseMessaging.getToken();
    print("Device token: $token");
    return token;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
}

class RentalService {
  final String apiUrl = ApiService.apiUrl;
  String _buildEndpoint(String endpoint) => '${ApiService.apiUrl}/$endpoint';
  final NotificationService _notificationService = NotificationService();

  Future<Map<String, dynamic>> createRental(
      Map<String, dynamic> rentalData) async {
    try {
      final deviceToken = await _notificationService.getDeviceToken();
      if (deviceToken == null) {
        throw Exception('Tidak dapat mendapatkan device token');
      }

      rentalData['device_token'] = deviceToken;

      final response = await http.post(
        Uri.parse('$_buildEndpoint/transaksi/create'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(rentalData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Gagal membuat rental');
      }
    } catch (e) {
      throw Exception('Gagal membuat rental: $e');
    }
  }
}
