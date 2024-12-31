import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rosantibike_mobile/api/api_service.dart';
import 'package:rosantibike_mobile/model/jenis_motor.dart'; // Pastikan Anda punya model JenisMotor

class JenisMotorApi {
  final String apiUrl = ApiService.apiUrl;

  // Mendapatkan daftar jenis motor beserta count-nya
  Future<Map<String, dynamic>> getJenisMotors() async {
    final response = await http.get(Uri.parse('$apiUrl/admin/jenis-motor'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      // Mengembalikan data dan count dalam bentuk Map
      return {
        'data': responseData['data'], // Data jenis motor
        'count': responseData['count'], // Jumlah jenis motor
      };
    } else {
      throw Exception('Failed to load jenis motors');
    }
  }

  // Mendapatkan detail jenis motor berdasarkan ID
  Future<JenisMotor> getJenisMotorDetail(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/admin/jenis-motor/$id'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return JenisMotor.fromJson(responseData['data']);
    } else {
      throw Exception('Failed to load jenis motor');
    }
  }

  // Menambahkan jenis motor baru
  Future<void> createJenisMotor(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$apiUrl/admin/jenis-motor'),
      body: json.encode(data),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create jenis motor');
    }
  }

  // Memperbarui jenis motor
  Future<void> updateJenisMotor(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$apiUrl/jenis-motor/$id'),
      body: json.encode(data),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update jenis motor');
    }
  }

  // Menghapus jenis motor berdasarkan ID
  Future<void> deleteJenisMotor(int id) async {
    final response =
        await http.delete(Uri.parse('$apiUrl/admin/jenis-motor/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete jenis motor');
    }
  }
}
