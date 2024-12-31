
class Stok {
  final int id;
  final String merk;
  final String judul;
  final String deskripsi1;
  final String deskripsi2;
  final String? deskripsi3;
  final String kategori;
  final String hargaPerHari;
  final String foto;

  Stok({
    required this.id,
    required this.merk,
    required this.judul,
    required this.deskripsi1,
    required this.deskripsi2,
    this.deskripsi3,
    required this.kategori,
    required this.hargaPerHari,
    required this.foto,
  });

  factory Stok.fromJson(Map<String, dynamic> json) {
    return Stok(
      id: json['id'],
      merk: json['merk'],
      judul: json['judul'],
      deskripsi1: json['deskripsi1'],
      deskripsi2: json['deskripsi2'],
      deskripsi3: json['deskripsi3'],
      kategori: json['kategori'],
      hargaPerHari: json['harga_perHari'],
      foto: json['foto'],
    );
  }
}