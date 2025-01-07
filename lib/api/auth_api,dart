import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';

class AuthApi {
  final String baseUrl = ApiService.apiUrl;

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
          return {'success': true, 'access_token': data['access_token']};
        } else {
          return {'success': false, 'message': data['error']};
        }
      } else {
        return {'success': false, 'message': 'Something went wrong. Please try again.'};
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<bool> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('access_token');
        return true;
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? 'Failed to logout');
      }
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }
}
