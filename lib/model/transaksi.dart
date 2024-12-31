import 'package:rosantibike_mobile/model/jenis_motor.dart';

class Transaksi {
  final int id;
  final int idJenis;
  final String namaPenyewa;
  final String alamat;
  final String wa1;
  final String wa2;
  final String wa3;
  final String tglSewa;
  final String tglKembali;
  final int helm;
  final int jasHujan;
  final String total;
  final String nopol;
  final String status;
  final int motor_tersewa;
  final int sisa_motor;
  final JenisMotor jenisMotor;

  Transaksi({
    required this.id,
    required this.idJenis,
    required this.namaPenyewa,
    required this.alamat,
    required this.wa1,
    required this.wa2,
    required this.wa3,
    required this.tglSewa,
    required this.tglKembali,
    required this.helm,
    required this.jasHujan,
    required this.total,
    required this.nopol,
    required this.status,
    required this.jenisMotor,
    required this.motor_tersewa,
    required this.sisa_motor,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'],
      idJenis: json['id_jenis'],
      namaPenyewa: json['nama_penyewa'],
      alamat: json['alamat'],
      wa1: json['wa1'],
      wa2: json['wa2'],
      wa3: json['wa3'],
      tglSewa: json['tgl_sewa'],
      tglKembali: json['tgl_kembali'],
      helm: json['helm'],
      jasHujan: json['jashujan'],
      total: json['total'],
      nopol: json['nopol'],
      status: json['status'],
      motor_tersewa: json['motor_tersewa'],
      sisa_motor: json['sisa_motor'],
      jenisMotor: JenisMotor.fromJson(json['jenis_motor']),
    );
  }
}
