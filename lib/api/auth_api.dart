import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';

class AuthApi {
  final String baseUrl = ApiService.apiUrl;

  // Login function
  Future<Map<String, dynamic>> login(String uname, String pass) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uname': uname,
          'pass': pass,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['access_token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', data['access_token']);
          await prefs.setInt(
              'expires_in',
              DateTime.now()
                  .add(Duration(seconds: data['expires_in']))
                  .millisecondsSinceEpoch);
          return {'success': true, 'access_token': data['access_token']};
        } else {
          return {'success': false, 'message': data['error']};
        }
      } else {
        return {
          'success': false,
          'message': 'Something went wrong. Please try again.'
        };
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<bool> logout(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('access_token');
        await prefs.remove('expires_in');
        return true;
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? 'Failed to logout');
      }
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  // Check if token is expired
  Future<bool> isTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final expiresIn = prefs.getInt('expires_in') ?? 0;
    return DateTime.now().millisecondsSinceEpoch > expiresIn;
  }

  // Get a valid token
  Future<String?> getValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('Token not found. Please login.');
    }

    // Check if token is expired
    final isExpired = await isTokenExpired();
    if (isExpired) {
      prefs.remove('access_token');
      prefs.remove('expires_in');
      throw Exception('Token expired. Please login again.');
    }

    return token; // Return valid token
  }
}
