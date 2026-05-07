import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rosantibike_mobile/api/api_service.dart';
import 'package:rosantibike_mobile/model/jenis_motor.dart';
import 'package:rosantibike_mobile/model/stok.dart';
import 'package:rosantibike_mobile/model/booking.dart';

class BookingApi {
  final String apiUrl = ApiService.apiUrl;

  // Function to get the token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<Map<String, dynamic>> getBooking(
      {String? lastUpdated, String? search}) async {
    final token = await _getToken(); // Get the token
    final uri =
        Uri.parse('$apiUrl/transaksi').replace(queryParameters: {
      if (search != null) 'search': search,
    });

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token', // Include token in the header
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load data: ${response.statusCode}');
      }

      final responseData = json.decode(response.body);

      if (responseData == null ||
          responseData is List && responseData.isEmpty) {
        return {
          'data': [],
          'count': 0,
          'timestamp': DateTime.now().toIso8601String(),
        };
      }

      if (responseData is List) {
        return {
          'data': responseData,
          'count': responseData.length,
          'timestamp': DateTime.now().toIso8601String(),
        };
      }

      final data = responseData['data'];
      return {
        'data': data is List ? data : (data != null ? [data] : []),
        'count': responseData['meta']?['totalItems'] ?? responseData['count'] ?? (data is List ? data.length : (data != null ? 1 : 0)),
        'timestamp': responseData['timestamp'] ?? DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw Exception('Failed to load bookings: $e');
    }
  }

  // Function to fetch transaction details
  Future<Booking> getTransaksiDetail(int id) async {
    final token = await _getToken(); // Get the token

    final response = await http.get(
      Uri.parse('$apiUrl/transaksi/$id'),
      headers: {
        'Authorization': 'Bearer $token', // Include token in the header
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load transaction');
    }

    final responseData = json.decode(response.body);
    final data = responseData['data'] ?? responseData;
    return Booking.fromJson(data);
  }

  // Update booking
  Future<void> updateBooking(int id, Booking booking) async {
    final token = await _getToken(); // Get the token

    final data = _mapTransactionToUpdate(booking);
    final response = await http.patch(
      Uri.parse('$apiUrl/transaksi/$id'),
      body: json.encode(data),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token', // Include token in the header
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update transaction');
    }
  }

  // Delete booking
  Future<void> deleteBooking(int id) async {
    final token = await _getToken(); // Get the token

    final response = await http.delete(
      Uri.parse('$apiUrl/transaksi/$id'),
      headers: {
        'Authorization': 'Bearer $token', // Include token in the header
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete transaction');
    }
  }

  // Bulk delete booking
  Future<void> bulkDelete(List<int> ids) async {
    final token = await _getToken(); // Get the token

    // Check if bulk-delete exists, otherwise loop
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/transaksi/bulk-delete'),
        body: json.encode({"ids": ids}),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token', // Include token in the header
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
         // Fallback to individual deletes if endpoint not found
         for (var id in ids) {
           await deleteBooking(id);
         }
      }
    } catch (e) {
      for (var id in ids) {
        await deleteBooking(id);
      }
    }
  }

  // Helper methods for mapping data (unchanged)
  Map<String, dynamic> _mapTransactionToUpdate(Booking booking) {
    return {
      "total": booking.total,
      "nopol": booking.nopol,
      "status": booking.status,
      "count": booking.count,
      "jenis_motor": _mapMotorToUpdate(booking.jenisMotor),
    };
  }

  Map<String, dynamic> _mapMotorToUpdate(JenisMotor jenisMotor) {
    return {
      "id": jenisMotor.id,
      "id_stok": jenisMotor.idStok,
      "nopol": jenisMotor.nopol,
      "status": jenisMotor.status,
      "stok": _mapStockToUpdate(jenisMotor.stok),
    };
  }

  Map<String, dynamic> _mapStockToUpdate(Stok stok) {
    return {
      "id": stok.id,
      "merk": stok.merk,
      "judul": stok.judul,
      "deskripsi1": stok.deskripsi1,
      "deskripsi2": stok.deskripsi2,
      "deskripsi3": stok.deskripsi3,
      "kategori": stok.kategori,
      "harga_perHari": stok.hargaPerHari,
      "foto": stok.foto,
    };
  }
}
