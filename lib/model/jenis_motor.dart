import 'package:rosantibike_mobile/model/stok.dart';

class JenisMotor {
  final int id;
  final int idStok;
  final String nopol;
  final String status;
  final Stok stok;

  JenisMotor({
    required this.id,
    required this.idStok,
    required this.nopol,
    required this.status,
    required this.stok,
  });

  factory JenisMotor.fromJson(Map<String, dynamic> json) {
    return JenisMotor(
      id: json['id'] as int,
      idStok: json['id_stok'] as int,
      nopol: json['nopol'] as String,
      status: json['status'] as String,
      stok: Stok.fromJson(json['stok'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_stok': idStok,
        'nopol': nopol,
        'status': status,
        'stok': stok.toJson(),
      };
}
