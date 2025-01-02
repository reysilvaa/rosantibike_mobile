import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rosantibike_mobile/api/api_service.dart';
import 'package:rosantibike_mobile/model/jenis_motor.dart';
import 'package:rosantibike_mobile/model/stok.dart';
import 'package:rosantibike_mobile/model/booking.dart';

class BookingApi {
  final String apiUrl = ApiService.apiUrl;

  // Mendapatkan data booking
  Future<Map<String, dynamic>> getBooking({String? lastUpdated}) async {
    final uri =
        Uri.parse('$apiUrl/admin/booking/list').replace(queryParameters: {
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) throw Exception('Failed to load data');

    final responseData = json.decode(response.body);

    return {
      'data': List.from(responseData['data'])
          .map((item) => _mapTransaction(item))
          .toList(),
      'count': responseData['count'],
      'timestamp': responseData['timestamp'], // For lastUpdated
    };
  }

  // Memetakan booking
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

  // Mendapatkan detail booking dengan id
  Future<Booking> getTransaksiDetail(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/admin/booking/$id'));
    if (response.statusCode != 200)
      throw Exception('Failed to load transaction');

    final responseData = json.decode(response.body);
    return Booking.fromJson(responseData);
  }

  // Update booking
  Future<void> updateBooking(int id, Booking booking) async {
    final data = _mapTransactionToUpdate(booking);
    final response = await http.put(
      Uri.parse('$apiUrl/admin/booking/$id'),
      body: json.encode(data),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200)
      throw Exception('Failed to update transaction');
  }

  // Memetakan booking untuk update
  Map<String, dynamic> _mapTransactionToUpdate(Booking booking) {
    return {
      "id_jenis": booking.idJenis,
      "nama_penyewa": booking.namaPenyewa,
      "alamat": booking.alamat,
      "wa1": booking.wa1,
      "wa2": booking.wa2,
      "wa3": booking.wa3,
      "tgl_sewa": booking.tglSewa,
      "tgl_kembali": booking.tglKembali,
      "helm": booking.helm,
      "jashujan": booking.jasHujan,
      "total": booking.total,
      "nopol": booking.nopol,
      "status": booking.status,
      "count": booking.count,
      "jenis_motor": _mapMotorToUpdate(booking.jenisMotor),
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

  // Hapus booking
  Future<void> deleteBooking(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/admin/booking/$id'));
    if (response.statusCode != 200)
      throw Exception('Failed to delete transaction');
  }

  // Bulk delete booking
  Future<void> bulkDelete(List<int> ids) async {
    final response = await http.post(
      Uri.parse('$apiUrl/admin/booking/bulk-delete'),
      body: json.encode({"ids": ids}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200)
      throw Exception('Failed to delete transactions');
  }
}