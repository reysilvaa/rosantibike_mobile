import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rosantibike_mobile/api/api_service.dart';
import 'package:rosantibike_mobile/model/jenis_motor.dart';
import 'package:rosantibike_mobile/model/stok.dart';
import 'package:rosantibike_mobile/model/transaksi.dart';

class TransaksiApi {
  final String apiUrl = ApiService.apiUrl;

  Future<Map<String, dynamic>> getTransaksi(
      {String? lastUpdated, String? search}) async {
    final uri = Uri.parse('$apiUrl/admin/transaksi').replace(queryParameters: {
      if (search != null) 'search': search,
    });

    try {
      // Log the final URL to ensure it's correct
      print('Fetching data from: $uri');

      final response = await http.get(uri);

      // Log response status code
      print('Response status code: ${response.statusCode}');

      if (response.statusCode != 200) {
        // Log the error if the status code is not 200
        print(
            'Error: Failed to load data with status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }

      // Log response body for debugging purposes
      print('Response body: ${response.body}');

      final responseData = json.decode(response.body);

      // Check if responseData is valid before accessing keys
      if (responseData == null) {
        print('Error: responseData is null');
        throw Exception('Invalid response data');
      }

      // Log the response data for inspection
      print('Parsed response data: $responseData');

      return {
        'data': List.from(responseData['data'])
            .map((item) => _mapTransaction(item))
            .toList(),
        'motor_tersewa': responseData['motor_tersewa'],
        'sisa_motor': responseData['sisa_motor'],
        'timestamp': responseData['timestamp'], // Update lastUpdated
      };
    } catch (e) {
      // Log the error with full context
      print('Error fetching transaksi: $e'); // Debug log
      throw Exception('Failed to load transaksi: $e');
    }
  }

  // Memetakan transaksi
  Map<String, dynamic> _mapTransaction(Map<String, dynamic> item) {
    return {
      'id': item['id'],
      'id_jenis': item['id_jenis'],
      'nama_penyewa': item['nama_penyewa'],
      'alamat': item['alamat'],
      'wa1': item['wa1'],
      'wa2': item['wa2'],
      'wa3': item['wa3'],
      'tgl_sewa': item['tgl_sewa'],
      'tgl_kembali': item['tgl_kembali'],
      'helm': item['helm'],
      'jashujan': item['jashujan'],
      'total': item['total'],
      'nopol': item['nopol'],
      'status': item['status'],
      'jenis_motor': _mapMotor(item['jenis_motor']),
    };
  }

  // Memetakan jenis motor
  Map<String, dynamic> _mapMotor(Map<String, dynamic> motor) {
    return {
      'id': motor['id'],
      'id_stok': motor['id_stok'],
      'nopol': motor['nopol'],
      'status': motor['status'],
      'stok': _mapStock(motor['stok']),
    };
  }

  // Memetakan stok
  Map<String, dynamic> _mapStock(Map<String, dynamic> stok) {
    return {
      'id': stok['id'],
      'merk': stok['merk'],
      'judul': stok['judul'],
      'deskripsi1': stok['deskripsi1'],
      'deskripsi2': stok['deskripsi2'],
      'deskripsi3': stok['deskripsi3'],
      'kategori': stok['kategori'],
      'harga_perHari': stok['harga_perHari'],
      'foto': stok['foto'],
    };
  }

  // Mendapatkan detail transaksi dengan id
  Future<Transaksi> getTransaksiDetail(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/admin/transaksi/$id'));
    if (response.statusCode != 200)
      throw Exception('Failed to load transaction');

    final responseData = json.decode(response.body);
    return Transaksi.fromJson(responseData);
  }

  // Update transaksi
  Future<void> updateTransaksi(int id, Transaksi transaksi) async {
    final data = _mapTransactionToUpdate(transaksi);
    final response = await http.put(
      Uri.parse('$apiUrl/admin/transaksi/$id'),
      body: json.encode(data),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200)
      throw Exception('Failed to update transaction');
  }

  // Memetakan transaksi untuk update
  Map<String, dynamic> _mapTransactionToUpdate(Transaksi transaksi) {
    return {
      "id_jenis": transaksi.idJenis,
      "nama_penyewa": transaksi.namaPenyewa,
      "alamat": transaksi.alamat,
      "wa1": transaksi.wa1,
      "wa2": transaksi.wa2,
      "wa3": transaksi.wa3,
      "tgl_sewa": transaksi.tglSewa,
      "tgl_kembali": transaksi.tglKembali,
      "helm": transaksi.helm,
      "jashujan": transaksi.jasHujan,
      "total": transaksi.total,
      "nopol": transaksi.nopol,
      "status": transaksi.status,
      "motor_tersewa": transaksi.motor_tersewa,
      "sisa_motor": transaksi.sisa_motor,
      "jenis_motor": _mapMotorToUpdate(transaksi.jenisMotor),
    };
  }

  // Memetakan jenis motor untuk update
  Map<String, dynamic> _mapMotorToUpdate(JenisMotor jenisMotor) {
    return {
      "id": jenisMotor.id,
      "id_stok": jenisMotor.idStok,
      "nopol": jenisMotor.nopol,
      "status": jenisMotor.status,
      "stok": _mapStockToUpdate(jenisMotor.stok),
    };
  }

  // Memetakan stok untuk update
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

  // Hapus transaksi
  Future<void> deleteTransaksi(int id) async {
    final response =
        await http.delete(Uri.parse('$apiUrl/admin/transaksi/$id'));
    if (response.statusCode != 200)
      throw Exception('Failed to delete transaction');
  }

  // Bulk delete transaksi
  Future<void> bulkDelete(List<int> ids) async {
    final response = await http.post(
      Uri.parse('$apiUrl/admin/transaksi/bulk-delete'),
      body: json.encode({"ids": ids}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200)
      throw Exception('Failed to delete transactions');
  }
}
