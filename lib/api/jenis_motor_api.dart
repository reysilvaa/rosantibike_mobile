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
    return prefs.getString('token');
  }

  // Get the list of jenis motor with count
  Future<Map<String, dynamic>> getJenisMotors({String? lastUpdated}) async {
    final token = await _getToken(); // Get the token
    final uri = Uri.parse('$apiUrl/admin/jenis-motor').replace(queryParameters: {
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });

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

      return {
        'data': List.from(responseData['data']),
        'count': responseData['count'],
        'timestamp': responseData['timestamp'],
      };
    } catch (e) {
      throw Exception('Failed to load jenis motors: $e');
    }
  }

  // Get the details of jenis motor by ID
  Future<JenisMotor> getJenisMotorDetail(int id) async {
    final token = await _getToken(); // Get the token

    final response = await http.get(
      Uri.parse('$apiUrl/admin/jenis-motor/$id'),
      headers: {
        'Authorization': 'Bearer $token', // Include token in the header
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return JenisMotor.fromJson(responseData['data']);
    } else {
      throw Exception('Failed to load jenis motor');
    }
  }

  // Create a new jenis motor
  Future<void> createJenisMotor(Map<String, dynamic> data) async {
    final token = await _getToken(); // Get the token

    final response = await http.post(
      Uri.parse('$apiUrl/admin/jenis-motor'),
      body: json.encode(data),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token', // Include token in the header
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create jenis motor');
    }
  }

  // Update an existing jenis motor
  Future<void> updateJenisMotor(int id, Map<String, dynamic> data) async {
    final token = await _getToken(); // Get the token

    final response = await http.put(
      Uri.parse('$apiUrl/admin/jenis-motor/$id'),
      body: json.encode(data),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token', // Include token in the header
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update jenis motor');
    }
  }

  // Delete jenis motor by ID
  Future<void> deleteJenisMotor(int id) async {
    final token = await _getToken(); // Get the token

    final response = await http.delete(
      Uri.parse('$apiUrl/admin/jenis-motor/$id'),
      headers: {
        'Authorization': 'Bearer $token', // Include token in the header
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete jenis motor');
    }
  }
}
