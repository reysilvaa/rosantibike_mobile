import 'package:rosantibike_mobile/model/stok.dart';

class JenisMotor {
  final int id;
  final int idStok;
  final String nopol;
  final String status;
  final Stok stok;
  final int count;

  JenisMotor({
    required this.id,
    required this.idStok,
    required this.nopol,
    required this.status,
    required this.stok,
    required this.count,
  });

  factory JenisMotor.fromJson(Map<String, dynamic> json) {
    return JenisMotor(
      id: json['id'],
      idStok: json['id_stok'],
      nopol: json['nopol'],
      status: json['status'],
      stok: Stok.fromJson(json['stok']),
      count: json['count'],
    );
  }
}
