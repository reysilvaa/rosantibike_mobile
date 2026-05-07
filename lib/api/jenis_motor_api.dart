import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rosantibike_mobile/api/api_service.dart';
import 'package:rosantibike_mobile/model/jenis_motor.dart'; // Ensure you have the JenisMotor model

class JenisMotorApi {
  final String apiUrl = ApiService.apiUrl;

  // Function to get the token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Get the list of jenis motor with count
  Future<Map<String, dynamic>> getJenisMotors({String? lastUpdated}) async {
    final token = await _getToken(); // Get the token
    Uri uri = Uri.parse('$apiUrl/jenis-motor');
    if (lastUpdated != null && lastUpdated.isNotEmpty) {
      uri = uri.replace(queryParameters: {'last_updated': lastUpdated});
    }

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token', // Include token in the header
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load jenis motors');
      }

      final responseData = json.decode(response.body);

      // Handle both paginated and list responses
      if (responseData is List) {
        return {
          'data': responseData,
          'count': responseData.length,
          'timestamp': DateTime.now().toIso8601String(),
        };
      }

      return {
        'data': responseData['data'] ?? [],
        'count': responseData['meta']?['totalItems'] ?? responseData['count'] ?? (responseData['data'] as List?)?.length ?? 0,
        'timestamp': responseData['timestamp'] ?? DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw Exception('Failed to load jenis motors: $e');
    }
  }

  // Get the details of jenis motor by ID
  Future<JenisMotor> getJenisMotorDetail(int id) async {
    final token = await _getToken(); // Get the token

    final response = await http.get(
      Uri.parse('$apiUrl/jenis-motor/$id'),
      headers: {
        'Authorization': 'Bearer $token', // Include token in the header
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // New API might return data directly or wrapped in 'data'
      final data = responseData['data'] ?? responseData;
      return JenisMotor.fromJson(data);
    } else {
      throw Exception('Failed to load jenis motor');
    }
  }

  // Create a new jenis motor
  Future<void> createJenisMotor(Map<String, dynamic> data) async {
    final token = await _getToken(); // Get the token

    final response = await http.post(
      Uri.parse('$apiUrl/jenis-motor'),
      body: json.encode(data),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token', // Include token in the header
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create jenis motor: ${response.body}');
    }
  }

  // Update an existing jenis motor
  Future<void> updateJenisMotor(int id, Map<String, dynamic> data) async {
    final token = await _getToken(); // Get the token

    final response = await http.patch(
      Uri.parse('$apiUrl/jenis-motor/$id'),
      body: json.encode(data),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token', // Include token in the header
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update jenis motor: ${response.body}');
    }
  }

  // Delete jenis motor by ID
  Future<void> deleteJenisMotor(int id) async {
    final token = await _getToken(); // Get the token

    final response = await http.delete(
      Uri.parse('$apiUrl/jenis-motor/$id'),
      headers: {
        'Authorization': 'Bearer $token', // Include token in the header
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete jenis motor: ${response.body}');
    }
  }
}
