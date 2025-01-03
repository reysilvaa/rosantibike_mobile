class Stok {
  final int id;
  final String merk;
  final String judul;
  final String deskripsi1;
  final String? deskripsi2;
  final String? deskripsi3;
  final String kategori;
  final String hargaPerHari;
  final String foto;

  Stok({
    required this.id,
    required this.merk,
    required this.judul,
    required this.deskripsi1,
    this.deskripsi2,
    this.deskripsi3,
    required this.kategori,
    required this.hargaPerHari,
    required this.foto,
  });

  factory Stok.fromJson(Map<String, dynamic> json) {
    return Stok(
      id: json['id'] as int,
      merk: json['merk'] as String,
      judul: json['judul'] as String,
      deskripsi1: json['deskripsi1'] as String,
      deskripsi2: json['deskripsi2'] as String?,
      deskripsi3: json['deskripsi3'] as String?,
      kategori: json['kategori'] as String,
      hargaPerHari: json['harga_perHari'] as String,
      foto: json['foto'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'merk': merk,
        'judul': judul,
        'deskripsi1': deskripsi1,
        'deskripsi2': deskripsi2,
        'deskripsi3': deskripsi3,
        'kategori': kategori,
        'harga_perHari': hargaPerHari,
        'foto': foto,
      };
}
