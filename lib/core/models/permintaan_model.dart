class PermintaanModel {
  final String id;
  final String idPengguna;
  final String? namaPerusahaan;
  final String? deskripsi;
  final String? alamatKantor;
  final String? nomorTelepon;
  final String? email;
  final List<String>? urlGambar;
  final String status; // pending / approved / rejected
  final DateTime tanggalDibuat;

  PermintaanModel({
    required this.id,
    required this.idPengguna,
    this.namaPerusahaan,
    this.deskripsi,
    this.alamatKantor,
    this.nomorTelepon,
    this.email,
    this.urlGambar,
    required this.status,
    required this.tanggalDibuat,
  });

  factory PermintaanModel.fromJson(Map<String, dynamic> json) {
    return PermintaanModel(
      id: json['id'],
      idPengguna: json['id_pengguna'],
      namaPerusahaan: json['nama_perusahaan'],
      deskripsi: json['deskripsi'],
      alamatKantor: json['alamat_kantor'],
      nomorTelepon: json['nomor_telepon'],
      email: json['email'],
      urlGambar: json['url_gambar'] != null 
          ? List<String>.from(json['url_gambar']) 
          : null,
      status: json['status'] ?? 'pending',
      tanggalDibuat: json['tanggal_dibuat'] != null
          ? DateTime.parse(json['tanggal_dibuat'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_pengguna': idPengguna,
      'nama_perusahaan': namaPerusahaan,
      'deskripsi': deskripsi,
      'alamat_kantor': alamatKantor,
      'nomor_telepon': nomorTelepon,
      'email': email,
      'url_gambar': urlGambar,
      'status': status,
      'tanggal_dibuat': tanggalDibuat.toIso8601String(),
    };
  }
}
