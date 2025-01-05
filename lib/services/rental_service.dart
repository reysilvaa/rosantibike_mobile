import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:rosantibike_mobile/services/notification_service.dart';

class RentalService {
  final String baseUrl = 'your_api_base_url';
  final NotificationService _notificationService = NotificationService();

  Future<Map<String, dynamic>> createRental(Map<String, dynamic> rentalData) async {
    try {
      // Get FCM token
      final deviceToken = await _notificationService.getDeviceToken();
      if (deviceToken == null) {
        throw Exception('Tidak dapat mendapatkan device token');
      }

      // Add device token to rental data
      rentalData['device_token'] = deviceToken;

      final response = await http.post(
        Uri.parse('$baseUrl/api/rentals'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(rentalData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal membuat rental: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}