import 'package:rosantibike_mobile/model/jenis_motor.dart';

class Booking {
  final int id;
  final int idJenis;
  final String namaPenyewa;
  final String? alamat;
  final String? wa1;
  final String? wa2;
  final String? wa3;
  final String tglSewa;
  final String tglKembali;
  final int? helm;
  final int? jasHujan;
  final String total;
  final String? createdAt;
  final String? updatedAt;
  final String nopol;
  final String status;
  final JenisMotor jenisMotor;
  final int? count;

  Booking({
    required this.id,
    required this.idJenis,
    required this.namaPenyewa,
    this.alamat,
    this.wa1,
    this.wa2,
    this.wa3,
    required this.tglSewa,
    required this.tglKembali,
    this.helm,
    this.jasHujan,
    required this.total,
    this.createdAt,
    this.updatedAt,
    required this.nopol,
    required this.status,
    required this.jenisMotor,
    this.count,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int,
      idJenis: json['id_jenis'] as int,
      namaPenyewa: json['nama_penyewa'] as String,
      alamat: json['alamat'] as String?,
      wa1: json['wa1'] as String?,
      wa2: json['wa2'] as String?,
      wa3: json['wa3'] as String?,
      tglSewa: json['tgl_sewa'] as String,
      tglKembali: json['tgl_kembali'] as String,
      helm: json['helm'] as int?,
      jasHujan: json['jashujan'] as int?,
      total: json['total'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      nopol: json['nopol'] as String,
      status: json['status'] as String,
      jenisMotor: JenisMotor.fromJson(json['jenis_motor'] as Map<String, dynamic>),
      count: json['count'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_jenis': idJenis,
        'nama_penyewa': namaPenyewa,
        'alamat': alamat,
        'wa1': wa1,
        'wa2': wa2,
        'wa3': wa3,
        'tgl_sewa': tglSewa,
        'tgl_kembali': tglKembali,
        'helm': helm,
        'jashujan': jasHujan,
        'total': total,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'nopol': nopol,
        'status': status,
        'jenis_motor': jenisMotor.toJson(),
        'count': count,
      };
}
