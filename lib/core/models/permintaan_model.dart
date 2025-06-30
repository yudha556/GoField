class PermintaanModel {
  final String id;
  final String idPengguna;
  final String namaLapangan;
  final String deskripsi;
  final String jenisOlahraga;
  final int banyakLapangan;
  final String nomorTelepon;
  final String email;
  final int hargaPerJam;
  final int kapasitas;
  final String alamat;
  final List<String> fasilitas;
  final String? fasilitasLain;
  final String status; // pending / approved / rejected
  final DateTime tanggal;

  PermintaanModel({
    required this.id,
    required this.idPengguna,
    required this.namaLapangan,
    required this.deskripsi,
    required this.jenisOlahraga,
    required this.banyakLapangan,
    required this.nomorTelepon,
    required this.email,
    required this.hargaPerJam,
    required this.kapasitas,
    required this.alamat,
    required this.fasilitas,
    this.fasilitasLain,
    required this.status,
    required this.tanggal,
  });

  factory PermintaanModel.fromJson(Map<String, dynamic> json) {
    return PermintaanModel(
      id: json['id'],
      idPengguna: json['id_pengguna'],
      namaLapangan: json['nama_lapangan'],
      deskripsi: json['deskripsi_lapangan'],
      jenisOlahraga: json['jenis_olahraga'],
      banyakLapangan: json['banyak_lapangan'],
      nomorTelepon: json['nomor_telepon'],
      email: json['email'],
      hargaPerJam: json['harga_per_jam'],
      kapasitas: json['kapasitas'],
      alamat: json['alamat'],
      fasilitas: List<String>.from(json['fasilitas']),
      fasilitasLain: json['fasilitas_lain'],
      status: json['status'],
      tanggal: DateTime.parse(json['tanggal']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_pengguna': idPengguna,
      'nama_lapangan': namaLapangan,
      'deskripsi_lapangan': deskripsi,
      'jenis_olahraga': jenisOlahraga,
      'banyak_lapangan': banyakLapangan,
      'nomor_telepon': nomorTelepon,
      'email': email,
      'harga_per_jam': hargaPerJam,
      'kapasitas': kapasitas,
      'alamat': alamat,
      'fasilitas': fasilitas,
      'fasilitas_lain': fasilitasLain,
      'status': status,
      'tanggal': tanggal.toIso8601String(),
    };
  }
}
